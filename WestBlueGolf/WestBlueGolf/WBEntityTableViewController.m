//
//  WBEntityTableViewController.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/23/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBEntityTableViewController.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
#import "WBEntityDetailViewController.h"

#define SORT_KEY @"name"

@interface WBEntityTableViewController () {
	NSFetchedResultsController *_fetchedResultsController;
}

@end

@implementation WBEntityTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		ALog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Abstract methods to implement

- (NSString *)cellIdentifier {
	return nil;
}

- (NSString *)entityName {
	return nil;
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sortOrderDescriptor];
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
    
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
		  atIndexPath:(NSIndexPath *)indexPath {
	ALog(@"Derived class did not implement configureCell");
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
        
        [fetchRequest setSortDescriptors:[self sortDescriptorsForFetch]];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																									managedObjectContext:[self managedObjectContext]
																									  sectionNameKeyPath:nil
																											   cacheName:@"nil"];
        aFetchedResultsController.delegate = self;
        _fetchedResultsController = aFetchedResultsController;
    }
	
	return _fetchedResultsController;
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

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	WBEntityDetailViewController *vc = [segue destinationViewController];
	vc.selectedEntity = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
}

@end
