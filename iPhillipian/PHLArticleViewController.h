//
//  PHLArticleViewController.h
//  iPhillipian
//
//  Created by David Cao on 7/27/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHLArticle;

@interface PHLArticleViewController : UIViewController

@property (strong, nonatomic) PHLArticle *article;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


- (id)initWithArticle:(PHLArticle *)article;

@end
