// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayer.m instead.

#import "_WBPlayer.h"

const struct WBPlayerAttributes WBPlayerAttributes = {
	.currentHandicap = @"currentHandicap",
	.name = @"name",
};

const struct WBPlayerRelationships WBPlayerRelationships = {
	.matches = @"matches",
	.results = @"results",
	.team = @"team",
	.yearData = @"yearData",
};

const struct WBPlayerFetchedProperties WBPlayerFetchedProperties = {
};

@implementation WBPlayerID
@end

@implementation _WBPlayer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBPlayer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBPlayer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBPlayer" inManagedObjectContext:moc_];
}

- (WBPlayerID*)objectID {
	return (WBPlayerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"currentHandicapValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"currentHandicap"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic currentHandicap;



- (int16_t)currentHandicapValue {
	NSNumber *result = [self currentHandicap];
	return [result shortValue];
}

- (void)setCurrentHandicapValue:(int16_t)value_ {
	[self setCurrentHandicap:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCurrentHandicapValue {
	NSNumber *result = [self primitiveCurrentHandicap];
	return [result shortValue];
}

- (void)setPrimitiveCurrentHandicapValue:(int16_t)value_ {
	[self setPrimitiveCurrentHandicap:[NSNumber numberWithShort:value_]];
}





@dynamic name;






@dynamic matches;

	
- (NSMutableSet*)matchesSet {
	[self willAccessValueForKey:@"matches"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"matches"];
  
	[self didAccessValueForKey:@"matches"];
	return result;
}
	

@dynamic results;

	

@dynamic team;

	

@dynamic yearData;

	






@end
