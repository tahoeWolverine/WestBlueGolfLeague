//
//  WBResultTableViewCell.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/17/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBResultTableViewCell.h"
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
	self.winLossLabel.textColor = win ? [UIColor colorWithRed:46.0 / 255.0 green:204.0 / 255.0 blue:113.0 / 255.0 alpha:1.0] : tie ? [UIColor blackColor] : [UIColor redColor];
	NSNumber *opponentScore = opponentResult.score ?: @0;
	self.scoreLabel.text = [NSString stringWithFormat:@"%@-%@", result.score, opponentScore];
}

@end
