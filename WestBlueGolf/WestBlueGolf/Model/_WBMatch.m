// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBMatch.m instead.

#import "_WBMatch.h"

const struct WBMatchAttributes WBMatchAttributes = {
};

const struct WBMatchRelationships WBMatchRelationships = {
	.players = @"players",
	.results = @"results",
	.teamMatchup = @"teamMatchup",
};

const struct WBMatchFetchedProperties WBMatchFetchedProperties = {
};

@implementation WBMatchID
@end

@implementation _WBMatch

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBMatch" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBMatch";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBMatch" inManagedObjectContext:moc_];
}

- (WBMatchID*)objectID {
	return (WBMatchID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic players;

	
- (NSMutableSet*)playersSet {
	[self willAccessValueForKey:@"players"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"players"];
  
	[self didAccessValueForKey:@"players"];
	return result;
}
	

@dynamic results;

	
- (NSMutableSet*)resultsSet {
	[self willAccessValueForKey:@"results"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"results"];
  
	[self didAccessValueForKey:@"results"];
	return result;
}
	

@dynamic teamMatchup;

	






@end
