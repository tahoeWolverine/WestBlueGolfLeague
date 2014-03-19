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
#import "WBNotifications.h"

@interface WBLeaderBoardListTableViewController ()

@property (assign, nonatomic) BOOL isInPlayerMode;
@property (strong, nonatomic) WBLeaderBoardListDataSource *teamDataSource;
@property (strong, nonatomic) WBLeaderBoardListDataSource *playerDataSource;

@end

@implementation WBLeaderBoardListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Run an initial switchTables within setupDataSources to get into team mode (setting it to start on player does this)
	self.isInPlayerMode = YES;
	
	[self setupDataSources:NO];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(resetYear)
												 name:WBYearChangedNotification
											   object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resetYear {
	self.teamDataSource = nil;
	self.playerDataSource = nil;
	
	[self.navigationController popToRootViewControllerAnimated:NO];
	
	// Switch the bool to make switching take us back to the current data
	self.isInPlayerMode = !self.isInPlayerMode;
	[self setupDataSources:YES];
	
	
}

- (void)setupDataSources:(BOOL)reload {
	self.teamDataSource = [WBLeaderBoardListDataSource dataSourceWithViewController:self playerBoard:NO];
	self.playerDataSource = [WBLeaderBoardListDataSource dataSourceWithViewController:self playerBoard:YES];
	
	[self switchTables:reload];
}

- (void)switchTables:(BOOL)reload {
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
	WBLeaderBoardTableViewController *vc = [segue destinationViewController];
	vc.selectedLeaderboard = [[(WBEntityDataSource *)self.tableView.dataSource fetchedResultsController] objectAtIndexPath:self.tableView.indexPathForSelectedRow];
	
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

@end
