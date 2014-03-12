//
//  WBTeamProfileTableViewController.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/15/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamProfileTableViewController.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
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

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.dataSource = [WBTeamProfileDataSource dataSourceWithViewController:self];
	[self.dataSource beginFetch];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self refreshTeamHighlights];
}

- (void)refreshTeamHighlights {
	WBTeam *team = self.dataSource.selectedTeam;
	self.placeLabel.text = [team placeString];
	self.averagePointsLabel.text = [team averagePointsString];
	self.winLossLabel.text = [team record];
	self.winLossAllLabel.text = [team individualRecord];
	self.improvedLabel.text = [team improvedString];
}

#pragma mark - WBEntityDetailViewController methods to implement

/*- (NSString *)selectedEntityName {
	WBTeam *team = (WBTeam *)self.selectedEntity;
	TRAssert(team, @"No team selected for team profile");
	return team.name;
}*/

@end
