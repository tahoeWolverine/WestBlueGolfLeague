//
//  WBEntityDataSource.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@interface WBEntityDataSource : NSObject <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (assign, nonatomic) BOOL isConnectedToTableView;

@property (nonatomic, weak, readonly) UIViewController *viewController;

+ (id)dataSourceWithViewController:(UIViewController *)aViewController;
- (id)initWithViewController:(UIViewController *)aViewController;

- (void)beginFetch;

- (NSString *)cellIdentifier;
- (NSString *)entityName;
- (NSArray *)sortDescriptorsForFetch;
- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object;

@end
