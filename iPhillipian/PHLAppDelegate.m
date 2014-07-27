//
//  PHLAppDelegate.m
//  iPhillipian
//
//  Created by David Cao on 7/16/14.
//  Copyright (c) 2014 Phillipian. All rights reserved.
//

#import "PHLAppDelegate.h"
#import "PHLConnectionHelper.h"
#import "PHLPSCManager.h"
#import "PHLSectionViewController.h"
#import "PHLMenuViewController.h"
#import "SWRevealViewController.h"
#import "PHLLoadingViewController.h"

@implementation PHLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    //Make sure to get ALL articles if there are current ones (check until nid is matching)
    
    //actually ignore that^ Probably just purge each launch, only load as they scroll down, api is too bare bones to do anything else
    
    [[PHLPSCManager sharedManager] purgeData];
    [PHLPSCManager sharedManager];
    [PHLConnectionHelper startWebRequests];
    
    
    
    
    PHLSectionViewController *sectionController = [[PHLSectionViewController alloc] init];
    UINavigationController *sectionNav = [[UINavigationController alloc] initWithRootViewController:sectionController];
    
    PHLLoadingViewController *loadingController = [[PHLLoadingViewController alloc] init];
    [sectionController setLoadingViewController:loadingController];
    [[sectionNav view] addSubview:[loadingController view]];
    
    PHLMenuViewController *menuController = [[PHLMenuViewController alloc] init];
    UINavigationController *menuNav = [[UINavigationController alloc] initWithRootViewController:menuController];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:menuNav frontViewController:sectionNav];
    
    [self.window setRootViewController:revealController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
