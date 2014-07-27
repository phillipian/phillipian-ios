//
//  PHLArticleViewController.m
//  iPhillipian
//
//  Created by David Cao on 7/27/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import "PHLArticleViewController.h"
#import "PHLArticle.h"
#import "MWPhotoBrowser.h"
#import "AFNetworking.h"

CGFloat edgeInset = 20.0;
CGFloat buffer = 8.0;

@interface PHLArticleViewController () <MWPhotoBrowserDelegate>

@property (weak, nonatomic) UITextView *titleTextView;
@property (weak, nonatomic) UITextView *writerTextView;
@property (nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UITextView *bodyTextView;

@property (nonatomic) NSMutableArray *photos;

- (void)imageTapped;

@end

@implementation PHLArticleViewController

- (id)initWithArticle:(PHLArticle *)article {
    
    if (self = [super init]) {
        [self setArticle:article];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat imageHeight = 0;
    
    [self setTitleTextView:[[UITextView alloc] init]];
    [self setWriterTextView:[[UITextView alloc] init]];
    [self setBodyTextView:[[UITextView alloc] init]];
    [self setImageView:[[UIImageView alloc] init]];
    
    [[self titleTextView] setText:[[self article] title]];
    [[self titleTextView] setFont:[UIFont fontWithName:@"Helvetica Neue" size:19.0]];
    [[self writerTextView] setText:[NSString stringWithFormat:@"By %@", [[self article] writer]]];
    [[self writerTextView] setFont:[UIFont fontWithName:@"Helvetica Neue Thin" size:12.0]];
    [[self writerTextView] setTextColor:[UIColor darkGrayColor]];
    [[self bodyTextView] setText:[[self article] body]];
    [[self bodyTextView] setFont:[UIFont fontWithName:@"Palatino" size:15.0]];
    
    [[self titleTextView] setScrollEnabled:NO];
    [[self writerTextView] setScrollEnabled:NO];
    [[self bodyTextView] setScrollEnabled:NO];
    
    [[self titleTextView] setEditable:NO];
    [[self writerTextView] setEditable:NO];
    [[self bodyTextView] setEditable:NO];
    
    CGSize titleSize = [[self titleTextView] sizeThatFits:CGSizeMake(self.view.frame.size.width - 2*edgeInset, MAXFLOAT)];
    [[self titleTextView] layoutIfNeeded];
    [[self titleTextView] setFrame:CGRectMake(edgeInset, edgeInset, titleSize.width, titleSize.height)];
    
    CGSize writerSize = [[self writerTextView] sizeThatFits:CGSizeMake(self.view.frame.size.width - 2*edgeInset, MAXFLOAT)];
    [[self writerTextView] layoutIfNeeded];
    [[self writerTextView] setFrame:CGRectMake(edgeInset, edgeInset + titleSize.height, writerSize.width, writerSize.height)];
    
    if ([[self article] imageURL]) {
        imageHeight = 187.0;
        [self setImageView:[[UIImageView alloc]
                            initWithFrame:CGRectMake(edgeInset, self.writerTextView.frame.origin.y + writerSize.height, 280, imageHeight)]];
        AFHTTPRequestOperation *req = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[self article] imageURL]]]];
        [req start];
        [req setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSData *data = responseObject;
            [[self imageView] setImage:[UIImage imageWithData:data]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
            [[self imageView] setUserInteractionEnabled:YES];
            [[self imageView] addGestureRecognizer:tap];
            
            NSLog(@"Image fetch success");
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LogObject(@"Image fetch failed");
        }];
        [[self imageView] setContentMode:UIViewContentModeScaleAspectFit];
    }
    
    CGSize bodySize = [[self bodyTextView] sizeThatFits:CGSizeMake(self.view.frame.size.width - 2*edgeInset, MAXFLOAT)];
    [[self bodyTextView] layoutIfNeeded];
    [[self bodyTextView] setFrame:CGRectMake(edgeInset, self.writerTextView.frame.origin.y + writerSize.height + imageHeight, bodySize.width, bodySize.height)];
    
    [[self scrollView] addSubview:[self titleTextView]];
    [[self scrollView] addSubview:[self writerTextView]];
    [[self scrollView] addSubview:[self bodyTextView]];
    [[self scrollView] addSubview:[self imageView]];
    
    [[self scrollView] setContentSize:CGSizeMake(self.view.frame.size.width, self.bodyTextView.frame.origin.y + bodySize.height + edgeInset)];
    
    [[self view] addSubview:[self scrollView]];
}

- (void)imageTapped {
    
    NSLog(@"image tapped!");
    
    // Create array of MWPhoto objects
    self.photos = [NSMutableArray array];
    [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[[self article] imageURL]]]];
    NSString *caption = [NSString stringWithFormat:@"%@\n%@", [[self article] imageCaption], [[self article] imageCredit]];
    [[self.photos objectAtIndex:0] setCaption:caption];
    
    // Create browser (must be done each time photo browser is
    // displayed. Photo browser objects cannot be re-used)
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];
    
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:10];
    
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

@end
