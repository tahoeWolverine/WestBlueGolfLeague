//
//  WBWeekTableViewController.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/7/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBWeekTableViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "WBAppDelegate.h"
#import "WBMatchupResultDataSource.h"
#import "WBModels.h"
#import "WBNotifications.h"

@interface WBWeekTableViewController ()

@property (strong, nonatomic) WBMatchupResultDataSource *dataSource;

@property (weak, nonatomic) IBOutlet UIView *header;

@end

@implementation WBWeekTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(yearWasReset)
													 name:WBYearChangedLoadingFinishedNotification
												   object:nil];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.dataSource = [WBMatchupResultDataSource dataSourceWithViewController:self];

    self.tableView.dataSource = self.dataSource;
	self.tableView.delegate = self.dataSource;
	
	[self.headerView addSubview:[self.dataSource headerView]];
	[self.footerView addSubview:[self.dataSource footerView]];
	
	[self.dataSource beginFetch];
	
	//[self.header addSubview:[self.dataSource tableHeaderViewForTable:self.tableView]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshYear:(id)sender {
	DLog(@"Refresh Year");

	[[WBAppDelegate sharedDelegate] refreshThisYear];
	[[WBAppDelegate sharedDelegate] setProfileTabPlayer];
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)yearWasReset {
	[self hideProgress];
	//[self performSelector:@selector(hideProgress) withObject:nil afterDelay:1.0];
}

- (void)hideProgress {
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
