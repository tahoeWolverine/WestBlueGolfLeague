//
//  WBAppDelegate.m
//  West Blue Golf
//
//  Created by Mike Harlow on 1/22/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBAppDelegate.h"
#import "WBCoreDataManager.h"
#import "WBHandicapManager.h"
#import "WBInputDataManager.h"
#import "WBLeaderBoardManager.h"
#import "WBModels.h"
#import "WBProfileTableViewController.h"

@implementation WBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
	//[[WBCoreDataManager sharedManager] resetManagedObjectContextAndPersistentStore];
	[WBCoreDataManager sharedManager];
	
	WBYear *year = [WBYear thisYear];
	
	if (!year) {
		WBInputDataManager *inputManager = [[WBInputDataManager alloc] init];
		[inputManager loadJsonData];
		
		WBHandicapManager *handiManager = [[WBHandicapManager alloc] init];
		[handiManager calculateHandicaps];
	}
	
	WBLeaderBoardManager *boardManager = [[WBLeaderBoardManager alloc] init];
	[boardManager calculateLeaderBoards];
	
    return YES;
}

- (void)setProfileTabPlayer {
	WBPlayer *me = [WBPlayer me];
	UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
	UINavigationController *profileTab = (UINavigationController *)[tbc.viewControllers objectAtIndex:0];
	((WBProfileTableViewController *)profileTab.topViewController).selectedPlayer = me;
}

- (BOOL)isProfileTab:(UIViewController *)vc {
	UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
	UINavigationController *navc = (UINavigationController *)[tbc.viewControllers objectAtIndex:0];
	return vc == navc.topViewController;
}

- (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
