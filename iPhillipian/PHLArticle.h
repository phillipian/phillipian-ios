//
//  PHLArticle.h
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const ArticleDateKey;
extern NSString * const BodyKey;
extern NSString * const DeckKey;
extern NSString * const ImageCaptionKey;
extern NSString * const ImageCreditKey;
extern NSString * const ImageURLKey;
extern NSString * const IssueDateKey;
extern NSString * const NidKey;
extern NSString * const ThumbnailKey;
extern NSString * const TitleKey;
extern NSString * const UrlToSiteKey;
extern NSString * const WriterKey;

@class PHLSection;

@interface PHLArticle : NSManagedObject

@property (nonatomic, retain) NSNumber * nid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * deck;
@property (nonatomic, retain) NSString * writer;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * imageCaption;
@property (nonatomic, retain) NSString * imageCredit;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * issueDate;
@property (nonatomic, retain) NSDate * articleDate;
@property (nonatomic, retain) PHLSection *section;

@end
