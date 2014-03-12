//
//  WBProfileDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBProfileDataSource.h"
#import "WBModels.h"
#import "WBResultTableViewCell.h"

#define SORT_KEY @"match.teamMatchup.week.date"

@interface WBProfileDataSource () {
	//WBPlayer *_selectedPlayer;
}

@end

@implementation WBProfileDataSource

/*- (void)setSelectedPlayer:(WBPlayer *)selectedPlayer {
	_selectedPlayer = selectedPlayer;
	if ([self isKindOfClass:[WBMeViewController class]]) {
		self.navigationController.tabBarItem.title = _selectedPlayer ? [_selectedPlayer firstName] : @"You";
		[self resetTableAndFetchedResultsController];
	}
}*/

/*- (void)setSelectedPlayer:(WBPlayer *)selectedPlayer {
	_selectedPlayer = selectedPlayer;
}*/

- (WBPlayer *)selectedPlayer {
	if (!_selectedPlayer) {
		_selectedPlayer = [WBPlayer me];//[WBPlayer playerWithName:[self selectedPlayerName]];
	}
	
	return _selectedPlayer;
}

/*- (NSString *)selectedPlayerName {
	WBPlayer *player = _selectedPlayer;
	NSString *meName = [WBPlayer me].name;
	//TODO: Not quite right
	return player ? player.name : meName ?: @"Find Yourself in Players";
}*/

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"ProfileResultsCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBResult";
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:NO];
	return @[sortOrderDescriptor];
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"player = %@", self.selectedPlayer];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
    WBResult *result = (WBResult *)object;
	WBResultTableViewCell *resultCell = (WBResultTableViewCell *)cell;
	[resultCell configureCellForResult:result];
}

@end
