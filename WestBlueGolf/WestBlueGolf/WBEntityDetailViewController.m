//
//  WBEntityDetailViewController.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/24/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBEntityDetailViewController.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
#import "WBResultTableViewCell.h"
//#import "DHxlsReader.h"

//extern int xls_debug;

@interface WBEntityDetailViewController () {
	NSFetchedResultsController *_fetchedResultsController;
}

@end

@implementation WBEntityDetailViewController

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
	
	//NSString *name = [self selectedEntityName];
	self.selectedEntityNameLabel.text = [self selectedEntityName];
	
	/* XLS Reader test code
	 NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"test.xls"];
	//	NSString *path = @"/tmp/test.xls";
	
	// xls_debug = 1; // good way to see everything in the Excel file
	
	DHxlsReader *reader = [DHxlsReader xlsReaderWithPath:path];
	assert(reader);
	
	NSString *text = @"";
	
	text = [text stringByAppendingFormat:@"AppName: %@\n", reader.appName];
	text = [text stringByAppendingFormat:@"Author: %@\n", reader.author];
	text = [text stringByAppendingFormat:@"Category: %@\n", reader.category];
	text = [text stringByAppendingFormat:@"Comment: %@\n", reader.comment];
	text = [text stringByAppendingFormat:@"Company: %@\n", reader.company];
	text = [text stringByAppendingFormat:@"Keywords: %@\n", reader.keywords];
	text = [text stringByAppendingFormat:@"LastAuthor: %@\n", reader.lastAuthor];
	text = [text stringByAppendingFormat:@"Manager: %@\n", reader.manager];
	text = [text stringByAppendingFormat:@"Subject: %@\n", reader.subject];
	text = [text stringByAppendingFormat:@"Title: %@\n", reader.title];
	
	text = [text stringByAppendingFormat:@"\n\nNumber of Sheets: %u\n", reader.numberOfSheets];
	
#if 0
	[reader startIterator:0];
	
	while(YES) {
		DHcell *cell = [reader nextCell];
		if(cell.type == cellBlank) break;
		
		text = [text stringByAppendingFormat:@"\n%@\n", [cell dump]];
	}
#else
    int row = 2;
    while(YES) {
        DHcell *cell = [reader cellInWorkSheetIndex:0 row:row col:2];
        if(cell.type == cellBlank) break;
        DHcell *cell1 = [reader cellInWorkSheetIndex:0 row:row col:3];
        NSLog(@"\nCell:%@\nCell1:%@\n", [cell dump], [cell1 dump]);
        row++;
		
        //text = [text stringByAppendingFormat:@"\n%@\n", [cell dump]];
        //text = [text stringByAppendingFormat:@"\n%@\n", [cell1 dump]];
    }
#endif
	//textView.text = text;*/
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

- (NSString *)sortDescriptor {
	return nil;
}

- (NSPredicate *)fetchPredicate {
	return nil;
}

- (NSString *)selectedEntityName {
	return nil;
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
		
		NSPredicate *predicate = [self fetchPredicate];
		if (predicate) {
			[fetchRequest setPredicate:predicate];
		}
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:[self sortDescriptor] ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
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
