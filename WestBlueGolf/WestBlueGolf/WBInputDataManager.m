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

#define wbJsonKeyMatches @"matchups"
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
	NSInteger weekId, weekIndex = 0;
	BOOL badData = NO;
	NSDate *date = nil;
	for (NSDictionary *elt in weekArray) {
		weekId = [[elt objectForKey:wbJsonKeyWeekId] integerValue];
		weekIndex = [[elt objectForKey:wbJsonKeyWeekIndex] integerValue];
		badData = [[elt objectForKey:wbJsonKeyWeekBadData] boolValue];
		weekDate = [elt objectForKey:wbJsonKeyWeekDate];
		date = [self dateForString:weekDate];
		courseId = [[elt objectForKey:wbJsonKeyWeekCourseId] integerValue];
		course = [WBCourse courseWithId:courseId];
		[WBWeek createWeekWithDate:date inYear:year weekId:weekId forCourse:course seasonIndex:weekIndex badData:badData inContext:moc];
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
	for (NSDictionary *elt in playerArray) {
		playerId = [[elt objectForKey:wbJsonKeyPlayerId] integerValue];
		playerName = [elt objectForKey:wbJsonKeyPlayerName];
		currentHandicap = [[elt objectForKey:wbJsonKeyPlayerCurrentHandicap] integerValue];
        real = [[elt objectForKey:wbJsonKeyPlayerValid] boolValue];
		player = [WBPlayer playerWithId:playerId name:playerName currentHandicap:currentHandicap real:real inContext:moc];
		
		// Player Year data parse
        data = [elt objectForKey:wbJsonKeyPlayerData];
		dataId = [[data objectForKey:wbJsonKeyPlayerDataId] integerValue];
		startingHandicap = [[data objectForKey:wbJsonKeyPlayerDataStartingHandicap] integerValue];
		finishingHandicap = [[data objectForKey:wbJsonKeyPlayerDataFinishingHandicap] integerValue];
		isRookie = [[data objectForKey:wbJsonKeyPlayerDataIsRookie] boolValue];
		teamId = [[data objectForKey:wbJsonKeyPlayerDataTeam] integerValue];
		playerTeam = [WBTeam teamWithId:teamId inContext:moc];
		[WBPlayerYearData createPlayerYearDataWithId:dataId forPlayer:player year:year onTeam:playerTeam withStartingHandicap:startingHandicap withFinishingHandicap:startingHandicap isRookie:isRookie moc:moc];
	}
	
	// Create a player to catch all the no shows (ends up being conditional too)
	//[WBPlayer createNoShowPlayerInContext:moc];
	
	//[WBCoreDataManager saveContext:moc];
	
	// Team Matchups
    NSArray *teamMatchupArray = [json objectForKey:wbJsonKeyTeamMatchups];
	
    WBTeamMatchup *matchup = nil;
    WBTeam *team1 = nil, *team2 = nil;
    WBPlayer *player1 = nil, *player2 = nil;
    WBWeek *week = nil;
    WBMatch *match = nil;
    NSInteger team1Id = -1, team2Id = -1, matchupId = 0, player1Id = 0, player2Id = 0, score = 0, priorHandicap = 0, points = 0;
    NSArray *matchesJson = nil, *resultsJson = nil;
    NSDictionary *matchJson = nil, *result1Json = nil, *result2Json = nil;
    BOOL matchComplete = NO, firstResult = YES;
    for (NSDictionary *elt in teamMatchupArray) {
        weekId = [[elt objectForKey:wbJsonKeyTeamMatchupWeekId] integerValue];
		matchupId = [[elt objectForKey:wbJsonKeyTeamMatchupId] integerValue];
		matchComplete = [[elt objectForKey:wbJsonKeyTeamMatchupComplete] boolValue];
		if (!matchComplete) {
			DLog(@"Incomplete Match in received data");
			//continue;
		}
        
        matchesJson = [elt objectForKey:wbJsonKeyMatches];
        if (!matchesJson || matchesJson.count == 0) {
            continue;
        }

        matchJson = matchesJson.count > 0 ? matchesJson[0] : nil;
        resultsJson = [matchJson objectForKey:wbJsonKeyResults];
        result1Json = resultsJson.count == 2 ? resultsJson[0] : nil;
        result2Json = resultsJson.count == 2 ? resultsJson[1] : nil;
		team1Id = [[result1Json objectForKey:wbJsonKeyResultTeamId] integerValue];
        team2Id = [[result2Json objectForKey:wbJsonKeyResultTeamId] integerValue];
        
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
        
        matchup = [WBTeamMatchup createTeamMatchupBetweenTeam:team1 andTeam:team2 forWeek:week matchupId:matchupId matchComplete:matchComplete moc:moc];
        
        // Matches
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
            firstResult = YES;
            for (result1Json in resultsJson) {
                score = [[result1Json objectForKey:wbJsonKeyResultScore] integerValue];
                priorHandicap = [[result1Json objectForKey:wbJsonKeyResultPriorHandicap] integerValue];
                points = [[result1Json objectForKey:wbJsonKeyResultPoints] integerValue];
                player1Id = [[result1Json objectForKey:wbJsonKeyResultPlayerId] integerValue];
                team1Id = [[result1Json objectForKey:wbJsonKeyResultTeamId] integerValue];
                
                [WBResult createResultForMatch:match forPlayer:firstResult ? player1 : player2 team:firstResult ? team1 : team2 withPoints:points priorHandicap:priorHandicap score:score moc:moc];
                
                firstResult = NO;
            }
        }
    }
	
	WBWeek *firstPlayoffWeek = [WBWeek firstPlayoffWeekInYear:year];
	NSArray *firstWeekMatchups = [firstPlayoffWeek.teamMatchups sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"matchId" ascending:YES]]];
	WBTeamMatchup *oneFourMatch = firstWeekMatchups[0];
	oneFourMatch.playoffTypeValue = WBPlayoffTypeChampionship;
	WBTeamMatchup *twoThreeMatch = firstWeekMatchups[1];
	twoThreeMatch.playoffTypeValue = WBPlayoffTypeChampionship;
	WBTeamMatchup *fiveEightMatch = firstWeekMatchups[2];
	fiveEightMatch.playoffTypeValue = WBPlayoffTypeConsolation;
	WBTeamMatchup *sixSevenMatch = firstWeekMatchups[3];
	sixSevenMatch.playoffTypeValue = WBPlayoffTypeConsolation;
	WBTeamMatchup *nineTenMatch = firstWeekMatchups[4];
	nineTenMatch.playoffTypeValue = WBPlayoffTypeLexis;
	
	WBWeek *finalPlayoffWeek = [WBWeek finalPlayoffWeekInYear:year];
	NSArray *finalWeekMatchups = [finalPlayoffWeek.teamMatchups sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"matchId" ascending:YES]]];
	WBTeamMatchup *oneTwoMatch = finalWeekMatchups[0];
	oneTwoMatch.playoffTypeValue = WBPlayoffTypeChampionship;
	WBTeamMatchup *threeFourMatch = finalWeekMatchups[1];
	threeFourMatch.playoffTypeValue = WBPlayoffTypeBronze;
	WBTeamMatchup *fiveSixMatch = finalWeekMatchups[2];
	fiveSixMatch.playoffTypeValue = WBPlayoffTypeConsolation;
	WBTeamMatchup *sevenEightMatch = finalWeekMatchups[3];
	sevenEightMatch.playoffTypeValue = WBPlayoffTypeLexis;
	WBTeamMatchup *lastMatch = finalWeekMatchups[4];
	lastMatch.playoffTypeValue = WBPlayoffTypeLexis;

	//[WBCoreDataManager saveContext:moc];
	
	// Determine if there are any weeks with no matches and mark them bad data (in addition to those marked bad from having teams playing themselves)
	NSArray *matches = nil;
	for (WBWeek *week in year.weeks) {
		matches = [WBMatch findWithPredicate:[NSPredicate predicateWithFormat:@"teamMatchup.week = %@", week] sortedBy:nil fetchLimit:0 moc:moc];
		if (!matches || matches.count == 0) {
			if (!week.isBadDataValue) {
				DLog(@"Bad data week not noticed by server");
			}
			
			DLog(@"week has no matches");
			week.isBadDataValue = YES;
		}
	}
	
	//[WBCoreDataManager saveContext:moc];
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
}

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
