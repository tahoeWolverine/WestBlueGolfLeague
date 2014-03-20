#import "WBTeam.h"
#import "WBBoardData.h"
#import "WBCoreDataManager.h"
#import "WBCourse.h"
#import "WBMatch.h"
#import "WBPlayer.h"
#import "WBResult.h"
#import "WBTeamMatchup.h"
#import "WBWeek.h"
#import "WBYear.h"

@interface WBTeam ()

@end

@implementation WBTeam

+ (WBTeam *)createTeamWithName:(NSString *)name teamId:(NSInteger)teamId inContext:(NSManagedObjectContext *)moc {
	WBTeam *newTeam = (WBTeam *)[self createPeopleWithName:name inContext:moc];
	newTeam.teamIdValue = teamId;
	return newTeam;
}

+ (WBTeam *)teamWithName:(NSString *)name teamId:(NSInteger)teamId inContext:(NSManagedObjectContext *)moc {
	WBTeam *team = [[self class] teamWithId:teamId inContext:moc];
	if (!team) {
		team = [[self class] createTeamWithName:name teamId:teamId inContext:moc];
	}
	return team;
}

+ (WBTeam *)teamWithId:(NSInteger)teamId inContext:(NSManagedObjectContext *)moc {
	return (WBTeam *)[[self class] findFirstRecordWithFormat:@"teamId = %@", [NSNumber numberWithInteger:teamId]];
}

+ (WBTeam *)myTeam {
	return (WBTeam *)[[self class] findFirstRecordWithFormat:@"me = 1"];
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
	return [NSString stringWithFormat:@"%ld%@", (long)place, text];
}

- (NSInteger)totalPointsForYear:(WBYear *)year {
	NSArray *filtered = [self findResultsForYear:year goodData:YES];
	NSInteger total = 0;
	for (WBResult *result in filtered) {
		total += result.pointsValue;
	}
	return total;
}

- (NSString *)averagePointsString {
	NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
	fmt.minimumFractionDigits = 1;
	NSInteger matchupCount = [self findMatchupsForYear:[WBYear thisYear]].count;
	NSNumber *avg = [NSNumber numberWithFloat:(CGFloat)[self totalPointsForYear:[WBYear thisYear]] / (CGFloat)matchupCount];
	return avg.floatValue != 0.0f ? [fmt stringFromNumber:avg] : @"0.0";
}

- (NSString *)individualRecord {
	NSArray *record = [self individualRecordForYear:[WBYear thisYear]];
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
	NSArray *results = [self findResultsForYear:year goodData:YES];
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

- (NSString *)record {
	NSArray *record = [self recordForYear:[WBYear thisYear]];
	BOOL hasTies = record[2] && [(NSNumber *)record[2] integerValue] != 0;
	return [NSString stringWithFormat:@"%@-%@%@%@", record[0], record[1], hasTies ? @"-" : @"", hasTies ? record[2] : @""];
}

- (CGFloat)recordRatioForYear:(WBYear *)year {
	NSArray *record = [self recordForYear:year];
	CGFloat totalWins = [(NSNumber *)record[0] floatValue] + [(NSNumber *)record[2] floatValue] / 2.0f;
	CGFloat totalWeeks = [(NSNumber *)record[0] floatValue] + [(NSNumber *)record[1] floatValue] + [(NSNumber *)record[2] floatValue];
	return totalWins / totalWeeks;
}

- (NSArray *)findResultsForYear:(WBYear *)year goodData:(BOOL)goodData {
	return [self.results.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && match.teamMatchup.week.isBadData = %@", year, [NSNumber numberWithBool:!goodData]]];
}

- (NSArray *)findMatchupsForYear:(WBYear *)year {
	return [self.matchups.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"week.year = %@ && week.isBadData = 0", year]];
}

+ (NSArray *)findAllForYear:(WBYear *)year {
	return [[self class] findWithFormat:@"ANY matchups.week.year = %@", year];
}

- (NSArray *)recordForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year goodData:YES];
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

- (NSInteger)improvedInYear:(WBYear *)year {
	NSInteger totalImproved = 0;
	for (WBPlayer *player in [self findPlayersForYear:year]) {
		totalImproved += [player improvedInYear:year];
	}
	return totalImproved;
}

- (NSArray *)findPlayersForYear:(WBYear *)year {
	return [self.players.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"ANY yearData.year = %@", year]];
}

- (NSString *)improvedString {
	NSInteger improved = [self findImprovedBoardData].valueValue;
	return [NSString stringWithFormat:@"%@%ld", improved >= 0 ? @"+" : @"", (long)improved];
}

- (CGFloat)averageHandicapForYear:(WBYear *)year {
	NSInteger totalHandicap = 0;
	NSArray *players = [self findPlayersForYear:year];
	for (WBPlayer *player in players) {
		totalHandicap += player.currentHandicapValue;
	}
	return (CGFloat)totalHandicap / (CGFloat)players.count;
}

- (CGFloat)averageScoreForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year goodData:YES];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	CGFloat totalScore = 0;
	CGFloat roundCount = 0;
	NSInteger value = 0;
	for (WBResult *result in results) {
		value = [result scoreDifference];
		if (value < 60) {
			totalScore += value;
			roundCount++;
		}
	}
	
	if (roundCount == 0.0 || totalScore == 0.0) {
		return 63.0;
	}
	
	return totalScore / roundCount;
}

- (CGFloat)averageNetScoreForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year goodData:YES];
	if (!results || results.count == 0) {
		return 0.0;
	}
	
	CGFloat totalScore = 0;
	CGFloat roundCount = 0;
	NSInteger value = 0;
	for (WBResult *result in results) {
		value = [result netScoreDifference];
		if (value < 60) {
			totalScore += value;
			roundCount++;
		}
	}
	
	return totalScore / roundCount;
}

- (CGFloat)averageOpponentScoreForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year goodData:YES];
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
	
	return totalOpponentScore / opponentCount;
}

- (CGFloat)averageOpponentNetScoreForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year goodData:YES];
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
	
	return totalOpponentScore / opponentCount;
}

- (NSInteger)mostPointsInWeekForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year goodData:YES];

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
	
	NSInteger maxPoints = 0;
	for (NSNumber *weekPoints in weeks) {
		if ([weekPoints integerValue] > maxPoints) {
			maxPoints = [weekPoints integerValue];
		}
	}
	
	return maxPoints;
}

- (CGFloat)averageMarginOfVictoryForYear:(WBYear *)year {
	NSArray *results = [self findResultsForYear:year goodData:YES];
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
	NSArray *results = [self findResultsForYear:year goodData:YES];
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

- (WBBoardData *)findTotalPointsBoardData {
	return [WBBoardData findWithBoardKey:kLeaderboardTeamAveragePoints peopleEntity:self];
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
