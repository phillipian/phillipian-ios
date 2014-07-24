//
//  PHLArticleCell.h
//  iPhillipian
//
//  Created by David Cao on 7/19/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHLArticleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *writerLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbView;

- (void)setNoThumb;
- (void)setWithThumb;

@end
