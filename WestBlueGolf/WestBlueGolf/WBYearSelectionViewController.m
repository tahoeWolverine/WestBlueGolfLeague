//
//  WBYearSelectionViewController.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/13/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBYearSelectionViewController.h"
#import "WBYearSelectionDataSource.h"

@interface WBYearSelectionViewController ()

@property (strong, nonatomic) WBYearSelectionDataSource *dataSource;

@end

@implementation WBYearSelectionViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.dataSource = [WBYearSelectionDataSource dataSourceWithViewController:self];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	self.tableView.dataSource = self.dataSource;
	self.tableView.delegate = self.dataSource;
	
	[self.dataSource beginFetch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
	if (self.navigationController.viewControllers.count > 1) {
		[self.navigationController popToRootViewControllerAnimated:NO];
	}
}

@end
