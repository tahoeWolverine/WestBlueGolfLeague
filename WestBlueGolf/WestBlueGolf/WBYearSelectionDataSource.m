//
//  WBYearSelectionDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/13/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBYearSelectionDataSource.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "WBAppDelegate.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
#import "WBNotifications.h"

#define SORT_KEY @"value"

@implementation WBYearSelectionDataSource

- (id)initWithViewController:(UIViewController *)aViewController {
	self = [super initWithViewController:aViewController];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(hideLoadingView)
													 name:WBYearChangedLoadingFinishedNotification
												   object:nil];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hideLoadingView {
	[self performSelector:@selector(hideProgress) withObject:nil afterDelay:3.0];
}

- (void)hideProgress {
	[MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
}

#pragma mark - WBEntityDataSource methods to implement

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"YearListCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBYear";
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:NO];
	return @[sortOrderDescriptor];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBYear *year = (WBYear *)object;
    cell.textLabel.text = [NSString stringWithFormat:@"%@", year.value];
	cell.accessoryType = [WBYear thisYear] == year ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	WBYear *year = (WBYear *)[self objectAtIndexPath:indexPath];
	if ([year needsRefresh]) {
		[MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
	}

	[(WBAppDelegate *)[UIApplication sharedApplication].delegate setThisYearValue:year.valueValue inContext:[[WBCoreDataManager sharedManager] managedObjectContext]];
	[tableView reloadData];
}

@end
