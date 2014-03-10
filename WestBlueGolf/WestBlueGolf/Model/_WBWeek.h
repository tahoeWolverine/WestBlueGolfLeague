// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBWeek.h instead.

#import <CoreData/CoreData.h>
#import "WBManagedObject.h"

extern const struct WBWeekAttributes {
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *seasonIndex;
} WBWeekAttributes;

extern const struct WBWeekRelationships {
	__unsafe_unretained NSString *course;
	__unsafe_unretained NSString *teamMatchups;
	__unsafe_unretained NSString *year;
} WBWeekRelationships;

extern const struct WBWeekFetchedProperties {
} WBWeekFetchedProperties;

@class WBCourse;
@class WBTeamMatchup;
@class WBYear;




@interface WBWeekID : NSManagedObjectID {}
@end

@interface _WBWeek : WBManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBWeekID*)objectID;





@property (nonatomic, strong) NSDate* date;



//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* seasonIndex;



@property int16_t seasonIndexValue;
- (int16_t)seasonIndexValue;
- (void)setSeasonIndexValue:(int16_t)value_;

//- (BOOL)validateSeasonIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) WBCourse *course;

//- (BOOL)validateCourse:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *teamMatchups;

- (NSMutableSet*)teamMatchupsSet;




@property (nonatomic, strong) WBYear *year;

//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;





@end

@interface _WBWeek (CoreDataGeneratedAccessors)

- (void)addTeamMatchups:(NSSet*)value_;
- (void)removeTeamMatchups:(NSSet*)value_;
- (void)addTeamMatchupsObject:(WBTeamMatchup*)value_;
- (void)removeTeamMatchupsObject:(WBTeamMatchup*)value_;

@end

@interface _WBWeek (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (NSNumber*)primitiveSeasonIndex;
- (void)setPrimitiveSeasonIndex:(NSNumber*)value;

- (int16_t)primitiveSeasonIndexValue;
- (void)setPrimitiveSeasonIndexValue:(int16_t)value_;





- (WBCourse*)primitiveCourse;
- (void)setPrimitiveCourse:(WBCourse*)value;



- (NSMutableSet*)primitiveTeamMatchups;
- (void)setPrimitiveTeamMatchups:(NSMutableSet*)value;



- (WBYear*)primitiveYear;
- (void)setPrimitiveYear:(WBYear*)value;


@end
