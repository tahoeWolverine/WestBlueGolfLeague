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
	[super viewDidLoad];
	
	self.selectedPlayer = [WBPlayer playerWithName:[self selectedEntityName]];
	
	self.winLossLabel.text = [self.selectedPlayer record];
	self.handicapLabel.text = [self.selectedPlayer currentHandicapString];
	self.lowRoundLabel.text = nil;
	self.averagePointsLabel.text = nil;
	self.averageScoreLabel.text = nil;
	self.lowNetLabel.text = nil;
}

#pragma mark - WBEntityDetailViewController methods to implement

- (NSString *)selectedEntityName {
	WBPlayer *player = (WBPlayer *)self.selectedEntity;
	return player ? player.name : @"Michael Harlow";
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:NO];
	return @[sortOrderDescriptor];
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"player.name = %@", [self selectedEntityName]];
}

- (void)configureCell:(UITableViewCell *)cell
		  atIndexPath:(NSIndexPath *)indexPath {
    WBResult *result = (WBResult *)[self.fetchedResultsController objectAtIndexPath:indexPath];
	WBResultTableViewCell *resultCell = (WBResultTableViewCell *)cell;
	[resultCell configureCellForResult:result];
}

@end
