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

#define wbJsonKeyLeaderboards @"leaderboards"
#define wbJsonKeyLeaderboardId @"id"
#define wbJsonKeyLeaderboardPlayerBoard @"isPlayerBoard"
#define wbJsonKeyLeaderboardKey @"key"
//#define wbJsonKeyLeaderboardData @"leaderboarddatas"
#define wbJsonKeyLeaderboardName @"name"
#define wbJsonKeyLeaderboardPriority @"priority"

#define wbJsonKeyLeaderboardData @"leaderboardDataForYear"
#define wbJsonKeyLeaderboardDataDetail @"det"
#define wbJsonKeyLeaderboardDataId @"id"
//#define wbJsonKeyLeaderboardDataPlayerBoard @"isp"
#define wbJsonKeyLeaderboardDataBoardId @"lbId"
#define wbJsonKeyLeaderboardDataPlayerId @"pId"
#define wbJsonKeyLeaderboardDataRank @"r"
#define wbJsonKeyLeaderboardDataValue @"v"
#define wbJsonKeyLeaderboardDataTeamId @"tId"

@implementation WBLeaderBoardManager

- (void)createLeaderBoardsForYear:(WBYear *)year withJson:(NSDictionary *)json {
    NSManagedObjectContext *moc = [WBCoreDataManager mainContext];

    // Leaderboards
    NSArray *boardArray = [json objectForKey:wbJsonKeyLeaderboards];
    
    NSString *boardName = nil, *boardKey = nil;
    NSInteger boardPriority = 0, boardId = 0;
    BOOL isPlayerBoard = NO;
	for (NSDictionary *elt in boardArray) {
		boardId = [[elt objectForKey:wbJsonKeyLeaderboardId] integerValue];
		boardName = [elt objectForKey:wbJsonKeyLeaderboardName];
		boardKey = [elt objectForKey:wbJsonKeyLeaderboardKey];
		boardPriority = [[elt objectForKey:wbJsonKeyLeaderboardPriority] integerValue];
		isPlayerBoard = [[elt objectForKey:wbJsonKeyLeaderboardPlayerBoard] boolValue];
        
        [WBLeaderBoard leaderBoardWithName:boardName boardId:boardId key:boardKey tablePriority:boardPriority isPlayerBoard:isPlayerBoard moc:moc];
	}
    
    // Leaderboard Data
    NSArray *dataArray = [json objectForKey:wbJsonKeyLeaderboardData];
    
    NSString *dataDetail = nil;
    NSNumber *playerId = nil, *teamId = nil;
    NSInteger dataId = 0, dataRank = 0;
    CGFloat dataValue = 0.0f;
    WBPeopleEntity *people = nil;
    WBLeaderBoard *board = nil;
    for (NSDictionary *elt in dataArray) {
		dataId = [[elt objectForKey:wbJsonKeyLeaderboardDataId] integerValue];
		dataDetail = [elt objectForKey:wbJsonKeyLeaderboardDataDetail];
		dataRank = [[elt objectForKey:wbJsonKeyLeaderboardDataRank] integerValue];
		dataValue = [[elt objectForKey:wbJsonKeyLeaderboardDataValue] floatValue];
		boardId = [[elt objectForKey:wbJsonKeyLeaderboardDataBoardId] integerValue];
		teamId = [elt objectForKey:wbJsonKeyLeaderboardDataTeamId];
		playerId = [elt objectForKey:wbJsonKeyLeaderboardDataPlayerId];

        if (playerId && ![playerId isKindOfClass:[NSNull class]]) {
            people = [WBPlayer findWithId:[playerId integerValue]];
        }

        if (teamId && ![teamId isKindOfClass:[NSNull class]]) {
            people = [WBTeam findWithId:[teamId integerValue]];
        }
        
        board = [WBLeaderBoard findWithId:boardId];
        
        if (!dataDetail || [dataDetail isEqualToString:@""]) {
            if ([people isKindOfClass:[WBTeam class]]) {
                NSString * (^detailValueCalc)(WBTeam *) = nil;
                detailValueCalc = [self detailBlockForTeamBoard:board.key year:year];
                dataDetail = detailValueCalc((WBTeam *)people);
            } else {
                NSString * (^detailValueCalc)(WBPlayer *) = nil;
                detailValueCalc = [self detailBlockForPlayerBoard:board.key year:year];
                dataDetail = detailValueCalc((WBPlayer *)people);
            }
        }
        
        [WBBoardData createBoardDataForEntity:people leaderBoard:board dataId:dataId value:dataValue detailValue:dataDetail rank:dataRank year:year moc:moc];
	}
    
    //[WBCoreDataManager saveContext:moc];
}

- (NSString * (^)(WBTeam *))detailBlockForTeamBoard:(NSString *)key year:(WBYear *)year {
    if ([key isEqualToString:kLeaderboardTeamTotalPoints]) {
        return ^NSString *(WBTeam *team) {
            return [NSString stringWithFormat:kDetailStringWeeks, (long)[team filterMatchupsForYear:year].count];
        };
    } else if ([key isEqualToString:kLeaderboardTeamAverageHandicap]) {
        return ^NSString *(WBTeam *team) {
            return [NSString stringWithFormat:kDetailStringPlayers, (long)[team filterPlayersForYear:year].count];
        };
    } else if ([key isEqualToString:kLeaderboardTeamWeeklyWinLossRatio]) {
        return ^NSString *(WBTeam *team) {
            return [NSString stringWithFormat:kDetailStringRecord, [team recordStringForYear:year]];
        };
    }else if ([key isEqualToString:kLeaderboardTeamTotalImproved]) {
        return ^NSString *(WBTeam *team) {
            return [NSString stringWithFormat:kDetailStringPlayers, (long)[team filterPlayersForYear:year].count];
        };
    } else if ([key isEqualToString:kLeaderboardTeamAverageOpponentScore]) {
        return ^NSString *(WBTeam *team) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[team totalOpponentResultsForYear:year]];
        };
    } else if ([key isEqualToString:kLeaderboardTeamAverageOpponentNetScore]) {
        return ^NSString *(WBTeam *team) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[team totalOpponentResultsForYear:year]];
        };
    } else if ([key isEqualToString:kLeaderboardTeamAverageScore]) {
        return ^NSString *(WBTeam *team) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[team totalResultsForYear:year]];
        };
    } else if ([key isEqualToString:kLeaderboardTeamAverageNet]) {
        return ^NSString *(WBTeam *team) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[team totalResultsForYear:year]];
        };
    } else if ([key isEqualToString:kLeaderboardTeamIndividualWinLossRatio]) {
        return ^NSString *(WBTeam *team) {
            return [NSString stringWithFormat:kDetailStringRecord, [team individualRecordStringForYear:year]];
        };
    } else if ([key isEqualToString:kLeaderboardTeamTotalWins]) {
        return ^NSString *(WBTeam *team) {
            return [NSString stringWithFormat:kDetailStringWeeks, (long)[team filterMatchupsForYear:year].count];
        };
    } else if ([key isEqualToString:kLeaderboardTeamMaxWeekPoints]) {
        return ^NSString *(WBTeam *team) {
            NSInteger index = [team seasonIndexForMostPointsInWeekForYear:year];
            return [NSString stringWithFormat:kDetailStringSingle, (long)index, [WBWeek findWeekWithSeasonIndex:index year:year].course.name];
        };
    } else if ([key isEqualToString:kLeaderboardTeamAverageMarginVictory]) {
        return ^NSString *(WBTeam *team) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[team totalResultsForYear:year]];
        };
    } else if ([key isEqualToString:kLeaderboardTeamAverageMarginNetVictory]) {
        return ^NSString *(WBTeam *team) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[team totalResultsForYear:year]];
        };
    }
    
    return ^NSString *(WBTeam *team) {
        return @"";
    };
}

- (NSString * (^)(WBPlayer *))detailBlockForPlayerBoard:(NSString *)key year:(WBYear *)year {
    if ([key isEqualToString:kLeaderboardPlayerMinScore]) {
        return ^NSString *(WBPlayer *player) {
            NSInteger index = [player seasonIndexForLowRoundForYear:year];
            return [NSString stringWithFormat:kDetailStringSingle, (long)index, [WBWeek findWeekWithSeasonIndex:index year:year].course.name];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerMinNet]) {
        return ^NSString *(WBPlayer *player) {
            NSInteger index = [player seasonIdexForLowNetForYear:year];
            return [NSString stringWithFormat:kDetailStringSingle, (long)index, [WBWeek findWeekWithSeasonIndex:index year:year].course.name];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerHandicap]) {
        return ^NSString *(WBPlayer *player) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerAveragePoints]) {
        return ^NSString *(WBPlayer *player) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerWinLossRatio]) {
        return ^NSString *(WBPlayer *player) {
            return [NSString stringWithFormat:kDetailStringRecord, [player recordStringForYear:year]];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerTotalImproved]) {
        return ^NSString *(WBPlayer *player) {
            return [NSString stringWithFormat:kDetailStringImprove, (long)[player startingHandicapInYear:year], (long)[player thisYearHandicap]];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerAverageOpponentScore]) {
        return ^NSString *(WBPlayer *player) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerAverageOpponentNetScore]) {
        return ^NSString *(WBPlayer *player) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerAverageScore]) {
        return ^NSString *(WBPlayer *player) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerAverageNet]) {
        return ^NSString *(WBPlayer *player) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerMaxPoints]) {
        return ^NSString *(WBPlayer *player) {
            NSInteger index = [player seasonIndexForMostPointsInMatchForYear:year];
            return [NSString stringWithFormat:kDetailStringSingle, (long)index, [WBWeek findWeekWithSeasonIndex:index year:year].course.name];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerTotalPoints]) {
        return ^NSString *(WBPlayer *player) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerTotalWins]) {
        return ^NSString *(WBPlayer *player) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerAverageMarginVictory]) {
        return ^NSString *(WBPlayer *player) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerAverageMarginNetVictory]) {
        return ^NSString *(WBPlayer *player) {
            return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
        };
    } else if ([key isEqualToString:kLeaderboardPlayerTotalRounds]) {
        return ^NSString *(WBPlayer *player) {
            return @"";
        };
    }
    
    return ^NSString *(WBPlayer *player) {
        return @"";
    };
}

- (void)calculateLeaderBoardsForYear:(WBYear *)year moc:(NSManagedObjectContext *)moc {
	// Important team boards
	NSArray *teams = [WBTeam findAllForYear:year inContext:moc];
	
	[self calculateTeamBoardWithName:@"Team Ranking" key:kLeaderboardTeamTotalPoints priority:1 teams:teams year:year ascending:NO moc:moc valueCalculation:^(WBTeam *team) {
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
		return [NSString stringWithFormat:kDetailStringRecord, [team recordStringForYear:year]];
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
		return [NSString stringWithFormat:kDetailStringRecord, [team individualRecordStringForYear:year]];
	}];

	[self calculateTeamBoardWithName:@"Total Match Wins" key:kLeaderboardTeamTotalWins priority:10 teams:teams year:year ascending:NO moc:moc valueCalculation:^(WBTeam *team) {
		return  (CGFloat)[[team individualRecordForYear:year][0] floatValue];
	} detailValueCalc:^(WBTeam *team) {
		return [NSString stringWithFormat:kDetailStringWeeks, (long)[team filterMatchupsForYear:year].count];
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

	[WBLeaderBoard leaderBoardWithName:@"% Weeks Top Score" boardId:-1 key:kLeaderboardTeamTopPercentage tablePriority:14 isPlayerBoard:NO moc:moc];
	[WBLeaderBoard leaderBoardWithName:@"% Weeks Top Five Score" boardId:-1 key:kLeaderboardTeamTopFivePercentage tablePriority:15 isPlayerBoard:NO moc:moc];
	[WBLeaderBoard leaderBoardWithName:@"Triple Crown" boardId:-1 key:kLeaderboardTeamTripleCrown tablePriority:16 isPlayerBoard:NO moc:moc];
	[WBLeaderBoard leaderBoardWithName:@"Playoffs" boardId:-1 key:kLeaderboardTeamPlayoffs tablePriority:17 isPlayerBoard:NO moc:moc];
	
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
		return (CGFloat)[player thisYearHandicap];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
	}];

	[self calculatePlayerBoardWithName:@"Average Points" key:kLeaderboardPlayerAveragePoints priority:4 players:players year:year ascending:NO moc:moc valueCalculation:^(WBPlayer *player) {
		return [player averagePointsInYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
	}];

	[self calculatePlayerBoardWithName:@"Win/Loss Ratio" key:kLeaderboardPlayerWinLossRatio priority:5 players:players year:year ascending:NO moc:moc valueCalculation:^(WBPlayer *player) {
		return [player recordRatioForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringRecord, [player recordStringForYear:year]];
	}];

	[self calculatePlayerBoardWithName:@"Season Improvement" key:kLeaderboardPlayerTotalImproved priority:6 players:players year:year ascending:YES moc:moc valueCalculation:^(WBPlayer *player) {
		return (CGFloat)[player improvedInYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringImprove, (long)[player startingHandicapInYear:year], (long)[player thisYearHandicap]];
	}];

	[self calculatePlayerBoardWithName:@"Avg. Opp. Score" key:kLeaderboardPlayerAverageOpponentScore priority:7 players:players year:year ascending:YES moc:moc valueCalculation:^(WBPlayer *player) {
		return [player averageOpponentScoreForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
	}];
	
	[self calculatePlayerBoardWithName:@"Avg. Opp. Net Score" key:kLeaderboardPlayerAverageOpponentNetScore priority:8 players:players year:year ascending:YES moc:moc valueCalculation:^(WBPlayer *player) {
		return [player averageOpponentNetScoreForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
	}];
	
	// Extra Player boards
	[self calculatePlayerBoardWithName:@"Average Score" key:kLeaderboardPlayerAverageScore priority:9 players:players year:year ascending:YES moc:moc valueCalculation:^(WBPlayer *player) {
		return [player averageScoreForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
	}];
	
	[self calculatePlayerBoardWithName:@"Avg. Net Score" key:kLeaderboardPlayerAverageNet priority:10 players:players year:year ascending:YES moc:moc valueCalculation:^(WBPlayer *player) {
		return [player averageNetScoreForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
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
		return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
	}];
	
	[self calculatePlayerBoardWithName:@"Total Wins" key:kLeaderboardPlayerTotalWins priority:13 players:players year:year ascending:NO moc:moc valueCalculation:^(WBPlayer *player) {
		return (CGFloat)[[player recordForYear:year][0] floatValue];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
	}];
	
	[self calculatePlayerBoardWithName:@"Avg Margin of Victory" key:kLeaderboardPlayerAverageMarginVictory priority:14 players:players year:year ascending:NO moc:moc valueCalculation:^(WBPlayer *player) {
		return [player averageMarginOfVictoryForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
	}];
	
	[self calculatePlayerBoardWithName:@"Avg Margin of Net Victory" key:kLeaderboardPlayerAverageMarginNetVictory priority:15 players:players year:year ascending:NO moc:moc valueCalculation:^(WBPlayer *player) {
		return [player averageMarginOfNetVictoryForYear:year];
	} detailValueCalc:^(WBPlayer *player) {
		return [NSString stringWithFormat:kDetailStringMatches, (long)[player filterResultsForYear:year goodData:YES].count];
	}];
	
	[self calculatePlayerBoardWithName:@"Total Rounds" key:kLeaderboardPlayerTotalRounds priority:16 players:players year:year ascending:NO moc:moc valueCalculation:^(WBPlayer *player) {
		return (CGFloat)([[player recordForYear:year][0] floatValue] + [[player recordForYear:year][1] floatValue] + [[player recordForYear:year][2] floatValue]);
	} detailValueCalc:^(WBPlayer *player) {
		return @"";
	}];

	[WBLeaderBoard leaderBoardWithName:@"% Weeks Top Score" boardId:-1 key:kLeaderboardPlayerTopPercentage tablePriority:17 isPlayerBoard:YES moc:moc];
	[WBLeaderBoard leaderBoardWithName:@"% Weeks Top Ten Score" boardId:-1 key:kLeaderboardPlayerTopTenPercentage tablePriority:18 isPlayerBoard:YES moc:moc];
	[WBLeaderBoard leaderBoardWithName:@"Triple Crown" boardId:-1 key:kLeaderboardPlayerTripleCrown tablePriority:19 isPlayerBoard:YES moc:moc];
	[WBLeaderBoard leaderBoardWithName:@"Triple Crown 2" boardId:-1 key:kLeaderboardPlayerTripleCrown2 tablePriority:20 isPlayerBoard:YES moc:moc];
	
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
	WBLeaderBoard *board = [WBLeaderBoard leaderBoardWithName:name boardId:-1 key:key tablePriority:priority isPlayerBoard:NO moc:moc];
	CGFloat totalLeagueValue = 0, value = 0, teamCount = 0;
	NSString *detailValue = nil;
	NSArray *results = nil;
	for (WBTeam *team in teams) {
		results = [team filterResultsForYear:year goodData:YES];
		if (results && results.count > 0) {
			value = valueCalculation(team);
			detailValue = detailValueCalc(team);
			[WBBoardData createBoardDataForEntity:team leaderBoard:board dataId:-1 value:value detailValue:detailValue rank:0 year:year moc:moc];
			totalLeagueValue += value;
			teamCount++;
		}
	}
	
	// Create league average for board
	if (teamCount > 0) {
		[WBBoardData createBoardDataForEntity:[WBPeopleEntity leagueAverageInContext:moc] leaderBoard:board dataId:-1 value:(totalLeagueValue / teamCount) detailValue:nil rank:0 year:year moc:moc];
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
	WBLeaderBoard *board = [WBLeaderBoard leaderBoardWithName:name boardId:-1 key:key tablePriority:priority isPlayerBoard:YES moc:moc];
	CGFloat totalLeagueValue = 0, value = 0, playerCount = 0;
	NSString *detailValue = nil;
	NSArray *results = nil;
	for (WBPlayer *player in players) {
		results = [player filterResultsForYear:year goodData:YES];
		if (results && results.count > 0) {
			value = valueCalculation(player);
			detailValue = detailValueCalc(player);
			[WBBoardData createBoardDataForEntity:player leaderBoard:board dataId:-1 value:value detailValue:detailValue rank:0 year:year moc:moc];
			if (!player.realValue) {
				totalLeagueValue += value;
				playerCount++;
			}
		}
	}
	
	// Create league average for board
	if (playerCount > 0) {
		[WBBoardData createBoardDataForEntity:[WBPeopleEntity leagueAverageInContext:moc] leaderBoard:board dataId:-1 value:(totalLeagueValue / playerCount) detailValue:nil rank:0 year:year moc:moc];
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
