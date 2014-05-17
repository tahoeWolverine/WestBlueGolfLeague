//
//  WBLeaderBoardFavoriteDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBLeaderBoardFavoriteDataSource.h"
#import "WBLeaderBoardParentDataSource.h"
#import "WBModels.h"

@implementation WBLeaderBoardFavoriteDataSource

#pragma mark - WBEntityDataSource methods to implement

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"leaderBoard = %@ && year = %@ && (peopleEntity.me = 1 || peopleEntity.favorite = 1)", [(WBLeaderBoardParentDataSource *)self.parentDataSource selectedLeaderBoard], [WBYear thisYear]];
}

@end
