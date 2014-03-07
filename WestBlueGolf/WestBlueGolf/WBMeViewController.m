//
//  WBMeViewController.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/7/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBMeViewController.h"
#import "WBCoreDataManager.h"
#import "WBPlayer.h"

@implementation WBMeViewController

- (void)setSelectedPlayer:(WBPlayer *)selectedPlayer {
	super.selectedPlayer = selectedPlayer;
	self.navigationController.tabBarItem.title = selectedPlayer.name;
	[self.tableView reloadData];
}

- (IBAction)favoritePlayer:(UIBarButtonItem *)sender {
	if ([self.favoriteButton.title isEqualToString:@"+ME"]) {
		TRAssert(![WBPlayer me], @"Attempting to +ME from Me tab");
	}
	
	[self.selectedPlayer setPlayerToNotMe];
	[WBCoreDataManager saveContext];

	[self refreshPlayerHighlights];
	[self refreshFavoriteButton];
}

- (void)refreshFavoriteButton {
	if (self.selectedPlayer) {
		self.favoriteButton.enabled = YES;
		self.favoriteButton.image = nil;
		self.favoriteButton.title = @"-ME";
	} else {
		self.favoriteButton.enabled = NO;
		self.favoriteButton.image = nil;
		self.favoriteButton.title = nil;
	}
}

@end
