//
//  WBTeamProfileDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamProfileDataSource.h"
#import "WBTeamPlayersDataSource.h"
#import "WBTeamResultsDataSource.h"

@implementation WBTeamProfileDataSource

- (id)initWithViewController:(UIViewController *)aViewController {
	self = [super initWithViewController:aViewController];
	if (self) {
        WBTeamResultsDataSource *results = (WBTeamResultsDataSource *)[WBTeamResultsDataSource dataSourceWithParentDataSource:self];
        results.futureWeeks = NO;
        WBTeamResultsDataSource *schedule = (WBTeamResultsDataSource *)[WBTeamResultsDataSource dataSourceWithParentDataSource:self];
        schedule.futureWeeks = YES;
        
		[self addSectionDataSource:results];
		[self addSectionDataSource:schedule];
		[self addSectionDataSource:[WBTeamPlayersDataSource dataSourceWithParentDataSource:self]];
	}
	return self;
}

@end
