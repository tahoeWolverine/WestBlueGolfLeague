//
//  WBYearDataService.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 5/23/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBYearDataService.h"
#import <AFNetworking/AFNetworking.h>

@implementation WBYearDataService

+ (void)requestYearDataAndPopulateForYear:(NSInteger)year completionBlock:(void (^) (BOOL))completionBlock {
	NSURL *url = [NSURL URLWithString:@"http://westblue.digitalzebra.net/api/v1/data/2014"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0];
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	
	operation.responseSerializer = [AFJSONResponseSerializer serializer];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		DLog(@"Dummy year data request Completed: %@", responseObject);
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			completionBlock(YES);
		}];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"Failed");
		completionBlock(NO);
	}];
	[operation start];
}

@end
