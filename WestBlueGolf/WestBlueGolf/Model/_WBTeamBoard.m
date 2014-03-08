// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeamBoard.m instead.

#import "_WBTeamBoard.h"

const struct WBTeamBoardAttributes WBTeamBoardAttributes = {
};

const struct WBTeamBoardRelationships WBTeamBoardRelationships = {
	.boardData = @"boardData",
};

const struct WBTeamBoardFetchedProperties WBTeamBoardFetchedProperties = {
};

@implementation WBTeamBoardID
@end

@implementation _WBTeamBoard

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBTeamBoard" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBTeamBoard";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBTeamBoard" inManagedObjectContext:moc_];
}

- (WBTeamBoardID*)objectID {
	return (WBTeamBoardID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic boardData;

	






@end
