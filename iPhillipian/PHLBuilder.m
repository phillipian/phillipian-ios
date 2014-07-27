//
//  PHLBuilder.m
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import "PHLBuilder.h"
#import "PHLPSCManager.h"
#import "PHLMainContext.h"
#import "PHLFetcher.h"
#import "PHLFormatter.h"
#import "PHLArticle.h"
#import "PHLSection.h"

static NSString * const JSONNidKey = @"nid";
static NSString * const JSONSectionKey = @"section";
static NSString * const JSONTitleKey = @"title";
static NSString * const JSONDeckKey = @"deck";
static NSString * const JSONWriterKey = @"writer";
static NSString * const JSONBodyKey = @"body";
static NSString * const JSONImageKey = @"image";
static NSString * const JSONThumbnailKey = @"square_thumbnail";
static NSString * const JSONImageCaptionKey = @"image_caption";
static NSString * const JSONImageCreditKey = @"image_credit";
static NSString * const JSONUrlKey = @"url";
static NSString * const JSONIssueDateKey = @"issue_date";
static NSString * const JSONArticleDateKey = @"article_date";

@interface PHLBuilder ()


@end

@implementation PHLBuilder

+ (void)buildArticles:(NSArray *)array {
    for (NSDictionary *dict in array) {
        [PHLBuilder buildArticle:dict];
    }
    
    NSLog(@"Finished parsing articles from initial JSON req, posting notification");
    [[NSNotificationCenter defaultCenter] postNotificationName:ArticlesRecievedNotification object:nil];
    
}

+ (void)buildArticle:(NSDictionary *)dict {
    
    PHLArticle *article = (PHLArticle *)[NSEntityDescription insertNewObjectForEntityForName:@"PHLArticle"
                                                        inManagedObjectContext:[PHLMainContext sharedContext]];

    //required
    NSNumber *nid = [NSNumber numberWithInteger:[[dict objectForKey:JSONNidKey] integerValue]];
    
    if ([[PHLFetcher articleWithNid:nid inContext:[PHLMainContext sharedContext]] count] != 0) {
        NSLog(@"This article has been parsed before!");
        NSLog(@"THIS IS STILL GOING TO PARSE IT, SINCE THE JSON IS TERRIBLE :((");
        [[PHLMainContext sharedContext] rollback];
        return;
    }
    
    [article setValue:nid forKeyPath:NidKey];
    [article setValue:[dict objectForKey:JSONTitleKey] forKeyPath:TitleKey];
    [article setValue:[dict objectForKey:JSONDeckKey] forKeyPath:DeckKey];
    [article setValue:[dict objectForKey:JSONWriterKey] forKeyPath:WriterKey];
    [article setValue:[dict objectForKey:JSONBodyKey] forKeyPath:BodyKey];
    [article setValue:[NSString stringWithFormat:@"%@%@", PhillipianURL, [dict objectForKey:JSONUrlKey]] forKeyPath:UrlToSiteKey];
    
    //check the dates
    if ([dict objectForKey:JSONIssueDateKey] != [NSNull null]) {
        [article setValue:[PHLFormatter issueDate:[dict objectForKey:JSONIssueDateKey]] forKeyPath:IssueDateKey];
    }
    if ([dict objectForKey:JSONArticleDateKey] != [NSNull null]) {
        [article setValue:[PHLFormatter articleDate:[dict objectForKey:JSONArticleDateKey]] forKeyPath:ArticleDateKey];
    }
    
    //validate
    if ([dict objectForKey:JSONImageKey] != [NSNull null] && [[dict objectForKey:JSONImageKey] length] != 0) {
        [article setValue:[PHLFormatter imageURL:[dict objectForKey:JSONImageKey]] forKeyPath:ImageURLKey];
        [article setValue:[dict objectForKey:JSONImageCaptionKey] forKeyPath:ImageCaptionKey];
        [article setValue:[dict objectForKey:JSONImageCreditKey] forKeyPath:ImageCreditKey];
    }
    
    //build section
    PHLSection *section;
    if ([[PHLFetcher SectionsWithName:[dict objectForKey:JSONSectionKey] inContext:[PHLMainContext sharedContext]] count] > 0) {
        //get the section or...
        section = [[PHLFetcher SectionsWithName:[dict objectForKey:JSONSectionKey] inContext:[PHLMainContext sharedContext]] firstObject];
    } else {
        //make a new section
        section = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PHLSection class])
                                                            inManagedObjectContext:[PHLMainContext sharedContext]];
        [section setSectionName:[dict objectForKey:JSONSectionKey]];
        NSLog(@"Made new section with name: %@", [section sectionName]);
    }
    
    [section addArticlesObject:article];
    [article setSection:section];
    
    NSError *err = nil;
    [[PHLMainContext sharedContext] save:&err];
    if (err) {
        [[PHLMainContext sharedContext] rollback];
        SharedErrorBlock(err, METHOD_NAME);
        return;
    } else {
        if ([dict objectForKey:JSONThumbnailKey] != [NSNull null] && ![[dict objectForKey:JSONThumbnailKey] isEqualToString:@""]) {
            [PHLFormatter thumbnailData:[PHLFormatter imageURL:[dict objectForKey:JSONThumbnailKey]] forArticle:article];
            [[PHLMainContext sharedContext] save:&err];
        }
    }
    
}

@end
