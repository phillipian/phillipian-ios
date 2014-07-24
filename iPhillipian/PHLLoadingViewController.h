//
//  PHLLoadingViewController.h
//  iPhillipian
//
//  Created by David Cao on 7/20/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHLLoadingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *indicatorBackgroundView;

- (void)doneLoading;

@end
