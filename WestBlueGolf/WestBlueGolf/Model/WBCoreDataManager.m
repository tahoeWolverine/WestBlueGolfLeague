//
//  WBCoreDataManager.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 2/7/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBCoreDataManager.h"
#import "WBFileSystem.h"

#define DOMAIN_NAME @"WestBlueGolf"
#define MODEL_FILE_EXTENSION @"momd"
#define DATABASE_FILE_EXTENSION @"sqlite"

@interface WBCoreDataManager () {
	NSManagedObjectContext *_managedObjectContext;
}

@end

@implementation WBCoreDataManager

#pragma mark - GCD-based Singleton method

+ (id)sharedManager {
	static dispatch_once_t pred;
	static WBCoreDataManager *alertCoreDataManager = nil;
	dispatch_once(&pred, ^{alertCoreDataManager = [[self alloc] init];});
	return alertCoreDataManager;
}

#pragma mark - Core Data stack

+ (NSString *)persistentStorePath {
	NSString *directory = [WBFileSystem privateDocumentsDirectory];
	return [[directory stringByAppendingPathComponent:DOMAIN_NAME @"-CD"] stringByAppendingPathExtension:DATABASE_FILE_EXTENSION];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	NSString *modelPath = [[NSBundle mainBundle] pathForResource:DOMAIN_NAME ofType:MODEL_FILE_EXTENSION];
	NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
	NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
	
	// The 'options' dictionary defines the required options telling Core Data to perform lightweight migrations
	NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
	options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
	options[NSInferMappingModelAutomaticallyOption] = @YES;
	
	NSError *error = nil;
	NSURL *storeUrl = [NSURL fileURLWithPath:[[self class] persistentStorePath]];
	NSPersistentStore *persistentStore = [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error];
	if (!persistentStore) {
		NSAssert3(NO, @"Unhandled error adding persistent store in %s at line %d: %@", __FUNCTION__, __LINE__, [error localizedDescription]);
	}
	return storeCoordinator;
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
	//NSAssert1([NSThread isMainThread], @"%s called with non-main thread!", __FUNCTION__);
	if (_managedObjectContext == nil) {
		_managedObjectContext = [[NSManagedObjectContext alloc] init];
		[_managedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
		[_managedObjectContext setUndoManager:nil];
	}
	return _managedObjectContext;
}

- (void)resetCoreDataStack {
	_managedObjectContext = nil;
	[[NSFileManager defaultManager] removeItemAtPath:[[self class] persistentStorePath] error:nil];
}

+ (void)logError:(NSError *)error {
	DLog(@"Failed to save to data store: %@", [error localizedDescription]);
	
#ifdef DEBUG
	// Are there detailed errors?  If so, cycle through and spit them out...
	NSArray *detailedErrors = [error userInfo][NSDetailedErrorsKey];
	if (detailedErrors) {
		for (NSError *detailedError in detailedErrors) {
			DLog(@"  DetailedError: %@", [detailedError userInfo]);
		}
	} else {
		DLog(@", %@", [error userInfo]);
	}
#endif
}

- (void)resetManagedObjectContextAndPersistentStore {
	[_managedObjectContext lock];
	[_managedObjectContext reset];		//to drop pending changes
	
	// remove any persistent stores before remove the files
	NSError *error = nil;
	NSPersistentStore *removeStore = [[_managedObjectContext persistentStoreCoordinator] persistentStores][0];
	if (removeStore) {
		if (![[_managedObjectContext persistentStoreCoordinator] removePersistentStore:removeStore error:&error]) {
			DLog(@"removePersistentStore - error %@, %@", error, [error userInfo]);
		}
	}
	
	// delete any persistent stores currently saved to disk
	if ([[NSFileManager defaultManager] fileExistsAtPath:[WBCoreDataManager persistentStorePath]]) {
		if (![[NSFileManager defaultManager] removeItemAtPath:[WBCoreDataManager persistentStorePath] error:&error])
			DLog(@"removeItemAtPath - error %@, %@", error, [error userInfo]);
	}
	
	[_managedObjectContext unlock];
	_managedObjectContext = nil;
}

+ (void)saveContext {
	NSError *error = nil;
	[[[self sharedManager] managedObjectContext] save:&error];
	if (error) {
		[self logError:error];
	}
}

@end
