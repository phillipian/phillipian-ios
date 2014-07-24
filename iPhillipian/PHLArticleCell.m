//
//  PHLArticleCell.m
//  iPhillipian
//
//  Created by David Cao on 7/19/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import "PHLArticleCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PHLArticleCell

- (void)awakeFromNib
{
    // Initialization code
    
    [[[self thumbView] layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[[self thumbView] layer] setBorderWidth:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNoThumb {
    
    [self.bodyLabel setFrame:CGRectMake(self.bodyLabel.frame.origin.x, self.bodyLabel.frame.origin.y, self.thumbView.frame.origin.x + self.thumbView.frame.size.width - self.bodyLabel.frame.origin.x, self.bodyLabel.frame.size.height)];
    [self setThumbView:nil];
}

- (void)setWithThumb {
    [self.bodyLabel setFrame:CGRectMake(self.bodyLabel.frame.origin.x, self.bodyLabel.frame.origin.y, self.bodyLabel.frame.size.width - 76 - 8, self.bodyLabel.frame.size.height)];
}

@end
