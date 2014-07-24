//
//  PHLFetcher.h
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PHLFetcher : NSObject

+ (NSArray *)SectionsWithName:(NSString *)name inContext:(NSManagedObjectContext *)moc;
+ (NSArray *)articleWithNid:(NSNumber *)nid inContext:(NSManagedObjectContext *)moc;

+ (NSFetchedResultsController *)resultsControllerForArticlesWithSection:(NSString *)sectionName inContext:(NSManagedObjectContext *)moc;
+ (NSFetchedResultsController *)resultsControllerForAllArticles:(NSManagedObjectContext *)moc;

@end
