#import "WBTeam.h"
#import "WBBoardData.h"
#import "WBCoreDataManager.h"
#import "WBCourse.h"
#import "WBMatch.h"
#import "WBPlayer.h"
#import "WBPlayerYearData.h"
#import "WBResult.h"
#import "WBTeamMatchup.h"
#import "WBWeek.h"
#import "WBYear.h"

#define kDifferenceMax 60
#define kScoreMax   90

@interface WBTeam ()

@end

@implementation WBTeam

+ (WBTeam *)createTeamWithName:(NSString *)name teamId:(NSInteger)teamId real:(BOOL)real inContext:(NSManagedObjectContext *)moc {
	WBTeam *newTeam = (WBTeam *)[self createPeopleWithName:name real:real inContext:moc];
    newTeam.idValue = teamId;
	return newTeam;
}

+ (WBTeam *)teamWithName:(NSString *)name teamId:(NSInteger)teamId real:(BOOL)real inContext:(NSManagedObjectContext *)moc {
	WBTeam *team = [[self class] teamWithId:teamId inContext:moc];
	if (!team) {
		team = [[self class] createTeamWithName:name teamId:teamId real:real inContext:moc];
	}
	return team;
}

+ (WBTeam *)teamWithId:(NSInteger)teamId inContext:(NSManagedObjectContext *)moc {
	return (WBTeam *)[[self class] findFirstRecordWithFormat:@"id = %@", [NSNumber numberWithInteger:teamId]];
}

+ (WBTeam *)myTeam {
	return (WBTeam *)[[self class] findFirstRecordWithFormat:@"me = 1"];
}

+ (WBTeam *)findWithId:(NSInteger)teamId {
	return (WBTeam *)[[self class] findFirstRecordWithFormat:@"id = %@", [NSNumber numberWithInteger:teamId]];
}

+ (NSArray *)findAllForYear:(WBYear *)year inContext:(NSManagedObjectContext *)moc {
	return [[self class] findWithPredicate:[NSPredicate predicateWithFormat:@"ANY matchups.week.year = %@", year] sortedBy:nil fetchLimit:0 moc:moc];
}

- (NSArray *)filterResultsForYear:(WBYear *)year goodData:(BOOL)goodData {
	return [self filterResultsForYear:year beforeWeek:nil goodData:goodData];
}

- (NSArray *)filterResultsForYear:(WBYear *)year beforeWeek:(WBWeek *)week goodData:(BOOL)goodData {
	NSArray *results = nil;
	NSNumber *seasonIndex = week ? week.seasonIndex : [NSNumber numberWithInteger:30];
	if (goodData) {
		results = [self.results.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && match.teamMatchup.week.isBadData = %@ && match.teamMatchup.week.seasonIndex < %@", year, [NSNumber numberWithBool:NO], seasonIndex]];
	} else {
		results = [self.results.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && match.teamMatchup.week.seasonIndex < %@", year, seasonIndex]];
	}
	return  results;
}

- (NSArray *)filterMatchupsForYear:(WBYear *)year {
	return [self.matchups.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"week.year = %@ && week.isBadData = 0", year]];
}

- (NSArray *)filterPlayerDataForYear:(WBYear *)year {
	return [self.playerYearData.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"year = %@", year]];
}

- (NSArray *)filterPlayersForYear:(WBYear *)year {
	NSMutableArray *players = [NSMutableArray array];
	NSArray *dataArray = [self filterPlayerDataForYear:year];
	for (WBPlayerYearData *data in dataArray) {
		[players addObject:data.player];
	}
	return players;
}

/*- (NSInteger)place {
	WBYear *year = [WBYear thisYear];
	NSInteger teamPoints = [self totalPointsForYear:year];
	
	NSArray *teams = [WBTeam findAll];
	NSInteger points = 0;
	NSInteger rank = 1;
	for (WBTeam *team in teams) {
		if (team == self) {
			continue;
		}

		points = [team totalPointsForYear:year];
		if (points > teamPoints) {
			rank++;
		}
	}
	return rank;
}*/

- (NSString *)placeString {
	NSInteger place = [self findTotalPointsBoardData].rankValue;
	NSString *text = place == 1 ? @"st" : place == 2 ? @"nd" : place == 3 ? @"rd" : @"th";
	return place > 0 ? [NSString stringWithFormat:@"%ld%@", (long)place, text] : @"N/A";
}

// Calculated strictly with the object model, no thread-context needed
- (NSInteger)totalPointsForYear:(WBYear *)year {
	NSArray *filtered = [self filterResultsForYear:year goodData:YES];
	NSInteger total = 0;
	for (WBResult *result in filtered) {
		total += result.pointsValue;
	}
	return total;
}

// Calculated strictly with the object model, no thread-context needed
- (NSInteger)totalPointsForYearBeforeWeek:(WBWeek *)week {
	NSArray *filtered = [self filterResultsForYear:week.year beforeWeek:week goodData:YES];
	NSInteger total = 0;
	for (WBResult *result in filtered) {
		total += result.pointsValue;
	}
	return total;
}

- (NSString *)averagePointsString {
	NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
	fmt.minimumFractionDigits = 1;
	NSInteger matchupCount = [self filterMatchupsForYear:[WBYear thisYear]].count;
	NSInteger total = [self totalPointsForYear:[WBYear thisYear]];
	NSNumber *avg = [NSNumber numberWithFloat:(CGFloat)total / (CGFloat)matchupCount];
	return matchupCount != 0 ? [fmt stringFromNumber:avg] : @"N/A";
}

- (NSString *)individualRecordStringForYear:(WBYear *)year {
	NSArray *record = [self individualRecordForYear:year];
	BOOL hasTies = record[2] && [(NSNumber *)record[2] integerValue] != 0;
	return [NSString stringWithFormat:@"%@-%@%@%@", record[0], record[1], hasTies ? @"-" : @"", hasTies ? record[2] : @""];
}

- (CGFloat)individualRecordRatioForYear:(WBYear *)year {
	NSArray *record = [self individualRecordForYear:year];
	CGFloat totalWins = [(NSNumber *)record[0] floatValue] + [(NSNumber *)record[2] floatValue] / 2.0f;
	CGFloat totalWeeks = [(NSNumber *)record[0] floatValue] + [(NSNumber *)record[1] floatValue] + [(NSNumber *)record[2] floatValue];
	return totalWins / totalWeeks;
}

- (NSArray *)individualRecordForYear:(WBYear *)year {
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

- (NSString *)recordStringForYear:(WBYear *)year {
	NSArray *record = [self recordForYear:year];
	BOOL hasTies = record[2] && [(NSNumber *)record[2] integerValue] != 0;
	return [NSString stringWithFormat:@"%@-%@%@%@", record[0], record[1], hasTies ? @"-" : @"", hasTies ? record[2] : @""];
}

// Calculated strictly with the object model, no thread-context needed
- (CGFloat)recordRatioForYear:(WBYear *)year {
	NSArray *record = [self recordForYear:year];
	CGFloat totalWins = [(NSNumber *)record[0] floatValue] + [(NSNumber *)record[2] floatValue] / 2.0f;
	CGFloat totalWeeks = [(NSNumber *)record[0] floatValue] + [(NSNumber *)record[1] floatValue] + [(NSNumber *)record[2] floatValue];
	return totalWins / totalWeeks;
}

- (NSArray *)recordForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
	NSInteger wins = 0;
	NSInteger losses = 0;
	NSInteger ties = 0;
	NSInteger arraySize = [year maxSeasonIndex];
	NSMutableArray *weeks = [NSMutableArray arrayWithCapacity:arraySize];
	for (NSInteger i = 0; i < arraySize; i++) {
		weeks[i] = [NSNumber numberWithInteger:0];
	}
	
	NSInteger index = 0;
	for (WBResult *result in results) {
		index = result.match.teamMatchup.week.seasonIndexValue - 1;
		if (index >= arraySize) {
			ALog(@"Index out of matchup bounds");
		}
		[weeks replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:[[weeks objectAtIndex:index] integerValue] + result.pointsValue]];
	}
	
	NSInteger value = 0;
	for (NSInteger i = 0; i < arraySize; i++) {
		value = [[weeks objectAtIndex:i] integerValue];
		if (value == 0) {
			//disregard
		} else if (value > 48) {
			wins++;
		} else if (value < 48) {
			losses++;
		} else {
			ties++;
		}
	}
	
	
	return @[[NSNumber numberWithInteger:wins], [NSNumber numberWithInteger:losses], [NSNumber numberWithInteger:ties]];
}

// Calculated strictly with the object model, no thread-context needed
- (NSInteger)improvedInYear:(WBYear *)year {
	NSInteger totalImproved = 0;
	for (WBPlayer *player in [self filterPlayersForYear:year]) {
		totalImproved += [player improvedInYear:year];
	}
	return totalImproved;
}

- (NSString *)improvedString {
	NSInteger improved = [self findImprovedBoardData].valueValue;
	return [NSString stringWithFormat:@"%@%ld", improved >= 0 ? @"+" : @"", (long)improved];
}

// Calculated strictly with the object model, no thread-context needed
- (CGFloat)averageHandicapForYear:(WBYear *)year {
	NSInteger totalHandicap = 0;
	NSArray *players = [self filterPlayersForYear:year];
	for (WBPlayer *player in players) {
		totalHandicap += player.currentHandicapValue;
	}
	return (CGFloat)totalHandicap / (CGFloat)players.count;
}

// Calculated strictly with the object model, no thread-context needed
- (CGFloat)averageScoreForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	CGFloat totalScore = 0;
	CGFloat roundCount = 0;
	NSInteger value = 0;
	for (WBResult *result in results) {
		value = [result scoreDifference];
		if (value < kDifferenceMax) {
			totalScore += value;
			roundCount++;
		}
	}
	
	if (roundCount == 0.0 || totalScore == 0.0) {
		return 63.0;
	}
	
	return totalScore / roundCount;
}

// Calculated strictly with the object model, no thread-context needed
- (CGFloat)averageNetScoreForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	CGFloat totalScore = 0;
	CGFloat roundCount = 0;
	NSInteger value = 0;
	for (WBResult *result in results) {
		value = [result netScoreDifference];
		if (value < kDifferenceMax) {
			totalScore += value;
			roundCount++;
		}
	}
	
	return totalScore / roundCount;
}

- (NSInteger)totalResultsForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	CGFloat roundCount = 0;
	NSInteger value = 0;
	for (WBResult *result in results) {
		value = [result netScoreDifference];
		if (value < kDifferenceMax) {
			roundCount++;
		}
	}
	
	return roundCount;
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
		if (value < kDifferenceMax) {
			totalOpponentScore += value;
			opponentCount++;
		}
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
		if (value < kDifferenceMax) {
			totalOpponentScore += value;
			opponentCount++;
		}
	}
	
	return totalOpponentScore / opponentCount;
}

- (NSInteger)totalOpponentResultsForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	CGFloat opponentCount = 0;
	NSInteger value = 0;
	for (WBResult *result in results) {
		value = [[result opponentResult] netScoreDifference];
		if (value < kDifferenceMax) {
			opponentCount++;
		}
	}
	
	return opponentCount;
}

// Calculated strictly with the object model, no thread-context needed
- (NSArray *)resultWeekArrayForYear:(WBYear *)year {
	NSArray *results = [self filterResultsForYear:year goodData:YES];
	
	NSInteger arraySize = [year maxSeasonIndex];
	NSMutableArray *weeks = [NSMutableArray arrayWithCapacity:arraySize];
	for (NSInteger i = 0; i < arraySize; i++) {
		weeks[i] = [NSNumber numberWithInteger:0];
	}
	
	NSInteger index = 0;
	for (WBResult *result in results) {
		index = result.match.teamMatchup.week.seasonIndexValue - 1;
		[weeks replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:[[weeks objectAtIndex:index] integerValue] + result.pointsValue]];
	}
	
	return weeks;
}

- (NSInteger)mostPointsInWeekForYear:(WBYear *)year {
	NSInteger maxPoints = 0;
	for (NSNumber *weekPoints in [self resultWeekArrayForYear:year]) {
		if ([weekPoints integerValue] > maxPoints) {
			maxPoints = [weekPoints integerValue];
		}
	}
	
	return maxPoints;
}

- (NSInteger)seasonIndexForMostPointsInWeekForYear:(WBYear *)year {
	NSInteger maxPoints = 0, maxPointsIndex = -1, loopIndex = 0;
	for (NSNumber *weekPoints in [self resultWeekArrayForYear:year]) {
		if ([weekPoints integerValue] > maxPoints) {
			maxPoints = [weekPoints integerValue];
			maxPointsIndex = loopIndex + 1;
		}
		loopIndex++;
	}
	
	return maxPointsIndex;
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
		if (oppValue < kDifferenceMax) {
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
		if (oppValue < kDifferenceMax) {
			totalMargin += oppValue - playerValue;
			roundCount++;
		}
	}
	
	if (roundCount == 0) {
		return 0.0;
	}
	
	return totalMargin / roundCount;
}

- (NSInteger)rankPriorToWeek:(WBWeek *)week {
	NSInteger cachedRank = [[WBCoreDataManager sharedManager] rankForTeam:self priorToWeek:week];
	if (cachedRank > 0) {
		return cachedRank;
	}
	
	NSInteger myTeamPoints = [self totalPointsForYearBeforeWeek:week], otherTeamPoints = 0, rank = 1;
	
	NSArray *teams = [WBTeam findAllForYear:week.year inContext:week.managedObjectContext];
	for (WBTeam *team in teams) {
		otherTeamPoints = [team totalPointsForYearBeforeWeek:week];
		if (otherTeamPoints > myTeamPoints) {
			rank++;
		}
	}
	
	if (rank == 1 && myTeamPoints == 0) {
		rank = 0;
	}
	
	// Cache the rank
	[[WBCoreDataManager sharedManager] setRank:rank forTeam:self priorToWeek:week];
	
	return rank;
}

- (NSArray *)top4Players {
	WBYear *year = [WBYear thisYear];
	NSArray *players = [self filterPlayersForYear:year];
	NSArray *sortedPlayers = [players sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"currentHandicap" ascending:YES]]];
	
	if (!players || players.count == 0) {
		return nil;
	}
	
	if ([(WBPlayer *)players[players.count - 1] finishingHandicapInYear:year] == 0) {
		// Year isn't done
		DLog(@"Unfinished Year");
	}
	
	return @[sortedPlayers[0], sortedPlayers[1], sortedPlayers[2], sortedPlayers[3]];
}

#pragma mark - Leaderboard fetches

- (WBBoardData *)findTotalPointsBoardData {
	return [WBBoardData findWithBoardKey:kLeaderboardTeamTotalPoints peopleEntity:self];
}

- (WBBoardData *)findHandicapBoardData {
	return [WBBoardData findWithBoardKey:kLeaderboardTeamAverageHandicap peopleEntity:self];
}

- (WBBoardData *)findWinLossRatioBoardData {
	return [WBBoardData findWithBoardKey:kLeaderboardTeamWeeklyWinLossRatio peopleEntity:self];
}

- (WBBoardData *)findImprovedBoardData {
	return [WBBoardData findWithBoardKey:kLeaderboardTeamTotalImproved peopleEntity:self];
}

- (WBBoardData *)findIndividualWinLossRatioBoardData {
	return [WBBoardData findWithBoardKey:kLeaderboardTeamIndividualWinLossRatio peopleEntity:self];
}

@end
