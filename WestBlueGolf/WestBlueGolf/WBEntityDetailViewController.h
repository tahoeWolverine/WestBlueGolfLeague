//
//  WBEntityDetailViewController.h
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/24/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class NSManagedObject;

@interface WBEntityDetailViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) NSManagedObject *selectedEntity;
@property (weak, nonatomic) IBOutlet UILabel *selectedEntityNameLabel;

- (NSString *)cellIdentifier;
- (NSString *)entityName;
- (NSString *)sortDescriptor;
- (NSString *)selectedEntityName;
- (void)configureCell:(UITableViewCell *)cell
		  atIndexPath:(NSIndexPath *)indexPath;

@end
