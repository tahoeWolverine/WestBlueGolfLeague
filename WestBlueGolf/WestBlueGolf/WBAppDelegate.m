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

@interface WBAppDelegate ()

@property (assign, nonatomic) NSInteger yearSelection;

@end

@implementation WBAppDelegate

- (NSInteger)thisYearValue {
	return self.yearSelection;
}

- (void)setThisYearValue:(NSInteger)value inContext:(NSManagedObjectContext *)moc {
	if (value != 0 && value != self.yearSelection) {
		self.yearSelection = value;
		[self resetYearInContext:moc];
	}
}

- (void)setLoading:(BOOL)loading {
	_loading = loading;
	[[NSNotificationCenter defaultCenter] postNotificationName:WBLoadingFinishedNotification object:nil];
}

- (void)loadAndCalculateForYear:(NSInteger)yearValue moc:(NSManagedObjectContext *)moc {
	WBInputDataManager *inputManager = [[WBInputDataManager alloc] init];
	[inputManager loadJsonDataForYearValue:yearValue fromContext:moc];
	WBYear *year = [WBYear yearWithValue:yearValue inContext:moc];
	WBHandicapManager *handiManager = [[WBHandicapManager alloc] init];
	[handiManager calculateHandicapsForYear:year moc:moc];
	WBLeaderBoardManager *boardManager = [[WBLeaderBoardManager alloc] init];
	[boardManager calculateLeaderBoardsForYear:year moc:moc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	//[self setupCoreData:NO];
	
	[self subscribeToNotifications];
	
	// Fix iOS7.1 tint issue
	[self.window setTintColor:kEmeraldColor];

    return YES;
}

- (void)setupCoreData:(BOOL)reset {
	if (reset) {
		[[WBCoreDataManager sharedManager] resetManagedObjectContextAndPersistentStore];
	}
	
	WBYear *year = [WBYear newestYearInContext:[[WBCoreDataManager sharedManager] managedObjectContext]];
	self.yearSelection = year.valueValue;
	
	if (!year) {
		//NSPersistentStoreCoordinator *psc = [[WBCoreDataManager sharedManager] persistentStoreCoordinator];
		//dispatch_queue_t request_queue = dispatch_queue_create("com.westbluegolfleague", NULL);
		__block typeof(self) weakSelf = self;
		DLog(@"Processing Started");
		//dispatch_async(request_queue, ^{
			//NSManagedObjectContext *newMoc = [[NSManagedObjectContext alloc] init];
			//[newMoc setPersistentStoreCoordinator:psc];
			
			//[[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(mergeChanges:)  name:NSManagedObjectContextDidSaveNotification object:newMoc];
			
			// Background code
			WBInputDataManager *inputManager = [[WBInputDataManager alloc] init];
			[inputManager createYearsInContext:[[WBCoreDataManager sharedManager] managedObjectContext]]; //newMoc];
			[WBCoreDataManager saveMainContext];
			
			[weakSelf setThisYearValue:[WBYear newestYearInContext:[[WBCoreDataManager sharedManager] managedObjectContext]].valueValue inContext:[[WBCoreDataManager sharedManager] managedObjectContext]];
			
			//[weakSelf resetYearInContext:newMoc];
			
			// Save and finish
			/*NSError *error = nil;
			BOOL success = [newMoc save:&error];
			if (!success) {
				DLog(@"Core data error in background %@", [error localizedDescription]);
			}*/
			
			
			//[[NSNotificationCenter defaultCenter] removeObserver:self];
			
		//});
	}
}

- (void)mergeChanges:(NSNotification *)notification {
	dispatch_async(dispatch_get_main_queue(), ^{
		[[[WBCoreDataManager sharedManager] managedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
	});
}

- (void)resetYearInContext:(NSManagedObjectContext *)moc {
	WBYear *newYear = [WBYear thisYearInContext:moc];
	if (!newYear.weeks || newYear.weeks.count == 0) {
		self.loading = YES;
		//dispatch_queue_t request_queue = dispatch_queue_create("com.westbluegolfleague", NULL);
		__block typeof(self) weakSelf = self;
		NSPersistentStoreCoordinator *psc = [[WBCoreDataManager sharedManager] persistentStoreCoordinator];
		
		DLog(@"Processing Started");
		//dispatch_async(request_queue, ^{
			NSManagedObjectContext *newMoc = [[NSManagedObjectContext alloc] init];
			[newMoc setPersistentStoreCoordinator:psc];
			
			[[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(mergeChanges:)  name:NSManagedObjectContextDidSaveNotification object:newMoc];
			
			[self loadAndCalculateForYear:newYear.valueValue moc:moc];
			
			[WBCoreDataManager saveContext:moc];
			
			[self performSelectorOnMainThread:@selector(setLoading:) withObject:NO waitUntilDone:NO];
		//});
		//[self performSelectorOnMainThread:@selector(setLoading:) withObject:NO waitUntilDone:NO];
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:WBYearChangedLoadingFinishedNotification object:nil];
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
