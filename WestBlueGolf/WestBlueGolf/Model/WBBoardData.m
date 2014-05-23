#import "WBBoardData.h"
#import "WBLeaderBoard.h"
#import "WBYear.h"

@interface WBBoardData ()
@end

@implementation WBBoardData

+ (WBBoardData *)createBoardDataForEntity:(WBPeopleEntity *)entity
							  leaderBoard:(WBLeaderBoard *)leaderBoard
									value:(CGFloat)value
							  detailValue:(NSString *)detailValue
									 rank:(NSInteger)rank
									 year:(WBYear *)year
									  moc:(NSManagedObjectContext *)moc {
	if (!entity) {
		ALog(@"No people sent to boardData contstructor");
		return nil;
	}
	
	WBBoardData *data = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
	data.valueValue = value;
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

@end
