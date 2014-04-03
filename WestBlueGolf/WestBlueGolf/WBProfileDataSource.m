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

#define CELL_HEIGHT 40.0f

@interface WBProfileDataSource () {
}

@property (strong, nonatomic) NSMutableDictionary *selectedIndexes;

@end

@implementation WBProfileDataSource

- (id)initWithViewController:(UIViewController *)aViewController {
	self = [super initWithViewController:aViewController];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(resetYear)
													 name:WBYearChangedLoadingFinishedNotification
												   object:nil];
		self.selectedIndexes = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (BOOL)cellIsSelected:(NSIndexPath *)indexPath {
	// Return whether the cell at the specified index path is selected or not
	NSNumber *selectedIndex = [self.selectedIndexes objectForKey:indexPath];
	return [selectedIndex boolValue];
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

#pragma mark - Grow code

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat factor = 1.0;
	if ([self cellIsSelected:indexPath]) {
		factor = 2.0;
	}
	return CELL_HEIGHT * factor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Deselect cell
	[tableView deselectRowAtIndexPath:indexPath animated:TRUE];
	
	// Toggle 'selected' state
	BOOL isSelected = ![self cellIsSelected:indexPath];
	
	// Store cell 'selected' state keyed on indexPath
	NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
	[self.selectedIndexes setObject:selectedIndex forKey:indexPath];
	
	// This is where magic happens...
	[tableView beginUpdates];
	[tableView endUpdates];
}

@end
