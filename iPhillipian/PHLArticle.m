//
//  PHLArticle.m
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import "PHLArticle.h"
#import "PHLSection.h"

NSString * const ArticleDateKey = @"articleDate";
NSString * const BodyKey = @"body";
NSString * const DeckKey = @"deck";
NSString * const ImageCaptionKey = @"imageCaption";
NSString * const ImageCreditKey = @"imageCredit";
NSString * const ImageURLKey = @"imageURL";
NSString * const IssueDateKey = @"issueDate";
NSString * const NidKey = @"nid";
NSString * const ThumbnailKey = @"thumbnail";
NSString * const TitleKey = @"title";
NSString * const UrlToSiteKey = @"url";
NSString * const WriterKey = @"writer";

@implementation PHLArticle

@dynamic nid;
@dynamic title;
@dynamic deck;
@dynamic writer;
@dynamic body;
@dynamic imageURL;
@dynamic thumbnail;
@dynamic imageCaption;
@dynamic imageCredit;
@dynamic url;
@dynamic issueDate;
@dynamic articleDate;
@dynamic section;

@end
