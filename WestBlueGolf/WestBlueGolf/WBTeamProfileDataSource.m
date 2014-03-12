//
//  WBTeamProfileDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamProfileDataSource.h"
#import "WBModels.h"

#define SORT_KEY_SECTION_1 @"match.teamMatchup.week.date"
#define SORT_KEY_SECTION_2 @"name"

@implementation WBTeamProfileDataSource

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"TeamCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBPlayer";
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY_SECTION_2 ascending:YES];
	return @[sortOrderDescriptor];
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"team = %@", self.selectedTeam];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBPlayer *player = (WBPlayer *)object;
    cell.textLabel.text = player.name;
	cell.detailTextLabel.text = player.team.name;
}

@end
