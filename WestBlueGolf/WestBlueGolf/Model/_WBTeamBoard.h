// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeamBoard.h instead.

#import <CoreData/CoreData.h>
#import "WBLeaderBoard.h"

extern const struct WBTeamBoardAttributes {
} WBTeamBoardAttributes;

extern const struct WBTeamBoardRelationships {
	__unsafe_unretained NSString *boardData;
} WBTeamBoardRelationships;

extern const struct WBTeamBoardFetchedProperties {
} WBTeamBoardFetchedProperties;

@class WBTeamBoardData;


@interface WBTeamBoardID : NSManagedObjectID {}
@end

@interface _WBTeamBoard : WBLeaderBoard {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBTeamBoardID*)objectID;





@property (nonatomic, strong) WBTeamBoardData *boardData;

//- (BOOL)validateBoardData:(id*)value_ error:(NSError**)error_;





@end

@interface _WBTeamBoard (CoreDataGeneratedAccessors)

@end

@interface _WBTeamBoard (CoreDataGeneratedPrimitiveAccessors)



- (WBTeamBoardData*)primitiveBoardData;
- (void)setPrimitiveBoardData:(WBTeamBoardData*)value;


@end
