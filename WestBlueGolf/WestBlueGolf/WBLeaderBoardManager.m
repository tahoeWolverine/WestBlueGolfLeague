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

- (void)calculateTeamPointsBoardWithTeams:(NSArray *)teams year:(WBYear *)year {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Team Ranking" key:kLeaderboardTeamAveragePoints tablePriority:1 isPlayerBoard:NO];
	
	for (WBTeam *team in teams) {
		[WBBoardData createBoardDataForEntity:team leaderBoard:board value:[team totalPointsForYear:year] rank:0];
	}
	
	[self assignRanksForBoard:board ascending:NO];
}

- (void)calculateTeamAverageHandicapBoardWithTeams:(NSArray *)teams year:(WBYear *)year {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Average Handicap" key:kLeaderboardTeamAverageHandicap tablePriority:2 isPlayerBoard:NO];

	for (WBTeam *team in teams) {
		[WBBoardData createBoardDataForEntity:team leaderBoard:board value:[team averageHandicapForYear:year] rank:0];
	}
	
	[self assignRanksForBoard:board ascending:YES];
}

- (void)calculateTeamWinLossBoardWithTeams:(NSArray *)teams year:(WBYear *)year {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Win/Loss Ratio" key:kLeaderboardTeamWeeklyWinLossRatio tablePriority:3 isPlayerBoard:NO];

	for (WBTeam *team in teams) {
		[WBBoardData createBoardDataForEntity:team leaderBoard:board value:[team recordRatioForYear:year] rank:0];
	}
	
	[self assignRanksForBoard:board ascending:NO];
}

- (void)calculateTeamImprovedBoardWithTeams:(NSArray *)teams year:(WBYear *)year {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Season Improvement" key:kLeaderboardTeamTotalImproved tablePriority:4 isPlayerBoard:NO];

	for (WBTeam *team in teams) {
		[WBBoardData createBoardDataForEntity:team leaderBoard:board value:[team improvedInYear:year] rank:0];
	}
	
	[self assignRanksForBoard:board ascending:YES];
}

- (void)calculateTeamIndividualWinLossBoardWithTeams:(NSArray *)teams year:(WBYear *)year {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Ind. W/L Ratio" key:kLeaderboardTeamIndividualWinLossRatio tablePriority:8 isPlayerBoard:NO];

	for (WBTeam *team in teams) {
		[WBBoardData createBoardDataForEntity:team leaderBoard:board value:[team individualRecordRatioForYear:year] rank:0];
	}
	
	[self assignRanksForBoard:board ascending:NO];
}

#pragma mark - Player Boards

- (void)calculatePlayerTopScoreBoardWithPlayers:(NSArray *)players year:(WBYear *)year {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Best Score" key:kLeaderboardPlayerMinScore tablePriority:1 isPlayerBoard:YES];

	for (WBPlayer *player in players) {
		if (player.results && player.results.count > 0) {
			[WBBoardData createBoardDataForEntity:player leaderBoard:board value:[player lowRoundForYear:year] rank:0];
		}
	}
	
	[self assignRanksForBoard:board ascending:YES];
}

- (void)calculatePlayerTopNetScoreBoardWithPlayers:(NSArray *)players year:(WBYear *)year {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Best Net Score" key:kLeaderboardPlayerMinNet tablePriority:2 isPlayerBoard:YES];

	for (WBPlayer *player in players) {
		if (player.results && player.results.count > 0) {
			[WBBoardData createBoardDataForEntity:player leaderBoard:board value:[player lowNetForYear:year] rank:0];
		}
	}
	
	[self assignRanksForBoard:board ascending:YES];
}

- (void)calculatePlayerHandicapBoardWithPlayers:(NSArray *)players year:(WBYear *)year {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Handicap" key:kLeaderboardPlayerHandicap tablePriority:3 isPlayerBoard:YES];

	for (WBPlayer *player in players) {
		if (player.results && player.results.count > 0) {
			[WBBoardData createBoardDataForEntity:player leaderBoard:board value:player.currentHandicapValue rank:0];
		}
	}
	
	[self assignRanksForBoard:board ascending:YES];
}

- (void)calculatePlayerAveragePointsBoardWithPlayers:(NSArray *)players year:(WBYear *)year {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Average Points" key:kLeaderboardPlayerAveragePoints tablePriority:4 isPlayerBoard:YES];

	for (WBPlayer *player in players) {
		if (player.results && player.results.count > 0) {
			[WBBoardData createBoardDataForEntity:player leaderBoard:board value:[player averagePointsInYear:year] rank:0];
		}
	}
	
	[self assignRanksForBoard:board ascending:NO];
}

- (void)calculatePlayerWinLossRatioBoardWithPlayers:(NSArray *)players year:(WBYear *)year {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Win/Loss Ratio" key:kLeaderboardPlayerWinLossRatio tablePriority:5 isPlayerBoard:YES];

	for (WBPlayer *player in players) {
		if (player.results && player.results.count > 0) {
			[WBBoardData createBoardDataForEntity:player leaderBoard:board value:[player recordRatioForYear:year] rank:0];
		}
	}
	
	[self assignRanksForBoard:board ascending:NO];
}

- (void)calculatePlayerImprovedBoardWithPlayers:(NSArray *)players year:(WBYear *)year {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Season Improvement" key:kLeaderboardPlayerTotalImproved tablePriority:6 isPlayerBoard:YES];

	for (WBPlayer *player in players) {
		if (player.results && player.results.count > 0) {
			[WBBoardData createBoardDataForEntity:player leaderBoard:board value:[player improvedInYear:year] rank:0];
		}
	}
	
	[self assignRanksForBoard:board ascending:YES];
}

#pragma mark - Board Helper functions

- (void)assignRanksForBoard:(WBLeaderBoard *)board ascending:(BOOL)ascending {
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:ascending], [NSSortDescriptor sortDescriptorWithKey:@"peopleEntity.name" ascending:YES]];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"leaderBoard = %@", board];
	NSArray *data = [WBBoardData findWithPredicate:pred sortedBy:sorts];
	double lastValue = INT16_MAX, rank = 0, i = 0;
	for (WBBoardData *datum in data) {
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
