//
//  WBProfileTableViewController.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/15/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBProfileTableViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "ProfilePictureCropperViewController.h"
#import "WBAppDelegate.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"
#import "WBNotifications.h"
#import "WBProfileDataSource.h"
#import "WBSettings.h"

@interface WBProfileTableViewController () <UIAlertViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UISplitViewControllerDelegate, ProfilePictureCropperViewControllerDelegate>

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
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(photoAdded:)
													 name:WBProfilePhotoAddedNotification
												   object:nil];
	}
	return self;
}

- (void)photoAdded:(NSNotification *)notification {
	if (notification.object) {
		WBPlayer *player = (WBPlayer *)notification.object;
		if ([player.name isEqualToString:self.selectedPlayer.name]) {
			[self setupProfileImageView];
		}
	}
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hideLoadingView {
	[self performSelectorOnMainThread:@selector(hideLoadingViewOnMainThread) withObject:nil waitUntilDone:NO];
}

- (void)hideLoadingViewOnMainThread {
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

- (void)setupProfileImageView {
	self.profileImageView.layer.borderColor = self.view.tintColor.CGColor;
    self.profileImageView.layer.borderWidth = 2.0f;
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2.0f;
    self.profileImageView.clipsToBounds = YES;
    
    // Check if we have the profile image
    UIImage *profileImage = [self fetchImageForPlayer:self.selectedPlayer];
	if (profileImage) {
		self.profileImageView.image = profileImage;
	} else {
		UIImage *contacts = [UIImage imageNamed:@"UITabBarContactsTemplate"];
		UIImage *defaultImage = [contacts imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		self.profileImageView.image = defaultImage;
		[self.profileImageView setTintColor:kEmeraldColor];
	}
}

- (WBPlayer *)selectedPlayer {
	return self.dataSource.selectedPlayer;
}

- (void)setSelectedPlayer:(WBPlayer *)selectedPlayer {
	self.dataSource.selectedPlayer = selectedPlayer;
	if ([self isMeTab]) {
		[self setTabName:selectedPlayer ? [selectedPlayer firstName] : @"You"];
	}
	[self resetTableAndFetchedResultsController];
	[self refreshPlayerHighlights];
	[self refreshFavoriteButton];
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
		self.winLossLabel.text = [player recordStringForYear:[WBYear thisYear]];
		self.handicapLabel.text = [player findHandicapBoardData].displayValue;
		self.lowRoundLabel.text = [player findLowScoreBoardData].displayValue;
		self.averagePointsLabel.text = [player findAveragePointsBoardData].displayValue;
		self.improvedLabel.text = [player findImprovedBoardData].displayValue;
		self.lowNetLabel.text = [player findLowNetBoardData].displayValue;
	} else {
		self.winLossLabel.text = @"-";
		self.handicapLabel.text = @"-";
		self.lowRoundLabel.text =  @"-";
		self.averagePointsLabel.text = @"-";
		self.improvedLabel.text = @"-";
		self.lowNetLabel.text = @"-";
	}

	self.navigationItem.title = self.selectedPlayer.name ?: @"Find Yourself in Players";
	
	// Refresh profile image
	[self setupProfileImageView];
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
		WBPlayer *selected = self.selectedPlayer;
		if (!me) {
			[selected setPlayerToMe];
			[(WBAppDelegate *)[UIApplication sharedApplication].delegate setProfileTabPlayer];
		} else {
            [selected toggleFavorite];
		}
		[WBCoreDataManager saveContext:selected.managedObjectContext];
	}
	
	[self refreshFavoriteButton];
}

#pragma mark - WBEntityDetailViewController methods to implement

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([alertView.title isEqualToString:@"No Player"]) {
		return;
	}
	
	if (buttonIndex > 0) {
		[self.selectedPlayer setPlayerToNotMe];
		
		[WBCoreDataManager saveMainContext];
	
		self.selectedPlayer = nil;
	
		[self refreshPlayerHighlights];
		[self refreshFavoriteButton];
	}
}

#pragma mark - IBAction Methods

- (IBAction)tappedProfileImage:(UITapGestureRecognizer *)sender {
	if (!self.selectedPlayer || [self.selectedPlayer.name isEqualToString:@""]) {
		UIAlertView *noPlayerAlert = [[UIAlertView alloc] initWithTitle:@"No Player"
																message:@"You can only add a profile photo once you've selected yourself from the players list"
															   delegate:self
													  cancelButtonTitle:@"Ok"
													  otherButtonTitles:nil];
		[noPlayerAlert show];
		return;
	}
	
	if (![self isMeTab]) {
		return;
	}
	
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

/*- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	return YES;
}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ProfilePictureCropperSegue"]) {
		ProfilePictureCropperViewController *ppcvc = segue.destinationViewController;
		ppcvc.delegate = self;
		ppcvc.imageToCrop = self.imageSelectedToCrop;
		ppcvc.radius = (int)(self.profileImageView.bounds.size.width);
		ppcvc.playerName = self.selectedPlayer.name;
		self.imageSelectedToCrop = nil;
	}
}

#pragma mark - ProfilePictureCropperViewControllerDelegate

- (void)profilePictureCropperViewController:(ProfilePictureCropperViewController *)controller croppedImage:(UIImage *)croppedImage {
	if (croppedImage) {
		self.profileImageView.image = croppedImage;
	}
	
	// Notify all other VCs that a photo has been taken, so they can update
	[[NSNotificationCenter defaultCenter] postNotificationName:WBProfilePhotoAddedNotification object:self.selectedPlayer];
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Profile Image Fetching

- (UIImage *)fetchImageForPlayer:(WBPlayer *)player {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *getImagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-profile-image.png", player.name]];
    return [UIImage imageWithContentsOfFile:getImagePath];
}

#pragma mark - UISplitViewControllerDelegate methods

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
	return NO;
}

@end
