//
//  PHLConnectionHelper.h
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHLConnectionHelper : NSObject

+ (PHLConnectionHelper *)startWebRequests;
+ (PHLConnectionHelper *)sharedRequestController;

+ (void)getArticlesForSection:(NSString *)section;

@end
