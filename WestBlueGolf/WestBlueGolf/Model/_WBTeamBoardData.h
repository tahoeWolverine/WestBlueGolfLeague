// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeamBoardData.h instead.

#import <CoreData/CoreData.h>


extern const struct WBTeamBoardDataAttributes {
} WBTeamBoardDataAttributes;

extern const struct WBTeamBoardDataRelationships {
	__unsafe_unretained NSString *leaderBoard;
} WBTeamBoardDataRelationships;

extern const struct WBTeamBoardDataFetchedProperties {
} WBTeamBoardDataFetchedProperties;

@class WBTeamBoard;


@interface WBTeamBoardDataID : NSManagedObjectID {}
@end

@interface _WBTeamBoardData : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBTeamBoardDataID*)objectID;





@property (nonatomic, strong) WBTeamBoard *leaderBoard;

//- (BOOL)validateLeaderBoard:(id*)value_ error:(NSError**)error_;





@end

@interface _WBTeamBoardData (CoreDataGeneratedAccessors)

@end

@interface _WBTeamBoardData (CoreDataGeneratedPrimitiveAccessors)



- (WBTeamBoard*)primitiveLeaderBoard;
- (void)setPrimitiveLeaderBoard:(WBTeamBoard*)value;


@end
