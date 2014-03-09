//
//  WBLeaderBoardListDataSource.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBEntityDataSource.h"

@interface WBLeaderBoardListDataSource : WBEntityDataSource

+ (id)dataSourceWithViewController:(UIViewController *)aViewController playerBoard:(BOOL)playerBoard;
- (id)initWithViewController:(UIViewController *)aViewController playerBoard:(BOOL)playerBoard;

@end
