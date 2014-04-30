// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPeopleEntity.m instead.

#import "_WBPeopleEntity.h"

const struct WBPeopleEntityAttributes WBPeopleEntityAttributes = {
	.me = @"me",
	.name = @"name",
	.real = @"real",
};

const struct WBPeopleEntityRelationships WBPeopleEntityRelationships = {
	.boardData = @"boardData",
};

const struct WBPeopleEntityFetchedProperties WBPeopleEntityFetchedProperties = {
};

@implementation WBPeopleEntityID
@end

@implementation _WBPeopleEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBPeopleEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBPeopleEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBPeopleEntity" inManagedObjectContext:moc_];
}

- (WBPeopleEntityID*)objectID {
	return (WBPeopleEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"meValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"me"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"realValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"real"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic me;



- (BOOL)meValue {
	NSNumber *result = [self me];
	return [result boolValue];
}

- (void)setMeValue:(BOOL)value_ {
	[self setMe:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveMeValue {
	NSNumber *result = [self primitiveMe];
	return [result boolValue];
}

- (void)setPrimitiveMeValue:(BOOL)value_ {
	[self setPrimitiveMe:[NSNumber numberWithBool:value_]];
}





@dynamic name;






@dynamic real;



- (BOOL)realValue {
	NSNumber *result = [self real];
	return [result boolValue];
}

- (void)setRealValue:(BOOL)value_ {
	[self setReal:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveRealValue {
	NSNumber *result = [self primitiveReal];
	return [result boolValue];
}

- (void)setPrimitiveRealValue:(BOOL)value_ {
	[self setPrimitiveReal:[NSNumber numberWithBool:value_]];
}





@dynamic boardData;

	
- (NSMutableSet*)boardDataSet {
	[self willAccessValueForKey:@"boardData"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"boardData"];
  
	[self didAccessValueForKey:@"boardData"];
	return result;
}
	






@end
