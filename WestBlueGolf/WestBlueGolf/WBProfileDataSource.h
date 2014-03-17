//
//  WBProfileDataSource.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBEntityDataSource.h"

@class WBPlayer;

@interface WBProfileDataSource : WBEntityDataSource

@property (strong, nonatomic) WBPlayer *selectedPlayer;

@end
