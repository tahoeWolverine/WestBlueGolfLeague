//
//  WBHandicapManager.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/10/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBHandicapManager.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"

@implementation WBHandicapManager

- (void)calculateHandicapsForYear:(WBYear *)year {
	NSArray *players = [WBPlayer findAll];

	for (WBPlayer *player in players) {
		[self calculateHandicapsForPlayer:player year:year isNewestYear:year == [WBYear newestYear]];
	}
}

- (void)calculateHandicapsForPlayer:(WBPlayer *)player year:(WBYear *)year isNewestYear:(BOOL)isNewestYear {
	NSMutableArray *scores = [NSMutableArray array];
	NSInteger scoreIndex = 4;
	
	// Add starting handicap 4 times to backfill based on ~2013 rules
	WBPlayerYearData *data = [player yearDataForYear:year];
	if (!data) {
		DLog(@"Handicap not calculated for %@ in year %@", player.name, year.value);
		return;
	}
	
	for (NSInteger i = 0; i < 5; i++) {
		[scores addObject:data.startingHandicap];
	}
	
	// Add scores for the season, calculating handicap result by result
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"match.teamMatchup.week.seasonIndex" ascending:YES]];
	NSArray *playerResults = [WBResult findWithPredicate:[NSPredicate predicateWithFormat:@"player = %@ && match.teamMatchup.week.year = %@", player, year] sortedBy:sorts];
	for (WBResult *result in playerResults) {
		result.priorHandicapValue = [self priorHandicapWithScores:scores scoresIndex:scoreIndex];
		
		// Add the score for the week to be factored into the next weeks handicap
		[scores addObject:[NSNumber numberWithInteger:result.scoreValue - result.match.teamMatchup.week.course.parValue]];

		scoreIndex++;
	}
	
	if (isNewestYear) {
		player.currentHandicapValue = [self priorHandicapWithScores:scores scoresIndex:scoreIndex];
	}

	if (year.isCompleteValue) {
		data.finishingHandicapValue = [self priorHandicapWithScores:scores scoresIndex:scoreIndex];
	}
}

- (NSInteger)priorHandicapWithScores:(NSArray *)scores scoresIndex:(NSInteger)scoreIndex {
	NSArray *usedScores = @[scores[scoreIndex], scores[scoreIndex - 1], scores[scoreIndex - 2], scores[scoreIndex - 3], scores[scoreIndex - 4]];
	NSInteger maxValue = -10;
	NSInteger handicapTotal = 0;
	for (NSNumber *num in usedScores) {
		if (num.integerValue > maxValue) {
			maxValue = num.integerValue;
		}
		handicapTotal += num.integerValue;
	}

	// Subtract the highest score diff as per handicap calculation rule
	handicapTotal -= maxValue;
	
	return (NSInteger)((CGFloat)handicapTotal / 4.0f + 0.5f);
}

@end
