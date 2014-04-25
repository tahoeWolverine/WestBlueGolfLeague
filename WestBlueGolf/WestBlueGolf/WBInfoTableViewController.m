//
//  WBInfoTableViewController.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/5/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBInfoTableViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "WBAppDelegate.h"
#import "WBInfoWebviewViewController.h"
#import "WBModels.h"
#import "WBNotifications.h"

@interface WBInfoTableViewController ()

@end

@implementation WBInfoTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(resetYear)
													 name:WBYearChangedLoadingFinishedNotification
												   object:nil];
    }
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resetYear {
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
	
	[self performSelector:@selector(hideProgress) withObject:nil afterDelay:1.0];
}

- (void)hideProgress {
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	if (indexPath.row == 4) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"SelectedYearCell" forIndexPath:indexPath];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [WBYear thisYear].value];
	} else {
		NSString *cellIdentifier = @"BasicInfoCell";
		if (indexPath.row == 3) {
			cellIdentifier = @"UrlLinkCell";
		} else if (indexPath.row == 5) {
			cellIdentifier = @"NormalCell";
		}
		cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
		cell.textLabel.text = [self textForCellAtIndex:indexPath.row];
	}
    
    return cell;
}

- (NSString *)textForCellAtIndex:(NSInteger)index {
	NSString *text = nil;
	switch (index) {
		case 0:
			text = @"League Rules of Play";
			break;
		case 1:
			text = @"General Information";
			break;
		case 2:
			text = @"Credits";
			break;
		case 3:
			text = @"westbluegolfleague.com";
			break;
		case 5:
			text = @"Reset Data";
			break;

		default:
			break;
	}
	
	return text;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 3) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://westbluegolfleague.com"]];
	} else if (indexPath.row == 5) {
		[(WBAppDelegate *)[UIApplication sharedApplication].delegate setupCoreData:YES];
		[(WBAppDelegate *)[UIApplication sharedApplication].delegate setProfileTabPlayer];
		[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	UITableViewCell *cell = (UITableViewCell *)sender;
	NSString *filename = nil;
	if ([cell.textLabel.text isEqualToString:@"League Rules of Play"]) {
		filename = @"rules";
	} else if ([cell.textLabel.text isEqualToString:@"General Information"]) {
		filename = @"info";
	} else if ([cell.textLabel.text isEqualToString:@"Credits"]) {
		filename = @"credits";
	} else {
		// other cells shouldn't bother with this logic
		return;
	}
	
	WBInfoWebviewViewController *dest = (WBInfoWebviewViewController *)[segue destinationViewController];
	[dest setWebviewContentWithFilename:filename];
}

- (IBAction)unwindSegueCallback:(UIStoryboardSegue *)segue {
	// No need to do anything here
}

@end
