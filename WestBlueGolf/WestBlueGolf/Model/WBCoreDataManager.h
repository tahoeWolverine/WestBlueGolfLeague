//
//  WBCoreDataManager.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 2/7/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBTeam;
@class WBWeek;

@interface WBCoreDataManager : NSObject

+ (id)sharedManager;
+ (void)logError:(NSError *)error;
+ (void)saveMainContext;
+ (void)saveContext:(NSManagedObjectContext *)moc;

- (NSManagedObjectContext *)managedObjectContext;
- (void)resetCoreDataStack;

// Removes any persistent stores and files.
// Releases the current Managed Object Context so that a new one will be set up and returned when sharedManager.managedObjectContext is accessed.
// NOTE: This method should only be called during app startup/reset!
- (void)resetManagedObjectContextAndPersistentStore;

- (NSInteger)rankForTeam:(WBTeam *)team priorToWeek:(WBWeek *)week;
- (void)setRank:(NSInteger)rank forTeam:(WBTeam *)team priorToWeek:(WBWeek *)week;

@end
