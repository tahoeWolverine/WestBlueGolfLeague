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

+ (NSArray *)findAll {
	NSFetchRequest *request = [self fetchAllRequest];
	NSError *error = nil;
	NSArray *results = [[self context] executeFetchRequest:request error:&error];
	if (error) {
		[[self dataManager] performSelector:@selector(logError:) withObject:error];
	}
	return results;
}

+ (NSArray *)findAllSortedBy:(NSString *)property ascending:(BOOL)asc {
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:property ascending:asc];
	NSArray *sorts = @[descriptor];
	return [self findWithPredicate:nil sortedBy:sorts fetchLimit:0];
}

+ (NSArray *)findWithFormat:(NSString *)predicateFormat, ... {
	va_list args;
	va_start(args, predicateFormat);
	NSArray *returnArray = [self findWithPredicate:[NSPredicate predicateWithFormat:predicateFormat arguments:args] sortedBy:nil fetchLimit:0];
	va_end(args);
	return returnArray;
}

+ (NSArray *)findWithPredicate:(NSPredicate *)predicate {
	return [self findWithPredicate:predicate sortedBy:nil fetchLimit:0];
}

+ (NSArray *)findWithPredicate:(NSPredicate *)predicate sortedBy:(NSArray *)sortDescriptors {
	return [self findWithPredicate:predicate sortedBy:sortDescriptors fetchLimit:0];
}

+ (WBManagedObject *)findFirstRecordWithFormat:(NSString *)predicateFormat, ... {
	va_list args;
	va_start(args, predicateFormat);
	WBManagedObject *obj = [self findFirstRecordWithPredicate:[NSPredicate predicateWithFormat:predicateFormat arguments:args] sortedBy:nil];
	va_end(args);
	return obj;
}

+ (WBManagedObject *)findFirstRecordWithPredicate:(NSPredicate *)predicate sortedBy:(NSArray *)sortDescriptors {
	NSArray *results = [self findWithPredicate:predicate sortedBy:sortDescriptors fetchLimit:1];
	return (WBManagedObject *)[results firstObject];
}

+ (NSArray *)findWithPredicate:(NSPredicate *)predicate sortedBy:(NSArray *)sortDescriptors fetchLimit:(NSInteger)fetchLimit {
	NSFetchRequest *request = [self fetchAllRequest];
	if (fetchLimit > 0) {
		[request setFetchLimit:fetchLimit];
	}
	
	if (predicate) {
		[request setPredicate:predicate];
	}
	
	if (sortDescriptors && sortDescriptors.count > 0) {
		[request setSortDescriptors:sortDescriptors];
	}
	
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
