//
//  WBInputDataManager.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/10/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBInputDataManager.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
#import "WBSettings.h"

#define wbJsonKeyYears @"availableYears"

#define wbJsonKeyYearId @"id"
#define wbJsonKeyYearValue @"value"
#define wbJsonKeyYearComplete @"isComplete"

#define wbJsonKeyCourses @"courses"
#define wbJsonKeyCourseId @"id"
#define wbJsonKeyCourseName @"name"
#define wbJsonKeyCoursePar @"par"

#define wbJsonKeyWeeks @"weeks"
#define wbJsonKeyWeekId @"id"
#define wbJsonKeyWeekDate @"date"
#define wbJsonKeyWeekIndex @"seasonIndex"
#define wbJsonKeyWeekBadData @"badData"
#define wbJsonKeyWeekCourseId @"courseId"
#define wbJsonKeyWeekPairingId @"pairingId"
#define wbJsonKeyWeekIsPlayoff @"isPlayoff"

#define wbJsonKeyTeams @"teamsForYear"
#define wbJsonKeyTeamId @"id"
#define wbJsonKeyTeamName @"name"
#define wbJsonKeyTeamValid @"valid"

#define wbJsonKeyPlayers @"playersForYear"
#define wbJsonKeyPlayerName @"name"
#define wbJsonKeyPlayerId @"id"
#define wbJsonKeyPlayerValid @"vp"
//#define wbJsonKeyPlayerCurrentTeam @"tId"
#define wbJsonKeyPlayerCurrentHandicap @"ch"

#define wbJsonKeyPlayerData @"yd"
#define wbJsonKeyPlayerDataId @"id"
#define wbJsonKeyPlayerDataStartingHandicap @"sh"
#define wbJsonKeyPlayerDataFinishingHandicap @"fh"
#define wbJsonKeyPlayerDataIsRookie @"isr"
#define wbJsonKeyPlayerDataTeam @"tId"

#define wbJsonKeyTeamMatchups @"teamMatchups"
#define wbJsonKeyTeamMatchupId @"id"
#define wbJsonKeyTeamMatchupOriginalId @"mId" // unused
#define wbJsonKeyTeamMatchupWeekId @"wId"
#define wbJsonKeyTeamMatchupComplete @"mc"
#define wbJsonKeyTeamMatchupTeams @"teamIds"
#define wbJsonKeyTeamMatchupPlayoffType @"playoffType"
#define wbJsonKeyTeamMatchupOrder @"matchOrder"

#define wbJsonValueTeamMatchupPlayoffTypeNone @""
#define wbJsonValueTeamMatchupPlayoffTypeChampionship @"championship"
#define wbJsonValueTeamMatchupPlayoffTypeThirdPlace @"thirdplace"
#define wbJsonValueTeamMatchupPlayoffTypeConsolation @"consolation"
#define wbJsonValueTeamMatchupPlayoffTypeLexisNexis @"lexisnexis"

#define wbJsonKeyMatches @"matches"
#define wbJsonKeyMatchId @"id"

#define wbJsonKeyResults @"results"
#define wbJsonKeyResultId @"id"
#define wbJsonKeyResultPlayerId @"pId"
#define wbJsonKeyResultTeamId @"tId"
#define wbJsonKeyResultPriorHandicap @"ph"
#define wbJsonKeyResultScore @"s"
#define wbJsonKeyResultPoints @"p"

@implementation WBInputDataManager

- (void)createYearsWithJson:(NSDictionary *)json {
    // Years
    NSArray *yearArray = [json objectForKey:wbJsonKeyYears];
    
	NSInteger yearId, yearValue = 0;
	BOOL isComplete = NO;
	for (NSDictionary *elt in yearArray) {
		yearId = [[elt objectForKey:wbJsonKeyYearId] integerValue];
		yearValue = [[elt objectForKey:wbJsonKeyYearValue] integerValue];
		isComplete = [[elt objectForKey:wbJsonKeyYearComplete] boolValue];
		[WBYear yearWithYearId:yearId value:yearValue isComplete:isComplete inContext:[WBCoreDataManager mainContext]];
	}
	
	[WBCoreDataManager saveMainContext];
}

- (void)createObjectsForYear:(NSInteger)yearValue withJson:(NSDictionary *)json {
	NSManagedObjectContext *moc = [WBCoreDataManager mainContext];
	WBYear *year = [WBYear findYearWithValue:yearValue inContext:moc];
	
	// Courses
	NSArray *courseArray = [json objectForKey:wbJsonKeyCourses];
	NSString *courseName = nil;
	NSInteger courseId = 0, par = 0;
	for (NSDictionary *elt in courseArray) {
		courseId = [[elt objectForKey:wbJsonKeyCourseId] integerValue];
		courseName = [elt objectForKey:wbJsonKeyCourseName];
		par = [[elt objectForKey:wbJsonKeyCoursePar] integerValue];
		[WBCourse courseWithName:courseName courseId:courseId par:par inContext:moc];
	}

	// Weeks
	NSArray *weekArray = [json objectForKey:wbJsonKeyWeeks];
	WBCourse *course = nil;
	NSString *weekDate = nil;
	NSInteger weekId = 0, weekIndex = 0, /*pairing = 0,*/ pairingId;
	BOOL badData = NO, isPlayoff = NO;
	NSDate *date = nil;
	for (NSDictionary *elt in weekArray) {
		weekId = [[elt objectForKey:wbJsonKeyWeekId] integerValue];
		weekIndex = [[elt objectForKey:wbJsonKeyWeekIndex] integerValue];
		badData = [[elt objectForKey:wbJsonKeyWeekBadData] boolValue];
		weekDate = [elt objectForKey:wbJsonKeyWeekDate];
		date = [self dateForString:weekDate];
		courseId = [[elt objectForKey:wbJsonKeyWeekCourseId] integerValue];
		course = [WBCourse courseWithId:courseId];
		pairingId = [[elt objectForKey:wbJsonKeyWeekPairingId] integerValue];
		isPlayoff = [[elt objectForKey:wbJsonKeyWeekIsPlayoff] boolValue];

        /*pairing = weekIndex % 3 + 1;
         Hard-coded pairing logic
         if (pairing == 1) {
            pairing = 4;
        }
        
        if (weekIndex > 9) {
            pairing--;
            if (pairing == 1) {
                pairing = 4;
            }
        }
        
        if (weekIndex > 16) {
            pairing--;
            if (pairing == 1) {
                pairing = 4;
            }
        }*/
        
		[WBWeek createWeekWithDate:date inYear:year weekId:weekId forCourse:course seasonIndex:weekIndex pairing:pairingId + 1 isPlayoff:isPlayoff badData:badData inContext:moc];
	}
	
	[WBCoreDataManager saveContext:moc];
	
	// Teams
	NSArray *teamArray = [json objectForKey:wbJsonKeyTeams];
	NSString *teamName = nil;
	NSInteger teamId = 0;
    BOOL real = NO;
	for (NSDictionary *elt in teamArray) {
		teamName = [elt objectForKey:wbJsonKeyTeamName];
		teamId = [[elt objectForKey:wbJsonKeyTeamId] integerValue];
        real = [[elt objectForKey:wbJsonKeyTeamValid] boolValue];
		[WBTeam teamWithName:teamName teamId:teamId real:real inContext:moc];
	}
	
	//[WBCoreDataManager saveContext:moc];
	
	// Players
	NSArray *playerArray = [json objectForKey:wbJsonKeyPlayers];
	WBTeam *playerTeam = nil;
	WBPlayer *player = nil;
	NSString *playerName = nil;
	NSInteger playerId = 0, dataId = 0, startingHandicap = 0, finishingHandicap = 0, currentHandicap = 0;
    NSDictionary *data = nil;
	teamId = 0;
	BOOL isRookie = NO;
    NSInteger mePlayerId = [[WBSettings sharedSettings].mePlayerId integerValue];
    NSArray *favoritePlayerIds = [[WBSettings sharedSettings] favoritePlayerIds];
	for (NSDictionary *elt in playerArray) {
		playerId = [[elt objectForKey:wbJsonKeyPlayerId] integerValue];
		playerName = [elt objectForKey:wbJsonKeyPlayerName];
		currentHandicap = [[elt objectForKey:wbJsonKeyPlayerCurrentHandicap] integerValue];
        real = [[elt objectForKey:wbJsonKeyPlayerValid] boolValue];
		player = [WBPlayer playerWithId:playerId name:playerName currentHandicap:currentHandicap real:real inContext:moc];
        
        if (playerId == mePlayerId) {
            player.meValue = YES;
        }
        
        if ([favoritePlayerIds containsObject:player.id]) {
            player.favoriteValue = YES;
        }
		
		// Player Year data parse
        data = [elt objectForKey:wbJsonKeyPlayerData];
		dataId = [[data objectForKey:wbJsonKeyPlayerDataId] integerValue];
		startingHandicap = [[data objectForKey:wbJsonKeyPlayerDataStartingHandicap] integerValue];
		finishingHandicap = [[data objectForKey:wbJsonKeyPlayerDataFinishingHandicap] integerValue];
		isRookie = [[data objectForKey:wbJsonKeyPlayerDataIsRookie] boolValue];
		teamId = [[data objectForKey:wbJsonKeyPlayerDataTeam] integerValue];
		playerTeam = [WBTeam teamWithId:teamId inContext:moc];
		[WBPlayerYearData createPlayerYearDataWithId:dataId forPlayer:player year:year onTeam:playerTeam withStartingHandicap:startingHandicap withFinishingHandicap:finishingHandicap isRookie:isRookie moc:moc];
	}
	
	//[WBCoreDataManager saveContext:moc];
	
	// Team Matchups
    NSArray *teamMatchupArray = [json objectForKey:wbJsonKeyTeamMatchups];
	
    WBTeamMatchup *matchup = nil;
    WBTeam *team1 = nil, *team2 = nil, *team = nil;
    WBPlayer *player1 = nil, *player2 = nil;
    WBWeek *week = nil;
    WBMatch *match = nil;
    WBPlayoffType playoffType = WBPlayoffTypeNone;
    NSInteger team1Id = -1, team2Id = -1, matchupId = 0, player1Id = 0, player2Id = 0, score = 0, priorHandicap = 0, points = 0, matchupOrder = 0;
    NSArray *matchesJson = nil, *resultsJson = nil, *teamsJson = nil;
    NSDictionary *matchJson = nil, *result1Json = nil, *result2Json = nil;
    NSString *playoffTypeStr = @"";
    BOOL matchComplete = NO;
    for (NSDictionary *elt in teamMatchupArray) {
        weekId = [[elt objectForKey:wbJsonKeyTeamMatchupWeekId] integerValue];
		matchupId = [[elt objectForKey:wbJsonKeyTeamMatchupId] integerValue];
		matchComplete = [[elt objectForKey:wbJsonKeyTeamMatchupComplete] boolValue];
		playoffTypeStr = [elt objectForKey:wbJsonKeyTeamMatchupPlayoffType];
        matchupOrder = [[elt objectForKey:wbJsonKeyTeamMatchupOrder] integerValue];
        playoffType = [self playoffTypeForString:playoffTypeStr];
        
		if (!matchComplete) {
			DLog(@"Incomplete Match in received data");
			//continue;
		}
        
        if (weekId == 326) {
            DLog(@"hi");
        }
        
        teamsJson = [elt objectForKey:wbJsonKeyTeamMatchupTeams];
        
        if (!teamsJson || teamsJson.count < 2) {
            DLog(@"Not enough teams in matchup");
            continue;
        }
        
        team1Id = [[teamsJson objectAtIndex:0] integerValue];
        team2Id = [[teamsJson objectAtIndex:1] integerValue];
        
        team1 = [WBTeam teamWithId:team1Id inContext:moc];
        team2 = [WBTeam teamWithId:team2Id inContext:moc];
        week = [WBWeek findWeekWithId:weekId inYear:year];

        if (!team1 || !team2) {
            DLog(@"Bad Teams");
            continue;
        }
        
        if (team1Id == team2Id) {
            DLog(@"Match has same team on both sides");

            if (!week.isBadDataValue) {
                DLog(@"Bad data week not noticed by server");
                week.isBadDataValue = YES;
            }
        }
        
        matchup = [WBTeamMatchup createTeamMatchupBetweenTeam:team1 andTeam:team2 forWeek:week matchupId:matchupId matchupOrder:matchupOrder matchComplete:matchComplete playoffType:playoffType moc:moc];
        
        // Matches
        matchesJson = [elt objectForKey:wbJsonKeyMatches];
        if (!matchesJson || matchesJson.count == 0) {
            continue;
        }
        

        //DLog(@"mathupid: %ld, team1: %@, team2: %@", (unsigned long)matchupId, team1.name, team2.name);
        for (matchJson in matchesJson) {
            resultsJson = [matchJson objectForKey:wbJsonKeyResults];
            result1Json = resultsJson.count == 2 ? resultsJson[0] : nil;
            result2Json = resultsJson.count == 2 ? resultsJson[1] : nil;
            
            player1Id = [[result1Json objectForKey:wbJsonKeyResultPlayerId] integerValue];
            player2Id = [[result2Json objectForKey:wbJsonKeyResultPlayerId] integerValue];
            
            player1 = (WBPlayer *)[WBPlayer findWithId:player1Id];
            player2 = (WBPlayer *)[WBPlayer findWithId:player2Id];
            if (!player1 || !player2) {
                DLog(@"Bad Player Results");
                continue;
            }
            
            match = [WBMatch createMatchForTeamMatchup:matchup player1:player1 player2:player2 moc:moc];
            
            // Results
            for (result1Json in resultsJson) {
                if (matchComplete) {
                    score = [[result1Json objectForKey:wbJsonKeyResultScore] integerValue];
                    points = [[result1Json objectForKey:wbJsonKeyResultPoints] integerValue];
                }
                priorHandicap = [[result1Json objectForKey:wbJsonKeyResultPriorHandicap] integerValue];
                playerId = [[result1Json objectForKey:wbJsonKeyResultPlayerId] integerValue];
                player = playerId == player1Id ? player1 : player2;
                teamId = [[result1Json objectForKey:wbJsonKeyResultTeamId] integerValue];
                team = teamId == team1Id ? team1 : team2;
                
                [WBResult createResultForMatch:match forPlayer:player team:team withPoints:points priorHandicap:priorHandicap score:score moc:moc];
            }
        }
    }
	
	//[self assignPlayoffSpotsForYear:year];

	//[WBCoreDataManager saveContext:moc];
	
	// Determine if there are any weeks with no matches and mark them bad data (in addition to those marked bad from having teams playing themselves)
	NSArray *matches = nil;
	for (WBWeek *week in year.weeks) {
		matches = [WBMatch findWithPredicate:[NSPredicate predicateWithFormat:@"teamMatchup.week = %@", week] sortedBy:nil fetchLimit:0 moc:moc];
		if ([week alreadyTookPlace] && (!matches || matches.count == 0)) {
			if (!week.isBadDataValue) {
				DLog(@"Bad data week not noticed by server");
			}
			
			DLog(@"week has no matches");
			week.isBadDataValue = YES;
		}
	}
	
	//[WBCoreDataManager saveContext:moc];
}

- (WBPlayoffType)playoffTypeForString:(NSString *)playoffTypeStr {
    if (!playoffTypeStr || ![playoffTypeStr isKindOfClass:[NSString class]]) {
        return WBPlayoffTypeNone;
    }
    
    if ([playoffTypeStr isEqualToString:wbJsonValueTeamMatchupPlayoffTypeChampionship]) {
        return WBPlayoffTypeChampionship;
    } else if ([playoffTypeStr isEqualToString:wbJsonValueTeamMatchupPlayoffTypeThirdPlace]) {
        return WBPlayoffTypeBronze;
    } else if ([playoffTypeStr isEqualToString:wbJsonValueTeamMatchupPlayoffTypeConsolation]) {
        return WBPlayoffTypeConsolation;
    } else if ([playoffTypeStr isEqualToString:wbJsonValueTeamMatchupPlayoffTypeLexisNexis]) {
        return WBPlayoffTypeLexis;
    } else {
        return WBPlayoffTypeNone;
    }
}

- (void)clearRefreshableDataForYearValue:(NSInteger)yearValue {
	WBYear *year = [WBYear findYearWithValue:yearValue inContext:[WBCoreDataManager mainContext]];
	
	// This should delete all weeks, teamMatchups, matches, and results
	for (WBWeek *week in year.weeks) {
		[week deleteEntityInContext:week.managedObjectContext];
	}
	
	for (WBPlayerYearData *data in year.playerYearData) {
		[data deleteEntityInContext:data.managedObjectContext];
	}
	
	for (WBBoardData *boardData in year.boardData) {
		[boardData deleteEntityInContext:boardData.managedObjectContext];
	}
    
    [WBCoreDataManager saveMainContext];
}

/* Old code for playoff prediction
 
 - (void)createPlayoffSpeculationsForYear:(WBYear *)year {
    WBTeamMatchup *matchup = nil;
    WBBoardData *team1Data = nil, *team2Data = nil;
    NSInteger matchupId = rand();
    BOOL matchComplete = NO;
    NSManagedObjectContext *moc = [WBCoreDataManager mainContext];
    NSInteger team1Index = 0, team2Index = 0;
    
    WBWeek *firstPlayoffWeek = [WBWeek firstPlayoffWeekInYear:year];
	NSArray *firstWeekMatchups = [firstPlayoffWeek.teamMatchups sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"matchId" ascending:YES]]];
    if (!firstWeekMatchups || firstWeekMatchups.count < 5) {
        // We need to build out 5 matchups for the expected teams
        NSArray *teamData = [WBBoardData findAllWithBoardKey:kLeaderboardTeamTotalPoints];
        for (NSInteger i = 0; i < 5; ++i) {
            switch (i) {
                case 0:
                    team1Index = 0;
                    team2Index = 3;
                    break;
                case 1:
                    team1Index = 1;
                    team2Index = 2;
                    break;
                case 2:
                    team1Index = 4;
                    team2Index = 7;
                    break;
                case 3:
                    team1Index = 5;
                    team2Index = 6;
                    break;
                case 4:
                    team1Index = 8;
                    team2Index = 9;
                    break;
                default:
                    ALog(@"Bad index");
                    break;
            }
            team1Data = teamData[team1Index];
            team2Data = teamData[team2Index];
            matchup = [WBTeamMatchup createTeamMatchupBetweenTeam:(WBTeam *)team1Data.peopleEntity andTeam:(WBTeam *)team2Data.peopleEntity forWeek:firstPlayoffWeek matchupId:matchupId matchComplete:matchComplete moc:moc];
            matchupId++;
        }
    }
    
    WBWeek *finalPlayoffWeek = [WBWeek finalPlayoffWeekInYear:year];
	NSArray *finalWeekMatchups = [finalPlayoffWeek.teamMatchups sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"matchId" ascending:YES]]];
    if (!finalWeekMatchups || finalWeekMatchups.count < 5) {
        // We need to build out 5 matchups for the expected teams
        NSArray *teams = [WBBoardData findAllWithBoardKey:kLeaderboardTeamTotalPoints];
        for (NSInteger i = 0; i < 5; ++i) {switch (i) {
            case 0:
                team1Index = 0;
                team2Index = 1;
                break;
            case 1:
                team1Index = 2;
                team2Index = 3;
                break;
            case 2:
                team1Index = 4;
                team2Index = 5;
                break;
            case 3:
                team1Index = 7;
                team2Index = 8;
                break;
            case 4:
                team1Index = 6;
                team2Index = 9;
                break;
            default:
                ALog(@"Bad index");
                break;
        }
            team1Data = teams[team1Index];
            team2Data = teams[team2Index];
            matchup = [WBTeamMatchup createTeamMatchupBetweenTeam:(WBTeam *)team1Data.peopleEntity andTeam:(WBTeam *)team2Data.peopleEntity forWeek:finalPlayoffWeek matchupId:matchupId matchComplete:matchComplete moc:moc];
            matchupId++;
        }
    }
    
    [self assignPlayoffSpotsForYear:year];
}*/

/* Old code for playoff sectioning
 
 - (void)assignPlayoffSpotsForYear:(WBYear *)year {
    WBWeek *firstPlayoffWeek = [WBWeek firstPlayoffWeekInYear:year];
	NSArray *firstWeekMatchups = [firstPlayoffWeek.teamMatchups sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"matchId" ascending:YES]]];
    if (firstWeekMatchups && firstWeekMatchups.count == 5) {
        WBTeamMatchup *oneFourMatch = firstWeekMatchups[0];
        oneFourMatch.playoffTypeValue = WBPlayoffTypeChampionship;
        WBTeamMatchup *twoThreeMatch = firstWeekMatchups[1];
        twoThreeMatch.playoffTypeValue = WBPlayoffTypeChampionship;
        if (firstWeekMatchups.count > 2) {
            WBTeamMatchup *fiveEightMatch = firstWeekMatchups[2];
            fiveEightMatch.playoffTypeValue = WBPlayoffTypeConsolation;
        }
        if (firstWeekMatchups.count > 3) {
            WBTeamMatchup *sixSevenMatch = firstWeekMatchups[3];
            sixSevenMatch.playoffTypeValue = WBPlayoffTypeConsolation;
        }
        if (firstWeekMatchups.count > 4) {
            WBTeamMatchup *nineTenMatch = firstWeekMatchups[4];
            nineTenMatch.playoffTypeValue = WBPlayoffTypeLexis;
        }
    } else {
        self.buildPlayoffMatchups = YES;
    }
	
	WBWeek *finalPlayoffWeek = [WBWeek finalPlayoffWeekInYear:year];
	NSArray *finalWeekMatchups = [finalPlayoffWeek.teamMatchups sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"matchId" ascending:YES]]];
    if (finalWeekMatchups && finalWeekMatchups.count == 5) {
        WBTeamMatchup *oneTwoMatch = finalWeekMatchups[0];
        oneTwoMatch.playoffTypeValue = WBPlayoffTypeChampionship;
        if (finalWeekMatchups.count > 1) {
            WBTeamMatchup *threeFourMatch = finalWeekMatchups[1];
            threeFourMatch.playoffTypeValue = WBPlayoffTypeBronze;
        }
        if (finalWeekMatchups.count > 2) {
            WBTeamMatchup *fiveSixMatch = finalWeekMatchups[2];
            fiveSixMatch.playoffTypeValue = WBPlayoffTypeConsolation;
        }
        if (finalWeekMatchups.count > 3) {
            WBTeamMatchup *sevenEightMatch = finalWeekMatchups[3];
            sevenEightMatch.playoffTypeValue = WBPlayoffTypeLexis;
        }
        if (finalWeekMatchups.count > 4) {
            WBTeamMatchup *lastMatch = finalWeekMatchups[4];
            lastMatch.playoffTypeValue = WBPlayoffTypeLexis;
        }
    } else {
        self.buildPlayoffMatchups = YES;
    }
}*/

#pragma mark - Helper functions

// Example: "4/23/2013", total grammar of formatters - @"yyyy-MM-dd HH:mm:ss ZZZ"
- (NSDate *)dateForString:(NSString *)dateString {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//[dateFormatter setDateFormat:@"MM/dd/yyyy"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
	return [dateFormatter dateFromString:dateString];
}

- (NSData *)fileDataForFilename:(NSString *)name year:(WBYear *)year {
	NSString *fileName = [NSString stringWithFormat:@"%@%@", name, year.value > 0 ? year.value : @""];
	NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
	return [[NSFileManager defaultManager] contentsAtPath:path];
}

- (NSArray *)jsonFromData:(NSData *)data {
	if (data) {
		NSError *error = nil;
		id object = [NSJSONSerialization JSONObjectWithData:data
													options:0
													  error:&error];
		
		if (error) {
			ALog(@"json was malformed");
		}
		
		if ([object isKindOfClass:[NSArray class]]) {
			return object;
		} else {
			ALog(@"json wasn't an array");
		}
	} else {
		ALog(@"no json data found");
	}
	return nil;
}

@end
