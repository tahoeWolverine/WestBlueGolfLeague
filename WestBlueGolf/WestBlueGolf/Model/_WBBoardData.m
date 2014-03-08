// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBBoardData.m instead.

#import "_WBBoardData.h"

const struct WBBoardDataAttributes WBBoardDataAttributes = {
};

const struct WBBoardDataRelationships WBBoardDataRelationships = {
};

const struct WBBoardDataFetchedProperties WBBoardDataFetchedProperties = {
};

@implementation WBBoardDataID
@end

@implementation _WBBoardData

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBBoardData" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBBoardData";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBBoardData" inManagedObjectContext:moc_];
}

- (WBBoardDataID*)objectID {
	return (WBBoardDataID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
