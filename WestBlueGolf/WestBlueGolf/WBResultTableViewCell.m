//
//  WBResultTableViewCell.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/17/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBResultTableViewCell.h"
#import "WBAppDelegate.h"
#import "WBModels.h"

@implementation WBResultTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellForResult:(WBResult *)result {
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"M/dd"];
	NSString *dateString = [dateFormatter stringFromDate:result.match.teamMatchup.week.date];
	
	WBResult *opponentResult = [result opponentResult];
	NSString *opponentName = opponentResult ? [opponentResult.player shortName] : @"No Show";
	self.dateAndOpponentLabel.text = [NSString stringWithFormat:@"%@ vs %@", dateString, opponentName];
	
	BOOL badData = result.match.teamMatchup.week.isBadDataValue;
	BOOL win = [result wasWin];
	BOOL tie = [result wasTie];
	self.winLossLabel.text = badData ? @"N/A" : win ? @"W" : tie ? @"T" : @"L";
	self.winLossLabel.textColor = win ? kEmeraldColor : tie ? [UIColor blackColor] : badData ? [UIColor blackColor] : [UIColor redColor];
	NSNumber *opponentScore = opponentResult.score ?: @0;
	self.scoreLabel.text = [NSString stringWithFormat:@"%@-%@", result.score, opponentScore];
	
	self.pairingLabel.text = [NSString stringWithFormat:@"#%ld Players", (long)[result.match pairing]];
	self.priorHandicapsLabel.text = [NSString stringWithFormat:@"%@ vs %@", [result priorHandicapString], [opponentResult priorHandicapString]];
	self.pointsLabel.text = [NSString stringWithFormat:@"%@/%@", result.points, opponentResult.points];
	self.netScoresLabel.text = [NSString stringWithFormat:@"%@,%@", [result netScoreDifferenceString], [opponentResult netScoreDifferenceString]];
}

- (void)configureCellForResultsOfTeam:(WBTeam *)team matchup:(WBTeamMatchup *)matchup {
	if (!matchup) {
		DLog(@"No results found for team in week");
		NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"M/dd"];
		NSString *dateString = [dateFormatter stringFromDate:matchup.week.date];
		self.dateAndOpponentLabel.text = [NSString stringWithFormat:@"%@ Did Not Play", dateString];
		self.winLossLabel.text = nil;
		self.scoreLabel.text = nil;
		return;
	} else {
		NSArray *displayStrings = [matchup displayStringsForTeam:team];
		self.dateAndOpponentLabel.text = displayStrings[0];
		if (matchup.matchCompleteValue) {
			BOOL win = [displayStrings[1] isEqualToString:@"W"];
			BOOL tie = [displayStrings[1] isEqualToString:@"T"];
			BOOL loss = [displayStrings[1] isEqualToString:@"L"];
			self.winLossLabel.textColor = win ? kEmeraldColor : tie ? [UIColor blackColor] : loss ? [UIColor redColor] : [UIColor blackColor];
			self.winLossLabel.text = displayStrings[1];
			self.scoreLabel.text = displayStrings[2];
			
			self.pairingLabel.text = displayStrings[3];
			self.priorHandicapsLabel.text = displayStrings[4];
			self.pointsLabel.text = displayStrings[5];
			self.netScoresLabel.text = displayStrings[6];
		} else {
			self.winLossLabel.textColor = [UIColor blackColor];
			self.winLossLabel.text = [matchup.week.course shortName];
			self.scoreLabel.text = [matchup shortTime];
			
			self.pairingLabel.text = displayStrings[3];
			self.priorHandicapsLabel.text = displayStrings[4];
		}
	}
}

@end
