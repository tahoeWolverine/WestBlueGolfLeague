//
//  WBEntityDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBEntityDataSource.h"
#import "WBAppDelegate.h"
#import "WBCoreDataManager.h"

#define CELL_HEIGHT 40.0f
#define CELL_EXPAND_HEIGHT 90.0f

@interface WBEntityDataSource () {
	NSFetchedResultsController *_fetchedResultsController;
}

@property (weak, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) NSMutableDictionary *selectedIndexes;

@end

@implementation WBEntityDataSource

+ (id)dataSourceWithViewController:(UIViewController *)aViewController {
	return [[self alloc] initWithViewController:aViewController];
}

- (id)initWithViewController:(UIViewController *)aViewController {
	self = [super init];
	if (self) {
		_viewController = aViewController;
		_selectedIndexes = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)beginFetch {
	if ([(WBAppDelegate *)[UIApplication sharedApplication].delegate loading]) {
		return;
	}
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		ALog(@"Unresolved error %@, %@", error, [error userInfo]);
		[WBCoreDataManager logError:error];
	}
}

#pragma mark - Abstract methods to implement

- (NSString *)cellIdentifier {
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [[self.fetchedResultsController sections] count];
    
	if (count == 0) {
		count = 1;
	}
	
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
	
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier] forIndexPath:indexPath];
    
	[self configureCell:cell withObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	ALog(@"Derived class did not implement configureCell");
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
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Toggle 'selected' state
	if ([self shouldExpand]) {
		BOOL isSelected = ![self cellIsSelected:indexPath];

		// Store cell 'selected' state keyed on indexPath
		NSNumber *selected = [NSNumber numberWithBool:isSelected];
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - NSFetchedResultsControllerDelegate

- (UITableView *)tableView {
	if (self.isConnectedToTableView) {
		return [(id)self.viewController tableView];
	}
	return nil;
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
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath]
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

@end
