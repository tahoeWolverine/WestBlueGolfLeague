//
//  WBInfoWebviewViewController.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/5/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBInfoWebviewViewController.h"

@interface WBInfoWebviewViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSURL *webviewURL;

@end

@implementation WBInfoWebviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self.webview loadRequest:[NSURLRequest requestWithURL:self.webviewURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setWebviewContentWithFilename:(NSString *)fileName {
	NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
	self.webviewURL = [NSURL fileURLWithPath:path];
}

@end
