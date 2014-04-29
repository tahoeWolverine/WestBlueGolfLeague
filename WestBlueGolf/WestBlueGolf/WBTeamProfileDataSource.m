//
//  WBTeamProfileDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamProfileDataSource.h"
#import "WBModels.h"
#import "WBResultTableViewCell.h"
#import "WBTeamPlayersDataSource.h"
#import "WBTeamResultsDataSource.h"

@implementation WBTeamProfileDataSource

- (id)initWithViewController:(UIViewController *)aViewController {
	self = [super initWithViewController:aViewController];
	if (self) {
		[self addSectionDataSource:[WBTeamResultsDataSource dataSourceWithParentDataSource:self]];
		[self addSectionDataSource:[WBTeamPlayersDataSource dataSourceWithParentDataSource:self]];
	}
	return self;
}

@end
