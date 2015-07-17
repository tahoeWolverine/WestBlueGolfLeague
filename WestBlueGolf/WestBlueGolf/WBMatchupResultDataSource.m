//
//  WBMatchupResultDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBMatchupResultDataSource.h"
#import "WBAppDelegate.h"
#import "WBMatchupResultCell.h"
#import "WBModels.h"
#import "WBNotifications.h"
#import "WBWeekTableViewController.h"
#import "V8HorizontalPickerView.h"

#define SORT_KEY	@"matchId"
#define SECTION_KEY	@"playoffType"

#define HEADER_HEIGHT 44.0f

#define CELL_HEIGHT 70.0f
#define CELL_EXPAND_HEIGHT 220.0f

@interface WBMatchupResultDataSource () <V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *weekTitleArray;
@property (strong, nonatomic) NSMutableArray *seasonIndexArray;

@property (strong, nonatomic) V8HorizontalPickerView *pickerView;

@end

@implementation WBMatchupResultDataSource

- (id)initWithViewController:(UIViewController *)aViewController {
	self = [super initWithViewController:aViewController];
	if (self) {
		[self createWeekArrays];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(resetYear)
													 name:WBYearChangedLoadingFinishedNotification
												   object:nil];
		
		//[[(WBWeekTableViewController *)aViewController tableView] setTableFooterView:[self footerView]];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createWeekArrays {
	NSArray *weeks = [WBWeek findWithPredicate:[NSPredicate predicateWithFormat:@"year = %@", [WBYear thisYear]] sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
	self.weekTitleArray = [NSMutableArray array];
	self.seasonIndexArray = [NSMutableArray array];
	
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"M/dd"];
	for (WBWeek *week in weeks) {
		if (![week alreadyTookPlace] || (week.teamMatchups && week.teamMatchups.count > 0)) {
			[self.weekTitleArray addObject:[dateFormatter stringFromDate:week.date]];
			[self.seasonIndexArray addObject:week.seasonIndex];
		}
	}
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
		
		// Starting element
		WBWeek *thisWeek = (WBWeek *)[WBWeek findFirstRecordWithPredicate:[NSPredicate predicateWithFormat:@"ANY teamMatchups.matchComplete = 0 && year = %@", [WBYear thisYear]] sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:@"seasonIndex" ascending:YES]]];
		NSInteger index = -1;
		if (thisWeek) {
			index = [self.seasonIndexArray indexOfObject:thisWeek.seasonIndex];
		} else {
			index = [self.seasonIndexArray indexOfObject:[self.seasonIndexArray lastObject]];
		}
		[_pickerView scrollToElement:index animated:NO];
		
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

- (NSString *)incompleteCellIdentifier {
	static NSString *IncompleteCellIdentifier = @"IncompleteMatchupListCell";
	return IncompleteCellIdentifier;
}

- (NSString *)entityName {
	return @"WBTeamMatchup";
}

- (NSString *)sectionNameKeyPath {
	return SECTION_KEY;
}

- (CGFloat)cellHeight {
	return CELL_HEIGHT;
}

- (CGFloat)expandedCellHeight {
	return CELL_EXPAND_HEIGHT;
}

- (BOOL)shouldExpand {
	return YES;
}

- (NSPredicate *)fetchPredicate {
	NSInteger seasonIndex = 0;
	if (self.seasonIndexArray && self.seasonIndexArray.count > 0) {
		if (self.pickerView && self.pickerView.currentSelectedIndex < 20) {
			seasonIndex = [self.seasonIndexArray[self.pickerView.currentSelectedIndex] integerValue];
		} else {
			seasonIndex = [[self.seasonIndexArray lastObject] integerValue];
		}
	}
	
	//DLog(@"seasonIndex is %ld", (long)seasonIndex);
	WBWeek *week = (WBWeek *)[WBWeek findFirstRecordWithFormat:@"seasonIndex = %@ && year = %@", [NSNumber numberWithInteger:seasonIndex], [WBYear thisYear]];
	if (week.isBadDataValue) {
		//TODO: bad data week
		DLog(@"Week has bad data");
	}
	
	return [NSPredicate predicateWithFormat:@"week = %@", week];
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sectionSort = [[NSSortDescriptor alloc] initWithKey:SECTION_KEY ascending:YES];
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sectionSort, sortOrderDescriptor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WBTeamMatchup *matchup = (WBTeamMatchup *)[self.fetchedResultsController objectAtIndexPath:indexPath];
	NSString *identifier = [matchup scoringComplete] ? [self cellIdentifier] : [self incompleteCellIdentifier];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
	
	[self configureCell:cell withObject:matchup];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBTeamMatchup *matchup = (WBTeamMatchup *)object;
	WBMatchupResultCell *resultCell = (WBMatchupResultCell *)cell;
	[resultCell configureCellForMatchup:matchup];
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return HEADER_HEIGHT;
}*/

- (WBWeek *)selectedWeek {
	return [WBWeek findWeekWithSeasonIndex:[self selectedSeasonIndex] year:[WBYear thisYear]];
}

- (NSInteger)selectedSeasonIndex {
	if (self.pickerView.currentSelectedIndex > 20) {
		return -1;
	}
	return [self.seasonIndexArray[self.pickerView.currentSelectedIndex] integerValue];
}

/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (!self.weekTitleArray || self.weekTitleArray.count == 0) {
		UILabel *noWeeks = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, HEADER_HEIGHT)];
		noWeeks.text = @"No Weeks Found";
		noWeeks.textAlignment = NSTextAlignmentCenter;
		return noWeeks;
	}
	
	return self.pickerView;
}*/

/*
This method seems bugged so we alloc the table with a footer initially
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	[self footerView];
}*/

- (UIView *)headerView {
	return self.pickerView;
}

- (UIView *)footerView {
	NSString *courseName = [self selectedWeek].course.name;
	if (!courseName || [courseName isEqualToString:@""]) {
		UILabel *noWeeks = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.viewController.view.bounds.size.width, HEADER_HEIGHT)];
		noWeeks.text = @"No Weeks Found";
		noWeeks.textAlignment = NSTextAlignmentCenter;
		return noWeeks;
	}
	
	WBWeekTableViewController *vc = (WBWeekTableViewController *)self.viewController;
	UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, vc.tableView.bounds.size.width, 44.0f)];
	UILabel *courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0, 160.0f, 44.0f)];
	courseLabel.text = [NSString stringWithFormat:@"Course: %@", courseName];
	UILabel *matchupsLabel = [[UILabel alloc] initWithFrame:CGRectMake(188.0f, 0.0, 112.0f, 44.0f)];
	matchupsLabel.text = [NSString stringWithFormat:@"Pairs: %@", [[self selectedWeek] pairingLabel]];
	[newView addSubview:courseLabel];
	[newView addSubview:matchupsLabel];
	return newView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (!self.fetchedResultsController.sections || self.fetchedResultsController.sections.count == 0) {
		return nil;
	}
	
	WBTeamMatchup *example = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
	switch (example.playoffTypeValue) {
		case WBPlayoffTypeNone:
			return nil;
		case WBPlayoffTypeChampionship:
			return @"Championship";
		case WBPlayoffTypeBronze:
			return @"Third Place";
		case WBPlayoffTypeConsolation:
			return @"Consolation";
		case WBPlayoffTypeLexis:
			return @"Lexis Nexis";
		default:
			ALog(@"Unkown playoff type");
			break;
	}
	
	return nil;
}

#pragma mark - HorizontalPickerView DataSource Methods

- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
	return [self.weekTitleArray count];
}

#pragma mark - HorizontalPickerView Delegate Methods

- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
    if (self.weekTitleArray.count < index) {
        return @"-/-";
    }
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
	[self resetSelectedCells];
	[self beginFetch];
	
	WBWeekTableViewController *vc = (WBWeekTableViewController *)self.viewController;
	[[vc tableView] reloadData];

	// Reset the pickerview header
	[self.pickerView removeFromSuperview];
	[vc.headerView addSubview:[self headerView]];
	for (UIView *view in vc.footerView.subviews) {
		[view removeFromSuperview];
	}
	[vc.footerView addSubview:[self footerView]];
}

- (void)resetYear {
	self.weekTitleArray = nil;
	self.seasonIndexArray = nil;
	self.pickerView = nil;
	[self createWeekArrays];
	[self resetDataSource];
}

@end
