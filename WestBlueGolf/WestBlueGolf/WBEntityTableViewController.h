//
//  WBEntityTableViewController.h
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/23/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@interface WBEntityTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

- (NSString *)cellIdentifier;
- (NSString *)entityName;
- (NSString *)sortDescriptor;
- (void)configureCell:(UITableViewCell *)cell
		  atIndexPath:(NSIndexPath *)indexPath;

@end
