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
	
	NSArray *teams = [matchup.teams allObjects];
	WBTeam *team1 = teams[0];
	WBTeam *team2 = teams[1];
	
	self.team1NameLabel.text = [NSString stringWithFormat:@"%@%@", [team1 isMyTeam] ? @"*" : @"", team1.name];
	self.team2NameLabel.text = [NSString stringWithFormat:@"%@%@", [team2 isMyTeam] ? @"*" : @"", team2.name];
	
	self.team1PointsLabel.text = [matchup totalPointsStringForTeam:team1];
	self.team2PointsLabel.text = [matchup totalPointsStringForTeam:team2];
	
	self.team1ScoreLabel.text = [matchup totalScoreStringForTeam:team1];
	self.team2ScoreLabel.text = [matchup totalScoreStringForTeam:team2];
}

@end
