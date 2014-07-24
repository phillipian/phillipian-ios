//
//  PHLBuilder.h
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHLArticle;

@interface PHLBuilder : NSObject

+ (void)buildArticles:(NSArray *)array;
+ (void)buildArticle:(NSDictionary *)dict;

@end
