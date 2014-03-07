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

@interface WBProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *winLossLabel;
@property (weak, nonatomic) IBOutlet UILabel *handicapLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowRoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowNetLabel;

@property (assign, nonatomic) BOOL isMeViewController;

@end

@implementation WBProfileTableViewController

- (void)markViewControllerMe {
	self.isMeViewController = YES;
}

- (void)viewDidLoad {
	self.selectedPlayer = [WBPlayer playerWithName:[self selectedEntityName]];
	//self.tabBarItem.title = /*_selectedPlayer ? _selectedPlayer.name :*/ @"You";
	if (!self.selectedPlayer) {
		/*self.selectedPlayer = [WBPlayer me];
		if (!self.selectedPlayer) {
			//self.view = [[UIView alloc] init];
		}*/
		// No me scenario
	}

	[super viewDidLoad];
	
	self.navigationController.tabBarItem.title = _selectedPlayer ? _selectedPlayer.name : @"You";
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self refreshPlayerHighlights];
	[self refreshFavoriteButton];
}

- (void)setSelectedPlayer:(WBPlayer *)selectedPlayer {
	_selectedPlayer = selectedPlayer;
	if (self.isMeViewController) {
		self.navigationController.tabBarItem.title = selectedPlayer.name;
		[self.tableView reloadData];
	}
}

- (void)refreshPlayerHighlights {
	if (self.selectedPlayer) {
		self.winLossLabel.text = [self.selectedPlayer record];
		self.handicapLabel.text = [self.selectedPlayer currentHandicapString];
		self.lowRoundLabel.text = [self.selectedPlayer lowRoundString];
		self.averagePointsLabel.text = [self.selectedPlayer averagePointsString];
		self.averageScoreLabel.text = [self.selectedPlayer averageScoreString];
		self.lowNetLabel.text = [self.selectedPlayer lowNetString];
	} else {
		self.winLossLabel.text = @"";
		self.handicapLabel.text = @"";
		self.lowRoundLabel.text =  @"";
		self.averagePointsLabel.text = @"";
		self.averageScoreLabel.text = @"";
		self.lowNetLabel.text = @"";
	}
}

- (void)refreshFavoriteButton {
	if (self.isMeViewController) {
		if (self.selectedPlayer) {
			self.favoriteButton.enabled = YES;
			self.favoriteButton.image = nil;
			self.favoriteButton.title = @"-ME";
		} else {
			self.favoriteButton.enabled = NO;
			self.favoriteButton.image = nil;
			self.favoriteButton.title = nil;
		}
	} else {
		WBPlayer *me = [WBPlayer me];
		if (!me) {
			self.favoriteButton.enabled = YES;
			self.favoriteButton.image = nil;
			self.favoriteButton.title = @"+ME";
		} else {
			self.favoriteButton.enabled = YES;
			self.favoriteButton.image = [UIImage imageNamed:self.selectedPlayer.favoriteValue ? @"UITabBarFavoritesTemplateSelected" : @"UITabBarFavoritesTemplate"];
			self.favoriteButton.title = nil;
		}
	}
}

- (IBAction)favoritePlayer:(UIBarButtonItem *)sender {
	if (self.isMeViewController) {
		if ([self.favoriteButton.title isEqualToString:@"+ME"]) {
			ALog(@"Attempting to +ME from Me tab");
		}
		
		[self.selectedPlayer setPlayerToNotMe];
		[WBCoreDataManager saveContext];
		
		[self refreshPlayerHighlights];
	} else {
		if ([self.favoriteButton.title isEqualToString:@"+ME"]) {
			TRAssert(![WBPlayer me], @"Attempting to +ME but already have ME");
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

@end
