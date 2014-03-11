#import "WBPlayer.h"
#import "WBBoardData.h"
#import "WBCoreDataManager.h"
#import "WBCourse.h"
#import "WBMatch.h"
#import "WBPlayerYearData.h"
#import "WBResult.h"
#import "WBTeam.h"
#import "WBTeamMatchup.h"
#import "WBWeek.h"
#import "WBYear.h"

#define kNoShowPlayerName @"xx No Show xx"

@interface WBPlayer ()

@end

@implementation WBPlayer

+ (WBPlayer *)createPlayerWithName:(NSString *)name
				   currentHandicap:(NSInteger)currentHandicap
							onTeam:(WBTeam *)currentTeam {
	WBPlayer *newPlayer = (WBPlayer *)[self createPeopleWithName:name];
	newPlayer.currentHandicapValue = currentHandicap;
	newPlayer.meValue = NO;
	newPlayer.favoriteValue = NO;
	
	if (currentTeam) {
		[currentTeam addPlayersObject:newPlayer];
	}

	return newPlayer;
}

- (void)setPlayerToMe {
	self.meValue = YES;
	self.favoriteValue = YES;
	self.team.meValue = YES;
}

- (void)setPlayerToNotMe {
	self.meValue = NO;
	self.team.meValue = NO;
}

+ (WBPlayer *)noShowPlayer {
	return [WBPlayer playerWithName:kNoShowPlayerName];
}

+ (void)createNoShowPlayer {
	[WBPlayer createPlayerWithName:kNoShowPlayerName currentHandicap:25 onTeam:nil];
}

+ (WBPlayer *)playerWithName:(NSString *)name {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
	NSArray *players = [WBPlayer findWithPredicate:predicate];
	return [players firstObject];
}

- (NSString *)firstName {
	return [self.name componentsSeparatedByString:@" "][0];
}

- (NSString *)shortName {
	NSString *firstName = [self firstName];
	NSString *shortFirstName = [NSString stringWithFormat:@"%@.", [firstName substringToIndex:1]];
	return [self.name stringByReplacingOccurrencesOfString:firstName withString:shortFirstName];
}

+ (WBPlayer *)me {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"me = 1"];
	NSArray *players = [WBPlayer findWithPredicate:predicate];
	return [players firstObject];
}

- (NSString *)record {
	NSArray *record = [self recordForYear:[WBYear thisYear]];
	BOOL hasTies = record[2] && [(NSNumber *)record[2] integerValue] != 0;
	return [NSString stringWithFormat:@"%@-%@%@%@", record[0], record[1], hasTies ? @"-" : @"", hasTies ? record[2] : @""];
}

- (CGFloat)recordRatioForYear:(WBYear *)year {
	NSArray *record = [self recordForYear:year];
	CGFloat totalWins = [(NSNumber *)record[0] floatValue] + [(NSNumber *)record[2] floatValue] / 2.0f;
	CGFloat totalWeeks = [(NSNumber *)record[0] floatValue] + [(NSNumber *)record[1] floatValue] + [(NSNumber *)record[2] floatValue];
	return totalWeeks > 0 ? totalWins / totalWeeks : 0.0f;
}

- (NSArray *)recordForYear:(WBYear *)year {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && player = %@", year, self];
	NSArray *results = [WBResult findWithPredicate:predicate];
	NSInteger wins = 0;
	NSInteger losses = 0;
	NSInteger ties = 0;

	for (WBResult *result in results) {
		if ([result wasWin]) {
			wins++;
		} else if ([result wasLoss]) {
			losses++;
		} else {
			ties++;
		}
	}

	return @[[NSNumber numberWithInteger:wins], [NSNumber numberWithInteger:losses], [NSNumber numberWithInteger:ties]];
}

- (NSString *)currentHandicapString {
	NSInteger handi = self.currentHandicapValue;
	BOOL isPositive = handi > 0;
	return [NSString stringWithFormat:@"%@%ld", isPositive ? @"+" : @"", (long)handi];
}

- (NSInteger)lowRoundForYear:(WBYear *)year {
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && player = %@", year, self];
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:YES]];
	WBResult *result = (WBResult *)[WBResult findFirstRecordWithPredicate:pred sortedBy:sorts];
	if (!result) {
		return 99;
	}
	
	return [result scoreValue];
}

- (NSString *)lowRoundString {
	return [NSString stringWithFormat:@"%@", [self findLowScoreBoardData].value];
}

- (NSInteger)lowNetForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:[WBYear thisYear]];
	if (results && results.count > 0) {
		NSInteger lowNet = 100;
		for (WBResult *result in results) {
			NSInteger netScoreDifference = [result netScoreDifference];
			if (netScoreDifference < lowNet) {
				lowNet = netScoreDifference;
			}
		}
		
		return lowNet;
	} else {
		return 10;
	}
}

- (NSString *)lowNetString {
	return [NSString stringWithFormat:@"%@", [self findLowNetBoardData].value];
}

- (CGFloat)averagePointsInYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:[WBYear thisYear]];
	if (results && results.count > 0) {
		NSInteger totalPoints = 0;
		for (WBResult *result in results) {
			totalPoints += result.pointsValue;
		}
	
		return (CGFloat)totalPoints / (CGFloat)results.count;
	} else {
		return 0.0f;
	}
}

- (NSString *)averagePointsString {
	NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
	fmt.minimumFractionDigits = 1;
	NSNumber *avg = [NSNumber numberWithFloat:[self findAveragePointsBoardData].value.floatValue];
	return avg.floatValue != 0.0f ? [fmt stringFromNumber:avg] : @"0.0";
}

- (NSString *)averageScoreString {
	NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
	fmt.minimumFractionDigits = 1;
	CGFloat avg = [self averageScoreForYear:[WBYear thisYear]];
	NSString *decimalString = [fmt stringFromNumber:[NSNumber numberWithFloat:avg]];
	return [NSString stringWithFormat:@"%@%@", avg > 0 ? @"+" : @"", decimalString];
}

- (NSArray *)findResultsForYear:(WBYear *)year {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && player = %@", year, self];
	return [WBResult findWithPredicate:predicate];
}

- (WBPlayerYearData *)yearDataForYear:(WBYear *)year {
	for (WBPlayerYearData *data in self.yearData) {
		if (data.year == year) {
			return data;
		}
	}
	DLog(@"No data found for player for year %ld", (long)year.valueValue);
	return nil;
}

- (WBPlayerYearData *)thisYearData {
	return [self yearDataForYear:[WBYear thisYear]];
}

- (NSInteger)startingHandicapInYear:(WBYear *)year {
	return [self yearDataForYear:year].startingHandicapValue;
}

- (NSInteger)improvedInYear:(WBYear *)year {
	NSInteger starting = [self startingHandicapInYear:year];
	return starting != INT32_MAX ? self.currentHandicapValue - starting : 0;
}

- (NSString *)improvedString {
	NSInteger improved = [self findImprovedBoardData].valueValue;
	return [NSString stringWithFormat:@"%@%ld", improved >= 0 ? @"+" : @"", (long)improved];
}

- (CGFloat)averageScoreForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	double totalOpponentScore = 0;
	double opponentCount = 0;
	NSInteger value = 0;
	for (WBResult *result in results) {
		value = [result scoreDifference];
		if (value < 99) {
			totalOpponentScore += value;
			opponentCount++;
		}
	}
	
	return totalOpponentScore / opponentCount;
}

- (CGFloat)averageNetScoreForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	double totalOpponentScore = 0;
	double opponentCount = 0;
	NSInteger value = 0;
	for (WBResult *result in results) {
		value = [result netScoreDifference];
		if (value < 99) {
			totalOpponentScore += value;
			opponentCount++;
		}
	}
	
	return totalOpponentScore / opponentCount;
}

- (CGFloat)averageOpponentScoreForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	double totalOpponentScore = 0;
	double opponentCount = 0;
	NSInteger value = 0;
	for (WBResult *result in results) {
		value = [[result opponentResult] scoreDifference];
		if (value < 99) {
			totalOpponentScore += value;
			opponentCount++;
		}
	}
	
	return totalOpponentScore / opponentCount;
}

- (CGFloat)averageOpponentNetScoreForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	double totalOpponentScore = 0;
	double opponentCount = 0;
	NSInteger value = 0;
	for (WBResult *result in results) {
		value = [[result opponentResult] netScoreDifference];
		if (value < 99) {
			totalOpponentScore += value;
			opponentCount++;
		}
	}
	
	return totalOpponentScore / opponentCount;
}

#pragma mark - Leaderboard fetches

- (WBBoardData *)findHandicapBoardData {
	return [WBBoardData findWithBoardKey:kLeaderboardPlayerHandicap peopleEntity:self];
}

- (WBBoardData *)findWinLossBoardData {
	return [WBBoardData findWithBoardKey:kLeaderboardPlayerWinLossRatio peopleEntity:self];
}

- (WBBoardData *)findLowScoreBoardData {
	return [WBBoardData findWithBoardKey:kLeaderboardPlayerMinScore peopleEntity:self];
}

- (WBBoardData *)findAveragePointsBoardData {
	return [WBBoardData findWithBoardKey:kLeaderboardPlayerAveragePoints peopleEntity:self];
}

- (WBBoardData *)findImprovedBoardData {
	return [WBBoardData findWithBoardKey:kLeaderboardPlayerTotalImproved peopleEntity:self];
}

- (WBBoardData *)findLowNetBoardData {
	return [WBBoardData findWithBoardKey:kLeaderboardPlayerMinNet peopleEntity:self];
}

@end
