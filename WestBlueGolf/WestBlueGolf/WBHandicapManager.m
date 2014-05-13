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

- (void)calculateHandicapsForYear:(WBYear *)year moc:(NSManagedObjectContext *)moc {
	NSArray *players = [WBPlayer findAllForYear:year inContext:moc];

	BOOL isNewestYear = [year isNewestYear];
	for (WBPlayer *player in players) {
		[self calculateHandicapsForPlayer:player year:year isNewestYear:isNewestYear];
	}
	
	[WBCoreDataManager saveContext:moc];
}

- (void)calculateHandicapsForPlayer:(WBPlayer *)player year:(WBYear *)year isNewestYear:(BOOL)isNewestYear {
	// Add starting handicap 4 times to backfill based on ~2013 rules
	WBPlayerYearData *data = [player filterYearDataForYear:year];
	if (!data) {
		DLog(@"Handicap not calculated for %@ in year %@", player.name, year.value);
		return;
	}

	// Rookies only get to count their starting handicap once, existing players get the full amount of backfills
	NSInteger backfillCount = 1;
	if (!data.isRookieValue) {
		backfillCount = 4;
	}
	
	NSMutableArray *scores = [NSMutableArray array];
	NSInteger scoreIndex = -1;
	for (NSInteger i = 0; i < backfillCount; i++) {
		[scores addObject:data.startingHandicap];
		scoreIndex++;
	}
	
	// Add scores for the season, calculating handicap result by result
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"match.teamMatchup.week.seasonIndex" ascending:YES]];
	NSArray *playerResults = [player filterResultsForYear:year goodData:NO sorts:sorts];
	
	// Note: the way this loop works is that it calculates the *prior* handicap, so it's kind of always one behind the result,
	// which the final score added being used for the final handicap
	NSInteger newNetScore = 0;
	for (WBResult *result in playerResults) {
		result.priorHandicapValue = [self priorHandicapWithScores:scores scoresIndex:scoreIndex];
		
		// Max score for handicap purproses is +20
		newNetScore = result.scoreValue - result.match.teamMatchup.week.course.parValue;
		if (newNetScore > 20) {
			newNetScore = 20;
		}
		
		// Add the score for the week to be factored into the next weeks handicap
		[scores addObject:[NSNumber numberWithInteger:newNetScore]];

		scoreIndex++;
	}
	
	NSInteger priorHandicap = [self priorHandicapWithScores:scores scoresIndex:scoreIndex];

	if (isNewestYear) {
		// This might need to change to support players that aren't playing this year; what's their current handicap?
		player.currentHandicapValue = priorHandicap;
	}

	if (year.isCompleteValue) {
		data.finishingHandicapValue = priorHandicap;
	}
}

// We only want to drop the lowest score once we have 4 scores recorded, otherwise its a true average
- (NSInteger)priorHandicapWithScores:(NSArray *)scores scoresIndex:(NSInteger)scoreIndex {
	NSInteger maxValue = -10;
	NSInteger handicapTotal = 0;
	NSNumber *netScore = nil;
	NSInteger i = scoreIndex;
	NSInteger usedScores = 0;
	while (i >= 0 && usedScores < 5) {
		netScore = scores[i];
		if (netScore.integerValue > maxValue) {
			maxValue = netScore.integerValue;
		}
		handicapTotal += netScore.integerValue;
		usedScores++;
		i--;
	}

	// Determine whether we're dropping the lowest of the 5 scores (including week 0) or doing a straight average
	if (usedScores == 5) {
		// Subtract the highest score diff as per handicap calculation rule
		handicapTotal -= maxValue;
		usedScores--;
	}
	
	return (NSInteger)((CGFloat)handicapTotal / (CGFloat)usedScores + 0.5f);
}

@end
