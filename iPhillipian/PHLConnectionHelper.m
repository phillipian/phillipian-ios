//
//  PHLConnectionHelper.m
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import "PHLConnectionHelper.h"
#import "AFNetworking.h"
#import "PHLBuilder.h"

static PHLConnectionHelper *requestController = nil;

@interface PHLConnectionHelper ()

@property (strong, nonatomic) NSArray *sections;

- (void)requestArticles;

@end

@implementation PHLConnectionHelper

- (id)init {
    
    if (self = [super init]) {
        //setup future properties here
        [self setSections:@[@"all", @"news", @"sports", @"arts", @"commentary", @"editorial", @"letters%20to%20the%20editor", @"features", @"cross%20campus"]];
        [self requestArticles];
    }
    
    return self;
}

+ (PHLConnectionHelper *)startWebRequests {
    if (!requestController) {
        requestController = [[PHLConnectionHelper alloc] init];
    }
    return requestController;
}

+ (PHLConnectionHelper *)sharedRequestController {
    [PHLConnectionHelper sharedRequestController];
    return requestController;
}

- (void)requestArticles {
    
    NSString *requestPath =  [NSString stringWithFormat:@"%@/mobile/views/services_article_list.jsonp?args=%@&page=0", PhillipianURL, [self.sections objectAtIndex:0]];
    NSURL *url = [NSURL URLWithString:requestPath];
    
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *req = [[AFHTTPRequestOperation alloc] initWithRequest:urlReq];
    [req setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *articles = (NSArray *)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                      options:0
                                                                        error:nil];
        NSLog(@"JSON RESPONSE: %@", articles);
        
        [PHLBuilder buildArticles:articles];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //network is down
        LogObject(@"Request Failure");
    }];
    
    [req start];

    
}

+ (void)getArticlesForSection:(NSString *)section {
    NSString *requestPath =  [NSString stringWithFormat:@"%@/mobile/views/services_article_list.jsonp?args=%@&page=0", PhillipianURL, section];
    LogObject(requestPath);
    NSURL *url = [NSURL URLWithString:requestPath];
    
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *req = [[AFHTTPRequestOperation alloc] initWithRequest:urlReq];
    [req setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *articles =(NSArray *)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                      options:0
                                                                        error:nil];
//        NSLog(@"JSON RESPONSE: %@", articles);
        
        [PHLBuilder buildArticles:articles];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //network is down
        LogObject(@"Request Failure");
    }];
    
    [req start];
}

@end
