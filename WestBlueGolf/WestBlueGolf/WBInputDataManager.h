//
//  WBInputDataManager.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/10/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@interface WBInputDataManager : NSObject

- (void)createYearsWithJson:(NSString *)json;
- (void)createObjectsForYear:(NSInteger)yearValue withJson:(NSDictionary *)json;
//- (void)createYearsInContext:(NSManagedObjectContext *)moc;
//- (void)loadJsonDataForYearValue:(NSInteger)yearValue fromContext:(NSManagedObjectContext *)moc;
- (void)clearRefreshableDataForYearValue:(NSInteger)yearValue;

@end
