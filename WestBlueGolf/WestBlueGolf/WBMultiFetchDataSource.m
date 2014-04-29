//
//  WBMultiFetchDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/13/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBMultiFetchDataSource.h"
#import "WBSectionDataSource.h"

@interface WBMultiFetchDataSource ()

@property (weak, nonatomic) UIViewController *viewController;

@property (strong, nonatomic) NSMutableArray *sectionDataSources;

@end

@implementation WBMultiFetchDataSource

+ (id)dataSourceWithViewController:(UIViewController *)aViewController {
	return [[self alloc] initWithViewController:aViewController];
}

- (id)initWithViewController:(UIViewController *)aViewController {
	self = [super init];
	if (self) {
		self.viewController = aViewController;
		self.sectionDataSources = [NSMutableArray array];
	}
	return self;
}

- (void)beginFetch {
	for (WBSectionDataSource *dataSource in self.sectionDataSources) {
		[dataSource beginFetch];
	}
}

- (void)addSectionDataSource:(WBSectionDataSource *)dataSource {
	[self.sectionDataSources addObject:dataSource];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionDataSources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionDataSources[section] tableView:tableView numberOfRowsInSection:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	WBSectionDataSource *sectionDataSource = self.sectionDataSources[indexPath.section];
	NSManagedObject *object = [sectionDataSource.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[sectionDataSource cellIdentifierForObject:object] forIndexPath:indexPath];
	
	[sectionDataSource configureCell:cell withObject:object];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self.sectionDataSources[indexPath.section] tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.sectionDataSources[indexPath.section] tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
}

- (WBSectionDataSource *)dataSourceForSegueIdentifier:(NSString *)segueIdentifier {
	for (WBSectionDataSource *dataSource in self.sectionDataSources) {
		if ([[dataSource supportedSegueIdentifier] isEqualToString:segueIdentifier]) {
			return dataSource;
		}
	}
	
	return nil;
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	WBSectionDataSource *sectionDataSource = [self dataSourceForSegueIdentifier:segue.identifier];
	if (sectionDataSource) {
		[sectionDataSource prepareForSegue:segue sender:sender];
	}
}

@end
