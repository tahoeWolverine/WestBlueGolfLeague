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
#import "WBMeViewController.h"
#import "WBModels.h"
#import "WBProfileDataSource.h"

@interface WBProfileTableViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *winLossLabel;
@property (weak, nonatomic) IBOutlet UILabel *handicapLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowRoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *improvedLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowNetLabel;

//@property (assign, nonatomic) BOOL isMeViewController;

@property (strong, nonatomic) WBProfileDataSource *dataSource;

@end

@implementation WBProfileTableViewController

/*- (void)markViewControllerMe {
	self.isMeViewController = YES;
}*/

- (BOOL)isMeTab {
	return [(WBAppDelegate *)[UIApplication sharedApplication].delegate isProfileTab:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.dataSource = [WBProfileDataSource dataSourceWithViewController:self];
	}
	return self;
}

- (void)viewDidLoad {
	// Important: set the selected player before viewDidLoad so that things render properly, having that information up front
	//self.selectedPlayer = [WBPlayer playerWithName:[self selectedEntityName]];

	//self.isMeViewController = !self.selectedPlayer;

	[super viewDidLoad];

	[self.dataSource beginFetch];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self refreshPlayerHighlights];
	[self refreshFavoriteButton];
}

- (WBPlayer *)selectedPlayer {
	return self.dataSource.selectedPlayer;
}

- (void)setSelectedPlayer:(WBPlayer *)selectedPlayer {
	self.dataSource.selectedPlayer = selectedPlayer;
	if ([self isMeTab]) {
		self.navigationController.tabBarItem.title = selectedPlayer ? [selectedPlayer firstName] : @"You";
		[self resetTableAndFetchedResultsController];
	}
}

- (void)resetTableAndFetchedResultsController {
	self.dataSource.fetchedResultsController = nil;
	[self.dataSource beginFetch];
	
	[self.tableView reloadData];
}

- (void)refreshPlayerHighlights {
	WBPlayer *player = self.selectedPlayer;
	if (player) {
		self.winLossLabel.text = [player record];
		self.handicapLabel.text = [player currentHandicapString];
		self.lowRoundLabel.text = [player lowRoundString];
		self.averagePointsLabel.text = [player averagePointsString];
		self.improvedLabel.text = [player improvedString];
		self.lowNetLabel.text = [player lowNetString];
	} else {
		self.winLossLabel.text = @"-";
		self.handicapLabel.text = @"-";
		self.lowRoundLabel.text =  @"-";
		self.averagePointsLabel.text = @"-";
		self.improvedLabel.text = @"-";
		self.lowNetLabel.text = @"-";
	}

	self.navigationItem.title = self.selectedPlayer.name ?: @"Find Yourself in Players";
}

- (void)refreshFavoriteButton {
	if ([self isMeTab]) {
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
	if ([self isMeTab]) {
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
