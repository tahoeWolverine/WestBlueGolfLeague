//
//  WBPlayersSplitDelegate.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 8/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBPlayersSplitDelegate.h"

@interface WBPlayersSplitDelegate ()
@end

@implementation WBPlayersSplitDelegate

#pragma mark - UISplitViewControllerDelegate methods

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
	return NO;
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
}

- (void)splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController {
    
}

@end
