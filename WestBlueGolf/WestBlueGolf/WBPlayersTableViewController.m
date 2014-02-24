//
//  WBPlayersTableViewController.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/16/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBPlayersTableViewController.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
#import "WBProfileTableViewController.h"

@interface WBPlayersTableViewController () {
	NSFetchedResultsController *_fetchedResultsController;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation WBPlayersTableViewController

#pragma mark - WBEntityTableViewController methods to implement

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"PlayerListCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBPlayer";
}

- (NSString *)sortDescriptor {
	return @"name";
}

- (void)configureCell:(UITableViewCell *)cell
		  atIndexPath:(NSIndexPath *)indexPath {
	WBPlayer *player = (WBPlayer *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = player.name;
	cell.detailTextLabel.text = player.team.name;
}

@end
