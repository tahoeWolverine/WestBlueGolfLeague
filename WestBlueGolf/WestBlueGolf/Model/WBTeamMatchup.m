#import "WBTeamMatchup.h"
#import "WBCoreDataManager.h"
#import "WBMatch.h"
#import "WBPlayer.h"
#import "WBResult.h"
#import "WBTeam.h"
#import "WBYear.h"
#import "WBWeek.h"

@interface WBTeamMatchup ()

@end

@implementation WBTeamMatchup

+ (WBTeamMatchup *)createTeamMatchupBetweenTeam:(WBTeam *)team1 andTeam:(WBTeam *)team2 forWeek:(WBWeek *)week {
	WBTeamMatchup *newTeamMatchup = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] context]];
	newTeamMatchup.week = week;
	[newTeamMatchup addTeamsObject:team1];
	[newTeamMatchup addTeamsObject:team2];

	//TODO: Support incomplete matches
	newTeamMatchup.matchCompleteValue = YES;
	return newTeamMatchup;
}

+ (WBTeamMatchup *)matchupForTeam:(WBTeam *)team inWeek:(WBWeek *)week {
	return (WBTeamMatchup *)[[self class] findFirstRecordWithPredicate:[NSPredicate predicateWithFormat:@"week = %@ && ANY teams = %@", week, team] sortedBy:nil];
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
				
	NSInteger points = [self totalPointsForTeam:team];
	BOOL win = points > 48;
	BOOL tie = points == 48;
	NSString *winLoss = win ? @"W" : tie ? @"T" : @"L";
	
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

@end
