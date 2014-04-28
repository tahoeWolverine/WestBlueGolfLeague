//
//  WBSectionDataSource.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBMultiFetchDataSource;

@interface WBSectionDataSource : NSObject <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) WBMultiFetchDataSource *multiFetchDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (void)beginFetch;

- (NSString *)cellIdentifier;
- (NSString *)entityName;
- (NSArray *)sortDescriptorsForFetch;
- (NSPredicate *)fetchPredicate;
- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object;

@end
