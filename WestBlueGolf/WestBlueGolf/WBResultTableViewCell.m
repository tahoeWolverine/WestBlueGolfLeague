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
	
	BOOL win = [result wasWin];
	BOOL tie = [result wasTie];
	self.winLossLabel.text = win ? @"W" : tie ? @"T" : @"L";
	self.winLossLabel.textColor = win ? kEmeraldColor : tie ? [UIColor blackColor] : [UIColor redColor];
	NSNumber *opponentScore = opponentResult.score ?: @0;
	self.scoreLabel.text = [NSString stringWithFormat:@"%@-%@", result.score, opponentScore];
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
	}
	
	NSArray *displayStrings = [matchup displayStringsForTeam:team];
	BOOL win = [displayStrings[1] isEqualToString:@"W"];
	BOOL tie = [displayStrings[1] isEqualToString:@"T"];
	self.winLossLabel.textColor = win ? kEmeraldColor : tie ? [UIColor blackColor] : [UIColor redColor];
	
	self.dateAndOpponentLabel.text = displayStrings[0];
	self.winLossLabel.text = displayStrings[1];
	self.scoreLabel.text = displayStrings[2];
}

@end
