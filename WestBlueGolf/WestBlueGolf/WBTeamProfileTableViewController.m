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

@interface WBTeamProfileTableViewController () {
}

@end

@implementation WBTeamProfileTableViewController

#pragma mark - WBEntityDetailViewController methods to implement

- (NSString *)selectedEntityName {
	WBTeam *team = (WBTeam *)self.selectedEntity;
	TRAssert(team, @"No team selected for team profile");
	return team.name;
}

- (NSString *)entityName {
	return @"WBPlayer";
}

- (NSString *)sortDescriptor {
	//return @"match.teamMatchup.week.date";
	return @"name";
}

- (NSPredicate *)fetchPredicate {
	//return [NSPredicate predicateWithFormat:@"player.team.name = %@", [self selectedEntityName]];
	return [NSPredicate predicateWithFormat:@"team.name = %@", [self selectedEntityName]];
}

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"PlayerListCell";
	return CellIdentifier;
}

- (void)configureCell:(UITableViewCell *)cell
		  atIndexPath:(NSIndexPath *)indexPath {
	WBPlayer *player = (WBPlayer *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = player.name;
	cell.detailTextLabel.text = player.team.name;
}

@end
