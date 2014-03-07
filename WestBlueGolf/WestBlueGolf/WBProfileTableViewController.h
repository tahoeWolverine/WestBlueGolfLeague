//
//  WBProfileTableViewController.h
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/15/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBEntityDetailViewController.h"

@class WBPlayer;

@interface WBProfileTableViewController : WBEntityDetailViewController

@property (weak, nonatomic) WBPlayer *selectedPlayer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;

- (void)markViewControllerMe;

- (void)refreshPlayerHighlights;
- (void)refreshFavoriteButton;

- (IBAction)favoritePlayer:(UIBarButtonItem *)sender;

@end
