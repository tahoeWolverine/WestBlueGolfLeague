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
	WBTeamMatchup *newTeamMatchup = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] managedObjectContext]];
	newTeamMatchup.week = week;
	[newTeamMatchup addTeamsObject:team1];
	[newTeamMatchup addTeamsObject:team2];

	//TODO: Support incomplete matches
	newTeamMatchup.matchCompleteValue = YES;
	
	[WBCoreDataManager saveContext];
	return newTeamMatchup;
}

+ (WBTeamMatchup *)matchupForTeam:(WBTeam *)team inWeek:(WBWeek *)week {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"week = %@ && ANY teams = %@", week, team];
	NSArray *matchups = [[WBCoreDataManager class] findWithPredicate:predicate forEntity:[[self class] entityName]];
	return [matchups lastObject];
}

- (void)deleteTeamMatchup {
	[[[self class] managedObjectContext] deleteObject:self];
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

- (NSArray *)otherPlayerResultsForTeam:(WBTeam *)team {
	NSFetchRequest *request = [WBCoreDataManager fetchAllRequestWithEntityName:[WBResult entityName]];
	[request setPredicate:[NSPredicate predicateWithFormat:@"match.teamMatchup.week = %@ && otherTeam = %@", self.week, team]];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"points" ascending:YES]];
	
	NSError *error = nil;
	NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
	if (error) {
		[[WBCoreDataManager class] performSelector:@selector(logError:) withObject:error];
	}
	return results;
}

- (NSInteger)totalPointsForTeam:(WBTeam *)team {
	NSInteger total = 0;
	for (WBMatch *match in self.matches) {
		for (WBResult *result in match.results) {
			if (result.player.team == team) {
				total += result.pointsValue;
			}
		}
	}
	
	// People playing on other teams
	NSArray *results = [self otherPlayerResultsForTeam:team];
	
	for (WBResult *result in results) {
		total += result.pointsValue;
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
			if (result.player.team == team) {
				total += result.scoreValue;
			}
		}
	}
	
	// People playing on other teams
	NSArray *results = [self otherPlayerResultsForTeam:team];
	
	for (WBResult *result in results) {
		total += result.scoreValue;
	}

	return total;
}

- (NSString *)totalScoreStringForTeam:(WBTeam *)team {
	return [NSString stringWithFormat:@"%ld", (long)[self totalScoreForTeam:team]];
}

@end
