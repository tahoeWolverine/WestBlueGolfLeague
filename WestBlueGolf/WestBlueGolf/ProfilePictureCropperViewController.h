//
//  ProfilePictureCropperViewController.h
//  ProfilePicker
//
//  Created by Adam Ahrens on 3/12/14.
//  Copyright (c) 2014 Adam Ahrens. All rights reserved.
//

@class ProfilePictureCropperViewController;

@protocol ProfilePictureCropperViewControllerDelegate <NSObject>

- (void)profilePictureCropperViewController:(ProfilePictureCropperViewController *)controller croppedImage:(UIImage *)croppedImage;

@end

@interface ProfilePictureCropperViewController : UIViewController

@property (strong, nonatomic) UIImage *imageToCrop;
@property (weak, nonatomic) id <ProfilePictureCropperViewControllerDelegate> delegate;
@property (assign, nonatomic) int radius;
@property (strong, nonatomic) NSString *playerName;

@end
