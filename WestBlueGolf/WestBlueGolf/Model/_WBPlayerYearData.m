// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayerYearData.m instead.

#import "_WBPlayerYearData.h"

@implementation WBPlayerYearDataID
@end

@implementation _WBPlayerYearData

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBPlayerYearData" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBPlayerYearData";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBPlayerYearData" inManagedObjectContext:moc_];
}

- (WBPlayerYearDataID*)objectID {
	return (WBPlayerYearDataID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"finishingHandicapValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"finishingHandicap"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isRookieValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isRookie"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"startingHandicapValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"startingHandicap"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic finishingHandicap;

- (int16_t)finishingHandicapValue {
	NSNumber *result = [self finishingHandicap];
	return [result shortValue];
}

- (void)setFinishingHandicapValue:(int16_t)value_ {
	[self setFinishingHandicap:@(value_)];
}

- (int16_t)primitiveFinishingHandicapValue {
	NSNumber *result = [self primitiveFinishingHandicap];
	return [result shortValue];
}

- (void)setPrimitiveFinishingHandicapValue:(int16_t)value_ {
	[self setPrimitiveFinishingHandicap:@(value_)];
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

@dynamic isRookie;

- (BOOL)isRookieValue {
	NSNumber *result = [self isRookie];
	return [result boolValue];
}

- (void)setIsRookieValue:(BOOL)value_ {
	[self setIsRookie:@(value_)];
}

- (BOOL)primitiveIsRookieValue {
	NSNumber *result = [self primitiveIsRookie];
	return [result boolValue];
}

- (void)setPrimitiveIsRookieValue:(BOOL)value_ {
	[self setPrimitiveIsRookie:@(value_)];
}

@dynamic startingHandicap;

- (int16_t)startingHandicapValue {
	NSNumber *result = [self startingHandicap];
	return [result shortValue];
}

- (void)setStartingHandicapValue:(int16_t)value_ {
	[self setStartingHandicap:@(value_)];
}

- (int16_t)primitiveStartingHandicapValue {
	NSNumber *result = [self primitiveStartingHandicap];
	return [result shortValue];
}

- (void)setPrimitiveStartingHandicapValue:(int16_t)value_ {
	[self setPrimitiveStartingHandicap:@(value_)];
}

@dynamic player;

@dynamic team;

@dynamic year;

@end

@implementation WBPlayerYearDataAttributes 
+ (NSString *)finishingHandicap {
	return @"finishingHandicap";
}
+ (NSString *)id {
	return @"id";
}
+ (NSString *)isRookie {
	return @"isRookie";
}
+ (NSString *)startingHandicap {
	return @"startingHandicap";
}
@end

@implementation WBPlayerYearDataRelationships 
+ (NSString *)player {
	return @"player";
}
+ (NSString *)team {
	return @"team";
}
+ (NSString *)year {
	return @"year";
}
@end

