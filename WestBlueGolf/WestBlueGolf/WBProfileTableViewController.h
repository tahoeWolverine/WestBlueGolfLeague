//
//  WBProfileTableViewController.h
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/15/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBPlayer;

@interface WBProfileTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;

- (void)refreshPlayerHighlights;
- (void)refreshFavoriteButton;

- (IBAction)favoritePlayer:(UIBarButtonItem *)sender;

// Fake selectedPlayer property passthrough
- (WBPlayer *)selectedPlayer;
- (void)setSelectedPlayer:(WBPlayer *)selectedPlayer;

- (void)setTabName:(NSString *)name;

- (BOOL)isMeTab;

@end
