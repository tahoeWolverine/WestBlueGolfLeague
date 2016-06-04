// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBCourse.m instead.

#import "_WBCourse.h"

@implementation WBCourseID
@end

@implementation _WBCourse

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBCourse" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBCourse";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBCourse" inManagedObjectContext:moc_];
}

- (WBCourseID*)objectID {
	return (WBCourseID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"parValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"par"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
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

@dynamic name;

@dynamic par;

- (uint16_t)parValue {
	NSNumber *result = [self par];
	return [result unsignedShortValue];
}

- (void)setParValue:(uint16_t)value_ {
	[self setPar:@(value_)];
}

- (uint16_t)primitiveParValue {
	NSNumber *result = [self primitivePar];
	return [result unsignedShortValue];
}

- (void)setPrimitiveParValue:(uint16_t)value_ {
	[self setPrimitivePar:@(value_)];
}

@dynamic weeks;

- (NSMutableSet<WBWeek*>*)weeksSet {
	[self willAccessValueForKey:@"weeks"];

	NSMutableSet<WBWeek*> *result = (NSMutableSet<WBWeek*>*)[self mutableSetValueForKey:@"weeks"];

	[self didAccessValueForKey:@"weeks"];
	return result;
}

@end

@implementation WBCourseAttributes 
+ (NSString *)id {
	return @"id";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)par {
	return @"par";
}
@end

@implementation WBCourseRelationships 
+ (NSString *)weeks {
	return @"weeks";
}
@end

