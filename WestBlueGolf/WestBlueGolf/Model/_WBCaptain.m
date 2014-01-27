// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBCaptain.m instead.

#import "_WBCaptain.h"

const struct WBCaptainAttributes WBCaptainAttributes = {
	.captainId = @"captainId",
	.password = @"password",
	.username = @"username",
};

const struct WBCaptainRelationships WBCaptainRelationships = {
};

const struct WBCaptainFetchedProperties WBCaptainFetchedProperties = {
};

@implementation WBCaptainID
@end

@implementation _WBCaptain

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBCaptain" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBCaptain";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBCaptain" inManagedObjectContext:moc_];
}

- (WBCaptainID*)objectID {
	return (WBCaptainID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"captainIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"captainId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic captainId;



- (int16_t)captainIdValue {
	NSNumber *result = [self captainId];
	return [result shortValue];
}

- (void)setCaptainIdValue:(int16_t)value_ {
	[self setCaptainId:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCaptainIdValue {
	NSNumber *result = [self primitiveCaptainId];
	return [result shortValue];
}

- (void)setPrimitiveCaptainIdValue:(int16_t)value_ {
	[self setPrimitiveCaptainId:[NSNumber numberWithShort:value_]];
}





@dynamic password;






@dynamic username;











@end
