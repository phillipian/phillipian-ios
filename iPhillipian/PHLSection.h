//
//  PHLSection.h
//  iPhillipian
//
//  Created by David Cao on 7/24/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const SectionKey;

@class PHLArticle;

@interface PHLSection : NSManagedObject

@property (nonatomic, retain) NSString * sectionName;
@property (nonatomic, retain) NSSet *articles;
@end

@interface PHLSection (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(PHLArticle *)value;
- (void)removeArticlesObject:(PHLArticle *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

@end
