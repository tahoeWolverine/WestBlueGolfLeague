// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeam.m instead.

#import "_WBTeam.h"

@implementation WBTeamID
@end

@implementation _WBTeam

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBTeam" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBTeam";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBTeam" inManagedObjectContext:moc_];
}

- (WBTeamID*)objectID {
	return (WBTeamID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
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

@dynamic matchups;

- (NSMutableSet<WBTeamMatchup*>*)matchupsSet {
	[self willAccessValueForKey:@"matchups"];

	NSMutableSet<WBTeamMatchup*> *result = (NSMutableSet<WBTeamMatchup*>*)[self mutableSetValueForKey:@"matchups"];

	[self didAccessValueForKey:@"matchups"];
	return result;
}

@dynamic playerYearData;

- (NSMutableSet<WBPlayerYearData*>*)playerYearDataSet {
	[self willAccessValueForKey:@"playerYearData"];

	NSMutableSet<WBPlayerYearData*> *result = (NSMutableSet<WBPlayerYearData*>*)[self mutableSetValueForKey:@"playerYearData"];

	[self didAccessValueForKey:@"playerYearData"];
	return result;
}

@dynamic results;

- (NSMutableSet<WBResult*>*)resultsSet {
	[self willAccessValueForKey:@"results"];

	NSMutableSet<WBResult*> *result = (NSMutableSet<WBResult*>*)[self mutableSetValueForKey:@"results"];

	[self didAccessValueForKey:@"results"];
	return result;
}

@end

@implementation WBTeamAttributes 
+ (NSString *)id {
	return @"id";
}
@end

@implementation WBTeamRelationships 
+ (NSString *)matchups {
	return @"matchups";
}
+ (NSString *)playerYearData {
	return @"playerYearData";
}
+ (NSString *)results {
	return @"results";
}
@end

