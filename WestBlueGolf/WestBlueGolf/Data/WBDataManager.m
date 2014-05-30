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

- (void)loadAndCalculateForYear:(NSInteger)yearValue withJson:(NSDictionary *)responseObject {
	WBInputDataManager *inputManager = [[WBInputDataManager alloc] init];
	[inputManager clearRefreshableDataForYearValue:yearValue];
	//[inputManager loadJsonDataForYearValue:yearValue fromContext:moc];
	[inputManager createObjectsForYear:yearValue withJson:responseObject];
	WBYear *year = [WBYear findYearWithValue:yearValue inContext:[WBCoreDataManager mainContext]];
	WBHandicapManager *handiManager = [[WBHandicapManager alloc] init];
	[handiManager calculateHandicapsForYear:year moc:[WBCoreDataManager mainContext]];
	WBLeaderBoardManager *boardManager = [[WBLeaderBoardManager alloc] init];
	[boardManager calculateLeaderBoardsForYear:year moc:[WBCoreDataManager mainContext]];
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
		[WBAvailableYearsService requestAvailableYearsAndPopulate:^(BOOL success, id responseObject) {
			if (success) {
				WBInputDataManager *inputManager = [[WBInputDataManager alloc] init];
				[inputManager createYearsWithJson:responseObject];
				[WBCoreDataManager saveMainContext];
				
				[weakSelf setThisYearValue:[WBYear newestYearInContext:[WBCoreDataManager mainContext]].valueValue inContext:[WBCoreDataManager mainContext]];
			}
		}];
	} else {
		self.yearSelection = year.valueValue;
	}
}

- (void)resetYearFromServer:(WBYear *)year {
	[WBYearDataService requestYearDataAndPopulateForYear:year.valueValue completionBlock:^(BOOL success, id responseObject) {
		if (success) {
			[self resetYear:year withJson:responseObject];
		}
	}];
}

- (void)resetYear:(WBYear *)year withJson:(NSDictionary *)responseObject {
	if (!year.weeks || year.weeks.count == 0) {
		[[WBAppDelegate sharedDelegate] setLoading:YES];
		DLog(@"Processing Started");
		[self loadAndCalculateForYear:year.valueValue withJson:responseObject];

		[[WBAppDelegate sharedDelegate] setLoading:NO];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:WBYearChangedLoadingFinishedNotification object:nil];
}

@end
