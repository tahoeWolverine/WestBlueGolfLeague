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
#import "WBEntityDataSource.h"
#import "WBEntityDetailViewController.h"
#import "WBPlayersDataSource.h"
#import "WBTeamsDataSource.h"

@interface WBEntityTableViewController ()
@property (assign, nonatomic) BOOL isInPlayerMode;
@property (strong, nonatomic) WBPlayersDataSource *playersDataSource;
@property (strong, nonatomic) WBTeamsDataSource *teamsDataSource;

@end

@implementation WBEntityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
	self.playersDataSource = [WBPlayersDataSource dataSourceWithViewController:self];
	self.teamsDataSource = [WBTeamsDataSource dataSourceWithViewController:self];

	// Run an initial switchTables to get into player mode
	[self switchTables:NO];
}

- (void)switchTables:(BOOL)reload {
	if (self.isInPlayerMode) {
	
		self.tableView.dataSource = self.teamsDataSource;
		self.tableView.delegate = self.teamsDataSource;
		self.teamsDataSource.isConnectedToTableView = YES;
		self.playersDataSource.isConnectedToTableView = NO;
	
		if ([[self.teamsDataSource.fetchedResultsController fetchedObjects] count] == 0) {
			[self.teamsDataSource beginFetch];
		}
		
		self.isInPlayerMode = NO;
	} else {
		self.tableView.dataSource = self.playersDataSource;
		self.tableView.delegate = self.playersDataSource;
		self.teamsDataSource.isConnectedToTableView = NO;
		self.playersDataSource.isConnectedToTableView = YES;

		if ([[self.playersDataSource.fetchedResultsController fetchedObjects] count] == 0) {
			[self.playersDataSource beginFetch];
		}
		
		self.isInPlayerMode = YES;
	}
	
	if (reload) {
		[self.tableView reloadData];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentedControlChanged:(id)sender {
	UISegmentedControl *control = (UISegmentedControl *)sender;
	if ((control.selectedSegmentIndex == 0 && !self.isInPlayerMode) ||
		(control.selectedSegmentIndex == 1 && self.isInPlayerMode)) {
		[self switchTables:YES];
	}
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	WBEntityDetailViewController *vc = [segue destinationViewController];
	vc.selectedEntity = [[(WBEntityDataSource *)self.tableView.dataSource fetchedResultsController] objectAtIndexPath:self.tableView.indexPathForSelectedRow];
	
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

@end
