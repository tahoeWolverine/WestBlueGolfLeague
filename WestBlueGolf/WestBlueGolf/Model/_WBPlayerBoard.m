// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayerBoard.m instead.

#import "_WBPlayerBoard.h"

const struct WBPlayerBoardAttributes WBPlayerBoardAttributes = {
};

const struct WBPlayerBoardRelationships WBPlayerBoardRelationships = {
	.boardData = @"boardData",
};

const struct WBPlayerBoardFetchedProperties WBPlayerBoardFetchedProperties = {
};

@implementation WBPlayerBoardID
@end

@implementation _WBPlayerBoard

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBPlayerBoard" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBPlayerBoard";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBPlayerBoard" inManagedObjectContext:moc_];
}

- (WBPlayerBoardID*)objectID {
	return (WBPlayerBoardID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic boardData;

	






@end
