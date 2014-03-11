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
	self.leaderBoardName.text = [leaderBoard name];
	
	NSArray *winners = [leaderBoard winnerData];
	if (winners.count == 0) {
		self.winner.text = @"";
		self.winnerValue.text = @"";
	} else {
		WBBoardData *data = [winners firstObject];
		if (winners.count == 1) {
			self.winner.text = data.peopleEntity.name;
		} else {
			self.winner.text = [NSString stringWithFormat:@"%ld Leaders", (long)winners.count];
		}

		NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
		NSNumber *valueNum = [NSNumber numberWithFloat:data.valueValue];
		if ([valueNum floatValue] == 0) {
			self.winnerValue.text = @"0";
		} else if (fmod([valueNum floatValue], 1.0) == 0) {
			fmt.maximumFractionDigits = 0;
			self.winnerValue.text = [fmt stringFromNumber:valueNum];
		} else if (abs([valueNum floatValue]) >= 1) {
			fmt.minimumFractionDigits = 2;
			self.winnerValue.text = [fmt stringFromNumber:valueNum];
		} else {
			fmt.minimumFractionDigits = 3;
			self.winnerValue.text = [NSString stringWithFormat:@"0%@", [fmt stringFromNumber:valueNum]];
		}
	}
}

@end
