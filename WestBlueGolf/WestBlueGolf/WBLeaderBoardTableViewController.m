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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.boardDataSource = [WBLeaderBoardParentDataSource dataSourceWithViewController:self];
        self.boardDataSource.selectedLeaderBoard = self.selectedLeaderboard;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self.boardDataSource;
	self.tableView.delegate = self.boardDataSource;
	
	[self.boardDataSource beginFetch];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationItem.title = self.selectedLeaderboard.name;
}

- (WBLeaderBoard *)selectedLeaderboard {
    return self.boardDataSource.selectedLeaderBoard;
}

- (void)setSelectedLeaderboard:(WBLeaderBoard *)selectedLeaderboard {
    if (self.boardDataSource.selectedLeaderBoard != selectedLeaderboard) {
        self.boardDataSource.selectedLeaderBoard = selectedLeaderboard;
        [self.boardDataSource resetTableAndFetchedResultsController];
    }
}

@end
