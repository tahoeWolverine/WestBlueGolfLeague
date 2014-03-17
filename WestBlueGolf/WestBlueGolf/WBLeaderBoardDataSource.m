//
//  WBLeaderBoardDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBLeaderBoardDataSource.h"
#import "WBCoreDataManager.h"
#import "WBLeaderBoardCell.h"
#import "WBLeaderBoardTableViewController.h"
#import "WBModels.h"

#define SECTION_KEY @"peopleEntity.me"
#define SORT_KEY @"rank"

typedef enum {
	WBLeaderBoardSectionMe,
	WBLeaderBoardSectionOthers
} WBLeaderBoardSection;

@interface WBLeaderBoardDataSource ()

@end

@implementation WBLeaderBoardDataSource

#pragma mark - WBEntityDataSource methods to implement

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"LeaderBoardCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBBoardData";
}

- (NSString *)sectionNameKeyPath {
	return SECTION_KEY;
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"leaderBoard = %@ && year = %@", [(WBLeaderBoardTableViewController *)self.viewController selectedLeaderboard], [WBYear thisYear]];
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sectionSortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SECTION_KEY ascending:NO];
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	NSSortDescriptor *nameSortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"peopleEntity.name" ascending:YES];
	return @[sectionSortOrderDescriptor, sortOrderDescriptor, nameSortOrderDescriptor];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBBoardData *data = (WBBoardData *)object;
	WBLeaderBoardCell *leaderBoardCell = (WBLeaderBoardCell *)cell;
	[leaderBoardCell configureCellForBoardData:data];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSInteger sectionCount = [self.fetchedResultsController.sections count];
	if (sectionCount == 2) {
		if (section == WBLeaderBoardSectionMe) {
			return @"My Rank";
		} else {
			return @"Leaderboard Ranks";
		}
	}
	
	return nil;
}

@end
