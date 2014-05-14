//
//  WBTeamPlayersDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamPlayersDataSource.h"
#import "WBModels.h"
#import "WBProfileTableViewController.h"
#import "WBResultTableViewCell.h"
#import "WBTeamProfileDataSource.h"

#define SORT_KEY @"name"
#define SEGUE_IDENTIFIER @"WBTeamPlayerSegue"

@implementation WBTeamPlayersDataSource

- (WBTeam *)selectedTeam {
	WBTeamProfileDataSource *multi = (WBTeamProfileDataSource *)self.parentDataSource;
	return multi.selectedTeam;
}

- (NSString *)cellIdentifierForObject:(NSManagedObject *)object {
	static NSString *CellIdentifier = @"TeamCell";
	return CellIdentifier;
}

/*- (NSString *)incompleteCellIdentifier {
	static NSString *CellIdentifier = @"IncompleteTeamResultsCell"; //@"TeamCell";
	return CellIdentifier;
}*/

- (NSString *)entityName {
	return @"WBPlayer";
}

- (BOOL)shouldExpand {
	return NO;
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sortOrderDescriptor];
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"team = %@ && ANY yearData.year = %@", [self selectedTeam], [WBYear thisYear]];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBPlayer *player = (WBPlayer *)object;
    cell.textLabel.text = player.name;
	cell.detailTextLabel.text = [player currentHandicapString];
}

- (NSString *)supportedSegueIdentifier {
	return SEGUE_IDENTIFIER;
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	WBProfileTableViewController *vc = [segue destinationViewController];
	NSIndexPath *path = self.parentDataSource.tableView.indexPathForSelectedRow;
	NSIndexPath *adjustedPath = [NSIndexPath indexPathForRow:path.row inSection:0];
	vc.selectedPlayer = (WBPlayer *)[self.fetchedResultsController objectAtIndexPath:adjustedPath];
}

@end
