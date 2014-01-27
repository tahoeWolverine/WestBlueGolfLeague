// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBCaptain.h instead.

#import <CoreData/CoreData.h>
#import "WBPlayer.h"

extern const struct WBCaptainAttributes {
	__unsafe_unretained NSString *captainId;
	__unsafe_unretained NSString *password;
	__unsafe_unretained NSString *username;
} WBCaptainAttributes;

extern const struct WBCaptainRelationships {
} WBCaptainRelationships;

extern const struct WBCaptainFetchedProperties {
} WBCaptainFetchedProperties;






@interface WBCaptainID : NSManagedObjectID {}
@end

@interface _WBCaptain : WBPlayer {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBCaptainID*)objectID;





@property (nonatomic, strong) NSNumber* captainId;



@property int16_t captainIdValue;
- (int16_t)captainIdValue;
- (void)setCaptainIdValue:(int16_t)value_;

//- (BOOL)validateCaptainId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* password;



//- (BOOL)validatePassword:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* username;



//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;






@end

@interface _WBCaptain (CoreDataGeneratedAccessors)

@end

@interface _WBCaptain (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCaptainId;
- (void)setPrimitiveCaptainId:(NSNumber*)value;

- (int16_t)primitiveCaptainIdValue;
- (void)setPrimitiveCaptainIdValue:(int16_t)value_;




- (NSString*)primitivePassword;
- (void)setPrimitivePassword:(NSString*)value;




- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;




@end
