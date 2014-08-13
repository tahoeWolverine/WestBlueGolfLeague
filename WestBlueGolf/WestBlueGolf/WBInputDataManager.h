//
//  WBInputDataManager.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/10/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBYear;

@interface WBInputDataManager : NSObject

@property (assign, nonatomic) BOOL buildPlayoffMatchups;

- (void)createYearsWithJson:(NSDictionary *)json;
- (void)createObjectsForYear:(NSInteger)yearValue withJson:(NSDictionary *)json;
- (void)clearRefreshableDataForYearValue:(NSInteger)yearValue;

- (void)createPlayoffSpeculationsForYear:(WBYear *)year;

@end
