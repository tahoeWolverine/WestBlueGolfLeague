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

- (void)calculateHandicaps {
	NSArray *players = [WBPlayer findAll];

	for (WBPlayer *player in players) {
		[self calculateHandicapsForPlayer:player];
	}
}

- (void)calculateHandicapsForPlayer:(WBPlayer *)player {
	WBYear *year = [WBYear thisYear];
	WBPlayer *p = [WBPlayer playerWithName:@"Scott Hanson"];
	
	if (player == p) {
		DLog(@"Me");
	}
	
	NSMutableArray *scores = [NSMutableArray array];
	NSInteger scoreIndex = 4;
	
	// Add starting handicap 4 times to backfill based on ~2013 rules
	for (NSInteger i = 0; i < 5; i++) {
		[scores addObject:[NSNumber numberWithInteger:[player startingHandicapInYear:year]]];
	}
	
	// Add scores for the season, calculating handicap result by result
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"player = %@", player];
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"match.teamMatchup.week.seasonIndex" ascending:YES]];
	NSArray *playerResults = [WBResult findWithPredicate:pred sortedBy:sorts];
	for (WBResult *result in playerResults) {
		result.priorHandicapValue = [self priorHandicapWithScores:scores scoresIndex:scoreIndex];
		
		// Add the score for the week to be factored into the next weeks handicap
		[scores addObject:[NSNumber numberWithInteger:result.scoreValue - result.match.teamMatchup.week.course.parValue]];

		scoreIndex++;
	}
	
	player.currentHandicapValue = [self priorHandicapWithScores:scores scoresIndex:scoreIndex];
	if (year.isCompleteValue) {
		[player thisYearData].finishingHandicapValue = player.currentHandicapValue;
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
