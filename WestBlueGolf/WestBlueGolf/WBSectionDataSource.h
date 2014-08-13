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

@property (weak, nonatomic) WBMultiFetchDataSource *parentDataSource;

+ (WBSectionDataSource *)dataSourceWithParentDataSource:(WBMultiFetchDataSource *)parentDataSource;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)section;

- (void)beginFetch;

- (NSString *)sectionName;
- (NSString *)cellIdentifierForObject:(NSManagedObject *)object;
- (NSString *)entityName;
- (NSArray *)sortDescriptorsForFetch;
- (NSPredicate *)fetchPredicate;
- (BOOL)shouldExpand;
- (CGFloat)cellHeight;
- (CGFloat)expandedCellHeight;
- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object;

- (NSString *)supportedSegueIdentifier;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
