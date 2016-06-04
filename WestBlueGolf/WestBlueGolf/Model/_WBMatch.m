// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBMatch.m instead.

#import "_WBMatch.h"

@implementation WBMatchID
@end

@implementation _WBMatch

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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

- (NSMutableSet<WBPlayer*>*)playersSet {
	[self willAccessValueForKey:@"players"];

	NSMutableSet<WBPlayer*> *result = (NSMutableSet<WBPlayer*>*)[self mutableSetValueForKey:@"players"];

	[self didAccessValueForKey:@"players"];
	return result;
}

@dynamic results;

- (NSMutableSet<WBResult*>*)resultsSet {
	[self willAccessValueForKey:@"results"];

	NSMutableSet<WBResult*> *result = (NSMutableSet<WBResult*>*)[self mutableSetValueForKey:@"results"];

	[self didAccessValueForKey:@"results"];
	return result;
}

@dynamic teamMatchup;

@end

@implementation WBMatchRelationships 
+ (NSString *)players {
	return @"players";
}
+ (NSString *)results {
	return @"results";
}
+ (NSString *)teamMatchup {
	return @"teamMatchup";
}
@end

