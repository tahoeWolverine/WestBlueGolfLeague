//
//  WBYearDataService.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 5/23/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@interface WBYearDataService : NSObject

+ (void)requestYearDataAndPopulateForYear:(NSInteger)year completionBlock:(void (^) (BOOL, id))completionBlock;

@end
