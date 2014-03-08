// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayerBoard.h instead.

#import <CoreData/CoreData.h>
#import "WBLeaderBoard.h"

extern const struct WBPlayerBoardAttributes {
} WBPlayerBoardAttributes;

extern const struct WBPlayerBoardRelationships {
	__unsafe_unretained NSString *boardData;
} WBPlayerBoardRelationships;

extern const struct WBPlayerBoardFetchedProperties {
} WBPlayerBoardFetchedProperties;

@class WBPlayerBoardData;


@interface WBPlayerBoardID : NSManagedObjectID {}
@end

@interface _WBPlayerBoard : WBLeaderBoard {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBPlayerBoardID*)objectID;





@property (nonatomic, strong) WBPlayerBoardData *boardData;

//- (BOOL)validateBoardData:(id*)value_ error:(NSError**)error_;





@end

@interface _WBPlayerBoard (CoreDataGeneratedAccessors)

@end

@interface _WBPlayerBoard (CoreDataGeneratedPrimitiveAccessors)



- (WBPlayerBoardData*)primitiveBoardData;
- (void)setPrimitiveBoardData:(WBPlayerBoardData*)value;


@end
