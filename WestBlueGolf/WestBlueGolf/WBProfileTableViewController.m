//
//  WBProfileTableViewController.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/15/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBProfileTableViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "WBAppDelegate.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
#import "WBNotifications.h"
#import "WBProfileDataSource.h"
#import "ProfilePictureCropperViewController.h"

@interface WBProfileTableViewController () <UIAlertViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ProfilePictureCropperViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *winLossLabel;
@property (weak, nonatomic) IBOutlet UILabel *handicapLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowRoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *improvedLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowNetLabel;

@property (strong, nonatomic) WBProfileDataSource *dataSource;

// For selecting profile pictures of Players
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) UIImage *imageSelectedToCrop;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation WBProfileTableViewController

- (BOOL)isMeTab {
	return [(WBAppDelegate *)[UIApplication sharedApplication].delegate isProfileTab:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.dataSource = [WBProfileDataSource dataSourceWithViewController:self];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(hideLoadingView)
													 name:WBLoadingFinishedNotification
												   object:nil];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hideLoadingView {
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView.dataSource = self.dataSource;
	self.tableView.delegate = self.dataSource;
	
	[self.dataSource beginFetch];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self refreshPlayerHighlights];
	[self refreshFavoriteButton];
	
	if ([(WBAppDelegate *)[UIApplication sharedApplication].delegate loading]) {
		/*MBProgressHUD *hud = */[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	} else {
		[self hideLoadingView];
	}
}

- (WBPlayer *)selectedPlayer {
	return self.dataSource.selectedPlayer;
}

- (void)setSelectedPlayer:(WBPlayer *)selectedPlayer {
	self.dataSource.selectedPlayer = selectedPlayer;
	if ([self isMeTab]) {
		[self setTabName:selectedPlayer ? [selectedPlayer firstName] : @"You"];
		[self resetTableAndFetchedResultsController];
	}
}

- (void)setTabName:(NSString *)name {
	self.navigationController.tabBarItem.title = name;
}

- (void)resetTableAndFetchedResultsController {
	self.dataSource.fetchedResultsController = nil;
	[self.dataSource beginFetch];
	
	[self.tableView reloadData];
}

- (void)refreshPlayerHighlights {
	WBPlayer *player = self.selectedPlayer;
	if (player) {
		self.winLossLabel.text = [player record];
		self.handicapLabel.text = [player currentHandicapString];
		self.lowRoundLabel.text = [player lowRoundString];
		self.averagePointsLabel.text = [player averagePointsString];
		self.improvedLabel.text = [player improvedString];
		self.lowNetLabel.text = [player lowNetString];
	} else {
		self.winLossLabel.text = @"-";
		self.handicapLabel.text = @"-";
		self.lowRoundLabel.text =  @"-";
		self.averagePointsLabel.text = @"-";
		self.improvedLabel.text = @"-";
		self.lowNetLabel.text = @"-";
	}

	self.navigationItem.title = self.selectedPlayer.name ?: @"Find Yourself in Players";
}

- (void)refreshFavoriteButton {
	if ([self isMeTab]) {
		if (self.selectedPlayer) {
			self.favoriteButton.enabled = YES;
			self.favoriteButton.image = [UIImage imageNamed:@"UITabBarContactsTemplate"];
		} else {
			self.favoriteButton.enabled = NO;
			self.favoriteButton.image = nil;
		}
	} else {
		WBPlayer *me = [WBPlayer me];
		if (!me) {
			self.favoriteButton.enabled = YES;
			self.favoriteButton.image = [UIImage imageNamed:@"UITabBarContactsTemplate"];
		} else {
			self.favoriteButton.enabled = YES;
			self.favoriteButton.image = [UIImage imageNamed:self.selectedPlayer.favoriteValue ? @"UITabBarFavoritesTemplateSelected" : @"UITabBarFavoritesTemplate"];
		}
	}
}

- (IBAction)favoritePlayer:(UIBarButtonItem *)sender {
	if ([self isMeTab]) {
		UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:@"Remove Profile"
															 message:@"Are you sure you want to reset your identity in the app?"
															delegate:self
												   cancelButtonTitle:@"Cancel"
												   otherButtonTitles:@"Reset", nil];
		[resetAlert show];
	} else {
		WBPlayer *me = [WBPlayer me];
		if (!me) {
			[self.selectedPlayer setPlayerToMe];
			[WBCoreDataManager saveContext];
			[(WBAppDelegate *)[UIApplication sharedApplication].delegate setProfileTabPlayer];
		} else {
			self.selectedPlayer.favoriteValue = !self.selectedPlayer.favoriteValue;
		}
	}
	
	[self refreshFavoriteButton];
}

#pragma mark - WBEntityDetailViewController methods to implement

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex > 0) {
		[self.selectedPlayer setPlayerToNotMe];
		[WBCoreDataManager saveContext];
	
		self.selectedPlayer = nil;
	
		[self refreshPlayerHighlights];
		[self refreshFavoriteButton];
	}
}

#pragma mark - IBAction Methods

- (IBAction)tappedProfileImage:(UITapGestureRecognizer *)sender {
	// Display Action Sheet for selecting source of image
	UIActionSheet *imagePickerActionSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Picture Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Library", @"Camera", nil];
	[imagePickerActionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
	
	// Check if the User selected the Library or Camera as a source
	if ([buttonTitle isEqualToString:@"Library"] || [buttonTitle isEqualToString:@"Camera"]) {
		self.imagePickerController = [[UIImagePickerController alloc] init];
		self.imagePickerController.sourceType = [buttonTitle isEqualToString:@"Library"] ?  UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
		self.imagePickerController.delegate = self;
		[self presentViewController:self.imagePickerController animated:YES completion:nil];
	}
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	// User selected an image for their profile. Lets segue to the cropper vc
	UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
	self.imageSelectedToCrop = selectedImage;
	[self dismissViewControllerAnimated:YES completion:^{
		[self performSegueWithIdentifier:@"ProfilePictureCropperSegue" sender:self];
	}];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ProfilePictureCropperSegue"]) {
		ProfilePictureCropperViewController *ppcvc = segue.destinationViewController;
		ppcvc.delegate = self;
		ppcvc.imageToCrop = self.imageSelectedToCrop;
		ppcvc.radius = (int)(self.profileImageView.bounds.size.width / 2.0f);
		ppcvc.playerName = self.selectedPlayer.name;
		self.imageSelectedToCrop = nil;
	}
}

#pragma mark - ProfilePictureCropperViewControllerDelegate

- (void)profilePictureCropperViewController:(ProfilePictureCropperViewController *)controller croppedImage:(UIImage *)croppedImage {
	if (croppedImage) {
		self.profileImageView.image = croppedImage;
		
		// Do we want to save the image in Core Data? POST to webservice?
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
