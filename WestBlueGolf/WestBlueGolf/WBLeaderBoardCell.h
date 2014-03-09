//
//  WBLeaderBoardCell.h
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/17/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBBoardData;

@interface WBLeaderBoardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleName;
@property (weak, nonatomic) IBOutlet UILabel *peopleValue;

- (void)configureCellForBoardData:(WBBoardData *)data;

@end
