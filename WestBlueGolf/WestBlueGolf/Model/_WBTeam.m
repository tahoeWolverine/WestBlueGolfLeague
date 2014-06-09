// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeam.m instead.

#import "_WBTeam.h"

const struct WBTeamAttributes WBTeamAttributes = {
};

const struct WBTeamRelationships WBTeamRelationships = {
	.matchups = @"matchups",
	.playerYearData = @"playerYearData",
	.results = @"results",
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




@dynamic matchups;

	
- (NSMutableSet*)matchupsSet {
	[self willAccessValueForKey:@"matchups"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"matchups"];
  
	[self didAccessValueForKey:@"matchups"];
	return result;
}
	

@dynamic playerYearData;

	
- (NSMutableSet*)playerYearDataSet {
	[self willAccessValueForKey:@"playerYearData"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"playerYearData"];
  
	[self didAccessValueForKey:@"playerYearData"];
	return result;
}
	

@dynamic results;

	
- (NSMutableSet*)resultsSet {
	[self willAccessValueForKey:@"results"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"results"];
  
	[self didAccessValueForKey:@"results"];
	return result;
}
	






@end
