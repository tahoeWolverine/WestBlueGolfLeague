#import "WBBoardData.h"
#import "WBLeaderBoard.h"
#import "WBYear.h"

@interface WBBoardData ()
@end

@implementation WBBoardData

+ (WBBoardData *)createBoardDataForEntity:(WBPeopleEntity *)entity
							  leaderBoard:(WBLeaderBoard *)leaderBoard
                                   dataId:(NSInteger)dataId
									value:(CGFloat)value
                             displayValue:(NSString *)displayValue
							  detailValue:(NSString *)detailValue
									 rank:(NSInteger)rank
									 year:(WBYear *)year
									  moc:(NSManagedObjectContext *)moc {
	if (!entity) {
		ALog(@"No people sent to boardData contstructor");
		return nil;
	}
	
	WBBoardData *data = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
    data.idValue = dataId;
	data.valueValue = value;
    data.displayValue = displayValue;
	data.detailValue = detailValue;
	data.rankValue = rank;
	
	[entity addBoardDataObject:data];
	[leaderBoard addBoardDataObject:data];
	[year addBoardDataObject:data];
	return data;
}

- (NSString *)rankString {
	if ([self.peopleEntity isLeagueAverage]) {
		return @"";
	}
	return [NSString stringWithFormat:@"%@", self.rank];
}

+ (WBBoardData *)findWithBoardKey:(NSString *)key peopleEntity:(WBPeopleEntity *)entity {
	return (WBBoardData *)[[self class] findFirstRecordWithFormat:@"leaderBoard.key = %@ && peopleEntity = %@ && year = %@", key, entity, [WBYear thisYear]];
}

+ (NSArray *)findAllWithBoardKey:(NSString *)key {
    return [[self class] findWithPredicate:[NSPredicate predicateWithFormat:@"leaderBoard.key = %@ && year = %@", key, [WBYear thisYear]] sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:NO]]];
}

@end
