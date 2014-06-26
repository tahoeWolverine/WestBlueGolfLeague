//
//  WBSectionDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBSectionDataSource.h"
#import "WBCoreDataManager.h"
#import "WBMultiFetchDataSource.h"

#define CELL_HEIGHT 40.0f
#define CELL_EXPAND_HEIGHT 90.0f

@interface WBSectionDataSource () {
	NSFetchedResultsController *_fetchedResultsController;
}

@property (strong, nonatomic) NSMutableDictionary *selectedIndexes;

@end

@implementation WBSectionDataSource

+ (WBSectionDataSource *)dataSourceWithParentDataSource:(WBMultiFetchDataSource *)parentDataSource {
	return (WBSectionDataSource *)[[self alloc] initWithParentDataSource:parentDataSource];
}

- (id)initWithParentDataSource:(WBMultiFetchDataSource *)parentDataSource {
	self = [super init];
	if (self) {
		_parentDataSource = parentDataSource;
		_selectedIndexes = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (NSInteger)section {
	NSInteger i = 0;
	for (WBSectionDataSource *ds in self.parentDataSource.sectionDataSources) {
		if (ds == self) {
			return i;
		}
		i++;
	}
	return -1;
}

- (void)beginFetch {
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		ALog(@"Unresolved error %@, %@", error, [error userInfo]);
		[WBCoreDataManager logError:error];
	}
}

#pragma mark - Overridable methods

- (NSString *)sectionName {
    return nil;
}

- (NSString *)cellIdentifierForObject:(NSManagedObject *)object {
	return nil;
}

- (NSString *)entityName {
	return nil;
}

- (NSArray *)sortDescriptorsForFetch {
	return nil;
}

- (NSString *)sectionNameKeyPath {
	return nil;
}

- (NSPredicate *)fetchPredicate {
	return nil;
}

- (BOOL)shouldExpand {
	return NO;
}

- (CGFloat)cellHeight {
	return CELL_HEIGHT;
}

- (CGFloat)expandedCellHeight {
	return CELL_EXPAND_HEIGHT;
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	ALog(@"Derived class did not implement configureCell");
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger numberOfRows = 0;
	
	if ([[self.fetchedResultsController sections] count] > 0) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
		numberOfRows = [sectionInfo numberOfObjects];
	}

	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForObject:object] forIndexPath:indexPath];

	[self configureCell:cell withObject:object];

	return cell;
}

#pragma mark - Grow code

- (BOOL)cellIsSelected:(NSIndexPath *)indexPath {
	// Return whether the cell at the specified index path is selected or not
	NSNumber *selected = [self.selectedIndexes objectForKey:indexPath];
	//DLog(@"cellIsSelected at %ld: %@", (long)index, !selected ? @"nil" : [selected boolValue] ? @"Yes" : @"No");
	return [selected boolValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	BOOL selected = [self cellIsSelected:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
	return selected ? [self expandedCellHeight] : [self cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Deselect cell
	[tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:[self section]] animated:YES];
	
	// Toggle 'selected' state
	if ([self shouldExpand]) {
		BOOL isSelected = ![self cellIsSelected:indexPath];
		
		// Store cell 'selected' state keyed on indexPath
		NSNumber *selected = [NSNumber numberWithBool:isSelected];
		
		// Hack: create a new index path to make sure that different run-time objects don't get in the way
		[self.selectedIndexes setObject:selected forKey:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
		
		// This is where magic happens...
		[tableView beginUpdates];
		[tableView endUpdates];
	}
}

- (void)resetSelectedCells {
	self.selectedIndexes = [[NSMutableDictionary alloc] init];
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
	// Set up the fetched results controller if needed.
	if (_fetchedResultsController == nil) {
		// Create the fetch request for the entity.
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		// Edit the entity name as appropriate.
		NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:[WBCoreDataManager mainContext]];
		[fetchRequest setEntity:entity];
		[fetchRequest setPredicate:[self fetchPredicate]];

		[fetchRequest setSortDescriptors:[self sortDescriptorsForFetch]];

		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																									managedObjectContext:[WBCoreDataManager mainContext]
																									  sectionNameKeyPath:[self sectionNameKeyPath]
																											   cacheName:nil];
		aFetchedResultsController.delegate = self;
		_fetchedResultsController = aFetchedResultsController;
	}
	
	return _fetchedResultsController;
}

- (NSManagedObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
	return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (UITableView *)tableView {
	return [self.parentDataSource tableView];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {

	UITableView *tableView = [self tableView];
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate: {
			UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			if (cell != nil) {
				[self configureCell:cell withObject:anObject];
			}}
			break;
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type {
	UITableView *tableView = [self tableView];
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
					 withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
					 withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[[self tableView] endUpdates];
}

#pragma mark - Segues

- (NSString *)supportedSegueIdentifier {
	return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	ALog(@"Base class - Please override in subclass");
}

@end
