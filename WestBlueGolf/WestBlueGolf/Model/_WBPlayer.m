// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayer.m instead.

#import "_WBPlayer.h"

const struct WBPlayerAttributes WBPlayerAttributes = {
	.currentHandicap = @"currentHandicap",
	.favorite = @"favorite",
	.me = @"me",
	.name = @"name",
};

const struct WBPlayerRelationships WBPlayerRelationships = {
	.boardData = @"boardData",
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
	if ([key isEqualToString:@"favoriteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"favorite"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"meValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"me"];
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





@dynamic favorite;



- (BOOL)favoriteValue {
	NSNumber *result = [self favorite];
	return [result boolValue];
}

- (void)setFavoriteValue:(BOOL)value_ {
	[self setFavorite:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFavoriteValue {
	NSNumber *result = [self primitiveFavorite];
	return [result boolValue];
}

- (void)setPrimitiveFavoriteValue:(BOOL)value_ {
	[self setPrimitiveFavorite:[NSNumber numberWithBool:value_]];
}





@dynamic me;



- (BOOL)meValue {
	NSNumber *result = [self me];
	return [result boolValue];
}

- (void)setMeValue:(BOOL)value_ {
	[self setMe:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveMeValue {
	NSNumber *result = [self primitiveMe];
	return [result boolValue];
}

- (void)setPrimitiveMeValue:(BOOL)value_ {
	[self setPrimitiveMe:[NSNumber numberWithBool:value_]];
}





@dynamic name;






@dynamic boardData;

	

@dynamic matches;

	
- (NSMutableSet*)matchesSet {
	[self willAccessValueForKey:@"matches"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"matches"];
  
	[self didAccessValueForKey:@"matches"];
	return result;
}
	

@dynamic results;

	
- (NSMutableSet*)resultsSet {
	[self willAccessValueForKey:@"results"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"results"];
  
	[self didAccessValueForKey:@"results"];
	return result;
}
	

@dynamic team;

	

@dynamic yearData;

	
- (NSMutableSet*)yearDataSet {
	[self willAccessValueForKey:@"yearData"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"yearData"];
  
	[self didAccessValueForKey:@"yearData"];
	return result;
}
	






@end
