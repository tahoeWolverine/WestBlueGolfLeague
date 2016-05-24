// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayer.m instead.

#import "_WBPlayer.h"

@implementation WBPlayerID
@end

@implementation _WBPlayer

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
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
	[self setCurrentHandicap:@(value_)];
}

- (int16_t)primitiveCurrentHandicapValue {
	NSNumber *result = [self primitiveCurrentHandicap];
	return [result shortValue];
}

- (void)setPrimitiveCurrentHandicapValue:(int16_t)value_ {
	[self setPrimitiveCurrentHandicap:@(value_)];
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

@dynamic matches;

- (NSMutableSet<WBMatch*>*)matchesSet {
	[self willAccessValueForKey:@"matches"];

	NSMutableSet<WBMatch*> *result = (NSMutableSet<WBMatch*>*)[self mutableSetValueForKey:@"matches"];

	[self didAccessValueForKey:@"matches"];
	return result;
}

@dynamic results;

- (NSMutableSet<WBResult*>*)resultsSet {
	[self willAccessValueForKey:@"results"];

	NSMutableSet<WBResult*> *result = (NSMutableSet<WBResult*>*)[self mutableSetValueForKey:@"results"];

	[self didAccessValueForKey:@"results"];
	return result;
}

@dynamic yearData;

- (NSMutableSet<WBPlayerYearData*>*)yearDataSet {
	[self willAccessValueForKey:@"yearData"];

	NSMutableSet<WBPlayerYearData*> *result = (NSMutableSet<WBPlayerYearData*>*)[self mutableSetValueForKey:@"yearData"];

	[self didAccessValueForKey:@"yearData"];
	return result;
}

@end

@implementation WBPlayerAttributes 
+ (NSString *)currentHandicap {
	return @"currentHandicap";
}
+ (NSString *)id {
	return @"id";
}
@end

@implementation WBPlayerRelationships 
+ (NSString *)matches {
	return @"matches";
}
+ (NSString *)results {
	return @"results";
}
+ (NSString *)yearData {
	return @"yearData";
}
@end

