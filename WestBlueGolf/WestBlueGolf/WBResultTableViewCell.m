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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellForResult:(WBResult *)result {
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"M/dd"];
	NSString *dateString = [dateFormatter stringFromDate:result.match.teamMatchup.week.date];
	
	//if (dateString && [dateString characterAtIndex:0] == '0'
	WBResult *opponentResult = [result opponentResult];
	NSString *opponentName = opponentResult ? [opponentResult.player shortName] : @"No Show";
	self.dateAndOpponentLabel.text = [NSString stringWithFormat:@"%@ vs %@", dateString, opponentName];
	
	BOOL win = result.pointsValue > 12;
	BOOL tie = result.pointsValue == 12;
	self.winLossLabel.text = win ? @"W" : tie ? @"T" : @"L";
	self.winLossLabel.textColor = win ? [UIColor greenColor] : tie ? [UIColor blackColor] : [UIColor redColor];
	NSNumber *opponentScore = opponentResult.score ?: @0;
	self.scoreLabel.text = [NSString stringWithFormat:@"%@-%@", result.score, opponentScore];
}

@end
