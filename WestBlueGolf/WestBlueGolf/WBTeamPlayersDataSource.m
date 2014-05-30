//
//  WBTeamPlayersDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamPlayersDataSource.h"
#import "WBModels.h"
#import "WBPlayerListCell.h"
#import "WBProfileTableViewController.h"
#import "WBResultTableViewCell.h"
#import "WBTeamProfileDataSource.h"

#define SORT_KEY @"player.name"
#define SEGUE_IDENTIFIER @"WBTeamPlayerSegue"

@implementation WBTeamPlayersDataSource

- (WBTeam *)selectedTeam {
	WBTeamProfileDataSource *multi = (WBTeamProfileDataSource *)self.parentDataSource;
	return multi.selectedTeam;
}

- (NSString *)cellIdentifierForObject:(NSManagedObject *)object {
	static NSString *CellIdentifier = @"PlayerListCell";
	return CellIdentifier;
}

/*- (NSString *)incompleteCellIdentifier {
	static NSString *CellIdentifier = @"IncompleteTeamResultsCell"; //@"TeamCell";
	return CellIdentifier;
}*/

- (NSString *)entityName {
	return @"WBPlayerYearData";
}

- (BOOL)shouldExpand {
	return NO;
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sortOrderDescriptor];
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"team = %@ && year = %@", [self selectedTeam], [WBYear thisYear]];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBPlayerYearData *data = (WBPlayerYearData *)object;
	[(WBPlayerListCell *)cell configureCellForPlayer:data.player];
    //cell.textLabel.text = data.player.name;
	//cell.detailTextLabel.text = [data.player currentHandicapString];
}

- (NSString *)supportedSegueIdentifier {
	return SEGUE_IDENTIFIER;
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	WBProfileTableViewController *vc = [segue destinationViewController];
	NSIndexPath *path = self.parentDataSource.tableView.indexPathForSelectedRow;
	NSIndexPath *adjustedPath = [NSIndexPath indexPathForRow:path.row inSection:0];
	vc.selectedPlayer = [(WBPlayerYearData *)[self.fetchedResultsController objectAtIndexPath:adjustedPath] player];
}

@end
