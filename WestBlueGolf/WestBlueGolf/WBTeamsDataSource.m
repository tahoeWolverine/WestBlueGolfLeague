//
//  WBTeamsDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamsDataSource.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
#import "WBProfileTableViewController.h"

@implementation WBTeamsDataSource

#pragma mark - WBEntityTableViewController methods to implement

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"TeamListCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBTeam";
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBTeam *team = (WBTeam *)object;
	cell.textLabel.text = team.name;
}

@end
