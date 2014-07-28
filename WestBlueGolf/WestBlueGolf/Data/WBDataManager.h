//
//  WBDataManager.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 5/23/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBYear;

@interface WBDataManager : NSObject

+ (instancetype)dataManager;

- (void)setupData;

- (NSInteger)thisYearValue;
- (void)setThisYearValue:(NSInteger)value inContext:(NSManagedObjectContext *)moc;

- (void)setupCoreData:(BOOL)reset;
- (void)resetYearFromServer:(WBYear *)year;

//- (void)clearRefreshableDataForYearValue:(NSInteger)yearValue;

@end
