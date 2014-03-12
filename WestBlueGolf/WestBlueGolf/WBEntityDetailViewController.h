//
//  WBEntityDetailViewController.h
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/24/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class NSManagedObject;

@interface WBEntityDetailViewController : UITableViewController// <NSFetchedResultsControllerDelegate>

//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) NSManagedObject *selectedEntity;

/*- (NSString *)cellIdentifier;
- (NSString *)entityName;
- (NSArray *)sortDescriptorsForFetch;
- (NSString *)selectedEntityName;
- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object;

- (void)beginFetch;*/

- (void)resetTableAndFetchedResultsController;

@end
