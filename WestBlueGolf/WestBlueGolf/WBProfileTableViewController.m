//
//  WBProfileTableViewController.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/15/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBProfileTableViewController.h"
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

@property (weak, nonatomic) WBPlayer *selectedPlayer;

@end

@implementation WBProfileTableViewController

- (void)viewDidLoad {
	self.selectedPlayer = [WBPlayer playerWithName:[self selectedEntityName]];
	if (!self.selectedPlayer) {
		self.selectedPlayer = [WBPlayer me];
	}

	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.winLossLabel.text = [self.selectedPlayer record];
	self.handicapLabel.text = [self.selectedPlayer currentHandicapString];
	self.lowRoundLabel.text = [self.selectedPlayer lowRoundString];
	self.averagePointsLabel.text = [self.selectedPlayer averagePointsString];
	self.averageScoreLabel.text = [self.selectedPlayer averageScoreString];
	self.lowNetLabel.text = [self.selectedPlayer lowNetString];
}

#pragma mark - WBEntityDetailViewController methods to implement

- (NSString *)selectedEntityName {
	WBPlayer *player = (WBPlayer *)self.selectedEntity;
	return player ? player.name : [WBPlayer me].name;
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

- (IBAction)favoritePlayer:(UIBarButtonItem *)sender {
	self.selectedPlayer.favoriteValue = !self.selectedPlayer.favoriteValue;
	[WBCoreDataManager saveContext];
	
	//[[NSNotificationCenter defaultCenter] postNotificationName:WBFavoriteCreatedNotification object:nil];
}

@end
