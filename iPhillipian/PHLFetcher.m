//
//  PHLFetcher.m
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import "PHLFetcher.h"
#import "PHLMainContext.h"
#import "PHLPSCManager.h"
#import "PHLArticle.h"

static NSString *NIDTemplateKey = @"NID";
static NSString *ArticleWithNidTemplate = @"ArticleWithNid";
static NSString *SectionNameTemplateKey = @"NAME";
static NSString *SectionsWithNameTemplate = @"SectionsForName";

NSString * const allArticlesCache = @"allArticles";
NSString * const allSectionsCache = @"allSections";

@implementation PHLFetcher

+ (NSArray *)SectionsWithName:(NSString *)name inContext:(NSManagedObjectContext *)moc {
    
    NSError *error = nil;
    NSDictionary *subVars = [NSDictionary dictionaryWithObject:name forKey:SectionNameTemplateKey];
    NSFetchRequest *req = [[[PHLPSCManager sharedManager] mom] fetchRequestFromTemplateWithName:SectionsWithNameTemplate
                                                                          substitutionVariables:subVars];
    NSArray *fetchedSections = [moc executeFetchRequest:req error:&error];
    SharedErrorBlock(error, METHOD_NAME);
    
    return fetchedSections;
}

+ (NSArray *)articleWithNid:(NSNumber *)nid inContext:(NSManagedObjectContext *)moc {
    NSError *error = nil;
    NSDictionary *subVars = [NSDictionary dictionaryWithObject:nid forKey:NIDTemplateKey];
    NSFetchRequest *req = [[[PHLPSCManager sharedManager] mom] fetchRequestFromTemplateWithName:ArticleWithNidTemplate
                                                                          substitutionVariables:subVars];
    NSArray *fetchedArticles = [moc executeFetchRequest:req error:&error];
    SharedErrorBlock(error, METHOD_NAME);
    
    return fetchedArticles;
}

+ (NSFetchedResultsController *)resultsControllerForAllArticles:(NSManagedObjectContext *)moc {
    
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"PHLArticle"];
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:ArticleDateKey ascending:NO];
    [req setSortDescriptors:[NSArray arrayWithObject:dateDescriptor]];
    NSFetchedResultsController *reqController = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                                    managedObjectContext:moc
                                                                                      sectionNameKeyPath:nil
                                                                                               cacheName:allArticlesCache];
    NSError *error = nil;
    [reqController performFetch:&error];
    SharedErrorBlock(error, METHOD_NAME);
    
    return reqController;
}

+ (NSFetchedResultsController *)resultsControllerForArticlesWithSection:(NSString *)sectionName inContext:(NSManagedObjectContext *)moc {
    
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:ArticleDateKey ascending:NO];
    [req setSortDescriptors:[NSArray arrayWithObject:dateDescriptor]];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PHLArticle" inManagedObjectContext:moc];
    [req setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"section.sectionName like[c] %@", sectionName];
    [req setPredicate:predicate];
    
    NSFetchedResultsController *reqController = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                                    managedObjectContext:moc
                                                                                      sectionNameKeyPath:nil
                                                                                               cacheName:allArticlesCache];
    NSError *error = nil;
    [reqController performFetch:&error];
    SharedErrorBlock(error, METHOD_NAME);
    
    return reqController;
}



@end
