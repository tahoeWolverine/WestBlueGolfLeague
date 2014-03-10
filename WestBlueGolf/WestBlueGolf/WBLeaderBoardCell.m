//
//  WBLeaderBoardCell.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/17/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBLeaderBoardCell.h"
#import "WBModels.h"

@implementation WBLeaderBoardCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellForBoardData:(WBBoardData *)data {
	self.rankLabel.text = [data rankString];
	self.peopleName.text = data.peopleEntity.name;
	
	NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
	NSNumber *avg = [NSNumber numberWithFloat:data.valueValue];
	if ([avg doubleValue] == 0) {
		self.peopleValue.text = @"0";
	} else if (fmod([avg doubleValue], 1.0) == 0) {
		fmt.maximumFractionDigits = 0;
		self.peopleValue.text = [fmt stringFromNumber:avg];
	} else if (abs([avg doubleValue]) >= 1) {
		fmt.minimumFractionDigits = 2;
		self.peopleValue.text = [fmt stringFromNumber:avg];
	} else {
		fmt.minimumFractionDigits = 3;
		self.peopleValue.text = [NSString stringWithFormat:@"0%@", [fmt stringFromNumber:avg]];
	}
}

@end
