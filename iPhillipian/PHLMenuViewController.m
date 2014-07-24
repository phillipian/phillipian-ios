//
//  PHLMenuViewController.m
//  iPhillipian
//
//  Created by David Cao on 7/20/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import "PHLMenuViewController.h"
#import "PHLFetcher.h"
#import "PHLSectionViewController.h"
#import "PHLSection.h"
#import "PHLLoadingViewController.h"
#import "SWRevealViewController.h"

NSString * MenuCellIdentifier = @"MenuCellIdentifier";

@interface PHLMenuViewController ()

@property NSArray *sections;
@property NSArray *sectionTitles;

@end

@implementation PHLMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.sections = @[@"all", @"news", @"sports", @"arts", @"commentary", @"editorial", @"letters%20to%20the%20editor", @"features", @"cross%20campus"];
        self.sectionTitles = @[@"Recent", @"News", @"Sports", @"Arts", @"Commentary", @"Editorial", @"Letters to the Editor", @"Features", @"Cross Campus"];
        
        [self setTitle:@"The Phillipian"];
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MenuCellIdentifier];
    }
    
    [[cell textLabel] setText:[self.sectionTitles objectAtIndex:[indexPath row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UINavigationController *frontNav = (UINavigationController *)[[self revealViewController] frontViewController];
    PHLSectionViewController *sectionController = (PHLSectionViewController *)[frontNav topViewController];
    PHLLoadingViewController *loadingController = [[PHLLoadingViewController alloc] init];
    
    [sectionController setLoadingViewController:loadingController];
    [[[sectionController navigationController] view] addSubview:[[sectionController loadingViewController] view]];
    
    //first check if it's the same section
    if ([indexPath row] == 0) {
        if ([sectionController section] != nil) {
            [[self revealViewController] setFrontViewPosition:FrontViewPositionRightMostRemoved animated:YES];
        }
        [sectionController setSection:nil];
        [sectionController setTitle:[self.sectionTitles objectAtIndex:[indexPath row]]];
        [[self revealViewController] revealToggle:sectionController];
        [sectionController setupTable];
        return;
    }
    
    if ([self.sections objectAtIndex:[indexPath row]] == [sectionController section] ) {
        NSLog(@"Same section!");
        [[self revealViewController] revealToggle:sectionController];
        return;
    }
    
    [sectionController setSection:[self.sections objectAtIndex:[indexPath row]]];
    [sectionController setupTable];
    [sectionController setTitle:[self.sectionTitles objectAtIndex:[indexPath row]]];
    [[self revealViewController] setFrontViewPosition:FrontViewPositionRightMostRemoved animated:YES];
    [[self revealViewController] revealToggle:sectionController];
    
}

@end
