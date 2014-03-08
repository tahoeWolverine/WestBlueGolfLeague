//
//  WLeaderBoardListTableViewController.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/7/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBLeaderBoardListTableViewController.h"
#import "WBTeamBoardListDataSource.h"

@interface WBLeaderBoardListTableViewController ()

@property (strong, nonatomic) WBTeamBoardListDataSource *dataSource;

@end

@implementation WBLeaderBoardListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.dataSource = [WBTeamBoardListDataSource dataSourceWithViewController:self];

    self.tableView.dataSource = self.dataSource;
	self.tableView.delegate = self.dataSource;
	
	[self.dataSource beginFetch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
