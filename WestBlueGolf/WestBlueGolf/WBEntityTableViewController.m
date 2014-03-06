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

@property (weak, nonatomic) UITableView *currentTable;
@property (strong, nonatomic) WBPlayersDataSource *playersDataSource;
@property (strong, nonatomic) WBTeamsDataSource *teamsDataSource;

@end

@implementation WBEntityTableViewController

/*- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
	self.playersDataSource = [WBPlayersDataSource dataSourceWithViewController:self];
	self.teamsDataSource = [WBTeamsDataSource dataSourceWithViewController:self];
	
	self.playersTable.dataSource = self.playersDataSource;
	self.playersTable.delegate = self.playersDataSource;
	self.teamsTable.dataSource = self.teamsDataSource;
	self.teamsTable.delegate = self.teamsDataSource;
	
	self.currentTable = self.playersTable;
	
    [self.playersDataSource beginFetch];
    [self.teamsDataSource beginFetch];
	
	self.view = self.playersTable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	WBEntityDetailViewController *vc = [segue destinationViewController];
	vc.selectedEntity = [[(WBEntityDataSource *)self.currentTable.dataSource fetchedResultsController] objectAtIndexPath:self.currentTable.indexPathForSelectedRow];
}

@end
