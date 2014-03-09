//
//  WLeaderBoardTableViewController.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/7/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBLeaderBoardTableViewController.h"
#import "WBLeaderBoardDataSource.h"

@interface WBLeaderBoardTableViewController ()

@property (strong, nonatomic) WBLeaderBoardDataSource *teamDataSource;

@end

@implementation WBLeaderBoardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.teamDataSource = [WBLeaderBoardDataSource dataSourceWithViewController:self];

    self.tableView.dataSource = self.teamDataSource;
	self.tableView.delegate = self.teamDataSource;
	
	[self.teamDataSource beginFetch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
