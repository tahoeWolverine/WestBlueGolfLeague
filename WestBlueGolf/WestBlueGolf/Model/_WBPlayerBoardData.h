// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayerBoardData.h instead.

#import <CoreData/CoreData.h>
#import "WBBoardData.h"

extern const struct WBPlayerBoardDataAttributes {
} WBPlayerBoardDataAttributes;

extern const struct WBPlayerBoardDataRelationships {
	__unsafe_unretained NSString *leaderBoard;
	__unsafe_unretained NSString *player;
} WBPlayerBoardDataRelationships;

extern const struct WBPlayerBoardDataFetchedProperties {
} WBPlayerBoardDataFetchedProperties;

@class WBPlayerBoard;
@class WBPlayer;


@interface WBPlayerBoardDataID : NSManagedObjectID {}
@end

@interface _WBPlayerBoardData : WBBoardData {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBPlayerBoardDataID*)objectID;





@property (nonatomic, strong) WBPlayerBoard *leaderBoard;

//- (BOOL)validateLeaderBoard:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) WBPlayer *player;

//- (BOOL)validatePlayer:(id*)value_ error:(NSError**)error_;





@end

@interface _WBPlayerBoardData (CoreDataGeneratedAccessors)

@end

@interface _WBPlayerBoardData (CoreDataGeneratedPrimitiveAccessors)



- (WBPlayerBoard*)primitiveLeaderBoard;
- (void)setPrimitiveLeaderBoard:(WBPlayerBoard*)value;



- (WBPlayer*)primitivePlayer;
- (void)setPrimitivePlayer:(WBPlayer*)value;


@end
