// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBCourse.m instead.

#import "_WBCourse.h"

const struct WBCourseAttributes WBCourseAttributes = {
	.name = @"name",
	.par = @"par",
};

const struct WBCourseRelationships WBCourseRelationships = {
	.weeks = @"weeks",
};

const struct WBCourseFetchedProperties WBCourseFetchedProperties = {
};

@implementation WBCourseID
@end

@implementation _WBCourse

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
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
	
	if ([key isEqualToString:@"parValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"par"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic name;






@dynamic par;



- (int16_t)parValue {
	NSNumber *result = [self par];
	return [result shortValue];
}

- (void)setParValue:(int16_t)value_ {
	[self setPar:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveParValue {
	NSNumber *result = [self primitivePar];
	return [result shortValue];
}

- (void)setPrimitiveParValue:(int16_t)value_ {
	[self setPrimitivePar:[NSNumber numberWithShort:value_]];
}





@dynamic weeks;

	
- (NSMutableSet*)weeksSet {
	[self willAccessValueForKey:@"weeks"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"weeks"];
  
	[self didAccessValueForKey:@"weeks"];
	return result;
}
	






@end
