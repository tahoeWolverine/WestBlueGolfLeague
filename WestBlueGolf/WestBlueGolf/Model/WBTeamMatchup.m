#import "WBTeamMatchup.h"
#import "WBCoreDataManager.h"
#import "WBMatch.h"
#import "WBPlayer.h"
#import "WBResult.h"
#import "WBTeam.h"
#import "WBYear.h"
#import "WBWeek.h"

#define TIME_SHORT_FIRST_MATCH	@"3:44pm"
#define TIME_SHORT_SECOND_MATCH	@"4:00pm"
#define TIME_SHORT_THIRD_MATCH	@"4:16pm"
#define TIME_SHORT_FOURTH_MATCH	@"4:32pm"
#define TIME_SHORT_FIFTH_MATCH	@"4:48pm"

#define TIME_FIRST_MATCH	TIME_SHORT_FIRST_MATCH	@" (3:52)"
#define TIME_SECOND_MATCH	TIME_SHORT_SECOND_MATCH	@" (4:08)"
#define TIME_THIRD_MATCH	TIME_SHORT_THIRD_MATCH	@" (4:24)"
#define TIME_FOURTH_MATCH	TIME_SHORT_FOURTH_MATCH	@" (4:40)"
#define TIME_FIFTH_MATCH	TIME_SHORT_FIFTH_MATCH	@" (4:56)"

@interface WBTeamMatchup ()
@end

@implementation WBTeamMatchup

+ (WBTeamMatchup *)createTeamMatchupBetweenTeam:(WBTeam *)team1
										andTeam:(WBTeam *)team2
										forWeek:(WBWeek *)week
										matchId:(NSInteger)matchId
								  matchComplete:(BOOL)matchComplete
											moc:(NSManagedObjectContext *)moc {
	WBTeamMatchup *newTeamMatchup = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
	newTeamMatchup.week = week;
	newTeamMatchup.matchIdValue = matchId;
	newTeamMatchup.matchCompleteValue = matchComplete;
	[newTeamMatchup addTeamsObject:team1];
	[newTeamMatchup addTeamsObject:team2];
	return newTeamMatchup;
}

+ (WBTeamMatchup *)matchupForTeam:(WBTeam *)team inWeek:(WBWeek *)week inContext:(NSManagedObjectContext *)moc {
	return (WBTeamMatchup *)[[self class] findFirstRecordWithPredicate:[NSPredicate predicateWithFormat:@"week = %@ && ANY teams = %@", week, team] sortedBy:nil moc:moc];
}

+ (NSArray *)findMatchupsForWeek:(WBWeek *)week {
	return [[self class] findWithPredicate:[NSPredicate predicateWithFormat:@"week = %@", week] sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:@"matchId" ascending:YES]]];
}

- (WBTeam *)opponentTeamOfTeam:(WBTeam *)team {
	for (WBTeam *aTeam in self.teams) {
		if (aTeam != team) {
			return aTeam;
		}
	}
	return nil;
}

- (NSArray *)displayStrings {
	// Determine winner/loser, tie is unimportant
	WBTeam *team1 = self.teams.allObjects[0];
	WBTeam *team2 = self.teams.allObjects[1];
	NSInteger team1Points = [self totalPointsForTeam:team1];
	NSInteger team2Points = [self totalPointsForTeam:team2];
	WBTeam *winner = (team1Points > team2Points) ? team1 : team2;
	WBTeam *loser = team1 == winner ? team2 : team1;
	WBTeam *myTeam = [WBTeam myTeam];
	
	NSString *winnerName = [NSString stringWithFormat:@"%@%@", winner == myTeam ? @"*" : @"", winner.name];
	NSString *winnerPoints = [NSString stringWithFormat:@"%ld pts", (long)(team1 == winner ? team1Points : team2Points)];
	NSString *winnerScore = [self totalScoreStringForTeam:winner];
	NSString *loserName = [NSString stringWithFormat:@"%@%@", loser == myTeam ? @"*" : @"", loser.name];
	NSString *loserPoints = [NSString stringWithFormat:@"%ld pts", (long)(team1 == winner ? team2Points : team1Points)];
	NSString *loserScore = [self totalScoreStringForTeam:loser];
	return @[winnerName, winnerPoints, winnerScore, loserName, loserPoints, loserScore];
}

- (NSArray *)displayStringsForTeam:(WBTeam *)team {
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"M/dd"];
	NSString *dateString = [dateFormatter stringFromDate:self.week.date];
	
	WBTeam *opponent = [self opponentTeamOfTeam:team];
	NSString *teamScore = [self totalScoreStringForTeam:team];
	NSString *opponentScore = [self totalScoreStringForTeam:opponent];
	NSString *titleString = [NSString stringWithFormat:@"%@ vs %@", dateString, [opponent shortName]];

	NSString *winLoss = nil;
	if (!self.week.isBadDataValue) {
		NSInteger points = [self totalPointsForTeam:team];
		BOOL win = points > 48;
		BOOL tie = points == 48;
		winLoss = win ? @"W" : tie ? @"T" : @"L";
	} else {
		winLoss = @"N/A";
	}
	
	NSString *scoreString = [NSString stringWithFormat:@"%@-%@", teamScore, opponentScore];
	return @[titleString, winLoss, scoreString];
}

- (NSInteger)totalPointsForTeam:(WBTeam *)team {
	NSInteger total = 0;
	for (WBMatch *match in self.matches) {
		for (WBResult *result in match.results) {
			if (result.team == team && ![result.player.name isEqualToString:@"xx No Show xx"]) {
				total += result.pointsValue;
			}
		}
	}
	
	return total;
}

- (NSString *)totalPointsStringForTeam:(WBTeam *)team {
	return [NSString stringWithFormat:@"%ld pts", (long)[self totalPointsForTeam:team]];
}

- (NSInteger)totalScoreForTeam:(WBTeam *)team {
	NSInteger total = 0;
	for (WBMatch *match in self.matches) {
		for (WBResult *result in match.results) {
			if (result.team == team && ![result.player.name isEqualToString:@"xx No Show xx"]) {
				total += result.scoreValue;
			}
		}
	}

	return total;
}

- (NSString *)totalScoreStringForTeam:(WBTeam *)team {
	return [NSString stringWithFormat:@"%ld", (long)[self totalScoreForTeam:team]];
}

- (NSString *)timeLabel {
	NSArray *matchups = [[self class] findMatchupsForWeek:self.week];
	NSInteger matchIndex = [matchups indexOfObject:self];
	switch (matchIndex) {
		case 0:
			return TIME_FIRST_MATCH;
		case 1:
			return TIME_SECOND_MATCH;
		case 2:
			return TIME_THIRD_MATCH;
		case 3:
			return TIME_FOURTH_MATCH;
		case 4:
			return TIME_FIFTH_MATCH;
		default:
			break;
	}
	return @"";
}

- (NSString *)shortTime {
	NSArray *matchups = [[self class] findMatchupsForWeek:self.week];
	NSInteger matchIndex = [matchups indexOfObject:self];
	switch (matchIndex) {
		case 0:
			return TIME_SHORT_FIRST_MATCH;
		case 1:
			return TIME_SHORT_SECOND_MATCH;
		case 2:
			return TIME_SHORT_THIRD_MATCH;
		case 3:
			return TIME_SHORT_FOURTH_MATCH;
		case 4:
			return TIME_SHORT_FIFTH_MATCH;
		default:
			break;
	}
	return @"";
}

@end
