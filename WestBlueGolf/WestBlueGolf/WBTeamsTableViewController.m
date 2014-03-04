//
//  WBTeamsTableViewController.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/17/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamsTableViewController.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
#import "WBProfileTableViewController.h"

@interface WBTeamsTableViewController () {
}

@end

@implementation WBTeamsTableViewController

#pragma mark - WBEntityTableViewController methods to implement

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"TeamListCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBTeam";
}

- (NSString *)sortDescriptor {
	return @"name";
}

- (void)configureCell:(UITableViewCell *)cell
		  atIndexPath:(NSIndexPath *)indexPath {
	WBTeam *team = (WBTeam *)[self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = team.name;
}

@end
