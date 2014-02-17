//
//  WBProfileTableViewController.h
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/15/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBPlayer;

@interface WBProfileTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) WBPlayer *selectedPlayer;

@end
