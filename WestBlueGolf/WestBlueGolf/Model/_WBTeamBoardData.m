// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeamBoardData.m instead.

#import "_WBTeamBoardData.h"

const struct WBTeamBoardDataAttributes WBTeamBoardDataAttributes = {
};

const struct WBTeamBoardDataRelationships WBTeamBoardDataRelationships = {
	.leaderBoard = @"leaderBoard",
	.team = @"team",
};

const struct WBTeamBoardDataFetchedProperties WBTeamBoardDataFetchedProperties = {
};

@implementation WBTeamBoardDataID
@end

@implementation _WBTeamBoardData

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBTeamBoardData" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBTeamBoardData";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBTeamBoardData" inManagedObjectContext:moc_];
}

- (WBTeamBoardDataID*)objectID {
	return (WBTeamBoardDataID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic leaderBoard;

	

@dynamic team;

	






@end
