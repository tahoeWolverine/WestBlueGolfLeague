//
//  WBLeaderBoardTableViewController.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/7/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBLeaderBoard;

@interface WBLeaderBoardTableViewController : UITableViewController

// Fake selectedPlayer property passthrough
- (WBLeaderBoard *)selectedLeaderboard;
- (void)setSelectedLeaderboard:(WBLeaderBoard *)selectedLeaderboard;

@end
