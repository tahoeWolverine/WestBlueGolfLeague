//
//  WBMatchupResultDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBMatchupResultDataSource.h"
#import "WBCoreDataManager.h"
#import "WBMatchupResultCell.h"
#import "WBModels.h"
#import "WBNotifications.h"
#import "WBProfileTableViewController.h"

//#define SECTION_KEY
#define SORT_KEY @"matchComplete"

@interface WBMatchupResultDataSource ()
@end

@implementation WBMatchupResultDataSource

#pragma mark - WBEntityDataSource methods to implement

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"MatchupListCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBTeamMatchup";
}

- (NSString *)sectionNameKeyPath {
	return nil;
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"week.seasonIndex = 16"];
}

- (NSArray *)sortDescriptorsForFetch {
	//NSSortDescriptor *sectionSortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SECTION_KEY ascending:NO];
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sortOrderDescriptor];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBTeamMatchup *matchup = (WBTeamMatchup *)object;
	WBMatchupResultCell *resultCell = (WBMatchupResultCell *)cell;
	[resultCell configureCellForMatchup:matchup];
}

@end
