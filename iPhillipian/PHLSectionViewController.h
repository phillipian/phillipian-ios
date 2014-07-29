//
//  PHLSectionViewController.h
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHLLoadingViewController;

@interface PHLSectionViewController : UITableViewController

@property (nonatomic) PHLLoadingViewController *loadingViewController;
@property (nonatomic) NSString *section;

- (void)setupTable;
- (void)clearTable;

@end
