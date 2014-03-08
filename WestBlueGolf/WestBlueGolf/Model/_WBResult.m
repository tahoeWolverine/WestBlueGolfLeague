// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBResult.m instead.

#import "_WBResult.h"

const struct WBResultAttributes WBResultAttributes = {
	.points = @"points",
	.priorHandicap = @"priorHandicap",
	.score = @"score",
};

const struct WBResultRelationships WBResultRelationships = {
	.match = @"match",
	.player = @"player",
	.team = @"team",
};

const struct WBResultFetchedProperties WBResultFetchedProperties = {
};

@implementation WBResultID
@end

@implementation _WBResult

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
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



- (int16_t)pointsValue {
	NSNumber *result = [self points];
	return [result shortValue];
}

- (void)setPointsValue:(int16_t)value_ {
	[self setPoints:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePointsValue {
	NSNumber *result = [self primitivePoints];
	return [result shortValue];
}

- (void)setPrimitivePointsValue:(int16_t)value_ {
	[self setPrimitivePoints:[NSNumber numberWithShort:value_]];
}





@dynamic priorHandicap;



- (int16_t)priorHandicapValue {
	NSNumber *result = [self priorHandicap];
	return [result shortValue];
}

- (void)setPriorHandicapValue:(int16_t)value_ {
	[self setPriorHandicap:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePriorHandicapValue {
	NSNumber *result = [self primitivePriorHandicap];
	return [result shortValue];
}

- (void)setPrimitivePriorHandicapValue:(int16_t)value_ {
	[self setPrimitivePriorHandicap:[NSNumber numberWithShort:value_]];
}





@dynamic score;



- (int16_t)scoreValue {
	NSNumber *result = [self score];
	return [result shortValue];
}

- (void)setScoreValue:(int16_t)value_ {
	[self setScore:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveScoreValue {
	NSNumber *result = [self primitiveScore];
	return [result shortValue];
}

- (void)setPrimitiveScoreValue:(int16_t)value_ {
	[self setPrimitiveScore:[NSNumber numberWithShort:value_]];
}





@dynamic match;

	

@dynamic player;

	

@dynamic team;

	






@end
