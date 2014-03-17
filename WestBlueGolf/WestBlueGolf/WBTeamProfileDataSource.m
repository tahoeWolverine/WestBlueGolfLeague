//
//  WBTeamProfileDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamProfileDataSource.h"
#import "WBModels.h"
#import "WBResultTableViewCell.h"

#define SORT_KEY_SECTION_1 @"week.date"
#define SORT_KEY_SECTION_2 @"name"

@implementation WBTeamProfileDataSource

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"TeamResultsCell"; //@"TeamCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	//return @"WBPlayer";
	return @"WBTeamMatchup";
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY_SECTION_1 ascending:NO];
	//NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY_SECTION_2 ascending:YES];
	return @[sortOrderDescriptor];
}

- (NSPredicate *)fetchPredicate {
	//return [NSPredicate predicateWithFormat:@"team = %@", self.selectedTeam];
	return [NSPredicate predicateWithFormat:@"%@ IN teams && week.year = %@", self.selectedTeam, [WBYear thisYear]];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	/*WBPlayer *player = (WBPlayer *)object;
    cell.textLabel.text = player.name;
	cell.detailTextLabel.text = player.team.name;*/
	WBTeamMatchup *matchup = (WBTeamMatchup *)object;
	WBResultTableViewCell *resultCell = (WBResultTableViewCell *)cell;
	[resultCell configureCellForResultsOfTeam:self.selectedTeam matchup:matchup];
	
}

@end
