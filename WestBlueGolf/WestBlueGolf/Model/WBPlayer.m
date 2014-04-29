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
							onTeam:(WBTeam *)currentTeam
						 inContext:(NSManagedObjectContext *)moc {
	WBPlayer *newPlayer = (WBPlayer *)[self createPeopleWithName:name inContext:moc];
	newPlayer.currentHandicapValue = currentHandicap;
	newPlayer.meValue = NO;
	newPlayer.favoriteValue = NO;
	
	if (currentTeam) {
		[currentTeam addPlayersObject:newPlayer];
	}

	return newPlayer;
}

+ (WBPlayer *)playerWithName:(NSString *)name
			 currentHandicap:(NSInteger)currentHandicap
					  onTeam:(WBTeam *)currentTeam
				   inContext:(NSManagedObjectContext *)moc {
	WBPlayer *player = [[self class] playerWithName:name inContext:moc];
	if (!player) {
		player = [[self class] createPlayerWithName:name currentHandicap:currentHandicap onTeam:currentTeam inContext:moc];
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

+ (WBPlayer *)playerWithName:(NSString *)name inContext:(NSManagedObjectContext *)moc {
	return (WBPlayer *)[[self class] findFirstRecordWithPredicate:[NSPredicate predicateWithFormat:@"name = %@", name] sortedBy:nil moc:moc];
}

+ (WBPlayer *)noShowPlayer {
	return [[self class] playerWithName:kNoShowPlayerName inContext:[[self class] context]];
}

+ (void)createNoShowPlayerInContext:(NSManagedObjectContext *)moc {
	[[self class] playerWithName:kNoShowPlayerName currentHandicap:25 onTeam:nil inContext:moc];
}

- (BOOL)isNoShowPlayer {
	return [self.name isEqualToString:kNoShowPlayerName];
}

+ (WBPlayer *)me {
	return (WBPlayer *)[[self class] findFirstRecordWithFormat:@"me = 1"];
}

+ (NSArray *)findAllForYear:(WBYear *)year inContext:(NSManagedObjectContext *)moc {
	return [[self class] findWithPredicate:[NSPredicate predicateWithFormat:@"ANY yearData.year = %@", year] sortedBy:nil fetchLimit:0 moc:moc];
}

- (NSArray *)filterResultsForYear:(WBYear *)year goodData:(BOOL)goodData {
	return [self filterResultsForYear:year goodData:goodData sorts:nil];
}

// If you pass YES for goodData, you only get back goodData.  If you pass no, you get back all data
- (NSArray *)filterResultsForYear:(WBYear *)year goodData:(BOOL)goodData sorts:(NSArray *)sorts {
	NSArray *results = nil;
	if (goodData) {
		results = [self.results.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && match.teamMatchup.week.isBadData = %@", year, [NSNumber numberWithBool:NO]]];
	} else {
		results = [self.results.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@", year]];
	}
	
	if (sorts) {
		results = [results sortedArrayUsingDescriptors:sorts];
	}
	return results;
}

- (WBPlayerYearData *)filterYearDataForYear:(WBYear *)year {
	NSArray *filteredArray = [self.yearData.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"year = %@", year]];
	if (filteredArray && filteredArray.count > 0) {
		return (WBPlayerYearData *)filteredArray[0];
	} else {
		DLog(@"No data found for player %@ for year %@", self.name, year.value);
		return nil;
	}
}

- (WBPlayerYearData *)thisYearData {
	return [self filterYearDataForYear:[WBYear thisYear]];
}

- (NSInteger)startingHandicapInYear:(WBYear *)year {
	return [self filterYearDataForYear:year].startingHandicapValue;
}

- (NSInteger)finishingHandicapInYear:(WBYear *)year {
	return [self filterYearDataForYear:year].finishingHandicapValue;
}

- (NSString *)recordStringForYear:(WBYear *)year {
	NSArray *record = [self recordForYear:year];
	BOOL hasTies = record[2] && [(NSNumber *)record[2] integerValue] != 0;
	return [NSString stringWithFormat:@"%@-%@%@%@", record[0], record[1], hasTies ? @"-" : @"", hasTies ? record[2] : @""];
}

- (CGFloat)recordRatioForYear:(WBYear *)year {
	NSArray *record = [self recordForYear:year];
	CGFloat totalWins = [(NSNumber *)record[0] floatValue] + [(NSNumber *)record[2] floatValue] / 2.0f;
	CGFloat totalWeeks = [(NSNumber *)record[0] floatValue] + [(NSNumber *)record[1] floatValue] + [(NSNumber *)record[2] floatValue];
	return totalWeeks > 0 ? totalWins / totalWeeks : 0.0f;
}

// Calculated strictly with the object model, no thread-context needed
- (NSArray *)recordForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
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

- (NSInteger)thisYearHandicap {
	WBYear *thisYear = [WBYear thisYear];
	WBYear *newestYear = [WBYear newestYearInContext:self.managedObjectContext];
	return thisYear == newestYear ? self.currentHandicapValue : [self finishingHandicapInYear:thisYear];
}

- (NSString *)currentHandicapString {
	TRAssert(self.managedObjectContext, @"No mananged object context in currentHandicapString");
	NSInteger handi = [self thisYearHandicap];
	
	BOOL isPositive = handi > 0;
	return [NSString stringWithFormat:@"%@%ld", isPositive ? @"+" : @"", (long)handi];
}

- (NSInteger)lowRoundForYear:(WBYear *)year inContext:(NSManagedObjectContext *)moc {
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && player = %@ && match.teamMatchup.week.isBadData = 0", year, self];
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:YES]];
	WBResult *result = (WBResult *)[WBResult findFirstRecordWithPredicate:pred sortedBy:sorts moc:moc];
	if (!result) {
		return 99;
	}
	
	return [result scoreValue];
}

- (NSString *)lowRoundString {
	NSNumber *value = [self findLowScoreBoardData].value;
	return [NSString stringWithFormat:@"%@", value ?: @"N/A"];
}

- (NSInteger)seasonIndexForLowRoundForYear:(WBYear *)year {
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && player = %@ && match.teamMatchup.week.isBadData = 0", year, self];
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:YES]];
	WBResult *result = (WBResult *)[WBResult findFirstRecordWithPredicate:pred sortedBy:sorts];
	if (!result) {
		return -1;
	}
	
	return result.match.teamMatchup.week.seasonIndexValue;
}

// Calculated strictly with the object model, no thread-context needed
- (NSInteger)lowNetForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
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

- (NSInteger)seasonIdexForLowNetForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
	NSInteger index = -1;
	if (results && results.count > 0) {
		NSInteger lowNet = 100;
		for (WBResult *result in results) {
			NSInteger netScoreDifference = [result netScoreDifference];
			if (netScoreDifference < lowNet) {
				lowNet = netScoreDifference;
				index = result.match.teamMatchup.week.seasonIndexValue;
			}
		}
	}
	return index;
}

// Calculated strictly with the object model, no thread-context needed
- (CGFloat)averagePointsInYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
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

// Calculated strictly with the object model, no thread-context needed
- (NSInteger)improvedInYear:(WBYear *)year {
	NSInteger starting = [self startingHandicapInYear:year];
	NSInteger ending = [year isNewestYear] ? self.currentHandicapValue : [self finishingHandicapInYear:year];
	return starting != INT32_MAX ? ending - starting : 0;
}

- (NSString *)improvedString {
	WBBoardData *data = [self findImprovedBoardData];
	NSInteger improved = data.valueValue;
	return [NSString stringWithFormat:@"%@%ld", improved >= 0 ? @"+" : @"", (long)improved];
}

// Calculated strictly with the object model, no thread-context needed
- (CGFloat)averageScoreForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
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

// Calculated strictly with the object model, no thread-context needed
- (CGFloat)averageNetScoreForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
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

// Calculated strictly with the object model, no thread-context needed
- (CGFloat)averageOpponentScoreForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
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

// Calculated strictly with the object model, no thread-context needed
- (CGFloat)averageOpponentNetScoreForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
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

// Calculated strictly with the object model, no thread-context needed
- (NSInteger)mostPointsInMatchForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
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

- (NSInteger)seasonIndexForMostPointsInMatchForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	NSInteger mostPoints = 0, seasonIndex = -1;
	for (WBResult *result in results) {
		if (result.pointsValue > mostPoints) {
			mostPoints = result.pointsValue;
			seasonIndex = result.match.teamMatchup.week.seasonIndexValue;
		}
	}
	
	return seasonIndex;
}

// Calculated strictly with the object model, no thread-context needed
- (NSInteger)totalPointsForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	CGFloat totalPoints = 0;
	for (WBResult *result in results) {
		totalPoints += result.pointsValue;
	}

	return totalPoints;
}

// Calculated strictly with the object model, no thread-context needed
- (CGFloat)averageMarginOfVictoryForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
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

// Calculated strictly with the object model, no thread-context needed
- (CGFloat)averageMarginOfNetVictoryForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
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
