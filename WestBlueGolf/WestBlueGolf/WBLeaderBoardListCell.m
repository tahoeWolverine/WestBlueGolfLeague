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
	WBBoardData *data = [leaderBoard winnerData];
	self.winner.text = data.peopleEntity.name;
	self.leaderBoardName.text = [leaderBoard name];
	
	NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
	NSNumber *valueNum = [NSNumber numberWithFloat:data.valueValue];
	if (!data) {
		self.winnerValue.text = @"";
	} else {
		if ([valueNum doubleValue] == 0) {
			self.winnerValue.text = @"0";
		} else if (fmod([valueNum doubleValue], 1.0) == 0) {
			fmt.maximumFractionDigits = 0;
			self.winnerValue.text = [fmt stringFromNumber:valueNum];
		} else if (abs([valueNum doubleValue]) >= 1) {
			fmt.minimumFractionDigits = 2;
			self.winnerValue.text = [fmt stringFromNumber:valueNum];
		} else {
			fmt.minimumFractionDigits = 3;
			self.winnerValue.text = [NSString stringWithFormat:@"0%@", [fmt stringFromNumber:valueNum]];
		}
	}
}

@end
