//
//  PHLLoadingViewController.m
//  iPhillipian
//
//  Created by David Cao on 7/20/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import "PHLLoadingViewController.h"

@interface PHLLoadingViewController ()

@end

@implementation PHLLoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneLoading) name:ArticlesRecievedNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[[self indicatorBackgroundView] layer] setCornerRadius:25.0];
    [[self indicatorBackgroundView] setNeedsDisplay];
    
    [[self activityIndicator] startAnimating];
}

- (void)doneLoading {
    
    NSLog(@"Done loading!");
    [[self view] removeFromSuperview];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[self activityIndicator] stopAnimating];
}

@end
