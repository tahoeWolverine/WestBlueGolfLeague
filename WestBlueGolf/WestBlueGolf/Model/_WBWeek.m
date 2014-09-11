// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBWeek.m instead.

#import "_WBWeek.h"

const struct WBWeekAttributes WBWeekAttributes = {
	.date = @"date",
	.id = @"id",
	.isBadData = @"isBadData",
	.isPlayoff = @"isPlayoff",
	.pairing = @"pairing",
	.seasonIndex = @"seasonIndex",
};

const struct WBWeekRelationships WBWeekRelationships = {
	.course = @"course",
	.teamMatchups = @"teamMatchups",
	.year = @"year",
};

const struct WBWeekFetchedProperties WBWeekFetchedProperties = {
};

@implementation WBWeekID
@end

@implementation _WBWeek

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBWeek" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBWeek";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBWeek" inManagedObjectContext:moc_];
}

- (WBWeekID*)objectID {
	return (WBWeekID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isBadDataValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isBadData"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isPlayoffValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isPlayoff"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"pairingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pairing"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"seasonIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"seasonIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic date;






@dynamic id;



- (int16_t)idValue {
	NSNumber *result = [self id];
	return [result shortValue];
}

- (void)setIdValue:(int16_t)value_ {
	[self setId:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result shortValue];
}

- (void)setPrimitiveIdValue:(int16_t)value_ {
	[self setPrimitiveId:[NSNumber numberWithShort:value_]];
}





@dynamic isBadData;



- (BOOL)isBadDataValue {
	NSNumber *result = [self isBadData];
	return [result boolValue];
}

- (void)setIsBadDataValue:(BOOL)value_ {
	[self setIsBadData:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsBadDataValue {
	NSNumber *result = [self primitiveIsBadData];
	return [result boolValue];
}

- (void)setPrimitiveIsBadDataValue:(BOOL)value_ {
	[self setPrimitiveIsBadData:[NSNumber numberWithBool:value_]];
}





@dynamic isPlayoff;



- (BOOL)isPlayoffValue {
	NSNumber *result = [self isPlayoff];
	return [result boolValue];
}

- (void)setIsPlayoffValue:(BOOL)value_ {
	[self setIsPlayoff:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsPlayoffValue {
	NSNumber *result = [self primitiveIsPlayoff];
	return [result boolValue];
}

- (void)setPrimitiveIsPlayoffValue:(BOOL)value_ {
	[self setPrimitiveIsPlayoff:[NSNumber numberWithBool:value_]];
}





@dynamic pairing;



- (int16_t)pairingValue {
	NSNumber *result = [self pairing];
	return [result shortValue];
}

- (void)setPairingValue:(int16_t)value_ {
	[self setPairing:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePairingValue {
	NSNumber *result = [self primitivePairing];
	return [result shortValue];
}

- (void)setPrimitivePairingValue:(int16_t)value_ {
	[self setPrimitivePairing:[NSNumber numberWithShort:value_]];
}





@dynamic seasonIndex;



- (int16_t)seasonIndexValue {
	NSNumber *result = [self seasonIndex];
	return [result shortValue];
}

- (void)setSeasonIndexValue:(int16_t)value_ {
	[self setSeasonIndex:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSeasonIndexValue {
	NSNumber *result = [self primitiveSeasonIndex];
	return [result shortValue];
}

- (void)setPrimitiveSeasonIndexValue:(int16_t)value_ {
	[self setPrimitiveSeasonIndex:[NSNumber numberWithShort:value_]];
}





@dynamic course;

	

@dynamic teamMatchups;

	
- (NSMutableSet*)teamMatchupsSet {
	[self willAccessValueForKey:@"teamMatchups"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"teamMatchups"];
  
	[self didAccessValueForKey:@"teamMatchups"];
	return result;
}
	

@dynamic year;

	






@end
