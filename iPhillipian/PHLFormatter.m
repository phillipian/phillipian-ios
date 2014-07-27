//
//  PHLFormatter.m
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import "PHLFormatter.h"
#import "PHLArticle.h"
#import "AFNetworking.h"
#import "PHLMainContext.h"

@implementation PHLFormatter

+ (NSString *)imageURL:(NSString *)rawString {
    
    if (rawString == nil) {
        
        NSLog(@"Nil?, %@", METHOD_NAME);
    }
    
    static NSRegularExpression *regex = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *error = nil;
        regex = [NSRegularExpression
                 regularExpressionWithPattern:@"\\b(src=\\\"[^\"]*\")"
                 options:NSRegularExpressionAllowCommentsAndWhitespace
                 error:&error];
        SharedErrorBlock(error, METHOD_NAME);
    });
    
    NSRange range = [regex rangeOfFirstMatchInString:rawString
                                             options:0
                                               range:NSMakeRange(0, [rawString length])];
    NSInteger index = range.location;
    NSInteger end = range.length;
    
    return [rawString substringWithRange:NSMakeRange(index + 5, end - 6)];
    
}

+ (void)thumbnailData:(NSString *)thumbURL forArticle:(PHLArticle *)article {
    
    if (thumbURL == nil) {
        NSLog(@"Nil?, %@", METHOD_NAME);
    }
        
    AFHTTPRequestOperation *req = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:thumbURL]]];
    [req start];
    [req setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = responseObject;
        [article setValue:data forKey:ThumbnailKey];
        
        [[PHLMainContext sharedContext] save:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ThumbnailReadyNotification object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogObject(@"Thumbnail request failed");
    }];
    
    
}

+ (NSDate *)issueDate:(NSString *)rawString {
    if(!rawString) return nil;
    
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
    });
    
    NSString *refinedDateString = [rawString substringToIndex:10];
    
    return [formatter dateFromString:refinedDateString];
}

+ (NSDate *)articleDate:(NSString *)rawString {
    if (rawString == nil) {
        NSLog(@"Nil?, %@", METHOD_NAME);
    }
    static NSDateFormatter *formatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    });
    
    NSString *refinedDateString = [rawString substringToIndex:19];
    
    return [formatter dateFromString:refinedDateString];
}

@end
