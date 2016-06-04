// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBLeaderBoard.m instead.

#import "_WBLeaderBoard.h"

@implementation WBLeaderBoardID
@end

@implementation _WBLeaderBoard

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBLeaderBoard" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBLeaderBoard";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBLeaderBoard" inManagedObjectContext:moc_];
}

- (WBLeaderBoardID*)objectID {
	return (WBLeaderBoardID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isPlayerBoardValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isPlayerBoard"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"tablePriorityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"tablePriority"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic id;

- (int16_t)idValue {
	NSNumber *result = [self id];
	return [result shortValue];
}

- (void)setIdValue:(int16_t)value_ {
	[self setId:@(value_)];
}

- (int16_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result shortValue];
}

- (void)setPrimitiveIdValue:(int16_t)value_ {
	[self setPrimitiveId:@(value_)];
}

@dynamic isPlayerBoard;

- (BOOL)isPlayerBoardValue {
	NSNumber *result = [self isPlayerBoard];
	return [result boolValue];
}

- (void)setIsPlayerBoardValue:(BOOL)value_ {
	[self setIsPlayerBoard:@(value_)];
}

- (BOOL)primitiveIsPlayerBoardValue {
	NSNumber *result = [self primitiveIsPlayerBoard];
	return [result boolValue];
}

- (void)setPrimitiveIsPlayerBoardValue:(BOOL)value_ {
	[self setPrimitiveIsPlayerBoard:@(value_)];
}

@dynamic key;

@dynamic name;

@dynamic tablePriority;

- (int16_t)tablePriorityValue {
	NSNumber *result = [self tablePriority];
	return [result shortValue];
}

- (void)setTablePriorityValue:(int16_t)value_ {
	[self setTablePriority:@(value_)];
}

- (int16_t)primitiveTablePriorityValue {
	NSNumber *result = [self primitiveTablePriority];
	return [result shortValue];
}

- (void)setPrimitiveTablePriorityValue:(int16_t)value_ {
	[self setPrimitiveTablePriority:@(value_)];
}

@dynamic boardData;

- (NSMutableSet<WBBoardData*>*)boardDataSet {
	[self willAccessValueForKey:@"boardData"];

	NSMutableSet<WBBoardData*> *result = (NSMutableSet<WBBoardData*>*)[self mutableSetValueForKey:@"boardData"];

	[self didAccessValueForKey:@"boardData"];
	return result;
}

@end

@implementation WBLeaderBoardAttributes 
+ (NSString *)id {
	return @"id";
}
+ (NSString *)isPlayerBoard {
	return @"isPlayerBoard";
}
+ (NSString *)key {
	return @"key";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)tablePriority {
	return @"tablePriority";
}
@end

@implementation WBLeaderBoardRelationships 
+ (NSString *)boardData {
	return @"boardData";
}
@end

