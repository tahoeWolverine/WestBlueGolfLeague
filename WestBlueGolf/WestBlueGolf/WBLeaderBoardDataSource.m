//
//  WBLeaderBoardDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBLeaderBoardDataSource.h"
#import "WBCoreDataManager.h"
//#import "WBLeaderBoardCell.h"
#import "WBModels.h"

//#define SECTION_KEY
#define SORT_KEY @"tablePriority"

@interface WBLeaderBoardDataSource ()
@end

@implementation WBLeaderBoardDataSource

#pragma mark - WBEntityTableViewController methods to implement

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"LeaderBoardCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBBoardData";
}

- (NSString *)sectionNameKeyPath {
	return nil;
}

- (NSPredicate *)fetchPredicate {
	return nil;
}

- (NSArray *)sortDescriptorsForFetch {
	//NSSortDescriptor *sectionSortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SECTION_KEY ascending:NO];
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sortOrderDescriptor];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	//WBBoardData *data = (WBBoardData *)object;
	//WBLeaderBoardCell *leaderBoardCell = (WBLeaderBoardCell *)cell;
	//[leaderBoardCell configureCellForBoardData:data];
}

@end
