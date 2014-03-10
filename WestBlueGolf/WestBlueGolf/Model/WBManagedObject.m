//
//  WBManagedObject.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/10/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBManagedObject.h"
#import "WBCoreDataManager.h"

@implementation WBManagedObject

+ (NSManagedObjectContext *)context {
	return [[[self dataManager] performSelector:@selector(sharedManager)] performSelector:@selector(managedObjectContext)];
}

+ (NSString *)entityName {
	return NSStringFromClass([self class]);
}

#pragma mark - Creation, Deletion

+ (WBManagedObject *)createEntity {
	return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[self context]];
}

- (void)deleteEntity {
	[[[self class] context] deleteObject:self];
}

#pragma mark - Fetches

+ (NSFetchRequest *)fetchAllRequest {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:[self entityName] inManagedObjectContext:[self context]]];
	return request;
}

+ (id)findAll {
	NSFetchRequest *request = [self fetchAllRequest];
	NSError *error = nil;
	NSArray *results = [[self context] executeFetchRequest:request error:&error];
	if (error) {
		[[self dataManager] performSelector:@selector(logError:) withObject:error];
	}
	return results;
}

+ (NSUInteger)countAll {
	NSFetchRequest *request = [self fetchAllRequest];
	NSError *error = nil;
	NSUInteger count = [[self context] countForFetchRequest:request error:&error];
	if (error) {
		[[self dataManager] performSelector:@selector(logError:) withObject:error];
	}
	return count;
}

+ (id)findAllSortedBy:(NSString *)property ascending:(BOOL)asc {
	NSFetchRequest *request = [self fetchAllRequest];
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:property ascending:asc];
	[request setSortDescriptors:@[descriptor]];
	
	NSError *error = nil;
	NSArray *results = [[self context] executeFetchRequest:request error:&error];
	if (error) {
		[[self dataManager] performSelector:@selector(logError:) withObject:error];
	}
	return results;
}

+ (id)findWithPredicate:(NSPredicate *)predicate {
	NSFetchRequest *request = [self fetchAllRequest];
	[request setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *results = [[self context] executeFetchRequest:request error:&error];
	if (error) {
		[[self dataManager] performSelector:@selector(logError:) withObject:error];
	}
	return results;
}

+ (id)findWithPredicate:(NSPredicate *)predicate sortedBy:(NSArray *)sortDescriptors {
	NSFetchRequest *request = [self fetchAllRequest];
	[request setPredicate:predicate];
	[request setSortDescriptors:sortDescriptors];
	
	NSError *error = nil;
	NSArray *results = [[self context] executeFetchRequest:request error:&error];
	if (error) {
		[[self dataManager] performSelector:@selector(logError:) withObject:error];
	}
	return results;
}

+ (NSUInteger)countWithPredicate:(NSPredicate *)predicate {
	NSFetchRequest *request = [self fetchAllRequest];
	[request setPredicate:predicate];
	
	NSError *error = nil;
	NSUInteger count = [[self context] countForFetchRequest:request error:&error];
	if (error) {
		[[self dataManager] performSelector:@selector(logError:) withObject:error];
	}
	return count;
}

+ (Class)dataManager {
	return [WBCoreDataManager class];
}

@end
