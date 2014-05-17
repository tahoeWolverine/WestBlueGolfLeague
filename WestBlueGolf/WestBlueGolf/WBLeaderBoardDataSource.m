//
//  WBLeaderBoardDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBLeaderBoardDataSource.h"
#import "WBLeaderBoardCell.h"
#import "WBLeaderBoardParentDataSource.h"
#import "WBModels.h"

#define SORT_KEY @"rank"

#define CELL_EXPAND_HEIGHT 80.0f

@interface WBLeaderBoardDataSource ()

@end

@implementation WBLeaderBoardDataSource

#pragma mark - WBEntityDataSource methods to implement

- (NSString *)cellIdentifierForObject:(NSManagedObject *)object {
	static NSString *CellIdentifier = @"LeaderBoardCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBBoardData";
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"leaderBoard = %@ && year = %@", [(WBLeaderBoardParentDataSource *)self.parentDataSource selectedLeaderBoard], [WBYear thisYear]];
}

// Cells should expand if there is a detailValue for this leaderboard
- (BOOL)shouldExpand {
	NSString *detail = [(WBBoardData *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] detailValue];
	return detail && ![detail isEqualToString:@""];
}

- (CGFloat)expandedCellHeight {
	return CELL_EXPAND_HEIGHT;
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	NSSortDescriptor *nameSortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"peopleEntity.name" ascending:YES];
	return @[sortOrderDescriptor, nameSortOrderDescriptor];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBBoardData *data = (WBBoardData *)object;
	WBLeaderBoardCell *leaderBoardCell = (WBLeaderBoardCell *)cell;
	[leaderBoardCell configureCellForBoardData:data];
}

@end
