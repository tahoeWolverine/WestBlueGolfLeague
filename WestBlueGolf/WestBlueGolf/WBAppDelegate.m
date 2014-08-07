//
//  WBAppDelegate.m
//  West Blue Golf
//
//  Created by Mike Harlow on 1/22/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBAppDelegate.h"
#import <TRInternalAppAuth/TRInternalAppAuthService.h>
#import "WBAvailableYearsService.h"
#import "WBCoreDataManager.h"
#import "WBDataManager.h"
#import "WBHandicapManager.h"
#import "WBInputDataManager.h"
#import "WBLeaderBoardManager.h"
#import "WBModels.h"
#import "WBNotifications.h"
#import "WBPlayersSplitDelegate.h"
#import "WBProfileTableViewController.h"
#import "WBSettings.h"
#import "WBYearDataService.h"

@interface WBAppDelegate ()

@property (strong, nonatomic) WBDataManager *dataManager;

@property (strong, nonatomic) NSMutableArray *splitDelegates;

@end

@implementation WBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Start reachability testing (simply by accessing the shared reference)
	//ConnectionStatusManager *connectManager = [ConnectionStatusManager sharedManager];
	
//#ifndef TR_SKIP_INTERNAL_APP_AUTH
	//if ([connectManager isAbleToConnectToInternet]) {

		// check to see if the use of the application has already been authorized
		//if (![TRInternalAppAuthService isAuthorized]) {
			//[self authorizeUserForInternalApp];
		//}
	//}
//#endif

	[self subscribeToNotifications];

    //[WBSettings configureStandardDefaults];
	
	self.dataManager = [WBDataManager dataManager];
	[self.dataManager setupData];
	
	// Fix iOS7.1 tint issue
	[self.window setTintColor:kEmeraldColor];

	// Split view hack
    self.splitDelegates = [NSMutableArray array];
	UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
	for (UIViewController *vc in tbc.viewControllers) {
        if ([vc isKindOfClass:[UISplitViewController class]]) {
            UISplitViewController *svc = (UISplitViewController *)vc;
            WBPlayersSplitDelegate *sd = [[WBPlayersSplitDelegate alloc] init];
            [self.splitDelegates addObject:sd];
            [svc setDelegate:sd];
        }
    }
	
    return YES;
}

#pragma mark - Important properties

+ (instancetype)sharedDelegate {
	return (WBAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (NSInteger)thisYearValue {
	return [self.dataManager thisYearValue];
}

- (void)changeYearToYear:(NSInteger)year {
	[self.dataManager setThisYearValue:year inContext:[WBCoreDataManager mainContext]];
}

- (void)refreshThisYear {
	[self.dataManager resetYearFromServer:[WBYear thisYear]];
}

- (void)setLoading:(BOOL)loading {
	_loading = loading;
	if (!loading) {
		[[NSNotificationCenter defaultCenter] postNotificationName:WBLoadingFinishedNotification object:nil];
	}
}

- (void)resetAllData {
	[self.dataManager setupCoreData:YES];
	[self setProfileTabPlayer];
}

- (void)setProfileTabPlayer {
	WBPlayer *me = [WBPlayer me];
	UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
	id vc = [tbc.viewControllers objectAtIndex:0];
	if ([vc isKindOfClass:[UINavigationController class]]) {
		UINavigationController *profileTab = (UINavigationController *)vc;
		((WBProfileTableViewController *)profileTab.topViewController).selectedPlayer = me;
	}
}

- (BOOL)isProfileTab:(UIViewController *)vc {
	UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
	id firstVC = [tbc.viewControllers objectAtIndex:0];
	if ([firstVC isKindOfClass:[UINavigationController class]]) {
		UINavigationController *navc = (UINavigationController *)firstVC;
		return vc == navc.topViewController;
	}
	return NO;
}

#pragma mark - TRInternalAppAuthService methods

#ifndef TR_SKIP_INTERNAL_APP_AUTH
- (void)authorizeUserForInternalApp {
	// otherwise make the user authenticate
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internalAppAuthorizationWasSuccessful:) name:TRInternalAppAuthorizationWasSuccessfulNotification object:nil];
	[TRInternalAppAuthService authorizeUserModallyFromRootViewController:self.window.rootViewController animated:NO];
}

- (void)internalAppAuthorizationWasSuccessful:(NSNotification *)notification {
	NSAssert([TRInternalAppAuthService isAuthorized], @"user should have been authorized");
	
	// remove the notifcation request and show the splash screen
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TRInternalAppAuthorizationWasSuccessfulNotification object:nil];
	//[self showSplashScreen];
}
#endif
							
- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	[self unsubscribeFromNotfications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[self unsubscribeFromNotfications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	[self subscribeToNotifications];
	
	//BOOL auth = [TRInternalAppAuthService isAuthorized];
	//DLog(@"User is %@authorized for use", auth ? @"" : @"not ");
	//[self.window.rootViewController dismissViewControllerAnimated:NO completion:^{}];
	//[self authorizeUserForInternalApp];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	[self subscribeToNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	[self unsubscribeFromNotfications];
}

- (void)subscribeToNotifications {
	/*[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(resetYear)
												 name:WBYearChangedNotification
											   object:nil];*/
}

- (void)unsubscribeFromNotfications {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
