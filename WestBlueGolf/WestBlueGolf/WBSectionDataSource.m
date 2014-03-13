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

@interface WBSectionDataSource () {
	NSFetchedResultsController *_fetchedResultsController;
}

@property (weak, nonatomic) WBMultiFetchDataSource *parentDataSource;

@end

@implementation WBSectionDataSource

- (WBMultiFetchDataSource *)dataSourceWithParentDataSource:(WBMultiFetchDataSource *)parentDataSource {
	return (WBMultiFetchDataSource *)[self initWithParentDataSource:parentDataSource];
}

- (id)initWithParentDataSource:(WBMultiFetchDataSource *)parentDataSource {
	self = [super init];
	if (self) {
		_parentDataSource = parentDataSource;
	}
	return self;
}

- (void)beginFetch {
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		ALog(@"Unresolved error %@, %@", error, [error userInfo]);
		[WBCoreDataManager logError:error];
	}
}

#pragma mark - Overridable methods

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier] forIndexPath:indexPath];
    
	[self configureCell:cell withObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    return cell;
}

#pragma mark - Fetched results controller

- (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

- (NSFetchedResultsController *)fetchedResultsController {
    // Set up the fetched results controller if needed.
    if (_fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:[self managedObjectContext]];
        [fetchRequest setEntity:entity];
		[fetchRequest setPredicate:[self fetchPredicate]];
        
        [fetchRequest setSortDescriptors:[self sortDescriptorsForFetch]];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																									managedObjectContext:[self managedObjectContext]
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
