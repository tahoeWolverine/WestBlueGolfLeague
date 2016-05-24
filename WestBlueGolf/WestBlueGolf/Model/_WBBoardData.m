// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBBoardData.m instead.

#import "_WBBoardData.h"

@implementation WBBoardDataID
@end

@implementation _WBBoardData

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBBoardData" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBBoardData";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBBoardData" inManagedObjectContext:moc_];
}

- (WBBoardDataID*)objectID {
	return (WBBoardDataID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"rankValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rank"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"valueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"value"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic detailValue;

@dynamic displayValue;

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

@dynamic rank;

- (uint16_t)rankValue {
	NSNumber *result = [self rank];
	return [result unsignedShortValue];
}

- (void)setRankValue:(uint16_t)value_ {
	[self setRank:@(value_)];
}

- (uint16_t)primitiveRankValue {
	NSNumber *result = [self primitiveRank];
	return [result unsignedShortValue];
}

- (void)setPrimitiveRankValue:(uint16_t)value_ {
	[self setPrimitiveRank:@(value_)];
}

@dynamic value;

- (double)valueValue {
	NSNumber *result = [self value];
	return [result doubleValue];
}

- (void)setValueValue:(double)value_ {
	[self setValue:@(value_)];
}

- (double)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result doubleValue];
}

- (void)setPrimitiveValueValue:(double)value_ {
	[self setPrimitiveValue:@(value_)];
}

@dynamic leaderBoard;

@dynamic peopleEntity;

@dynamic year;

@end

@implementation WBBoardDataAttributes 
+ (NSString *)detailValue {
	return @"detailValue";
}
+ (NSString *)displayValue {
	return @"displayValue";
}
+ (NSString *)id {
	return @"id";
}
+ (NSString *)rank {
	return @"rank";
}
+ (NSString *)value {
	return @"value";
}
@end

@implementation WBBoardDataRelationships 
+ (NSString *)leaderBoard {
	return @"leaderBoard";
}
+ (NSString *)peopleEntity {
	return @"peopleEntity";
}
+ (NSString *)year {
	return @"year";
}
@end

