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
#import "WBPlayerListCell.h"
#import "WBProfileTableViewController.h"
#import "WBTeamProfileTableViewController.h"

#define SECTION_KEY @"favorite"
#define SORT_KEY @"name"

typedef enum {
	WBPlayerSectionFavorites,
	WBPlayerSectionPlayers
} WBPlayerSection;

@interface WBPlayersDataSource ()

@end

@implementation WBPlayersDataSource

- (id)initWithViewController:(UIViewController *)aViewController {
	self = [super initWithViewController:aViewController];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(resetYear)
													 name:WBYearChangedLoadingFinishedNotification
												   object:nil];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resetYear {
	self.fetchedResultsController = nil;
	[self beginFetch];
	
	[[(UITableViewController *)self.viewController tableView] reloadData];
}

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

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"ANY yearData.year = %@", [WBYear thisYear]];
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sectionSortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SECTION_KEY ascending:NO];
	NSSortDescriptor *nameSortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sectionSortOrderDescriptor, nameSortOrderDescriptor];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBPlayer *player = (WBPlayer *)object;
	[(WBPlayerListCell *)cell configureCellForPlayer:player];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.viewController.splitViewController) {
		UIViewController *vc = nil;
		for (UINavigationController *nc in self.viewController.splitViewController.viewControllers) {
			vc = [nc topViewController];
			if (vc != self.viewController) {
				if ([vc isKindOfClass:[WBProfileTableViewController class]]) {
					WBPlayer *player = [[(WBEntityDataSource *)tableView.dataSource fetchedResultsController] objectAtIndexPath:tableView.indexPathForSelectedRow];
					[(WBProfileTableViewController *)vc setSelectedPlayer:player];
				}
			}
		}
	}
	
	//[tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

@end
