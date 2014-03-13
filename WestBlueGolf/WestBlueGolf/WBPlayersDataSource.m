//
//  WBPlayersDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBPlayersDataSource.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
#import "WBNotifications.h"
#import "WBProfileTableViewController.h"

#define SECTION_KEY @"favorite"
#define SORT_KEY @"name"

typedef enum {
	WBPlayerSectionFavorites,
	WBPlayerSectionPlayers
} WBPlayerSection;

@interface WBPlayersDataSource ()
@end

@implementation WBPlayersDataSource

#pragma mark - WBEntityDataSource methods to implement

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"PlayerListCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBPlayer";
}

- (NSString *)sectionNameKeyPath {
	return SECTION_KEY;
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sectionSortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SECTION_KEY ascending:NO];
	NSSortDescriptor *nameSortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sectionSortOrderDescriptor, nameSortOrderDescriptor];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBPlayer *player = (WBPlayer *)object;
    cell.textLabel.text = player.name;
	cell.detailTextLabel.text = player.team.name;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSInteger sectionCount = [self.fetchedResultsController.sections count];
	if (sectionCount == 2 && section == WBPlayerSectionFavorites) {
		return @"Favorite Players";
	} else {
		return @"All Players";
	}
	
	return nil;
}

@end
