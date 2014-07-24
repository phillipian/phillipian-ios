//
//  PHLReadContext.m
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import "PHLMainContext.h"
#import "PHLPSCManager.h"
#import "PHLSection.h"
static PHLMainContext *sharedReadContextManager = nil;

@interface PHLMainContext ()

@property (strong, nonatomic) NSManagedObjectContext *src;
@end



@implementation PHLMainContext
@synthesize src;

+ (id)allocWithZone:(NSZone *)zone{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedReadContextManager = [[super allocWithZone:nil] init];
    });
    
    return sharedReadContextManager;
}

+ (NSManagedObjectContext *)sharedContext{
    if (!sharedReadContextManager) {
        sharedReadContextManager = [[PHLMainContext alloc] init];
    }
    if ([sharedReadContextManager src]) {
        return [sharedReadContextManager src];
    }
    
    NSPersistentStoreCoordinator *psc = [PHLPSCManager sharedStoreCooridinator];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    
    [sharedReadContextManager setSrc:moc];
    
    return [sharedReadContextManager src];
}

@end
