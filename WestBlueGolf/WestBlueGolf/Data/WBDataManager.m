//
//  WBDataManager.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 5/23/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBDataManager.h"
#import "WBAppDelegate.h"
#import "WBAvailableYearsService.h"
#import "WBCoreDataManager.h"
#import "WBHandicapManager.h"
#import "WBInputDataManager.h"
#import "WBLeaderBoardManager.h"
#import "WBModels.h" // should really only be WBYear
#import "WBNotifications.h"
#import "WBYearDataService.h"

@interface WBDataManager ()

@property (assign, nonatomic) NSInteger yearSelection;

@end

@implementation WBDataManager

+ (instancetype)dataManager {
	return [[self alloc] init];
}

- (void)setupData {
	// Setup year (could be preference of some kind, but for now, newest)
	WBYear *year = [WBYear newestYearInContext:[WBCoreDataManager mainContext]];
	if (!year) {
		//self.loading = YES;
		[[WBAppDelegate sharedDelegate] setLoading:YES];
		
		// Try to pull the first data for the app
		[self setupCoreData:YES];
	}
	
	self.yearSelection = year.valueValue;
}

#pragma mark - Important properties

- (NSInteger)thisYearValue {
	return self.yearSelection;
}

- (void)setThisYearValue:(NSInteger)value inContext:(NSManagedObjectContext *)moc {
	if (value != 0 && value != self.yearSelection) {
		self.yearSelection = value;
	}
		
	WBYear *year = [WBYear thisYear];
	if ([year needsRefresh]) {
		[self resetYearFromServer:year];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:WBYearChangedLoadingFinishedNotification object:nil];
	}
}

#pragma mark - Data calls

- (void)loadAndCalculateForYear:(NSInteger)yearValue moc:(NSManagedObjectContext *)moc {
	WBInputDataManager *inputManager = [[WBInputDataManager alloc] init];
	[inputManager clearRefreshableDataForYearValue:yearValue];
	[inputManager loadJsonDataForYearValue:yearValue fromContext:moc];
	WBYear *year = [WBYear findYearWithValue:yearValue inContext:moc];
	WBHandicapManager *handiManager = [[WBHandicapManager alloc] init];
	[handiManager calculateHandicapsForYear:year moc:moc];
	WBLeaderBoardManager *boardManager = [[WBLeaderBoardManager alloc] init];
	[boardManager calculateLeaderBoardsForYear:year moc:moc];
	//[WBCoreDataManager saveContext:moc];
}

- (void)setupCoreData:(BOOL)reset {
	if (reset) {
		[[WBCoreDataManager sharedManager] resetManagedObjectContextAndPersistentStore];
	}
	
	WBYear *year = [WBYear newestYearInContext:[WBCoreDataManager mainContext]];
	if (!year) {
		DLog(@"Processing Started");
		__block typeof(self) weakSelf = self;
		[WBAvailableYearsService requestAvailableYearsAndPopulate:^(BOOL success) {
			if (success) {
				WBInputDataManager *inputManager = [[WBInputDataManager alloc] init];
				[inputManager createYearsInContext:[WBCoreDataManager mainContext]];
				[WBCoreDataManager saveMainContext];
				
				[weakSelf setThisYearValue:[WBYear newestYearInContext:[WBCoreDataManager mainContext]].valueValue inContext:[WBCoreDataManager mainContext]];
			}
		}];
	} else {
		self.yearSelection = year.valueValue;
	}
}

- (void)resetYearFromServer:(WBYear *)year {
	[WBYearDataService requestYearDataAndPopulateForYear:year.valueValue completionBlock:^(BOOL success) {
		if (success) {
			[self resetYear:year];
		}
	}];
}

- (void)resetYear:(WBYear *)year {
	if (!year.weeks || year.weeks.count == 0) {
		[[WBAppDelegate sharedDelegate] setLoading:YES];
		DLog(@"Processing Started");
		[self loadAndCalculateForYear:year.valueValue moc:year.managedObjectContext];

		[[WBAppDelegate sharedDelegate] setLoading:NO];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:WBYearChangedLoadingFinishedNotification object:nil];
}

@end
