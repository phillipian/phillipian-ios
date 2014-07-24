//
//  PHLPSCManager.h
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

 

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PHLMainContext;

@interface PHLPSCManager : NSObject

@property (nonatomic, readonly, strong) NSManagedObjectModel *mom;

+ (PHLPSCManager *)sharedManager;
+ (NSPersistentStoreCoordinator *)sharedStoreCooridinator;

- (void)purgeData;

@end
