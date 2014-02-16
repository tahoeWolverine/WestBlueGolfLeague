//
//  WBAppDelegate.m
//  West Blue Golf
//
//  Created by Mike Harlow on 1/22/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBAppDelegate.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"

@implementation WBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
	[[WBCoreDataManager sharedManager] resetManagedObjectContextAndPersistentStore];

    return YES;
}

- (void)createTestData {
	/*WBYear *year = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[self managedObjectContext]];
	 WBWeek *week = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[self managedObjectContext]];
	 
	 WBTeam *team1 = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[self managedObjectContext]];
	 WBCaptain *captain1 = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[self managedObjectContext]];
	 WBPlayer *player10 = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[self managedObjectContext]];
	 WBPlayer *player11 = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[self managedObjectContext]];
	 WBPlayer *player12 = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[self managedObjectContext]];
	 WBPlayer *player13 = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[self managedObjectContext]];
	 
	 WBTeam *team2 = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[self managedObjectContext]];
	 WBCaptain *captain2 = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[self managedObjectContext]];
	 WBPlayer *player20 = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[self managedObjectContext]];
	 WBPlayer *player21 = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[self managedObjectContext]];
	 WBPlayer *player22 = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[self managedObjectContext]];
	 WBPlayer *player23 = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[self managedObjectContext]];*/
	
	[[WBCoreDataManager sharedManager] saveContext];
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
