#import "WBTeamMatchup.h"
#import "WBCoreDataManager.h"
#import "WBMatch.h"
#import "WBPlayer.h"
#import "WBResult.h"
#import "WBTeam.h"
#import "WBYear.h"

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
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"week = %@ && ANY teams = %@", week, team];
	NSArray *matchups = [WBCoreDataManager findEntity:[[self class] entityName] withPredicate:predicate sorts:nil];
	return [matchups lastObject];
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
