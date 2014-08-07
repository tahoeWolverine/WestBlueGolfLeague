//
//  WBLeaderBoardParentDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBLeaderBoardParentDataSource.h"
#import "WBLeaderBoardFavoriteDataSource.h"
#import "WBModels.h"

typedef enum {
	WBLeaderBoardSectionMe,
	WBLeaderBoardSectionOthers
} WBLeaderBoardSection;

@implementation WBLeaderBoardParentDataSource

- (id)initWithViewController:(UIViewController *)aViewController {
	self = [super initWithViewController:aViewController];
	if (self) {
		[self addSectionDataSource:[WBLeaderBoardFavoriteDataSource dataSourceWithParentDataSource:self]];
		[self addSectionDataSource:[WBLeaderBoardDataSource dataSourceWithParentDataSource:self]];
	}
	return self;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSFetchedResultsController *firstSectionFrc = [(WBSectionDataSource *)self.sectionDataSources[0] fetchedResultsController];
	if ([[firstSectionFrc sections][0] numberOfObjects] > 0) {
		if (section == WBLeaderBoardSectionMe) {
			return self.selectedLeaderBoard.isPlayerBoardValue ? @"Favorite Player Ranks" : @"My Team Rank";
		} else {
			return @"Leaderboard Ranks";
		}
	}
	
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSFetchedResultsController *frc = [(WBSectionDataSource *)self.sectionDataSources[indexPath.section] fetchedResultsController];
	WBBoardData *data = (WBBoardData *)[frc objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
	if (data.detailValue && ![data.detailValue isEqualToString:@""]) {
		[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	} else {
		// Deselect cell
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

- (WBLeaderBoard *)selectedLeaderBoard {
    if (!_selectedLeaderBoard) {
        _selectedLeaderBoard = [WBLeaderBoard firstLeaderboard];
    }
    return _selectedLeaderBoard;
}

@end
