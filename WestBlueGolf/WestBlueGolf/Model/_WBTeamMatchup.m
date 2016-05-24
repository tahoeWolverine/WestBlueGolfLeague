// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeamMatchup.m instead.

#import "_WBTeamMatchup.h"

@implementation WBTeamMatchupID
@end

@implementation _WBTeamMatchup

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBTeamMatchup" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBTeamMatchup";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBTeamMatchup" inManagedObjectContext:moc_];
}

- (WBTeamMatchupID*)objectID {
	return (WBTeamMatchupID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"matchCompleteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"matchComplete"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"matchIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"matchId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"matchOrderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"matchOrder"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"playoffTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"playoffType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic matchComplete;

- (BOOL)matchCompleteValue {
	NSNumber *result = [self matchComplete];
	return [result boolValue];
}

- (void)setMatchCompleteValue:(BOOL)value_ {
	[self setMatchComplete:@(value_)];
}

- (BOOL)primitiveMatchCompleteValue {
	NSNumber *result = [self primitiveMatchComplete];
	return [result boolValue];
}

- (void)setPrimitiveMatchCompleteValue:(BOOL)value_ {
	[self setPrimitiveMatchComplete:@(value_)];
}

@dynamic matchId;

- (int16_t)matchIdValue {
	NSNumber *result = [self matchId];
	return [result shortValue];
}

- (void)setMatchIdValue:(int16_t)value_ {
	[self setMatchId:@(value_)];
}

- (int16_t)primitiveMatchIdValue {
	NSNumber *result = [self primitiveMatchId];
	return [result shortValue];
}

- (void)setPrimitiveMatchIdValue:(int16_t)value_ {
	[self setPrimitiveMatchId:@(value_)];
}

@dynamic matchOrder;

- (uint16_t)matchOrderValue {
	NSNumber *result = [self matchOrder];
	return [result unsignedShortValue];
}

- (void)setMatchOrderValue:(uint16_t)value_ {
	[self setMatchOrder:@(value_)];
}

- (uint16_t)primitiveMatchOrderValue {
	NSNumber *result = [self primitiveMatchOrder];
	return [result unsignedShortValue];
}

- (void)setPrimitiveMatchOrderValue:(uint16_t)value_ {
	[self setPrimitiveMatchOrder:@(value_)];
}

@dynamic playoffType;

- (int16_t)playoffTypeValue {
	NSNumber *result = [self playoffType];
	return [result shortValue];
}

- (void)setPlayoffTypeValue:(int16_t)value_ {
	[self setPlayoffType:@(value_)];
}

- (int16_t)primitivePlayoffTypeValue {
	NSNumber *result = [self primitivePlayoffType];
	return [result shortValue];
}

- (void)setPrimitivePlayoffTypeValue:(int16_t)value_ {
	[self setPrimitivePlayoffType:@(value_)];
}

@dynamic matches;

- (NSMutableSet<WBMatch*>*)matchesSet {
	[self willAccessValueForKey:@"matches"];

	NSMutableSet<WBMatch*> *result = (NSMutableSet<WBMatch*>*)[self mutableSetValueForKey:@"matches"];

	[self didAccessValueForKey:@"matches"];
	return result;
}

@dynamic teams;

- (NSMutableSet<WBTeam*>*)teamsSet {
	[self willAccessValueForKey:@"teams"];

	NSMutableSet<WBTeam*> *result = (NSMutableSet<WBTeam*>*)[self mutableSetValueForKey:@"teams"];

	[self didAccessValueForKey:@"teams"];
	return result;
}

@dynamic week;

@end

@implementation WBTeamMatchupAttributes 
+ (NSString *)matchComplete {
	return @"matchComplete";
}
+ (NSString *)matchId {
	return @"matchId";
}
+ (NSString *)matchOrder {
	return @"matchOrder";
}
+ (NSString *)playoffType {
	return @"playoffType";
}
@end

@implementation WBTeamMatchupRelationships 
+ (NSString *)matches {
	return @"matches";
}
+ (NSString *)teams {
	return @"teams";
}
+ (NSString *)week {
	return @"week";
}
@end

