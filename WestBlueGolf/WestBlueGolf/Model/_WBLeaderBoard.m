// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBLeaderBoard.m instead.

#import "_WBLeaderBoard.h"

const struct WBLeaderBoardAttributes WBLeaderBoardAttributes = {
	.name = @"name",
	.tablePriority = @"tablePriority",
};

const struct WBLeaderBoardRelationships WBLeaderBoardRelationships = {
};

const struct WBLeaderBoardFetchedProperties WBLeaderBoardFetchedProperties = {
};

@implementation WBLeaderBoardID
@end

@implementation _WBLeaderBoard

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBLeaderBoard" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBLeaderBoard";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBLeaderBoard" inManagedObjectContext:moc_];
}

- (WBLeaderBoardID*)objectID {
	return (WBLeaderBoardID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"tablePriorityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"tablePriority"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic name;






@dynamic tablePriority;



- (int16_t)tablePriorityValue {
	NSNumber *result = [self tablePriority];
	return [result shortValue];
}

- (void)setTablePriorityValue:(int16_t)value_ {
	[self setTablePriority:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveTablePriorityValue {
	NSNumber *result = [self primitiveTablePriority];
	return [result shortValue];
}

- (void)setPrimitiveTablePriorityValue:(int16_t)value_ {
	[self setPrimitiveTablePriority:[NSNumber numberWithShort:value_]];
}










@end
