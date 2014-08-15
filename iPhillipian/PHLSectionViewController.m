//
//  PHLSectionViewController.m
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import "PHLSectionViewController.h"
#import "PHLFetcher.h"
#import "PHLConnectionHelper.h"
#import "PHLMainContext.h"
#import "PHLSection.h"
#import "PHLArticle.h"
#import "PHLArticleCell.h"
#import "SWRevealViewController.h"
#import "PHLLoadingViewController.h"
#import "PHLArticleViewController.h"

NSString * const ArticleCellIdentifier = @"ArticleCellIdentifier";
CGFloat const cellHeight = 152.0;

@interface PHLSectionViewController ()

@property BOOL clear;
@property (nonatomic) NSArray *sectionPages;
@property (nonatomic) NSFetchedResultsController *resultsController;

- (void)articlesRecieved;
- (void)thumbReady;

@end

@implementation PHLSectionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(articlesRecieved) name:ArticlesRecievedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thumbReady) name:ThumbnailReadyNotification object:nil];
        [self setSection:nil];
        [self setClear:NO];
        [self setTitle:@"Recent"];
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 0; i < 9; i++) {
            [array addObject:[NSNumber numberWithInt:0]];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"PHLArticleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ArticleCellIdentifier];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
}

- (void)clearTable {
    
    [self setClear:YES];
    [[self tableView] reloadData];
    [self setClear:NO];
}

- (void)articlesRecieved {
    
    NSLog(@"Articles are done parsing!");
    [self setupTable];
}

- (void)thumbReady {
//    NSLog(@"Thumb Ready");
    [[self tableView] reloadData];
}
 
//---------------------------NOTE---------------------------
//call this right after setting section

- (void)setupTable {
    
    if (self.section == nil) {
        NSLog(@"The section is all articles");
        
        //set nav title here
        
        [self setResultsController:[PHLFetcher resultsControllerForAllArticles:[PHLMainContext sharedContext]]];
        NSError *err = nil;
        [self.resultsController performFetch:&err];
        SharedErrorBlock(err, METHOD_NAME);
        [self.tableView reloadData];
    } else {
        NSLog(@"The section is %@", self.section);
        //do we have anything with it?
        
        if ([[PHLFetcher SectionsWithName:self.section inContext:[PHLMainContext sharedContext]] count] == 0 || [[[[PHLFetcher SectionsWithName:self.section inContext:[PHLMainContext sharedContext]] objectAtIndex:0] articles] count] < 16) {
            //now request that section
            
            NSString *sectionName = [self.section stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            [PHLConnectionHelper getArticlesForSection:sectionName];
            return;
        }
        
        //set nav title here
        
        [self setResultsController:[PHLFetcher resultsControllerForArticlesWithSection:self.section inContext:[PHLMainContext sharedContext]]];
        NSError *err = nil;
        [self.resultsController performFetch:&err];
        SharedErrorBlock(err, METHOD_NAME);
        [self.tableView reloadData];
    }
    
    [[self loadingViewController] doneLoading];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self clear]) {
        return 0;
    }
//    NSLog(@"Number of articles: %d", [[[self resultsController] fetchedObjects] count]);
    return [[[self resultsController] fetchedObjects] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHLArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:ArticleCellIdentifier];
    
    if (!cell) {
        cell = [[PHLArticleCell alloc] init];
    }
    // Configure the cell...
    
    PHLArticle *currentArticle = [[[self resultsController] fetchedObjects] objectAtIndex:[indexPath row]];
    
    [[cell titleLabel] setText:currentArticle.title];
    [[cell writerLabel] setText:[NSString stringWithFormat:@"By %@", currentArticle.writer]];
    [[cell bodyLabel] setText:currentArticle.body];
    
    //CHECK THUMBNAIL STUFF HERE
    
    if ([currentArticle thumbnail]) {
        [[cell thumbView] setHidden:NO];
        [[cell thumbView] setImage:[UIImage imageWithData:currentArticle.thumbnail]];
        [[cell bodyLabel] setFrame:CGRectMake(cell.bodyLabel.frame.origin.x, cell.bodyLabel.frame.origin.y, 216, cell.bodyLabel.frame.size.height)];
        [[cell writerLabel] setFrame:CGRectMake(cell.writerLabel.frame.origin.x, cell.writerLabel.frame.origin.y, 216, cell.writerLabel.frame.size.height)];
    } else {
        [[cell thumbView] setHidden:YES];
        [[cell bodyLabel] setFrame:CGRectMake(cell.bodyLabel.frame.origin.x, cell.bodyLabel.frame.origin.y, 300, cell.bodyLabel.frame.size.height)];
        [[cell writerLabel] setFrame:CGRectMake(cell.writerLabel.frame.origin.x, cell.writerLabel.frame.origin.y, 300, cell.writerLabel.frame.size.height)];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PHLArticleViewController *articleView = [[PHLArticleViewController alloc] initWithArticle:[[self resultsController] objectAtIndexPath:indexPath]];
    [[self navigationController] pushViewController:articleView animated:YES];
    
}

@end
