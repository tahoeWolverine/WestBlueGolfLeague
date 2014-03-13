//
//  WBTeamProfileTableViewController.h
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/15/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

//#import "WBEntityDetailViewController.h"

@class WBTeam;

@interface WBTeamProfileTableViewController : UITableViewController

- (WBTeam *)selectedTeam;
- (void)setSelectedTeam:(WBTeam *)selectedTeam;

@end
