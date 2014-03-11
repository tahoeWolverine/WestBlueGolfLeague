//
//  WBProfileTableViewController.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/15/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBProfileTableViewController.h"
#import "WBAppDelegate.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
#import "WBNotifications.h"
#import "WBResultTableViewCell.h"

#define SORT_KEY @"match.teamMatchup.week.date"

@interface WBProfileTableViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *winLossLabel;
@property (weak, nonatomic) IBOutlet UILabel *handicapLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowRoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *improvedLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowNetLabel;

@property (assign, nonatomic) BOOL isMeViewController;

@end

@implementation WBProfileTableViewController

- (void)markViewControllerMe {
	self.isMeViewController = YES;
}

- (void)viewDidLoad {
	// Important: set the selected player before viewDidLoad so that things render properly, having that information up front
	self.selectedPlayer = [WBPlayer playerWithName:[self selectedEntityName]];

	[super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self refreshPlayerHighlights];
	[self refreshFavoriteButton];
}

- (void)setSelectedPlayer:(WBPlayer *)selectedPlayer {
	_selectedPlayer = selectedPlayer;
	if (self.isMeViewController) {
		self.navigationController.tabBarItem.title = _selectedPlayer ? [_selectedPlayer firstName] : @"You";
		self.fetchedResultsController = nil;
		[self beginFetch];

		[self.tableView reloadData];
	}
}

- (void)refreshPlayerHighlights {
	if (self.selectedPlayer) {
		self.winLossLabel.text = [self.selectedPlayer record]; //[NSString stringWithFormat:@"%@", [self.selectedPlayer findWinLossBoardData].value];
		self.handicapLabel.text = [NSString stringWithFormat:@"%@", [self.selectedPlayer findHandicapBoardData].value];
		self.lowRoundLabel.text = [NSString stringWithFormat:@"%@", [self.selectedPlayer findLowScoreBoardData].value];
		self.averagePointsLabel.text = [NSString stringWithFormat:@"%@", [self.selectedPlayer findAveragePointsBoardData].value];
		self.improvedLabel.text = [NSString stringWithFormat:@"%@", [self.selectedPlayer findImprovedBoardData].value];
		self.lowNetLabel.text = [NSString stringWithFormat:@"%@", [self.selectedPlayer findLowNetBoardData].value];
	} else {
		self.winLossLabel.text = @"-";
		self.handicapLabel.text = @"-";
		self.lowRoundLabel.text =  @"-";
		self.averagePointsLabel.text = @"-";
		self.improvedLabel.text = @"-";
		self.lowNetLabel.text = @"-";
	}

	self.navigationItem.title = [self selectedEntityName];
}

- (void)refreshFavoriteButton {
	if (self.isMeViewController) {
		if (self.selectedPlayer) {
			self.favoriteButton.enabled = YES;
			self.favoriteButton.image = [UIImage imageNamed:@"UITabBarContactsTemplate"];
		} else {
			self.favoriteButton.enabled = NO;
			self.favoriteButton.image = nil;
		}
	} else {
		WBPlayer *me = [WBPlayer me];
		if (!me) {
			self.favoriteButton.enabled = YES;
			self.favoriteButton.image = [UIImage imageNamed:@"UITabBarContactsTemplate"];
		} else {
			self.favoriteButton.enabled = YES;
			self.favoriteButton.image = [UIImage imageNamed:self.selectedPlayer.favoriteValue ? @"UITabBarFavoritesTemplateSelected" : @"UITabBarFavoritesTemplate"];
		}
	}
}

- (IBAction)favoritePlayer:(UIBarButtonItem *)sender {
	if (self.isMeViewController) {
		UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:@"Remove Profile"
															 message:@"Are you sure you want to reset your identity in the app?"
															delegate:self
												   cancelButtonTitle:@"Cancel"
												   otherButtonTitles:@"Reset", nil];
		[resetAlert show];
	} else {
		WBPlayer *me = [WBPlayer me];
		if (!me) {
			[self.selectedPlayer setPlayerToMe];
			[WBCoreDataManager saveContext];
			[(WBAppDelegate *)[UIApplication sharedApplication].delegate setProfileTabPlayer];
		} else {
			self.selectedPlayer.favoriteValue = !self.selectedPlayer.favoriteValue;
		}
	}
	
	[self refreshFavoriteButton];
}

#pragma mark - WBEntityDetailViewController methods to implement

- (NSString *)selectedEntityName {
	WBPlayer *player = (WBPlayer *)self.selectedEntity;
	self.isMeViewController = !player; // if there is no selectedEntity (aka someone touched an item in a cell), we know we're on the me tab
	NSString *meName = [WBPlayer me].name;
	return player ? player.name : meName ?: @"Find Yourself in Players";
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:NO];
	return @[sortOrderDescriptor];
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"player.name = %@", [self selectedEntityName]];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
    WBResult *result = (WBResult *)object;
	WBResultTableViewCell *resultCell = (WBResultTableViewCell *)cell;
	[resultCell configureCellForResult:result];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex > 0) {
		[self.selectedPlayer setPlayerToNotMe];
		[WBCoreDataManager saveContext];
	
		self.selectedPlayer = nil;
	
		[self refreshPlayerHighlights];
		[self refreshFavoriteButton];
	}
}

@end
