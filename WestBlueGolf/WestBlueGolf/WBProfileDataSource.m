//
//  WBProfileDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBProfileDataSource.h"
#import "WBAppDelegate.h"
#import "WBModels.h"
#import "WBNotifications.h"
#import "WBProfileTableViewController.h"
#import "WBResultTableViewCell.h"

#define SORT_KEY @"match.teamMatchup.week.date"

@interface WBProfileDataSource () {
}

@end

@implementation WBProfileDataSource

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

- (WBPlayer *)selectedPlayer {
	if (!_selectedPlayer) {
		_selectedPlayer = [WBPlayer me];
		[(WBProfileTableViewController *)self.viewController setTabName:_selectedPlayer ? [_selectedPlayer firstName] : @"You"];
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
	return [NSPredicate predicateWithFormat:@"player = %@ && match.teamMatchup.week.year = %@", self.selectedPlayer, [WBYear thisYear]];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
    WBResult *result = (WBResult *)object;
	WBResultTableViewCell *resultCell = (WBResultTableViewCell *)cell;
	[resultCell configureCellForResult:result];
}

@end
