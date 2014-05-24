//
//  WLeaderBoardTableViewController.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/7/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBLeaderBoardTableViewController.h"
#import "WBLeaderBoardParentDataSource.h"
#import "WBModels.h"

@interface WBLeaderBoardTableViewController ()

@property (strong, nonatomic) WBLeaderBoardParentDataSource *boardDataSource;

@end

@implementation WBLeaderBoardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.boardDataSource = [WBLeaderBoardParentDataSource dataSourceWithViewController:self];
	self.boardDataSource.selectedLeaderBoard = self.selectedLeaderboard;

    self.tableView.dataSource = self.boardDataSource;
	self.tableView.delegate = self.boardDataSource;
	
	[self.boardDataSource beginFetch];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationItem.title = self.selectedLeaderboard.name;
}

@end
