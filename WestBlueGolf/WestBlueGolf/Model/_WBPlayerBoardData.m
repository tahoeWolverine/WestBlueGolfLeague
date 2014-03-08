// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayerBoardData.m instead.

#import "_WBPlayerBoardData.h"

const struct WBPlayerBoardDataAttributes WBPlayerBoardDataAttributes = {
};

const struct WBPlayerBoardDataRelationships WBPlayerBoardDataRelationships = {
	.leaderBoard = @"leaderBoard",
	.player = @"player",
};

const struct WBPlayerBoardDataFetchedProperties WBPlayerBoardDataFetchedProperties = {
};

@implementation WBPlayerBoardDataID
@end

@implementation _WBPlayerBoardData

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBPlayerBoardData" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBPlayerBoardData";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBPlayerBoardData" inManagedObjectContext:moc_];
}

- (WBPlayerBoardDataID*)objectID {
	return (WBPlayerBoardDataID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic leaderBoard;

	

@dynamic player;

	






@end
