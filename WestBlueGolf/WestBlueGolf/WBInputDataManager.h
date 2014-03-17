//
//  WBInputDataManager.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/10/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@interface WBInputDataManager : NSObject

- (void)createYears;
- (void)loadJsonDataForYearValue:(NSInteger)yearValue;

@end
