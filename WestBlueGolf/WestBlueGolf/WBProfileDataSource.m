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
}

@end

@implementation WBProfileDataSource

- (WBPlayer *)selectedPlayer {
	if (!_selectedPlayer) {
		_selectedPlayer = [WBPlayer me];
	}
	
	return _selectedPlayer;
}

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
