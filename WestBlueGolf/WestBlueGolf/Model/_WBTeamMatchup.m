// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeamMatchup.m instead.

#import "_WBTeamMatchup.h"

const struct WBTeamMatchupAttributes WBTeamMatchupAttributes = {
	.matchComplete = @"matchComplete",
};

const struct WBTeamMatchupRelationships WBTeamMatchupRelationships = {
	.matches = @"matches",
	.teams = @"teams",
	.week = @"week",
};

const struct WBTeamMatchupFetchedProperties WBTeamMatchupFetchedProperties = {
};

@implementation WBTeamMatchupID
@end

@implementation _WBTeamMatchup

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
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

	return keyPaths;
}




@dynamic matchComplete;



- (BOOL)matchCompleteValue {
	NSNumber *result = [self matchComplete];
	return [result boolValue];
}

- (void)setMatchCompleteValue:(BOOL)value_ {
	[self setMatchComplete:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveMatchCompleteValue {
	NSNumber *result = [self primitiveMatchComplete];
	return [result boolValue];
}

- (void)setPrimitiveMatchCompleteValue:(BOOL)value_ {
	[self setPrimitiveMatchComplete:[NSNumber numberWithBool:value_]];
}





@dynamic matches;

	
- (NSMutableSet*)matchesSet {
	[self willAccessValueForKey:@"matches"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"matches"];
  
	[self didAccessValueForKey:@"matches"];
	return result;
}
	

@dynamic teams;

	
- (NSMutableSet*)teamsSet {
	[self willAccessValueForKey:@"teams"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"teams"];
  
	[self didAccessValueForKey:@"teams"];
	return result;
}
	

@dynamic week;

	






@end
