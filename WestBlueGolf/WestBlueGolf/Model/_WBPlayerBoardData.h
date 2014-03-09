// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayerBoardData.h instead.

#import <CoreData/CoreData.h>


extern const struct WBPlayerBoardDataAttributes {
} WBPlayerBoardDataAttributes;

extern const struct WBPlayerBoardDataRelationships {
	__unsafe_unretained NSString *leaderBoard;
} WBPlayerBoardDataRelationships;

extern const struct WBPlayerBoardDataFetchedProperties {
} WBPlayerBoardDataFetchedProperties;

@class WBPlayerBoard;


@interface WBPlayerBoardDataID : NSManagedObjectID {}
@end

@interface _WBPlayerBoardData : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBPlayerBoardDataID*)objectID;





@property (nonatomic, strong) WBPlayerBoard *leaderBoard;

//- (BOOL)validateLeaderBoard:(id*)value_ error:(NSError**)error_;





@end

@interface _WBPlayerBoardData (CoreDataGeneratedAccessors)

@end

@interface _WBPlayerBoardData (CoreDataGeneratedPrimitiveAccessors)



- (WBPlayerBoard*)primitiveLeaderBoard;
- (void)setPrimitiveLeaderBoard:(WBPlayerBoard*)value;


@end
