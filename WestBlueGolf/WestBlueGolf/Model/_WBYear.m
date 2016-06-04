// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBYear.m instead.

#import "_WBYear.h"

@implementation WBYearID
@end

@implementation _WBYear

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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

	if ([key isEqualToString:@"dataCompleteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"dataComplete"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isCompleteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isComplete"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"valueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"value"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic dataComplete;

- (BOOL)dataCompleteValue {
	NSNumber *result = [self dataComplete];
	return [result boolValue];
}

- (void)setDataCompleteValue:(BOOL)value_ {
	[self setDataComplete:@(value_)];
}

- (BOOL)primitiveDataCompleteValue {
	NSNumber *result = [self primitiveDataComplete];
	return [result boolValue];
}

- (void)setPrimitiveDataCompleteValue:(BOOL)value_ {
	[self setPrimitiveDataComplete:@(value_)];
}

@dynamic id;

- (int16_t)idValue {
	NSNumber *result = [self id];
	return [result shortValue];
}

- (void)setIdValue:(int16_t)value_ {
	[self setId:@(value_)];
}

- (int16_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result shortValue];
}

- (void)setPrimitiveIdValue:(int16_t)value_ {
	[self setPrimitiveId:@(value_)];
}

@dynamic isComplete;

- (BOOL)isCompleteValue {
	NSNumber *result = [self isComplete];
	return [result boolValue];
}

- (void)setIsCompleteValue:(BOOL)value_ {
	[self setIsComplete:@(value_)];
}

- (BOOL)primitiveIsCompleteValue {
	NSNumber *result = [self primitiveIsComplete];
	return [result boolValue];
}

- (void)setPrimitiveIsCompleteValue:(BOOL)value_ {
	[self setPrimitiveIsComplete:@(value_)];
}

@dynamic value;

- (uint16_t)valueValue {
	NSNumber *result = [self value];
	return [result unsignedShortValue];
}

- (void)setValueValue:(uint16_t)value_ {
	[self setValue:@(value_)];
}

- (uint16_t)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result unsignedShortValue];
}

- (void)setPrimitiveValueValue:(uint16_t)value_ {
	[self setPrimitiveValue:@(value_)];
}

@dynamic boardData;

- (NSMutableSet<WBBoardData*>*)boardDataSet {
	[self willAccessValueForKey:@"boardData"];

	NSMutableSet<WBBoardData*> *result = (NSMutableSet<WBBoardData*>*)[self mutableSetValueForKey:@"boardData"];

	[self didAccessValueForKey:@"boardData"];
	return result;
}

@dynamic playerYearData;

- (NSMutableSet<WBPlayerYearData*>*)playerYearDataSet {
	[self willAccessValueForKey:@"playerYearData"];

	NSMutableSet<WBPlayerYearData*> *result = (NSMutableSet<WBPlayerYearData*>*)[self mutableSetValueForKey:@"playerYearData"];

	[self didAccessValueForKey:@"playerYearData"];
	return result;
}

@dynamic weeks;

- (NSMutableSet<WBWeek*>*)weeksSet {
	[self willAccessValueForKey:@"weeks"];

	NSMutableSet<WBWeek*> *result = (NSMutableSet<WBWeek*>*)[self mutableSetValueForKey:@"weeks"];

	[self didAccessValueForKey:@"weeks"];
	return result;
}

@end

@implementation WBYearAttributes 
+ (NSString *)dataComplete {
	return @"dataComplete";
}
+ (NSString *)id {
	return @"id";
}
+ (NSString *)isComplete {
	return @"isComplete";
}
+ (NSString *)value {
	return @"value";
}
@end

@implementation WBYearRelationships 
+ (NSString *)boardData {
	return @"boardData";
}
+ (NSString *)playerYearData {
	return @"playerYearData";
}
+ (NSString *)weeks {
	return @"weeks";
}
@end

