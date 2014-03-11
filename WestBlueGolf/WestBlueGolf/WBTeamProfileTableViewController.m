//
//  WBTeamProfileTableViewController.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/15/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamProfileTableViewController.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
#import "WBResultTableViewCell.h"

#define SORT_KEY @"name" //@"match.teamMatchup.week.date"

@interface WBTeamProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *winLossLabel;
@property (weak, nonatomic) IBOutlet UILabel *winLossAllLabel;
@property (weak, nonatomic) IBOutlet UILabel *improvedLabel;

@end

@implementation WBTeamProfileTableViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self refreshTeamHighlights];
}

- (void)refreshTeamHighlights {
	WBTeam *team = (WBTeam *)self.selectedEntity;
	WBBoardData *teamRank = [team findTotalPointsBoardData];
	self.placeLabel.text = [NSString stringWithFormat:@"%@", teamRank.rank];
	self.averagePointsLabel.text = [team averagePointsString];
	self.winLossLabel.text = [team record];
	self.winLossAllLabel.text = [team individualRecord];
	self.improvedLabel.text = [NSString stringWithFormat:@"%@", [team findImprovedBoardData].rank];
}

#pragma mark - WBEntityDetailViewController methods to implement

- (NSString *)selectedEntityName {
	WBTeam *team = (WBTeam *)self.selectedEntity;
	TRAssert(team, @"No team selected for team profile");
	return team.name;
}

- (NSString *)entityName {
	return @"WBPlayer";
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sortOrderDescriptor];
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"team.name = %@", [self selectedEntityName]];
}

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"PlayerListCell";
	return CellIdentifier;
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBPlayer *player = (WBPlayer *)object;
    cell.textLabel.text = player.name;
	cell.detailTextLabel.text = player.team.name;
}

@end
