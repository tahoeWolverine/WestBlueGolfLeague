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
	[dateFormatter setDateFormat:@"MM/dd"];
	NSString *dateString = [dateFormatter stringFromDate:result.match.teamMatchup.week.date];
	
	self.textLabel.text = dateString;
	
	//cell.detailTextLabel.text = [result.score stringValue];
}

@end
