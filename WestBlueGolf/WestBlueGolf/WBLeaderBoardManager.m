//
//  WBLeaderBoardManager.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/10/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBLeaderBoardManager.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"

@implementation WBLeaderBoardManager

- (void)calculateLeaderBoards {
	[self clearLeaderBoards];
	WBYear *year = [WBYear thisYear];
	
	// Important team boards
	NSArray *teams = [WBTeam findAll];
	[self calculateTeamPointsBoardWithTeams:teams year:year];
	[self calculateTeamAverageHandicapBoardWithTeams:teams year:year];
	[self calculateTeamWinLossBoardWithTeams:teams year:year];
	[self calculateTeamImprovedBoardWithTeams:teams year:year];
	[WBLeaderBoard createLeaderBoardWithName:@"Avg. Opp. Score" key:kLeaderboardTeamAverageOpponentScore tablePriority:5 isPlayerBoard:NO];
	
	// Extra team boards
	[WBLeaderBoard createLeaderBoardWithName:@"Avg. Net Score" key:kLeaderboardTeamAverageNet tablePriority:6 isPlayerBoard:NO];
	[WBLeaderBoard createLeaderBoardWithName:@"Average Score" key:kLeaderboardTeamAverageScore tablePriority:7 isPlayerBoard:NO];
	[self calculateTeamIndividualWinLossBoardWithTeams:teams year:year];
	[WBLeaderBoard createLeaderBoardWithName:@"Total Match Wins" key:kLeaderboardTeamTotalWins tablePriority:9 isPlayerBoard:NO];
	[WBLeaderBoard createLeaderBoardWithName:@"Points in a Week" key:kLeaderboardTeamMaxWeekPoints tablePriority:10 isPlayerBoard:NO];
	[WBLeaderBoard createLeaderBoardWithName:@"% Weeks Top Score" key:kLeaderboardTeamTopPercentage tablePriority:11 isPlayerBoard:NO];
	[WBLeaderBoard createLeaderBoardWithName:@"% Weeks Top Five Score" key:kLeaderboardTeamTopFivePercentage tablePriority:12 isPlayerBoard:NO];
	
	
	// Important Player leaderboards
	NSArray *players = [WBPlayer findAll];
	[self calculatePlayerTopScoreBoardWithPlayers:players year:year];
	[self calculatePlayerTopNetScoreBoardWithPlayers:players year:year];
	[self calculatePlayerHandicapBoardWithPlayers:players year:year];
	[self calculatePlayerAveragePointsBoardWithPlayers:players year:year];
	[self calculatePlayerWinLossRatioBoardWithPlayers:players year:year];
	[self calculatePlayerImprovedBoardWithPlayers:players year:year];
	[WBLeaderBoard createLeaderBoardWithName:@"Avg. Opp. Score" key:kLeaderboardPlayerAverageOpponentScore tablePriority:7 isPlayerBoard:YES];
	
	// Extra Player boards
	[WBLeaderBoard createLeaderBoardWithName:@"Average Score" key:kLeaderboardPlayerAverageScore tablePriority:8 isPlayerBoard:YES];
	[WBLeaderBoard createLeaderBoardWithName:@"Avg. Net Score" key:kLeaderboardPlayerAverageNet tablePriority:9 isPlayerBoard:YES];
	[WBLeaderBoard createLeaderBoardWithName:@"Points in a Match" key:kLeaderboardPlayerMaxPoints tablePriority:10 isPlayerBoard:YES];
	[WBLeaderBoard createLeaderBoardWithName:@"Total Points" key:kLeaderboardPlayerTotalPoints tablePriority:11 isPlayerBoard:YES];
	[WBLeaderBoard createLeaderBoardWithName:@"Total Wins" key:kLeaderboardPlayerTotalWins tablePriority:12 isPlayerBoard:YES];
	[WBLeaderBoard createLeaderBoardWithName:@"% Weeks Top Score" key:kLeaderboardPlayerTopPercentage tablePriority:13 isPlayerBoard:YES];
	[WBLeaderBoard createLeaderBoardWithName:@"% Weeks Top Ten Score" key:kLeaderboardPlayerTopTenPercentage tablePriority:14 isPlayerBoard:YES];
	
	[WBCoreDataManager saveContext];
}

#pragma mark - Team Boards

- (void)calculateTeamBoardWithName:(NSString *)name
							   key:(NSString *)key
						  priority:(NSInteger)priority
							 teams:(NSArray *)teams
							  year:(WBYear *)year
						 ascending:(BOOL)ascending
				  valueCalculation:(double (^) (WBTeam *))valueCalculation {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:name key:key tablePriority:priority isPlayerBoard:NO];
	double totalLeagueValue = 0;
	double value = 0;
	for (WBTeam *team in teams) {
		value = valueCalculation(team);
		[WBBoardData createBoardDataForEntity:team leaderBoard:board value:value rank:0];
		totalLeagueValue += value;
	}
	
	// Create league average for board
	[WBBoardData createBoardDataForEntity:[WBPeopleEntity leagueAverage] leaderBoard:board value:(totalLeagueValue / (double)teams.count) rank:0];
	
	[self assignRanksForBoard:board ascending:ascending];
}

- (void)calculateTeamPointsBoardWithTeams:(NSArray *)teams year:(WBYear *)year {
	[self calculateTeamBoardWithName:@"Team Ranking" key:kLeaderboardTeamAveragePoints priority:1 teams:teams year:year ascending:NO valueCalculation:^(WBTeam *team) {
		return (double)[team totalPointsForYear:year];
	}];
}

- (void)calculateTeamAverageHandicapBoardWithTeams:(NSArray *)teams year:(WBYear *)year {
	[self calculateTeamBoardWithName:@"Average Handicap" key:kLeaderboardTeamAverageHandicap priority:2 teams:teams year:year ascending:YES valueCalculation:^(WBTeam *team) {
		return [team averageHandicapForYear:year];
	}];
}

- (void)calculateTeamWinLossBoardWithTeams:(NSArray *)teams year:(WBYear *)year {
	[self calculateTeamBoardWithName:@"Win/Loss Ratio" key:kLeaderboardTeamWeeklyWinLossRatio priority:3 teams:teams year:year ascending:NO valueCalculation:^(WBTeam *team) {
		return [team recordRatioForYear:year];
	}];
}

- (void)calculateTeamImprovedBoardWithTeams:(NSArray *)teams year:(WBYear *)year {
	[self calculateTeamBoardWithName:@"Season Improvement" key:kLeaderboardTeamTotalImproved priority:4 teams:teams year:year ascending:YES valueCalculation:^(WBTeam *team) {
		return (double)[team improvedInYear:year];
	}];
}

- (void)calculateTeamIndividualWinLossBoardWithTeams:(NSArray *)teams year:(WBYear *)year {
	[self calculateTeamBoardWithName:@"Ind. W/L Ratio" key:kLeaderboardTeamIndividualWinLossRatio priority:8 teams:teams year:year ascending:NO valueCalculation:^(WBTeam *team) {
		return [team individualRecordRatioForYear:year];
	}];
}

#pragma mark - Player Boards

- (void)calculatePlayerBoardWithName:(NSString *)name
								 key:(NSString *)key
							priority:(NSInteger)priority
							 players:(NSArray *)players
								year:(WBYear *)year
						   ascending:(BOOL)ascending
					valueCalculation:(double (^) (WBPlayer *))valueCalculation {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:name key:key tablePriority:priority isPlayerBoard:YES];
	double totalLeagueValue = 0;
	double value = 0;
	double playerCount = 0;
	for (WBPlayer *player in players) {
		if (player.results && player.results.count > 0) {
			value = valueCalculation(player);
			[WBBoardData createBoardDataForEntity:player leaderBoard:board value:value rank:0];
			totalLeagueValue += value;
			playerCount++;
		}
	}
	
	// Create league average for board
	[WBBoardData createBoardDataForEntity:[WBPeopleEntity leagueAverage] leaderBoard:board value:(totalLeagueValue / playerCount) rank:0];
	
	[self assignRanksForBoard:board ascending:ascending];
}

- (void)calculatePlayerTopScoreBoardWithPlayers:(NSArray *)players year:(WBYear *)year {
	[self calculatePlayerBoardWithName:@"Best Score" key:kLeaderboardPlayerMinScore priority:1 players:players year:year ascending:YES valueCalculation:^(WBPlayer *player) {
		return (double)[player lowRoundForYear:year];
	}];
}

- (void)calculatePlayerTopNetScoreBoardWithPlayers:(NSArray *)players year:(WBYear *)year {
	[self calculatePlayerBoardWithName:@"Best Net Score" key:kLeaderboardPlayerMinNet priority:2 players:players year:year ascending:YES valueCalculation:^(WBPlayer *player) {
		return (double)[player lowNetForYear:year];
	}];
}

- (void)calculatePlayerHandicapBoardWithPlayers:(NSArray *)players year:(WBYear *)year {
	[self calculatePlayerBoardWithName:@"Handicap" key:kLeaderboardPlayerHandicap priority:3 players:players year:year ascending:YES valueCalculation:^(WBPlayer *player) {
		return (double)player.currentHandicapValue;
	}];
}

- (void)calculatePlayerAveragePointsBoardWithPlayers:(NSArray *)players year:(WBYear *)year {
	[self calculatePlayerBoardWithName:@"Average Points" key:kLeaderboardPlayerAveragePoints priority:4 players:players year:year ascending:NO valueCalculation:^(WBPlayer *player) {
		return [player averagePointsInYear:year];
	}];
}

- (void)calculatePlayerWinLossRatioBoardWithPlayers:(NSArray *)players year:(WBYear *)year {
	[self calculatePlayerBoardWithName:@"Win/Loss Ratio" key:kLeaderboardPlayerWinLossRatio priority:5 players:players year:year ascending:NO valueCalculation:^(WBPlayer *player) {
		return [player recordRatioForYear:year];
	}];
}

- (void)calculatePlayerImprovedBoardWithPlayers:(NSArray *)players year:(WBYear *)year {
	[self calculatePlayerBoardWithName:@"Season Improvement" key:kLeaderboardPlayerTotalImproved priority:6 players:players year:year ascending:YES valueCalculation:^(WBPlayer *player) {
		return (double)[player improvedInYear:year];
	}];
}

#pragma mark - Board Helper functions

- (void)assignRanksForBoard:(WBLeaderBoard *)board ascending:(BOOL)ascending {
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:ascending], [NSSortDescriptor sortDescriptorWithKey:@"peopleEntity.name" ascending:YES]];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"leaderBoard = %@", board];
	NSArray *data = [WBBoardData findWithPredicate:pred sortedBy:sorts];
	double lastValue = INT16_MAX, rank = 0, i = 0;
	for (WBBoardData *datum in data) {
		// Increment rank for each unique value, except when it's the league average (which will have same rank as previous, but not show rank)
		if ([datum.peopleEntity isLeagueAverage]) {
			// don't change rank
			// don't increment i
			// set the rank for league average to the following rank (it shows up first in the alpha sort)
			datum.rankValue = rank + 1;
		}
		
		if (lastValue != datum.valueValue) {
			rank = i + 1;
			lastValue = datum.valueValue;
		}
		datum.rankValue = rank;
		i++;
	}
}

- (void)clearLeaderBoards {
	NSArray *boards = [WBLeaderBoard findAll];
	for (WBLeaderBoard *board in boards) {
		[board deleteEntity];
	}
}

@end
