// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBYear.h instead.

#import <CoreData/CoreData.h>


extern const struct WBYearAttributes {
	__unsafe_unretained NSString *value;
} WBYearAttributes;

extern const struct WBYearRelationships {
	__unsafe_unretained NSString *champion;
	__unsafe_unretained NSString *playerYearData;
	__unsafe_unretained NSString *weeks;
} WBYearRelationships;

extern const struct WBYearFetchedProperties {
} WBYearFetchedProperties;

@class WBTeam;
@class WBPlayerYearData;
@class WBWeek;



@interface WBYearID : NSManagedObjectID {}
@end

@interface _WBYear : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBYearID*)objectID;





@property (nonatomic, strong) NSNumber* value;



@property int16_t valueValue;
- (int16_t)valueValue;
- (void)setValueValue:(int16_t)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) WBTeam *champion;

//- (BOOL)validateChampion:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *playerYearData;

- (NSMutableSet*)playerYearDataSet;




@property (nonatomic, strong) NSSet *weeks;

- (NSMutableSet*)weeksSet;





@end

@interface _WBYear (CoreDataGeneratedAccessors)

- (void)addPlayerYearData:(NSSet*)value_;
- (void)removePlayerYearData:(NSSet*)value_;
- (void)addPlayerYearDataObject:(WBPlayerYearData*)value_;
- (void)removePlayerYearDataObject:(WBPlayerYearData*)value_;

- (void)addWeeks:(NSSet*)value_;
- (void)removeWeeks:(NSSet*)value_;
- (void)addWeeksObject:(WBWeek*)value_;
- (void)removeWeeksObject:(WBWeek*)value_;

@end

@interface _WBYear (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (int16_t)primitiveValueValue;
- (void)setPrimitiveValueValue:(int16_t)value_;





- (WBTeam*)primitiveChampion;
- (void)setPrimitiveChampion:(WBTeam*)value;



- (NSMutableSet*)primitivePlayerYearData;
- (void)setPrimitivePlayerYearData:(NSMutableSet*)value;



- (NSMutableSet*)primitiveWeeks;
- (void)setPrimitiveWeeks:(NSMutableSet*)value;


@end
