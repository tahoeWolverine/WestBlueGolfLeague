// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayerYearData.m instead.

#import "_WBPlayerYearData.h"

const struct WBPlayerYearDataAttributes WBPlayerYearDataAttributes = {
	.isRookie = @"isRookie",
	.startingHandicap = @"startingHandicap",
};

const struct WBPlayerYearDataRelationships WBPlayerYearDataRelationships = {
	.player = @"player",
};

const struct WBPlayerYearDataFetchedProperties WBPlayerYearDataFetchedProperties = {
};

@implementation WBPlayerYearDataID
@end

@implementation _WBPlayerYearData

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
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




@dynamic isRookie;



- (BOOL)isRookieValue {
	NSNumber *result = [self isRookie];
	return [result boolValue];
}

- (void)setIsRookieValue:(BOOL)value_ {
	[self setIsRookie:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsRookieValue {
	NSNumber *result = [self primitiveIsRookie];
	return [result boolValue];
}

- (void)setPrimitiveIsRookieValue:(BOOL)value_ {
	[self setPrimitiveIsRookie:[NSNumber numberWithBool:value_]];
}





@dynamic startingHandicap;



- (int16_t)startingHandicapValue {
	NSNumber *result = [self startingHandicap];
	return [result shortValue];
}

- (void)setStartingHandicapValue:(int16_t)value_ {
	[self setStartingHandicap:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveStartingHandicapValue {
	NSNumber *result = [self primitiveStartingHandicap];
	return [result shortValue];
}

- (void)setPrimitiveStartingHandicapValue:(int16_t)value_ {
	[self setPrimitiveStartingHandicap:[NSNumber numberWithShort:value_]];
}





@dynamic player;

	






@end
