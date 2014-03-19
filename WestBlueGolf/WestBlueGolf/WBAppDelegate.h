//
//  WBAppDelegate.h
//  West Blue Golf
//
//  Created by Mike Harlow on 1/22/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#define kEmeraldColor [UIColor colorWithRed:46.0 / 255.0 green:204.0 / 255.0 blue:113.0 / 255.0 alpha:1.0]

@interface WBAppDelegate : UIResponder <UIApplicationDelegate> {
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL loading;

- (void)setProfileTabPlayer;
- (BOOL)isProfileTab:(UIViewController *)vc;

- (NSInteger)thisYearValue;
- (void)setThisYearValue:(NSInteger)value;

- (void)setupCoreData:(BOOL)reset;

@end
