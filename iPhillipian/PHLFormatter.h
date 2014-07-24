//
//  PHLFormatter.h
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHLArticle;

@interface PHLFormatter : NSObject

+ (NSString *)imageURL:(NSString *)rawString;
+ (void)thumbnailData:(NSString *)thumbURL forArticle:(PHLArticle *)article;
+ (NSDate *)issueDate:(NSString *)rawString;
+ (NSDate *)articleDate:(NSString *)rawString;

@end
