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

+ (WBManagedObject *)createEntity;
- (void)deleteEntity;

+ (id)findAll;
+ (NSUInteger)countAll;
+ (id)findAllSortedBy:(NSString *)property ascending:(BOOL)asc;
+ (id)findWithPredicate:(NSPredicate *)predicate;
+ (id)findWithPredicate:(NSPredicate *)predicate sortedBy:(NSArray *)sortDescriptors;
+ (NSUInteger)countWithPredicate:(NSPredicate *)predicate;

+ (Class)dataManager;

@end
