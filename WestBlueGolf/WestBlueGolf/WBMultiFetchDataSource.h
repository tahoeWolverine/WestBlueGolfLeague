//
//  WBMultiFetchDataSource.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/13/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBSectionDataSource;

@interface WBMultiFetchDataSource : NSObject <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic, readonly) UITableView *tableView;

+ (id)dataSourceWithViewController:(UIViewController *)aViewController;
- (id)initWithViewController:(UIViewController *)aViewController;

- (void)addSectionDataSource:(WBSectionDataSource *)dataSource;

- (void)beginFetch;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
