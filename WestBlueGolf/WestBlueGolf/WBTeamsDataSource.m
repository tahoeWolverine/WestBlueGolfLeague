//
//  WBTeamsDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamsDataSource.h"
#import "WBModels.h"
#import "WBNotifications.h"
#import "WBProfileTableViewController.h"
#import "WBTeamProfileTableViewController.h"

#define SORT_KEY @"name"
#define SECTION_KEY @"me"

@implementation WBTeamsDataSource

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
	static NSString *CellIdentifier = @"TeamListCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBTeam";
}

- (NSString *)sectionNameKeyPath {
	return SECTION_KEY;
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"ANY matchups.week.year = %@ && real = 1", [WBYear thisYear]];
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sectionSortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SECTION_KEY ascending:NO];
	NSSortDescriptor *nameSortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sectionSortOrderDescriptor, nameSortOrderDescriptor];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBTeam *team = (WBTeam *)object;
	cell.textLabel.text = team.name;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSInteger sectionCount = [self.fetchedResultsController.sections count];
	if (sectionCount == 2 && section == 0) {
		return @"My Team";
	} else {
		return @"Teams";
	}
	
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.viewController.splitViewController) {
		UIViewController *vc = nil;
		for (UINavigationController *nc in self.viewController.splitViewController.viewControllers) {
			vc = [nc topViewController];
			if (vc != self.viewController) {
                WBTeam *team = [[(WBEntityDataSource *)tableView.dataSource fetchedResultsController] objectAtIndexPath:tableView.indexPathForSelectedRow];
				if ([vc isKindOfClass:[WBProfileTableViewController class]]) {
					UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
                    UIViewController *sbvc = [storyboard instantiateViewControllerWithIdentifier:@"TeamProfileView"];
					WBTeamProfileTableViewController *teamVc = (WBTeamProfileTableViewController *)sbvc;
                    [teamVc setSelectedTeam:team];
					[nc setViewControllers:@[teamVc]];
				} else if ([vc isKindOfClass:[WBTeamProfileTableViewController class]]) {
					[(WBTeamProfileTableViewController *)vc setSelectedTeam:team];
				}
			}
		}
	}
	
	//[tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

@end
