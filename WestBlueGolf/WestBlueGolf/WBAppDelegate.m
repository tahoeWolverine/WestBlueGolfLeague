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
#import "WBNotifications.h"
#import "WBProfileTableViewController.h"

#define kDefaultYear 2013

@interface WBAppDelegate ()

@property (assign, nonatomic) NSInteger yearSelection;

@end

@implementation WBAppDelegate

- (NSInteger)thisYearValue {
	return self.yearSelection ?: kDefaultYear;
}

- (void)setThisYearValue:(NSInteger)value {
	self.yearSelection = value;
	[[NSNotificationCenter defaultCenter] postNotificationName:WBYearChangedNotification object:nil];
}

- (void)setLoading:(BOOL)loading {
	_loading = loading;
	[[NSNotificationCenter defaultCenter] postNotificationName:WBLoadingFinishedNotification object:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
	//[[WBCoreDataManager sharedManager] resetManagedObjectContextAndPersistentStore];
	[WBCoreDataManager sharedManager];
	
	__block WBYear *year = [WBYear newestYear];
	self.yearSelection = year.valueValue;
	__block typeof(self) weakSelf = self;
	
	if (!year) {
		self.loading = YES;
		//MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	//	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
			// Do something...
			WBInputDataManager *inputManager = [[WBInputDataManager alloc] init];
			[inputManager loadJsonDataForYearValue:self.thisYearValue];
			[inputManager loadJsonDataForYearValue:2012];
			//[inputManager loadJsonDataForYearValue:2011];
			
			// Create dummy 2011
			WBTeam *noTeam = [WBTeam createTeamWithName:@"Season not yet over" teamId:0];
			WBYear *year2 = [WBYear createYearWithValue:2011 champion:noTeam];
			year2.isCompleteValue = YES;
			[noTeam deleteEntity];
			[WBCoreDataManager saveContext];
			
			year = [WBYear newestYear];
			weakSelf.yearSelection = year.valueValue;
			
			WBHandicapManager *handiManager = [[WBHandicapManager alloc] init];
			[handiManager calculateHandicapsForYear:year];
			[handiManager calculateHandicapsForYear:[WBYear yearWithValue:2012]];
			
			WBLeaderBoardManager *boardManager = [[WBLeaderBoardManager alloc] init];
			[boardManager clearLeaderBoards];
			[boardManager calculateLeaderBoardsForYear:year];
			[boardManager calculateLeaderBoardsForYear:[WBYear yearWithValue:2012]];
			[boardManager calculateLeaderBoardsForYear:[WBYear yearWithValue:2011]];

		//	dispatch_async(dispatch_get_main_queue(), ^{
				//[MBProgressHUD hideHUDForView:self.view animated:YES];
				//weakSelf.loading = NO;
		[self performSelector:@selector(setLoading:) withObject:NO afterDelay:3.0];
		//	});
		//});
	}

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
