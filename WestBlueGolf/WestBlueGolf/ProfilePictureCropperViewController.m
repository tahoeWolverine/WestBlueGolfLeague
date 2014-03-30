//
//  ProfilePictureCropperViewController.m
//  ProfilePicker
//
//  Created by Adam Ahrens on 3/12/14.
//  Copyright (c) 2014 Adam Ahrens. All rights reserved.
//

#import "ProfilePictureCropperViewController.h"

@interface ProfilePictureCropperViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *cutoutView;

@property (nonatomic) CGRect circleFrame;
@property (nonatomic) CGFloat circleRadius;
@property (strong, nonatomic) CAShapeLayer *fillLayer;

@property (assign) float xCoord;
@property (assign) float yCoord;

@end

@implementation ProfilePictureCropperViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.imageView.image = self.imageToCrop;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.scrollView.minimumZoomScale = 0.45;
	self.scrollView.maximumZoomScale = 1.5;
	self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor darkGrayColor];
	
	// Add a transparent layer with a cutout hole
	UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.bounds];
	self.xCoord = self.view.bounds.size.width / 2.0;
	self.yCoord = self.view.bounds.size.height / 2.0;
	self.xCoord -= self.radius;
	self.yCoord -= self.radius;
	
	self.circleFrame = CGRectMake(self.xCoord, self.yCoord, self.radius * 2, self.radius * 2);
	
	UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:self.circleFrame cornerRadius:self.radius];
	[path appendPath:circle];
	[path setUsesEvenOddFillRule:YES];
	
	self.circleRadius = self.radius;
	
	self.fillLayer = [CAShapeLayer layer];
	self.fillLayer.path = path.CGPath;
	self.fillLayer.fillRule = kCAFillRuleEvenOdd;
	self.fillLayer.fillColor = [UIColor blackColor].CGColor;
	self.fillLayer.opacity = 0.75;
	[self.cutoutView.layer addSublayer:self.fillLayer];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.scrollView.contentSize = self.imageToCrop.size;
	self.imageView.frame = CGRectMake(0, 0, self.imageToCrop.size.width, self.imageToCrop.size.height);
}

- (IBAction)croppedImage:(id)sender {
	NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-profile-image.png", self.playerName]];
	
	// Remove the fill layer
	[self.fillLayer removeFromSuperlayer];
	
	// Clipping the Image
	UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
	[self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:YES];
	
	UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	// Add the fill layer back
	[self.view.layer addSublayer:self.fillLayer];
	CGFloat scale = renderedImage.scale;
    CGFloat side = self.radius * 2;
	CGRect frame = CGRectMake(self.circleFrame.origin.x * scale, self.circleFrame.origin.y * scale , side * scale, side * scale);
	CGImageRef imageRef = CGImageCreateWithImageInRect(renderedImage.CGImage, frame);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
	
    // save the image
    NSData *data = UIImagePNGRepresentation(croppedImage);
    [data writeToFile:path atomically:YES];
	
	// Pass to the delegate
	[self.delegate profilePictureCropperViewController:self croppedImage:croppedImage];
}

- (IBAction)cancelCrop:(id)sender {
	[self.delegate profilePictureCropperViewController:self croppedImage:nil];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
	CGFloat zoomScale = scrollView.zoomScale;
    CGFloat inset = 120 / zoomScale;
    inset = floorf(inset);
    self.scrollView.contentInset = UIEdgeInsetsMake(inset, inset, inset, inset);
}

@end
