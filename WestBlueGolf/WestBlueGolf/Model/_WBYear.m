// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBYear.m instead.

#import "_WBYear.h"

const struct WBYearAttributes WBYearAttributes = {
};

const struct WBYearRelationships WBYearRelationships = {
	.champion = @"champion",
	.weeks = @"weeks",
};

const struct WBYearFetchedProperties WBYearFetchedProperties = {
};

@implementation WBYearID
@end

@implementation _WBYear

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBYear";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBYear" inManagedObjectContext:moc_];
}

- (WBYearID*)objectID {
	return (WBYearID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic champion;

	

@dynamic weeks;

	
- (NSMutableSet*)weeksSet {
	[self willAccessValueForKey:@"weeks"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"weeks"];
  
	[self didAccessValueForKey:@"weeks"];
	return result;
}
	






@end
