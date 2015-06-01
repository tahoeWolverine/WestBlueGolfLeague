//
//  WBAvailableYearsService.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 5/23/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBAvailableYearsService.h"
#import <AFNetworking/AFNetworking.h>
#import "WBInputDataManager.h"

@implementation WBAvailableYearsService

+ (void)requestAvailableYearsAndPopulate:(void (^) (BOOL, id))completionBlock {
    //NSURL *url = [NSURL URLWithString:@"http://westblue.digitalzebra.net/api/v1/availableYears"];
    NSURL *url = [NSURL URLWithString:@"http://new.westbluegolfleague.com/api/v1/availableYears"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	operation.responseSerializer = [AFJSONResponseSerializer serializer];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		//DLog(@"Year data request Completed: %@", responseObject);
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			completionBlock(YES, responseObject);
		}];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"Failed");
		completionBlock(NO, nil);
	}];
	[operation start];
}

@end
