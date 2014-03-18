//
//  WBMatchupResultCell.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/17/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBMatchupResultCell.h"
#import "WBModels.h"

@implementation WBMatchupResultCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellForMatchup:(WBTeamMatchup *)matchup {
	//DLog(@"%ld", (long)matchup.week.seasonIndexValue);

	NSArray *displayStrings = [matchup displayStrings];
	
	self.team1NameLabel.text = displayStrings[0];
	self.team1NameLabel.font = [UIFont boldSystemFontOfSize:17.0f];
	self.team2NameLabel.text = displayStrings[3];
	
	
	if (matchup.matchCompleteValue) {
		self.team1PointsLabel.text = displayStrings[1];
		self.team2PointsLabel.text = displayStrings[4];
	
		self.team1ScoreLabel.text = displayStrings[2];
		self.team2ScoreLabel.text = displayStrings[5];
	} else {
		self.team1PointsLabel.text = [matchup timeLabel];
		self.team2PointsLabel.text = @"";
		
		self.team1ScoreLabel.text = @"";
		self.team2ScoreLabel.text = @"";
	}
}

@end
