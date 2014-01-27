// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeam.m instead.

#import "_WBTeam.h"

const struct WBTeamAttributes WBTeamAttributes = {
	.name = @"name",
};

const struct WBTeamRelationships WBTeamRelationships = {
	.championYears = @"championYears",
	.matches = @"matches",
	.players = @"players",
};

const struct WBTeamFetchedProperties WBTeamFetchedProperties = {
};

@implementation WBTeamID
@end

@implementation _WBTeam

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
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
	

	return keyPaths;
}




@dynamic name;






@dynamic championYears;

	
- (NSMutableSet*)championYearsSet {
	[self willAccessValueForKey:@"championYears"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"championYears"];
  
	[self didAccessValueForKey:@"championYears"];
	return result;
}
	

@dynamic matches;

	
- (NSMutableSet*)matchesSet {
	[self willAccessValueForKey:@"matches"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"matches"];
  
	[self didAccessValueForKey:@"matches"];
	return result;
}
	

@dynamic players;

	
- (NSMutableSet*)playersSet {
	[self willAccessValueForKey:@"players"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"players"];
  
	[self didAccessValueForKey:@"players"];
	return result;
}
	






@end
