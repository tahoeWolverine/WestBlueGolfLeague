//
//  WBLeaderBoardListDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBLeaderBoardListDataSource.h"
#import "WBCoreDataManager.h"
#import "WBLeaderBoardListCell.h"
#import "WBModels.h"

#define SORT_KEY @"tablePriority"

@interface WBLeaderBoardListDataSource ()

@property (assign, nonatomic) BOOL isPlayerBoard;

@end

@implementation WBLeaderBoardListDataSource

+ (id)dataSourceWithViewController:(UIViewController *)aViewController playerBoard:(BOOL)playerBoard {
	return [[self alloc] initWithViewController:aViewController playerBoard:playerBoard];
}

- (id)initWithViewController:(UIViewController *)aViewController playerBoard:(BOOL)playerBoard {
	self = [super initWithViewController:aViewController];
	if (self) {
		self.isPlayerBoard = playerBoard;
	}
	return self;
}

#pragma mark - WBEntityDataSource methods to implement

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"LeaderBoardListCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBLeaderBoard";
}

- (NSString *)sectionNameKeyPath {
	return nil;
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"isPlayerBoard = %@", [NSNumber numberWithBool:self.isPlayerBoard]];
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sortOrderDescriptor];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBLeaderBoard *leaderBoard = (WBLeaderBoard *)object;
	WBLeaderBoardListCell *leaderBoardCell = (WBLeaderBoardListCell *)cell;
	[leaderBoardCell configureCellForLeaderBoard:leaderBoard];
}

@end
