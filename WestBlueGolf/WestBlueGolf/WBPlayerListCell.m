//
//  WBPlayerListCell.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/17/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBPlayerListCell.h"
#import "WBAppDelegate.h"
#import "WBFileSystem.h"
#import "WBModels.h"

@implementation WBPlayerListCell

- (void)configureCellForPlayer:(WBPlayer *)player {
	self.playerNameLabel.text = player.name;
	self.teamNameLabel.text = player.team.name;

	//cell.imageView.clipsToBounds = YES;
	
	NSString *path = [[WBFileSystem documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-profile-image.png", player.name]];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		self.profilePicture.image = [UIImage imageWithContentsOfFile:path];
		self.profilePicture.layer.borderColor = kEmeraldColor.CGColor;
		self.profilePicture.layer.borderWidth = 1.0f;
		self.profilePicture.layer.cornerRadius = self.profilePicture.bounds.size.width / 2.0f;
		self.profilePicture.clipsToBounds = YES;
	} else {
		self.profilePicture.image = [UIImage imageNamed:@"UITabBarContactsTemplate"];
		self.profilePicture.image = [self.profilePicture.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		self.profilePicture.layer.borderWidth = 0.0f;
	}
}

@end
