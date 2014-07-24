//
//  PHLReadContext.h
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface PHLMainContext : NSObject

+ (NSManagedObjectContext *)sharedContext;

@end
