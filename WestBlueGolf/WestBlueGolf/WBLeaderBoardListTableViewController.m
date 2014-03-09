//
//  WLeaderBoardListTableViewController.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/7/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBLeaderBoardListTableViewController.h"
#import "WBLeaderBoardTableViewController.h"
#import "WBLeaderBoardListDataSource.h"

@interface WBLeaderBoardListTableViewController ()

@property (assign, nonatomic) BOOL isInPlayerMode;
@property (strong, nonatomic) WBLeaderBoardListDataSource *teamDataSource;
@property (strong, nonatomic) WBLeaderBoardListDataSource *playerDataSource;

@end

@implementation WBLeaderBoardListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.teamDataSource = [WBLeaderBoardListDataSource dataSourceWithViewController:self playerBoard:NO];
	self.playerDataSource = [WBLeaderBoardListDataSource dataSourceWithViewController:self playerBoard:YES];
	
	// Run an initial switchTables to get into team mode (setting it to start on player does this)
	self.isInPlayerMode = YES;
	[self switchTables:NO];
}

- (void)switchTables:(BOOL)reload {
	[NSFetchedResultsController deleteCacheWithName:nil];
	
	if (self.isInPlayerMode) {
		
		self.tableView.dataSource = self.teamDataSource;
		self.tableView.delegate = self.teamDataSource;
		self.teamDataSource.isConnectedToTableView = YES;
		self.playerDataSource.isConnectedToTableView = NO;
		
		if ([[self.teamDataSource.fetchedResultsController fetchedObjects] count] == 0) {
			[self.teamDataSource beginFetch];
		}
		
		self.isInPlayerMode = NO;
	} else {
		self.tableView.dataSource = self.playerDataSource;
		self.tableView.delegate = self.playerDataSource;
		self.teamDataSource.isConnectedToTableView = NO;
		self.playerDataSource.isConnectedToTableView = YES;
		
		if ([[self.playerDataSource.fetchedResultsController fetchedObjects] count] == 0) {
			[self.playerDataSource beginFetch];
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
	WBLeaderBoardTableViewController *vc = [segue destinationViewController];
	vc.selectedLeaderboard = [[(WBEntityDataSource *)self.tableView.dataSource fetchedResultsController] objectAtIndexPath:self.tableView.indexPathForSelectedRow];
	
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

@end
