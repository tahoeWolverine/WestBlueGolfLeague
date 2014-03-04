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
#import "WBResultTableViewCell.h"

@interface WBTeamProfileTableViewController () {
}

@end

@implementation WBTeamProfileTableViewController

- (NSString *)selectedEntityName {
	WBTeam *team = (WBTeam *)self.selectedEntity;
	TRAssert(team, @"No team selected for team profile");
	return team.name;
}

#pragma mark - WBEntityDetailViewController methods to implement

- (NSString *)sortDescriptor {
	return @"match.teamMatchup.week.date";
}

@end
