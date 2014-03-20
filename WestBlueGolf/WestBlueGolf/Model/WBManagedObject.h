//
//  WBManagedObject.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/10/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@interface WBManagedObject : NSManagedObject

+ (NSManagedObjectContext *)context;
+ (NSFetchRequest *)fetchAllRequest;

//+ (WBManagedObject *)createEntity;
+ (WBManagedObject *)createEntityInContext:(NSManagedObjectContext *)moc;
- (void)deleteEntityInContext:(NSManagedObjectContext *)moc;

+ (NSArray *)findAll;
+ (NSArray *)findAllSortedBy:(NSString *)property ascending:(BOOL)asc;
+ (NSArray *)findWithFormat:(NSString *)predicateFormat, ...;
+ (NSArray *)findWithPredicate:(NSPredicate *)predicate;
+ (NSArray *)findWithPredicate:(NSPredicate *)predicate sortedBy:(NSArray *)sortDescriptors;
+ (NSArray *)findWithPredicate:(NSPredicate *)predicate
					  sortedBy:(NSArray *)sortDescriptors
					fetchLimit:(NSInteger)fetchLimit
						   moc:(NSManagedObjectContext *)moc;
+ (WBManagedObject *)findFirstRecordWithFormat:(NSString *)predicateFormat, ...;
+ (WBManagedObject *)findFirstRecordWithPredicate:(NSPredicate *)predicate sortedBy:(NSArray *)sortDescriptors;
+ (WBManagedObject *)findFirstRecordWithPredicate:(NSPredicate *)predicate sortedBy:(NSArray *)sortDescriptors moc:(NSManagedObjectContext *)moc;

+ (NSUInteger)countAll;
+ (NSUInteger)countWithPredicate:(NSPredicate *)predicate;

+ (Class)dataManager;

@end
