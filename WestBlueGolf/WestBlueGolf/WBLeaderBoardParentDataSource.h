//
//  WBLeaderBoardParentDataSource.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBMultiFetchDataSource.h"

@class WBLeaderBoard;

@interface WBLeaderBoardParentDataSource : WBMultiFetchDataSource

@property (strong, nonatomic) WBLeaderBoard *selectedLeaderBoard;

@end
