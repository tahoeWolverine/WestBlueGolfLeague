//
//  WBLeaderBoardListCell.h
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/17/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBLeaderBoard;

@interface WBLeaderBoardListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *winner;
@property (weak, nonatomic) IBOutlet UILabel *leaderBoardName;
@property (weak, nonatomic) IBOutlet UILabel *winnerValue;

- (void)configureCellForLeaderBoard:(WBLeaderBoard *)leaderBoard;

@end
