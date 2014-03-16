//
//  WBMatchupResultDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBMatchupResultDataSource.h"
#import "WBAppDelegate.h"
#import "WBCoreDataManager.h"
#import "WBMatchupResultCell.h"
#import "WBModels.h"
#import "WBNotifications.h"
#import "WBProfileTableViewController.h"
#import "V8HorizontalPickerView.h"

#define SORT_KEY @"matchComplete"

#define HEADER_HEIGHT 44.0f

@interface WBMatchupResultDataSource () <V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *weekTitleArray;
@property (strong, nonatomic) NSMutableArray *seasonIndexArray;

@property (strong, nonatomic) V8HorizontalPickerView *pickerView;

@end

@implementation WBMatchupResultDataSource

- (id)initWithViewController:(UIViewController *)aViewController {
	self = [super initWithViewController:aViewController];
	if (self) {
		NSArray *weeks = [WBWeek findWithPredicate:[NSPredicate predicateWithFormat:@"year = %@", [WBYear thisYear]] sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
		self.weekTitleArray = [NSMutableArray array];
		self.seasonIndexArray = [NSMutableArray array];
		
		NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"M/dd"];
		for (WBWeek *week in weeks) {
			if (week.teamMatchups && week.teamMatchups.count > 0) {
				[self.weekTitleArray addObject:[dateFormatter stringFromDate:week.date]];
				[self.seasonIndexArray addObject:week.seasonIndex];
			}
		}
	}
	return self;
}

- (V8HorizontalPickerView *)pickerView {
	if (!_pickerView) {
		UITableView *tableView = [(UITableViewController *)self.viewController tableView];
		_pickerView = [[V8HorizontalPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, HEADER_HEIGHT)];
		_pickerView.backgroundColor = [UIColor whiteColor];
		_pickerView.selectedTextColor = kEmeraldColor;
		_pickerView.textColor = [UIColor grayColor];
		_pickerView.delegate = self;
		_pickerView.dataSource = self;
		_pickerView.elementFont = [UIFont boldSystemFontOfSize:14.0f];
		_pickerView.selectionPoint = CGPointMake(ceil(tableView.bounds.size.width / 2), 0);
		[_pickerView scrollToElement:[self.weekTitleArray count] - 1 animated:NO];
		
		// add carat or other view to indicate selected element
		UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator"]];
		indicator.image = [indicator.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		[indicator setTintColor:kEmeraldColor];
		_pickerView.selectionIndicatorView = indicator;
	}
	return _pickerView;
}

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
	NSInteger seasonIndex = 0;
	if (self.pickerView) {
		seasonIndex = [self.seasonIndexArray[self.pickerView.currentSelectedIndex] integerValue];
	} else {
		seasonIndex = [[self.seasonIndexArray lastObject] integerValue];
	}
	
	return [NSPredicate predicateWithFormat:@"week.seasonIndex = %@", [NSNumber numberWithInteger:seasonIndex]];
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sortOrderDescriptor];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBTeamMatchup *matchup = (WBTeamMatchup *)object;
	WBMatchupResultCell *resultCell = (WBMatchupResultCell *)cell;
	[resultCell configureCellForMatchup:matchup];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return self.pickerView;
}

#pragma mark - HorizontalPickerView DataSource Methods

- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
	return [self.weekTitleArray count];
}

#pragma mark - HorizontalPickerView Delegate Methods

- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
	return [self.weekTitleArray objectAtIndex:index];
}

- (NSInteger)horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
	CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
	NSString *text = [self.weekTitleArray objectAtIndex:index];
	NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]};
	CGRect textRect = [text boundingRectWithSize:constrainedSize
										 options:NSStringDrawingUsesLineFragmentOrigin
									  attributes:attributes
										 context:nil];
	return textRect.size.width + 20.0f;
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
	[self resetDataSource];
}

- (void)resetDataSource {
	self.fetchedResultsController = nil;
	[self beginFetch];
	
	[[(UITableViewController *)self.viewController tableView] reloadData];
}

@end
