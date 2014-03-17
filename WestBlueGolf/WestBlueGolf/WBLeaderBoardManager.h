//
//  WBLeaderBoardManager.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/10/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBYear;

@interface WBLeaderBoardManager : NSObject

- (void)calculateLeaderBoardsForYear:(WBYear *)year;
- (void)clearLeaderBoards;

@end
