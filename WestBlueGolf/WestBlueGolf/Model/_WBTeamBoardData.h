// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeamBoardData.h instead.

#import <CoreData/CoreData.h>
#import "WBBoardData.h"

extern const struct WBTeamBoardDataAttributes {
} WBTeamBoardDataAttributes;

extern const struct WBTeamBoardDataRelationships {
	__unsafe_unretained NSString *leaderBoard;
	__unsafe_unretained NSString *team;
} WBTeamBoardDataRelationships;

extern const struct WBTeamBoardDataFetchedProperties {
} WBTeamBoardDataFetchedProperties;

@class WBTeamBoard;
@class WBTeam;


@interface WBTeamBoardDataID : NSManagedObjectID {}
@end

@interface _WBTeamBoardData : WBBoardData {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBTeamBoardDataID*)objectID;





@property (nonatomic, strong) WBTeamBoard *leaderBoard;

//- (BOOL)validateLeaderBoard:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) WBTeam *team;

//- (BOOL)validateTeam:(id*)value_ error:(NSError**)error_;





@end

@interface _WBTeamBoardData (CoreDataGeneratedAccessors)

@end

@interface _WBTeamBoardData (CoreDataGeneratedPrimitiveAccessors)



- (WBTeamBoard*)primitiveLeaderBoard;
- (void)setPrimitiveLeaderBoard:(WBTeamBoard*)value;



- (WBTeam*)primitiveTeam;
- (void)setPrimitiveTeam:(WBTeam*)value;


@end
