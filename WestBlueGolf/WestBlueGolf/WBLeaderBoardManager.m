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
	
	// Important team boards
	[self calculateTeamPointsBoard];
	[self calculateTeamAverageHandicapBoard];
	[self calculateTeamWinLossBoard];
	[self calculateTeamImprovedBoard];
	[WBLeaderBoard createLeaderBoardWithName:@"Avg. Opp. Score" key:kLeaderboardTeamAverageOpponentScore tablePriority:5 isPlayerBoard:NO];
	
	// Extra team boards
	[WBLeaderBoard createLeaderBoardWithName:@"Avg. Net Score" key:kLeaderboardTeamAverageNet tablePriority:6 isPlayerBoard:NO];
	[WBLeaderBoard createLeaderBoardWithName:@"Average Score" key:kLeaderboardTeamAverageScore tablePriority:7 isPlayerBoard:NO];
	[self calculateTeamIndividualWinLossBoard];
	[WBLeaderBoard createLeaderBoardWithName:@"Total Match Wins" key:kLeaderboardTeamTotalWins tablePriority:9 isPlayerBoard:NO];
	[WBLeaderBoard createLeaderBoardWithName:@"Points in a Week" key:kLeaderboardTeamMaxWeekPoints tablePriority:10 isPlayerBoard:NO];
	[WBLeaderBoard createLeaderBoardWithName:@"% Weeks Top Score" key:kLeaderboardTeamTopPercentage tablePriority:11 isPlayerBoard:NO];
	[WBLeaderBoard createLeaderBoardWithName:@"% Weeks Top Five Score" key:kLeaderboardTeamTopFivePercentage tablePriority:12 isPlayerBoard:NO];
	
	
	// Important Player leaderboards
	[self calculatePlayerTopScoreBoard];
	[self calculatePlayerTopNetScoreBoard];
	[self calculatePlayerHandicapBoard];
	[self calculatePlayerAveragePointsBoard];
	[self calculatePlayerWinLossRatioBoard];
	[self calculatePlayerImprovedBoard];
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

- (void)calculateTeamPointsBoard {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Team Ranking" key:kLeaderboardTeamAveragePoints tablePriority:1 isPlayerBoard:NO];
	NSArray *teams = [WBCoreDataManager findEntity:[WBTeam entityName] withPredicate:nil sorts:nil];
	WBYear *year = [WBYear thisYear];
	for (WBTeam *team in teams) {
		[WBBoardData createBoardDataForEntity:team leaderBoard:board value:[team totalPointsForYear:year] rank:0];
	}
	
	[self assignRanksForBoard:board ascending:NO];
}

- (void)calculateTeamAverageHandicapBoard {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Average Handicap" key:kLeaderboardTeamAverageHandicap tablePriority:2 isPlayerBoard:NO];
	NSArray *teams = [WBCoreDataManager findEntity:[WBTeam entityName] withPredicate:nil sorts:nil];
	WBYear *year = [WBYear thisYear];
	for (WBTeam *team in teams) {
		[WBBoardData createBoardDataForEntity:team leaderBoard:board value:[team averageHandicapForYear:year] rank:0];
	}
	
	[self assignRanksForBoard:board ascending:YES];
}

- (void)calculateTeamWinLossBoard {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Win/Loss Ratio" key:kLeaderboardTeamWeeklyWinLossRatio tablePriority:3 isPlayerBoard:NO];
	NSArray *teams = [WBCoreDataManager findEntity:[WBTeam entityName] withPredicate:nil sorts:nil];
	WBYear *year = [WBYear thisYear];
	for (WBTeam *team in teams) {
		[WBBoardData createBoardDataForEntity:team leaderBoard:board value:[team recordRatioForYear:year] rank:0];
	}
	
	[self assignRanksForBoard:board ascending:NO];
}

- (void)calculateTeamImprovedBoard {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Season Improvement" key:kLeaderboardTeamTotalImproved tablePriority:4 isPlayerBoard:NO];
	NSArray *teams = [WBCoreDataManager findEntity:[WBTeam entityName] withPredicate:nil sorts:nil];
	WBYear *year = [WBYear thisYear];
	for (WBTeam *team in teams) {
		[WBBoardData createBoardDataForEntity:team leaderBoard:board value:[team improvedInYear:year] rank:0];
	}
	
	[self assignRanksForBoard:board ascending:YES];
}

- (void)calculateTeamIndividualWinLossBoard {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Ind. W/L Ratio" key:kLeaderboardTeamIndividualWinLossRatio tablePriority:8 isPlayerBoard:NO];
	NSArray *teams = [WBCoreDataManager findEntity:[WBTeam entityName] withPredicate:nil sorts:nil];
	WBYear *year = [WBYear thisYear];
	for (WBTeam *team in teams) {
		[WBBoardData createBoardDataForEntity:team leaderBoard:board value:[team individualRecordRatioForYear:year] rank:0];
	}
	
	[self assignRanksForBoard:board ascending:NO];
}

#pragma mark - Player Boards

- (void)calculatePlayerTopScoreBoard {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Top Score" key:kLeaderboardPlayerMinScore tablePriority:1 isPlayerBoard:YES];
	NSArray *players = [WBCoreDataManager findEntity:[WBPlayer entityName] withPredicate:nil sorts:nil];
	WBYear *year = [WBYear thisYear];
	for (WBPlayer *player in players) {
		if (player.results && player.results.count > 0) {
			[WBBoardData createBoardDataForEntity:player leaderBoard:board value:[player lowRoundForYear:year] rank:0];
		}
	}
	
	[self assignRanksForBoard:board ascending:YES];
}

- (void)calculatePlayerTopNetScoreBoard {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Top Net Score" key:kLeaderboardPlayerMinNet tablePriority:2 isPlayerBoard:YES];
	NSArray *players = [WBCoreDataManager findEntity:[WBPlayer entityName] withPredicate:nil sorts:nil];
	WBYear *year = [WBYear thisYear];
	for (WBPlayer *player in players) {
		if (player.results && player.results.count > 0) {
			[WBBoardData createBoardDataForEntity:player leaderBoard:board value:[player lowNetForYear:year] rank:0];
		}
	}
	
	[self assignRanksForBoard:board ascending:YES];
}

- (void)calculatePlayerHandicapBoard {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Handicap" key:kLeaderboardPlayerHandicap tablePriority:3 isPlayerBoard:YES];
	NSArray *players = [WBCoreDataManager findEntity:[WBPlayer entityName] withPredicate:nil sorts:nil];
	for (WBPlayer *player in players) {
		if (player.results && player.results.count > 0) {
			[WBBoardData createBoardDataForEntity:player leaderBoard:board value:player.currentHandicapValue rank:0];
		}
	}
	
	[self assignRanksForBoard:board ascending:YES];
}

- (void)calculatePlayerAveragePointsBoard {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Average Points" key:kLeaderboardPlayerAveragePoints tablePriority:4 isPlayerBoard:YES];
	NSArray *players = [WBCoreDataManager findEntity:[WBPlayer entityName] withPredicate:nil sorts:nil];
	WBYear *year = [WBYear thisYear];
	for (WBPlayer *player in players) {
		if (player.results && player.results.count > 0) {
			[WBBoardData createBoardDataForEntity:player leaderBoard:board value:[player averagePointsInYear:year] rank:0];
		}
	}
	
	[self assignRanksForBoard:board ascending:NO];
}

- (void)calculatePlayerWinLossRatioBoard {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Win/Loss Ratio" key:kLeaderboardPlayerWinLossRatio tablePriority:5 isPlayerBoard:YES];
	NSArray *players = [WBCoreDataManager findEntity:[WBPlayer entityName] withPredicate:nil sorts:nil];
	WBYear *year = [WBYear thisYear];
	for (WBPlayer *player in players) {
		if (player.results && player.results.count > 0) {
			[WBBoardData createBoardDataForEntity:player leaderBoard:board value:[player recordRatioForYear:year] rank:0];
		}
	}
	
	[self assignRanksForBoard:board ascending:NO];
}

- (void)calculatePlayerImprovedBoard {
	WBLeaderBoard *board = [WBLeaderBoard createLeaderBoardWithName:@"Season Improvement" key:kLeaderboardPlayerTotalImproved tablePriority:6 isPlayerBoard:YES];
	NSArray *players = [WBCoreDataManager findEntity:[WBPlayer entityName] withPredicate:nil sorts:nil];
	WBYear *year = [WBYear thisYear];
	for (WBPlayer *player in players) {
		if (player.results && player.results.count > 0) {
			[WBBoardData createBoardDataForEntity:player leaderBoard:board value:[player improvedInYear:year] rank:0];
		}
	}
	
	[self assignRanksForBoard:board ascending:YES];
}




- (void)assignRanksForBoard:(WBLeaderBoard *)board ascending:(BOOL)ascending {
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:ascending], [NSSortDescriptor sortDescriptorWithKey:@"peopleEntity.name" ascending:YES]];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"leaderBoard = %@", board];
	NSArray *data = [WBCoreDataManager findEntity:[WBBoardData entityName] withPredicate:pred sorts:sorts];
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
	NSArray *boards = [WBLeaderBoard fetchAllLeaderBoards];
	for (WBLeaderBoard *board in boards) {
		[board deleteLeaderBoard];
	}
}

@end
