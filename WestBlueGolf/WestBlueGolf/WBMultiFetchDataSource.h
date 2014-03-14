//
//  WBMultiFetchDataSource.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/13/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@interface WBMultiFetchDataSource : NSObject

@property (strong, nonatomic) UITableView *tableView;

+ (id)dataSourceWithViewController:(UIViewController *)aViewController;
- (id)initWithViewController:(UIViewController *)aViewController;

@end