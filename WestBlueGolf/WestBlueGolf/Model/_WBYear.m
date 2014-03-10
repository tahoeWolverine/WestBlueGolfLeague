// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBYear.m instead.

#import "_WBYear.h"

const struct WBYearAttributes WBYearAttributes = {
	.isComplete = @"isComplete",
	.value = @"value",
};

const struct WBYearRelationships WBYearRelationships = {
	.champion = @"champion",
	.playerYearData = @"playerYearData",
	.weeks = @"weeks",
};

const struct WBYearFetchedProperties WBYearFetchedProperties = {
};

@implementation WBYearID
@end

@implementation _WBYear

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
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




@dynamic isComplete;



- (BOOL)isCompleteValue {
	NSNumber *result = [self isComplete];
	return [result boolValue];
}

- (void)setIsCompleteValue:(BOOL)value_ {
	[self setIsComplete:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsCompleteValue {
	NSNumber *result = [self primitiveIsComplete];
	return [result boolValue];
}

- (void)setPrimitiveIsCompleteValue:(BOOL)value_ {
	[self setPrimitiveIsComplete:[NSNumber numberWithBool:value_]];
}





@dynamic value;



- (int16_t)valueValue {
	NSNumber *result = [self value];
	return [result shortValue];
}

- (void)setValueValue:(int16_t)value_ {
	[self setValue:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result shortValue];
}

- (void)setPrimitiveValueValue:(int16_t)value_ {
	[self setPrimitiveValue:[NSNumber numberWithShort:value_]];
}





@dynamic champion;

	

@dynamic playerYearData;

	
- (NSMutableSet*)playerYearDataSet {
	[self willAccessValueForKey:@"playerYearData"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"playerYearData"];
  
	[self didAccessValueForKey:@"playerYearData"];
	return result;
}
	

@dynamic weeks;

	
- (NSMutableSet*)weeksSet {
	[self willAccessValueForKey:@"weeks"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"weeks"];
  
	[self didAccessValueForKey:@"weeks"];
	return result;
}
	






@end
