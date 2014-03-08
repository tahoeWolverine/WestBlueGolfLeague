//
//  WBTeamBoardDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamBoardDataSource.h"
#import "WBCoreDataManager.h"
//#import "WBMatchupResultCell.h"
#import "WBModels.h"
//#import "WBProfileTableViewController.h"

//#define SECTION_KEY
#define SORT_KEY @"tablePriority"

@interface WBTeamBoardDataSource ()
@end

@implementation WBTeamBoardDataSource

#pragma mark - WBEntityTableViewController methods to implement

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"TeamBoardListCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBTeamBoard";
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
	//WBTeamMatchup *matchup = (WBTeamMatchup *)object;
	//WBMatchupResultCell *resultCell = (WBMatchupResultCell *)cell;
	//[resultCell configureCellForMatchup:matchup];
}

@end
