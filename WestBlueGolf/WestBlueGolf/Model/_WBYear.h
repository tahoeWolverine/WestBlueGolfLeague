// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBYear.h instead.

#import <CoreData/CoreData.h>


extern const struct WBYearAttributes {
} WBYearAttributes;

extern const struct WBYearRelationships {
	__unsafe_unretained NSString *champion;
	__unsafe_unretained NSString *weeks;
} WBYearRelationships;

extern const struct WBYearFetchedProperties {
} WBYearFetchedProperties;

@class WBTeam;
@class WBWeek;


@interface WBYearID : NSManagedObjectID {}
@end

@interface _WBYear : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBYearID*)objectID;





@property (nonatomic, strong) WBTeam *champion;

//- (BOOL)validateChampion:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *weeks;

- (NSMutableSet*)weeksSet;





@end

@interface _WBYear (CoreDataGeneratedAccessors)

- (void)addWeeks:(NSSet*)value_;
- (void)removeWeeks:(NSSet*)value_;
- (void)addWeeksObject:(WBWeek*)value_;
- (void)removeWeeksObject:(WBWeek*)value_;

@end

@interface _WBYear (CoreDataGeneratedPrimitiveAccessors)



- (WBTeam*)primitiveChampion;
- (void)setPrimitiveChampion:(WBTeam*)value;



- (NSMutableSet*)primitiveWeeks;
- (void)setPrimitiveWeeks:(NSMutableSet*)value;


@end
