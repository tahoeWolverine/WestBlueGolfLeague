//
//  WBEntityDetailViewController.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/24/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBEntityDetailViewController.h"
#import "WBCoreDataManager.h"
#import "WBEntityDataSource.h"
#import "WBModels.h"
#import "WBResultTableViewCell.h"

@interface WBEntityDetailViewController () {
	//NSFetchedResultsController *_fetchedResultsController;
}

@property (strong, nonatomic) WBEntityDataSource *dataSource;

@end

@implementation WBEntityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.dataSource = [WBEntityDataSource dataSourceWithViewController:self];

	[self.dataSource beginFetch];
}
/*
- (void)beginFetch {
    NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		ALog(@"Unresolved error %@, %@", error, [error userInfo]);
		[WBCoreDataManager logError:error];
	}
}*/

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.navigationItem.title = [self selectedEntityName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Abstract methods to implement

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"ProfileResultsCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBResult";
}

- (NSArray *)sortDescriptorsForFetch {
	return nil;
}

- (NSPredicate *)fetchPredicate {
	return nil;
}

- (NSString *)selectedEntityName {
	return nil;
}

#pragma mark - Table view data source
/*
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
}*/
/*
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
		
		NSPredicate *predicate = [self fetchPredicate];
		if (predicate) {
			[fetchRequest setPredicate:predicate];
		}
        
        [fetchRequest setSortDescriptors:[self sortDescriptorsForFetch]];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																									managedObjectContext:[self managedObjectContext]
																									  sectionNameKeyPath:nil
																											   cacheName:nil];
        aFetchedResultsController.delegate = self;
        _fetchedResultsController = aFetchedResultsController;
    }
	
	return _fetchedResultsController;
}*/

- (void)resetTableAndFetchedResultsController {
	self.dataSource.fetchedResultsController = nil;
	[self.dataSource beginFetch];
	
	[self.tableView reloadData];
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
	vc.selectedEntity = [self.dataSource objectAtIndexPath:self.tableView.indexPathForSelectedRow];
}

@end
