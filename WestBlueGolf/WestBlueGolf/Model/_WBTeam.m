// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeam.m instead.

#import "_WBTeam.h"

const struct WBTeamAttributes WBTeamAttributes = {
	.name = @"name",
	.teamId = @"teamId",
};

const struct WBTeamRelationships WBTeamRelationships = {
	.championYears = @"championYears",
	.matchups = @"matchups",
	.players = @"players",
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
	
	if ([key isEqualToString:@"teamIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"teamId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic name;






@dynamic teamId;



- (int16_t)teamIdValue {
	NSNumber *result = [self teamId];
	return [result shortValue];
}

- (void)setTeamIdValue:(int16_t)value_ {
	[self setTeamId:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveTeamIdValue {
	NSNumber *result = [self primitiveTeamId];
	return [result shortValue];
}

- (void)setPrimitiveTeamIdValue:(int16_t)value_ {
	[self setPrimitiveTeamId:[NSNumber numberWithShort:value_]];
}





@dynamic championYears;

	
- (NSMutableSet*)championYearsSet {
	[self willAccessValueForKey:@"championYears"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"championYears"];
  
	[self didAccessValueForKey:@"championYears"];
	return result;
}
	

@dynamic matchups;

	
- (NSMutableSet*)matchupsSet {
	[self willAccessValueForKey:@"matchups"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"matchups"];
  
	[self didAccessValueForKey:@"matchups"];
	return result;
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
	






@end
