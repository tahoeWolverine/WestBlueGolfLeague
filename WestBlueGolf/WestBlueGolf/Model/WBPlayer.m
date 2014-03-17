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
#define kNoShowPlayerScore 99.0f

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

+ (WBPlayer *)playerWithName:(NSString *)name currentHandicap:(NSInteger)currentHandicap onTeam:(WBTeam *)currentTeam {
	WBPlayer *player = [[self class] playerWithName:name];
	if (!player) {
		player = [[self class] createPlayerWithName:name currentHandicap:currentHandicap onTeam:currentTeam];
	}
	return player;
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

+ (WBPlayer *)playerWithName:(NSString *)name {
	return (WBPlayer *)[[self class] findFirstRecordWithFormat:@"name = %@", name];
}

+ (WBPlayer *)noShowPlayer {
	return [[self class] playerWithName:kNoShowPlayerName];
}

+ (void)createNoShowPlayer {
	[[self class] playerWithName:kNoShowPlayerName currentHandicap:25 onTeam:nil];
}

- (BOOL)isNoShowPlayer {
	return [self.name isEqualToString:kNoShowPlayerName];
}

+ (WBPlayer *)me {
	return (WBPlayer *)[[self class] findFirstRecordWithFormat:@"me = 1"];
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
	NSArray *results = [WBResult findWithFormat:@"match.teamMatchup.week.year = %@ && player = %@", year, self];
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
	WBYear *thisYear = [WBYear thisYear];
	WBYear *newestYear = [WBYear newestYear];
	if (newestYear != thisYear) {
		handi = [self finishingHandicapInYear:thisYear];
	}
	
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
	NSNumber *value = [self findLowScoreBoardData].value;
	return [NSString stringWithFormat:@"%@", value ?: @"N/A"];
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
	NSNumber *value = [self findLowNetBoardData].value;
	return [NSString stringWithFormat:@"%@", value ?: @"N/A"];
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
	WBBoardData *data = [self findAveragePointsBoardData];
	NSNumber *avg = [NSNumber numberWithFloat:data.value.floatValue];
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
	return [self.results.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@", year]];
}

+ (NSArray *)findAllForYear:(WBYear *)year {
	return [[self class] findWithFormat:@"ANY yearData.year = %@", year];
}

- (WBPlayerYearData *)yearDataForYear:(WBYear *)year {
	for (WBPlayerYearData *data in self.yearData) {
		if (data.year == year) {
			return data;
		}
	}
	DLog(@"No data found for player %@ for year %@", self.name, year.value);
	return nil;
}

- (WBPlayerYearData *)thisYearData {
	return [self yearDataForYear:[WBYear thisYear]];
}

- (NSInteger)startingHandicapInYear:(WBYear *)year {
	return [self yearDataForYear:year].startingHandicapValue;
}

- (NSInteger)finishingHandicapInYear:(WBYear *)year {
	return [self yearDataForYear:year].finishingHandicapValue;
}

- (NSInteger)improvedInYear:(WBYear *)year {
	NSInteger starting = [self startingHandicapInYear:year];
	NSInteger ending = year == [WBYear newestYear] ? self.currentHandicapValue : [self finishingHandicapInYear:year];
	return starting != INT32_MAX ? ending - starting : 0;
}

- (NSString *)improvedString {
	WBBoardData *data = [self findImprovedBoardData];
	NSInteger improved = data.valueValue;
	return [NSString stringWithFormat:@"%@%ld", improved >= 0 ? @"+" : @"", (long)improved];
}

- (CGFloat)averageScoreForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	CGFloat totalRoundScore = 0;
	CGFloat roundCount = 0;
	for (WBResult *result in results) {
		totalRoundScore += [result scoreDifference];
		roundCount++;
	}
	
	if (roundCount == 0) {
		return 0.0;
	}
	
	return totalRoundScore / roundCount;
}

- (CGFloat)averageNetScoreForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	CGFloat totalRoundScore = 0;
	CGFloat roundCount = 0;
	for (WBResult *result in results) {
		totalRoundScore += [result netScoreDifference];
		roundCount++;
	}
	
	return totalRoundScore / roundCount;
}

- (CGFloat)averageOpponentScoreForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	CGFloat totalOpponentScore = 0;
	CGFloat opponentCount = 0;
	NSInteger value = 0;
	for (WBResult *result in results) {
		value = [[result opponentResult] scoreDifference];
		if (value < 60) {
			totalOpponentScore += value;
			opponentCount++;
		}
	}
	
	if (opponentCount == 0) {
		return 0.0;
	}
	
	return totalOpponentScore / opponentCount;
}

- (CGFloat)averageOpponentNetScoreForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	CGFloat totalOpponentScore = 0;
	CGFloat opponentCount = 0;
	NSInteger value = 0;
	for (WBResult *result in results) {
		value = [[result opponentResult] netScoreDifference];
		if (value < 60) {
			totalOpponentScore += value;
			opponentCount++;
		}
	}
	
	if (opponentCount == 0) {
		return 0.0;
	}
	
	return totalOpponentScore / opponentCount;
}

- (NSInteger)mostPointsInMatchForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	NSInteger mostPoints = 0;
	for (WBResult *result in results) {
		if (result.pointsValue > mostPoints) {
			mostPoints = result.pointsValue;
		}
	}
	
	return mostPoints;
}

- (NSInteger)totalPointsForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	CGFloat totalPoints = 0;
	for (WBResult *result in results) {
		totalPoints += result.pointsValue;
	}

	return totalPoints;
}

- (CGFloat)averageMarginOfVictoryForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	CGFloat totalMargin = 0;
	CGFloat roundCount = 0;
	NSInteger playerValue = 0, oppValue = 0;
	for (WBResult *result in results) {
		playerValue = [result scoreDifference];
		oppValue = [[result opponentResult] scoreDifference];
		if (oppValue < 60) {
			totalMargin += oppValue - playerValue;
			roundCount++;
		}
	}
	
	if (roundCount == 0) {
		return 0.0;
	}
	
	return totalMargin / roundCount;
}

- (CGFloat)averageMarginOfNetVictoryForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	CGFloat totalMargin = 0;
	CGFloat roundCount = 0;
	NSInteger playerValue = 0, oppValue = 0;
	for (WBResult *result in results) {
		playerValue = [result netScoreDifference];
		oppValue = [[result opponentResult] netScoreDifference];
		if (oppValue < 60) {
			totalMargin += oppValue - playerValue;
			roundCount++;
		}
	}
	
	if (roundCount == 0) {
		return 0.0;
	}
	
	return totalMargin / roundCount;
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
