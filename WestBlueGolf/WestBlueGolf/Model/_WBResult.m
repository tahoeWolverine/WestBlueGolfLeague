// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBResult.m instead.

#import "_WBResult.h"

@implementation WBResultID
@end

@implementation _WBResult

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBResult" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBResult";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBResult" inManagedObjectContext:moc_];
}

- (WBResultID*)objectID {
	return (WBResultID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"pointsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"points"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"priorHandicapValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"priorHandicap"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"scoreValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"score"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic points;

- (uint16_t)pointsValue {
	NSNumber *result = [self points];
	return [result unsignedShortValue];
}

- (void)setPointsValue:(uint16_t)value_ {
	[self setPoints:@(value_)];
}

- (uint16_t)primitivePointsValue {
	NSNumber *result = [self primitivePoints];
	return [result unsignedShortValue];
}

- (void)setPrimitivePointsValue:(uint16_t)value_ {
	[self setPrimitivePoints:@(value_)];
}

@dynamic priorHandicap;

- (int16_t)priorHandicapValue {
	NSNumber *result = [self priorHandicap];
	return [result shortValue];
}

- (void)setPriorHandicapValue:(int16_t)value_ {
	[self setPriorHandicap:@(value_)];
}

- (int16_t)primitivePriorHandicapValue {
	NSNumber *result = [self primitivePriorHandicap];
	return [result shortValue];
}

- (void)setPrimitivePriorHandicapValue:(int16_t)value_ {
	[self setPrimitivePriorHandicap:@(value_)];
}

@dynamic score;

- (uint16_t)scoreValue {
	NSNumber *result = [self score];
	return [result unsignedShortValue];
}

- (void)setScoreValue:(uint16_t)value_ {
	[self setScore:@(value_)];
}

- (uint16_t)primitiveScoreValue {
	NSNumber *result = [self primitiveScore];
	return [result unsignedShortValue];
}

- (void)setPrimitiveScoreValue:(uint16_t)value_ {
	[self setPrimitiveScore:@(value_)];
}

@dynamic match;

@dynamic player;

@dynamic team;

@end

@implementation WBResultAttributes 
+ (NSString *)points {
	return @"points";
}
+ (NSString *)priorHandicap {
	return @"priorHandicap";
}
+ (NSString *)score {
	return @"score";
}
@end

@implementation WBResultRelationships 
+ (NSString *)match {
	return @"match";
}
+ (NSString *)player {
	return @"player";
}
+ (NSString *)team {
	return @"team";
}
@end

