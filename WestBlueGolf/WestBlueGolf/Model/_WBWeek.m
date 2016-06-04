// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBWeek.m instead.

#import "_WBWeek.h"

@implementation WBWeekID
@end

@implementation _WBWeek

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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
	[self setId:@(value_)];
}

- (int16_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result shortValue];
}

- (void)setPrimitiveIdValue:(int16_t)value_ {
	[self setPrimitiveId:@(value_)];
}

@dynamic isBadData;

- (BOOL)isBadDataValue {
	NSNumber *result = [self isBadData];
	return [result boolValue];
}

- (void)setIsBadDataValue:(BOOL)value_ {
	[self setIsBadData:@(value_)];
}

- (BOOL)primitiveIsBadDataValue {
	NSNumber *result = [self primitiveIsBadData];
	return [result boolValue];
}

- (void)setPrimitiveIsBadDataValue:(BOOL)value_ {
	[self setPrimitiveIsBadData:@(value_)];
}

@dynamic isPlayoff;

- (BOOL)isPlayoffValue {
	NSNumber *result = [self isPlayoff];
	return [result boolValue];
}

- (void)setIsPlayoffValue:(BOOL)value_ {
	[self setIsPlayoff:@(value_)];
}

- (BOOL)primitiveIsPlayoffValue {
	NSNumber *result = [self primitiveIsPlayoff];
	return [result boolValue];
}

- (void)setPrimitiveIsPlayoffValue:(BOOL)value_ {
	[self setPrimitiveIsPlayoff:@(value_)];
}

@dynamic pairing;

- (int16_t)pairingValue {
	NSNumber *result = [self pairing];
	return [result shortValue];
}

- (void)setPairingValue:(int16_t)value_ {
	[self setPairing:@(value_)];
}

- (int16_t)primitivePairingValue {
	NSNumber *result = [self primitivePairing];
	return [result shortValue];
}

- (void)setPrimitivePairingValue:(int16_t)value_ {
	[self setPrimitivePairing:@(value_)];
}

@dynamic seasonIndex;

- (uint16_t)seasonIndexValue {
	NSNumber *result = [self seasonIndex];
	return [result unsignedShortValue];
}

- (void)setSeasonIndexValue:(uint16_t)value_ {
	[self setSeasonIndex:@(value_)];
}

- (uint16_t)primitiveSeasonIndexValue {
	NSNumber *result = [self primitiveSeasonIndex];
	return [result unsignedShortValue];
}

- (void)setPrimitiveSeasonIndexValue:(uint16_t)value_ {
	[self setPrimitiveSeasonIndex:@(value_)];
}

@dynamic course;

@dynamic teamMatchups;

- (NSMutableSet<WBTeamMatchup*>*)teamMatchupsSet {
	[self willAccessValueForKey:@"teamMatchups"];

	NSMutableSet<WBTeamMatchup*> *result = (NSMutableSet<WBTeamMatchup*>*)[self mutableSetValueForKey:@"teamMatchups"];

	[self didAccessValueForKey:@"teamMatchups"];
	return result;
}

@dynamic year;

@end

@implementation WBWeekAttributes 
+ (NSString *)date {
	return @"date";
}
+ (NSString *)id {
	return @"id";
}
+ (NSString *)isBadData {
	return @"isBadData";
}
+ (NSString *)isPlayoff {
	return @"isPlayoff";
}
+ (NSString *)pairing {
	return @"pairing";
}
+ (NSString *)seasonIndex {
	return @"seasonIndex";
}
@end

@implementation WBWeekRelationships 
+ (NSString *)course {
	return @"course";
}
+ (NSString *)teamMatchups {
	return @"teamMatchups";
}
+ (NSString *)year {
	return @"year";
}
@end

