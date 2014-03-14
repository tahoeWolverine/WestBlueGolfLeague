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

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation WBMatchupResultDataSource

- (id)initWithViewController:(UIViewController *)aViewController {
	self = [super initWithViewController:aViewController];
	if (self) {
		self.titleArray = @[@"7/29", @"8/12", @"8/19", @"8/26"];
	}
	return self;
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
	return [NSPredicate predicateWithFormat:@"week.seasonIndex = 16"];
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
	V8HorizontalPickerView *view = [[V8HorizontalPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, HEADER_HEIGHT)];
	view.backgroundColor   = [UIColor whiteColor];
	view.selectedTextColor = kEmeraldColor;
	view.textColor   = [UIColor grayColor];
	view.delegate    = self;
	view.dataSource  = self;
	view.elementFont = [UIFont boldSystemFontOfSize:14.0f];
	view.selectionPoint = CGPointMake(ceil(tableView.bounds.size.width / 2), 0);
	[view scrollToElement:3 animated:NO];
	
	// add carat or other view to indicate selected element
	
	UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator"]];
	indicator.image = [indicator.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[indicator setTintColor:kEmeraldColor];
	view.selectionIndicatorView = indicator;
	return view;
}

#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
	return [self.titleArray count];
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
	return [self.titleArray objectAtIndex:index];
}

- (NSInteger)horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
	CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
	NSString *text = [self.titleArray objectAtIndex:index];
	NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]};
	CGRect textRect = [text boundingRectWithSize:constrainedSize
										 options:NSStringDrawingUsesLineFragmentOrigin
									  attributes:attributes
										 context:nil];
	return textRect.size.width + 20.0f;
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
	//self.infoLabel.text = [NSString stringWithFormat:@"Selected index %ld", (long)index];
}

@end
