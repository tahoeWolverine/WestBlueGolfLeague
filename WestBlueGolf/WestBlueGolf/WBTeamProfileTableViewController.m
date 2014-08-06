//
//  WBTeamProfileTableViewController.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/15/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamProfileTableViewController.h"
#import "WBModels.h"
#import "WBProfileTableViewController.h"
#import "WBTeamProfileDataSource.h"
#import "WBResultTableViewCell.h"

@interface WBTeamProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *winLossLabel;
@property (weak, nonatomic) IBOutlet UILabel *winLossAllLabel;
@property (weak, nonatomic) IBOutlet UILabel *improvedLabel;

@property (strong, nonatomic) WBTeamProfileDataSource *dataSource;

@end

@implementation WBTeamProfileTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.dataSource = [WBTeamProfileDataSource dataSourceWithViewController:self];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.dataSource beginFetch];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.tableView.dataSource = self.dataSource;
	self.tableView.delegate = self.dataSource;
	
	[self refreshTeamHighlights];
}

- (WBTeam *)selectedTeam {
	return self.dataSource.selectedTeam;
}

- (void)setSelectedTeam:(WBTeam *)selectedTeam {
	self.dataSource.selectedTeam = selectedTeam;
}

- (void)refreshTeamHighlights {
	WBYear *year = [WBYear thisYear];
	WBTeam *team = self.dataSource.selectedTeam;
	self.placeLabel.text = [team placeString];
	self.averagePointsLabel.text = [team averagePointsString];
	self.winLossLabel.text = [team recordStringForYear:year];
	self.winLossAllLabel.text = [team individualRecordStringForYear:year];
	self.improvedLabel.text = [team findImprovedBoardData].displayValue;
	
	self.navigationItem.title = self.selectedTeam.name ?: @"No Team Selected";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[self.dataSource prepareForSegue:segue sender:sender];
}

@end
