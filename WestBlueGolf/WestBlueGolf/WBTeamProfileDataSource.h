//
//  WBTeamProfileDataSource.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBEntityDataSource.h"

@class WBTeam;

@interface WBTeamProfileDataSource : WBEntityDataSource

@property (strong, nonatomic) WBTeam *selectedTeam;

@end
