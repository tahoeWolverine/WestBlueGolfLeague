//
//  WBYearSelectionDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/13/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBYearSelectionDataSource.h"
#import "WBAppDelegate.h"
#import "WBModels.h"

#define SORT_KEY @"value"

@implementation WBYearSelectionDataSource

#pragma mark - WBEntityDataSource methods to implement

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"YearListCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBYear";
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
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
	[(WBAppDelegate *)[UIApplication sharedApplication].delegate setThisYearValue:year.valueValue];
	[tableView reloadData];
}

@end
