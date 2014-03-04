//
//  WBProfileTableViewController.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/15/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBProfileTableViewController.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
#import "WBResultTableViewCell.h"

@interface WBProfileTableViewController () {
}

@end

@implementation WBProfileTableViewController

- (NSString *)selectedEntityName {
	WBPlayer *player = (WBPlayer *)self.selectedEntity;
	return player ? player.name : @"Michael Harlow";
}

#pragma mark - WBEntityDetailViewController methods to implement

- (NSString *)sortDescriptor {
	return @"match.teamMatchup.week.date";
}

@end
