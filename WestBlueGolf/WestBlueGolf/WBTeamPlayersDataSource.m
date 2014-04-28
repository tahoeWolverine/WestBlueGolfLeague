//
//  WBTeamPlayersDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamPlayersDataSource.h"
#import "WBModels.h"
#import "WBResultTableViewCell.h"
#import "WBTeamProfileDataSource.h"

#define SORT_KEY @"name"

@implementation WBTeamPlayersDataSource

- (WBTeam *)selectedTeam {
	WBTeamProfileDataSource *multi = (WBTeamProfileDataSource *)self.multiFetchDataSource;
	return multi.selectedTeam;
}

- (NSString *)cellIdentifier {
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
	return YES;
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sortOrderDescriptor];
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"team = %@", [self selectedTeam]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WBTeamMatchup *matchup = (WBTeamMatchup *)[self.fetchedResultsController objectAtIndexPath:indexPath];
	NSString *identifier = [self cellIdentifier];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
	
	[self configureCell:cell withObject:matchup];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBPlayer *player = (WBPlayer *)object;
    cell.textLabel.text = player.name;
	cell.detailTextLabel.text = player.team.name;
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	//WBProfileTableViewController *vc = [segue destinationViewController];
	//vc.selectedPlayer = (WBPlayer *)[self.dataSource objectAtIndexPath:self.tableView.indexPathForSelectedRow];
}

@end
