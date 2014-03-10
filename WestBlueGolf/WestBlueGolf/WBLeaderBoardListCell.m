//
//  WBLeaderBoardListCell.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/17/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBLeaderBoardListCell.h"
#import "WBModels.h"

@implementation WBLeaderBoardListCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellForLeaderBoard:(WBLeaderBoard *)leaderBoard {
	self.winner.text = [leaderBoard winnerData].peopleEntity.name;
	self.leaderBoardName.text = [leaderBoard name];
	self.winnerValue.text = [NSString stringWithFormat:@"%@", [leaderBoard winnerData].value];
}

@end
