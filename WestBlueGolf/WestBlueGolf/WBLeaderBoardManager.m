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

#define kDetailStringWeeks @"data through %ld weeks"
#define kDetailStringPlayers @"data from %ld players"
#define kDetailStringRecord @"record: %@"
#define kDetailStringMatches @"data from %ld matches"
#define kDetailStringImprove @"improved from %ld to %ld"
#define kDetailStringSingle @"occurred in Week %ld on %@"

@implementation WBLeaderBoardManager

- (void)calculateLeaderBoardsForYear:(WBYear *)year moc:(NSManagedObjectContext *)moc {
	// Important team boards
	NSArray *teams = [WBTeam findAllForYear:year inContext:moc];
	
	[self calculateTeamBoardWithName:@"Team Ranking" key:kLeaderboardTeamAveragePoints priority:1 teams:teams year:year ascending:NO moc:moc valueCalculation:^(WBTeam *team) {
		return (CGFloat)[team totalPointsForYear:year];
	} detailValueCalc:^(WBTeam *team) {
		return [NSString stringWithFormat:kDetailStringWeeks, (long)[team filterMatchupsForYear:year].count];
	}];
	
	[self calculateTeamBoardWithName:@"Average Handicap" key:kLeaderboardTeamAverageHandicap priority:2 teams:teams year:year ascending:YES moc:moc valueCalculation:^(WBTeam *team) {
		return [team averageHandicapForYear:year];
	} detailValueCalc:^(WBTeam *team) {
		return [NSString stringWithFormat:kDetailStringPlayers, (long)[team filterPlayersForYear:year].count];
	}];
	
	[self calculateTeamBoardWithName:@"Win/Loss Ratio" key:kLeaderboardTeamWeeklyWinLossRatio priority:3 teams:teams year:year ascending:NO moc:moc valueCalculation:^(WBTeam *team) {
		return [team recordRatioForYear:year];
	} detailValueCalc:^(WBTeam *team) {
		return [NSString stringWithFormat:kDetailStringRecord, [team record]];
	}];
	
	[self calculateTeamBoardWithName:@"Season Improvement" key:kLeaderboardTeamTotalImproved priority:4 teams:teams year:year ascending:YES moc:moc valueCalculation:^(WBTeam *team) {
		return (CGFloat)[team improvedInYear:year];
	} detailValueCalc:^(WBTeam *team) {
		return [NSString stringWithFormat:kDetailStringPlayers, (long)[team filterPlayersForYear:year].count];
	}];
	
	[self calculateTeamBoardWithName:@"Avg. Opp. Score" key:kLeaderboardTeamAverageOpponentScore priority:5 teams:teams year:year ascending:YES moc:moc valueCalculation:^(WBTeam *team) {
		return [team averageOpponentScoreForYear:year];
	} detailValueCalc:^(WBTeam *team) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[team totalOpponentResultsForYear:year]];
	}];
	
	[self calculateTeamBoardWithName:@"Avg. Opp. Net Score" key:kLeaderboardTeamAverageOpponentNetScore priority:6 teams:teams year:year ascending:YES moc:moc valueCalculation:^(WBTeam *team) {
		return [team averageOpponentNetScoreForYear:year];
	} detailValueCalc:^(WBTeam *team) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[team totalOpponentResultsForYear:year]];
	}];
	
	// Extra team boards
	[self calculateTeamBoardWithName:@"Average Score" key:kLeaderboardTeamAverageScore priority:7 teams:teams year:year ascending:YES moc:moc valueCalculation:^(WBTeam *team) {
		return [team averageScoreForYear:year];
	} detailValueCalc:^(WBTeam *team) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[team totalResultsForYear:year]];
	}];

	[self calculateTeamBoardWithName:@"Avg. Net Score" key:kLeaderboardTeamAverageNet priority:8 teams:teams year:year ascending:YES moc:moc valueCalculation:^(WBTeam *team) {
		return [team averageNetScoreForYear:year];
	} detailValueCalc:^(WBTeam *team) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[team totalResultsForYear:year]];
	}];

	[self calculateTeamBoardWithName:@"Ind. W/L Ratio" key:kLeaderboardTeamIndividualWinLossRatio priority:9 teams:teams year:year ascending:NO moc:moc valueCalculation:^(WBTeam *team) {
		return [team individualRecordRatioForYear:year];
	} detailValueCalc:^(WBTeam *team) {
		return [NSString stringWithFormat:kDetailStringRecord, [team individualRecord]];
	}];

	[self calculateTeamBoardWithName:@"Total Match Wins" key:kLeaderboardTeamTotalWins priority:10 teams:teams year:year ascending:NO moc:moc valueCalculation:^(WBTeam *team) {
		return  (CGFloat)[[team individualRecordForYear:year][0] floatValue];
	} detailValueCalc:^(WBTeam *team) {
		return [NSString stringWithFormat:kDetailStringWeeks, (long)team.matchups.count];
	}];

	[self calculateTeamBoardWithName:@"Points in a Week" key:kLeaderboardTeamMaxWeekPoints priority:11 teams:teams year:year ascending:NO moc:moc valueCalculation:^(WBTeam *team) {
		return  (CGFloat)[team mostPointsInWeekForYear:year];
	} detailValueCalc:^(WBTeam *team) {
		NSInteger index = [team seasonIndexForMostPointsInWeekForYear:year];
		return [NSString stringWithFormat:kDetailStringSingle, (long)index, [WBWeek findWeekWithSeasonIndex:index year:year].course.name];
	}];
	
	[self calculateTeamBoardWithName:@"Avg Margin of Victory" key:kLeaderboardTeamAverageMarginVictory priority:12 teams:teams year:year ascending:NO moc:moc valueCalculation:^(WBTeam *team) {
		return [team averageMarginOfVictoryForYear:year];
	} detailValueCalc:^(WBTeam *team) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[team totalResultsForYear:year]];
	}];
	
	[self calculateTeamBoardWithName:@"Avg Margin of Net Victory" key:kLeaderboardTeamAverageMarginNetVictory priority:13 teams:teams year:year ascending:NO moc:moc valueCalculation:^(WBTeam *team) {
		return [team averageMarginOfNetVictoryForYear:year];
	} detailValueCalc:^(WBTeam *team) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[team totalResultsForYear:year]];
	}];

	[WBLeaderBoard leaderBoardWithName:@"% Weeks Top Score" key:kLeaderboardTeamTopPercentage tablePriority:14 isPlayerBoard:NO moc:moc];
	[WBLeaderBoard leaderBoardWithName:@"% Weeks Top Five Score" key:kLeaderboardTeamTopFivePercentage tablePriority:15 isPlayerBoard:NO moc:moc];
	[WBLeaderBoard leaderBoardWithName:@"Triple Crown" key:kLeaderboardTeamTripleCrown tablePriority:16 isPlayerBoard:NO moc:moc];
	[WBLeaderBoard leaderBoardWithName:@"Playoffs" key:kLeaderboardTeamPlayoffs tablePriority:17 isPlayerBoard:NO moc:moc];
	
	// Triple crown board: Avg Points, Avg Score, Improved
	
	
	// Important Player leaderboards
	NSArray *players = [WBPlayer findAllForYear:year inContext:moc];

	[self calculatePlayerBoardWithName:@"Best Score" key:kLeaderboardPlayerMinScore priority:1 players:players year:year ascending:YES moc:moc valueCalculation:^(WBPlayer *player) {
		return (CGFloat)[player lowRoundForYear:year inContext:moc];
	} detailValueCalc:^(WBPlayer *player) {
		NSInteger index = [player seasonIndexForLowRoundForYear:year];
		return [NSString stringWithFormat:kDetailStringSingle, (long)index, [WBWeek findWeekWithSeasonIndex:index year:year].course.name];
	}];

	[self calculatePlayerBoardWithName:@"Best Net Score" key:kLeaderboardPlayerMinNet priority:2 players:players year:year ascending:YES moc:moc valueCalculation:^(WBPlayer *player) {
		return (CGFloat)[player lowNetForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		NSInteger index = [player seasonIdexForLowNetForYear:year];
		return [NSString stringWithFormat:kDetailStringSingle, (long)index, [WBWeek findWeekWithSeasonIndex:index year:year].course.name];
	}];

	[self calculatePlayerBoardWithName:@"Handicap" key:kLeaderboardPlayerHandicap priority:3 players:players year:year ascending:YES moc:moc valueCalculation:^(WBPlayer *player) {
		return (CGFloat)[player finishingHandicapInYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)player.results.count];
	}];

	[self calculatePlayerBoardWithName:@"Average Points" key:kLeaderboardPlayerAveragePoints priority:4 players:players year:year ascending:NO moc:moc valueCalculation:^(WBPlayer *player) {
		return [player averagePointsInYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)player.results.count];
	}];

	[self calculatePlayerBoardWithName:@"Win/Loss Ratio" key:kLeaderboardPlayerWinLossRatio priority:5 players:players year:year ascending:NO moc:moc valueCalculation:^(WBPlayer *player) {
		return [player recordRatioForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringRecord, [player record]];
	}];

	[self calculatePlayerBoardWithName:@"Season Improvement" key:kLeaderboardPlayerTotalImproved priority:6 players:players year:year ascending:YES moc:moc valueCalculation:^(WBPlayer *player) {
		return (CGFloat)[player improvedInYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringImprove, (long)[player filterYearDataForYear:year].startingHandicapValue, (long)[player filterYearDataForYear:year].finishingHandicapValue];
	}];

	[self calculatePlayerBoardWithName:@"Avg. Opp. Score" key:kLeaderboardPlayerAverageOpponentScore priority:7 players:players year:year ascending:YES moc:moc valueCalculation:^(WBPlayer *player) {
		return [player averageOpponentScoreForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)player.results.count];
	}];
	
	[self calculatePlayerBoardWithName:@"Avg. Opp. Net Score" key:kLeaderboardPlayerAverageOpponentNetScore priority:8 players:players year:year ascending:YES moc:moc valueCalculation:^(WBPlayer *player) {
		return [player averageOpponentNetScoreForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)player.results.count];
	}];
	
	// Extra Player boards
	[self calculatePlayerBoardWithName:@"Average Score" key:kLeaderboardPlayerAverageScore priority:9 players:players year:year ascending:YES moc:moc valueCalculation:^(WBPlayer *player) {
		return [player averageScoreForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)player.results.count];
	}];
	
	[self calculatePlayerBoardWithName:@"Avg. Net Score" key:kLeaderboardPlayerAverageNet priority:10 players:players year:year ascending:YES moc:moc valueCalculation:^(WBPlayer *player) {
		return [player averageNetScoreForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)player.results.count];
	}];

	[self calculatePlayerBoardWithName:@"Points in a Match" key:kLeaderboardPlayerMaxPoints priority:11 players:players year:year ascending:NO moc:moc valueCalculation:^(WBPlayer *player) {
		return (CGFloat)[player mostPointsInMatchForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		NSInteger index = [player seasonIndexForMostPointsInMatchForYear:year];
		return [NSString stringWithFormat:kDetailStringSingle, (long)index, [WBWeek findWeekWithSeasonIndex:index year:year].course.name];
	}];
	
	[self calculatePlayerBoardWithName:@"Total Points" key:kLeaderboardPlayerTotalPoints priority:12 players:players year:year ascending:NO moc:moc valueCalculation:^(WBPlayer *player) {
		return (CGFloat)[player totalPointsForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)player.results.count];
	}];
	
	[self calculatePlayerBoardWithName:@"Total Wins" key:kLeaderboardPlayerTotalWins priority:13 players:players year:year ascending:NO moc:moc valueCalculation:^(WBPlayer *player) {
		return (CGFloat)[[player recordForYear:year][0] floatValue];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)player.results.count];
	}];
	
	[self calculatePlayerBoardWithName:@"Avg Margin of Victory" key:kLeaderboardPlayerAverageMarginVictory priority:14 players:players year:year ascending:NO moc:moc valueCalculation:^(WBPlayer *player) {
		return [player averageMarginOfVictoryForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)player.results.count];
	}];
	
	[self calculatePlayerBoardWithName:@"Avg Margin of Net Victory" key:kLeaderboardPlayerAverageMarginNetVictory priority:15 players:players year:year ascending:NO moc:moc valueCalculation:^(WBPlayer *player) {
		return [player averageMarginOfNetVictoryForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)player.results.count];
	}];
	
	[self calculatePlayerBoardWithName:@"Total Rounds" key:kLeaderboardPlayerTotalRounds priority:16 players:players year:year ascending:NO moc:moc valueCalculation:^(WBPlayer *player) {
		return (CGFloat)([[player recordForYear:year][0] floatValue] + [[player recordForYear:year][1] floatValue] + [[player recordForYear:year][2] floatValue]);
	} detailValueCalc:^(WBPlayer *player) {
		return @"";
	}];

	[WBLeaderBoard leaderBoardWithName:@"% Weeks Top Score" key:kLeaderboardPlayerTopPercentage tablePriority:17 isPlayerBoard:YES moc:moc];
	[WBLeaderBoard leaderBoardWithName:@"% Weeks Top Ten Score" key:kLeaderboardPlayerTopTenPercentage tablePriority:18 isPlayerBoard:YES moc:moc];
	[WBLeaderBoard leaderBoardWithName:@"Triple Crown" key:kLeaderboardPlayerTripleCrown tablePriority:19 isPlayerBoard:YES moc:moc];
	[WBLeaderBoard leaderBoardWithName:@"Triple Crown 2" key:kLeaderboardPlayerTripleCrown2 tablePriority:20 isPlayerBoard:YES moc:moc];
	
	// Pro Triple crown board: Avg Points, Avg Score, Total Wins
	// Triple Crown: Avg Points, Avg Net Score, Improved
	
	[WBCoreDataManager saveContext:moc];
}

#pragma mark - Team Boards

- (void)calculateTeamBoardWithName:(NSString *)name
							   key:(NSString *)key
						  priority:(NSInteger)priority
							 teams:(NSArray *)teams
							  year:(WBYear *)year
						 ascending:(BOOL)ascending
							   moc:(NSManagedObjectContext *)moc
				  valueCalculation:(CGFloat (^) (WBTeam *))valueCalculation
				   detailValueCalc:(NSString * (^) (WBTeam *))detailValueCalc {
	WBLeaderBoard *board = [WBLeaderBoard leaderBoardWithName:name key:key tablePriority:priority isPlayerBoard:NO moc:moc];
	CGFloat totalLeagueValue = 0, value = 0, teamCount = 0;
	NSString *detailValue = nil;
	NSArray *results = nil;
	for (WBTeam *team in teams) {
		results = [team filterResultsForYear:year goodData:YES];
		if (results && results.count > 0) {
			value = valueCalculation(team);
			detailValue = detailValueCalc(team);
			[WBBoardData createBoardDataForEntity:team leaderBoard:board value:value detailValue:detailValue rank:0 year:year moc:moc];
			totalLeagueValue += value;
			teamCount++;
		}
	}
	
	// Create league average for board
	if (teamCount > 0) {
		[WBBoardData createBoardDataForEntity:[WBPeopleEntity leagueAverageInContext:moc] leaderBoard:board value:(totalLeagueValue / teamCount) detailValue:detailValue rank:0 year:year moc:moc];
	}
	
	[self assignRanksForBoard:board year:year ascending:ascending moc:moc];
}

#pragma mark - Player Boards

- (void)calculatePlayerBoardWithName:(NSString *)name
								 key:(NSString *)key
							priority:(NSInteger)priority
							 players:(NSArray *)players
								year:(WBYear *)year
						   ascending:(BOOL)ascending
								 moc:(NSManagedObjectContext *)moc
					valueCalculation:(CGFloat (^) (WBPlayer *))valueCalculation
					 detailValueCalc:(NSString * (^) (WBPlayer *))detailValueCalc {
	WBLeaderBoard *board = [WBLeaderBoard leaderBoardWithName:name key:key tablePriority:priority isPlayerBoard:YES moc:moc];
	CGFloat totalLeagueValue = 0, value = 0, playerCount = 0;
	NSString *detailValue = nil;
	NSArray *results = nil;
	for (WBPlayer *player in players) {
		results = [player filterResultsForYear:year goodData:YES];
		if (results && results.count > 0) {
			value = valueCalculation(player);
			detailValue = detailValueCalc(player);
			[WBBoardData createBoardDataForEntity:player leaderBoard:board value:value detailValue:detailValue rank:0 year:year moc:moc];
			if (![player isNoShowPlayer]) {
				totalLeagueValue += value;
				playerCount++;
			}
		}
	}
	
	// Create league average for board
	if (playerCount > 0) {
		[WBBoardData createBoardDataForEntity:[WBPeopleEntity leagueAverageInContext:moc] leaderBoard:board value:(totalLeagueValue / playerCount) detailValue:detailValue rank:0 year:year moc:moc];
	}
	
	[self assignRanksForBoard:board year:year ascending:ascending moc:moc];
}

#pragma mark - Board Helper functions

- (void)assignRanksForBoard:(WBLeaderBoard *)board year:(WBYear *)year ascending:(BOOL)ascending moc:(NSManagedObjectContext *)moc {
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:ascending], [NSSortDescriptor sortDescriptorWithKey:@"peopleEntity.name" ascending:YES]];
	NSArray *data = [WBBoardData findWithPredicate:[NSPredicate predicateWithFormat:@"leaderBoard = %@ && year = %@", board, year] sortedBy:sorts fetchLimit:0 moc:moc];
	CGFloat lastValue = INT16_MAX, rank = 0, i = 0;
	for (WBBoardData *datum in data) {
		// Increment rank for each unique value, except when it's the league average (which will have same rank as previous, but not show rank)
		if ([datum.peopleEntity isLeagueAverage]) {
			// don't change rank
			// don't increment i
			// set the rank for league average to the following rank (it shows up first in the alpha sort)
			datum.rankValue = rank + 1;
			continue;
		}
		
		if (lastValue != datum.valueValue) {
			rank = i + 1;
			lastValue = datum.valueValue;
		}
		datum.rankValue = rank;
		i++;
	}
}

- (void)clearLeaderBoardsInContext:(NSManagedObjectContext *)moc {
	NSArray *boards = [WBLeaderBoard findAll];
	for (WBLeaderBoard *board in boards) {
		[board deleteEntityInContext:moc];
	}
}

@end
