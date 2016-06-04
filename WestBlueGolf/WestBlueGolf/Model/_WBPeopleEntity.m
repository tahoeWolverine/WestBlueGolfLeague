// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPeopleEntity.m instead.

#import "_WBPeopleEntity.h"

@implementation WBPeopleEntityID
@end

@implementation _WBPeopleEntity

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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

	if ([key isEqualToString:@"favoriteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"favorite"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
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

@dynamic favorite;

- (BOOL)favoriteValue {
	NSNumber *result = [self favorite];
	return [result boolValue];
}

- (void)setFavoriteValue:(BOOL)value_ {
	[self setFavorite:@(value_)];
}

- (BOOL)primitiveFavoriteValue {
	NSNumber *result = [self primitiveFavorite];
	return [result boolValue];
}

- (void)setPrimitiveFavoriteValue:(BOOL)value_ {
	[self setPrimitiveFavorite:@(value_)];
}

@dynamic me;

- (BOOL)meValue {
	NSNumber *result = [self me];
	return [result boolValue];
}

- (void)setMeValue:(BOOL)value_ {
	[self setMe:@(value_)];
}

- (BOOL)primitiveMeValue {
	NSNumber *result = [self primitiveMe];
	return [result boolValue];
}

- (void)setPrimitiveMeValue:(BOOL)value_ {
	[self setPrimitiveMe:@(value_)];
}

@dynamic name;

@dynamic real;

- (BOOL)realValue {
	NSNumber *result = [self real];
	return [result boolValue];
}

- (void)setRealValue:(BOOL)value_ {
	[self setReal:@(value_)];
}

- (BOOL)primitiveRealValue {
	NSNumber *result = [self primitiveReal];
	return [result boolValue];
}

- (void)setPrimitiveRealValue:(BOOL)value_ {
	[self setPrimitiveReal:@(value_)];
}

@dynamic boardData;

- (NSMutableSet<WBBoardData*>*)boardDataSet {
	[self willAccessValueForKey:@"boardData"];

	NSMutableSet<WBBoardData*> *result = (NSMutableSet<WBBoardData*>*)[self mutableSetValueForKey:@"boardData"];

	[self didAccessValueForKey:@"boardData"];
	return result;
}

@end

@implementation WBPeopleEntityAttributes 
+ (NSString *)favorite {
	return @"favorite";
}
+ (NSString *)me {
	return @"me";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)real {
	return @"real";
}
@end

@implementation WBPeopleEntityRelationships 
+ (NSString *)boardData {
	return @"boardData";
}
@end

