//
//  WBPlayersDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBPlayersDataSource.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
#import "WBNotifications.h"
#import "WBProfileTableViewController.h"

#define SECTION_KEY @"favorite"
#define SORT_KEY @"name"

typedef enum {
	WBPlayerSectionFavorites,
	WBPlayerSectionPlayers
} WBPlayerSection;

@interface WBPlayersDataSource ()

@property (strong, nonatomic) NSString *documentsPath;
@end

@implementation WBPlayersDataSource

- (id)initWithViewController:(UIViewController *)aViewController {
	self = [super initWithViewController:aViewController];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(resetYear)
													 name:WBYearChangedLoadingFinishedNotification
												   object:nil];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)documentsPath {
    if (!_documentsPath) {
        _documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    }
    
    return _documentsPath;
}

- (void)resetYear {
	self.fetchedResultsController = nil;
	[self beginFetch];
	
	[[(UITableViewController *)self.viewController tableView] reloadData];
}

#pragma mark - WBEntityDataSource methods to implement

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"PlayerListCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBPlayer";
}

- (NSString *)sectionNameKeyPath {
	return SECTION_KEY;
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"ANY yearData.year = %@", [WBYear thisYear]];
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sectionSortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SECTION_KEY ascending:NO];
	NSSortDescriptor *nameSortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sectionSortOrderDescriptor, nameSortOrderDescriptor];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBPlayer *player = (WBPlayer *)object;
    cell.textLabel.text = player.name;
	cell.detailTextLabel.text = player.team.name;
    cell.imageView.clipsToBounds = YES;
    
    NSString *path = [self.documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-profile-image.png", player.name]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        cell.imageView.image = [UIImage imageWithContentsOfFile:path];
        cell.imageView.layer.borderColor = cell.contentView.tintColor.CGColor;
        cell.imageView.layer.borderWidth = 2.0f;
    } else {
        cell.imageView.image = [UIImage imageNamed:@"UITabBarContactsTemplate"];
        cell.imageView.layer.borderColor = [UIColor clearColor].CGColor;
        cell.imageView.layer.borderWidth = 0.0f;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSInteger sectionCount = [self.fetchedResultsController.sections count];
	if (sectionCount == 2 && section == WBPlayerSectionFavorites) {
		return @"Favorite Players";
	} else {
		return @"All Players";
	}
	
	return nil;
}

@end
