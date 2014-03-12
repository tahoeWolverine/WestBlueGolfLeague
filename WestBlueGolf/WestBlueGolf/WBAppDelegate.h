//
//  WBAppDelegate.h
//  West Blue Golf
//
//  Created by Mike Harlow on 1/22/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@interface WBAppDelegate : UIResponder <UIApplicationDelegate> {
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (strong, nonatomic) UIWindow *window;

- (void)setProfileTabPlayer;
- (BOOL)isProfileTab:(UIViewController *)vc;

@end
