//
//  WBTeamResultsDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamResultsDataSource.h"
#import "WBModels.h"
#import "WBResultTableViewCell.h"
#import "WBTeamProfileDataSource.h"

#define SORT_KEY_SECTION_1 @"week.date"

@implementation WBTeamResultsDataSource

- (WBTeam *)selectedTeam {
	WBTeamProfileDataSource *multi = (WBTeamProfileDataSource *)self.multiFetchDataSource;
	return multi.selectedTeam;
}

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"TeamResultsCell";
	return CellIdentifier;
}

- (NSString *)incompleteCellIdentifier {
	static NSString *CellIdentifier = @"IncompleteTeamResultsCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBTeamMatchup";
}

- (BOOL)shouldExpand {
	return YES;
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY_SECTION_1 ascending:NO];
	return @[sortOrderDescriptor];
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"%@ IN teams && week.year = %@", [self selectedTeam], [WBYear thisYear]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WBTeamMatchup *matchup = (WBTeamMatchup *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
	NSString *identifier = matchup.matchCompleteValue ? [self cellIdentifier] : [self incompleteCellIdentifier];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
	
	[self configureCell:cell withObject:matchup];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBTeamMatchup *matchup = (WBTeamMatchup *)object;
	WBResultTableViewCell *resultCell = (WBResultTableViewCell *)cell;
	[resultCell configureCellForResultsOfTeam:self.selectedTeam matchup:matchup];
}

@end
