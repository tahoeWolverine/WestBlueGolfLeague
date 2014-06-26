//
//  WBYearDataService.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 5/23/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBYearDataService.h"
#import <AFNetworking/AFNetworking.h>

#define kEndpointYearData @"http://westblue.digitalzebra.net/api/v1/data/%ld"

@implementation WBYearDataService

+ (void)requestYearDataAndPopulateForYear:(NSInteger)year completionBlock:(void (^) (BOOL, id))completionBlock {
    NSString *urlString = [NSString stringWithFormat:kEndpointYearData, (long)year];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0];
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	
	operation.responseSerializer = [AFJSONResponseSerializer serializer];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		DLog(@"Dummy year data request Completed: %@", responseObject);
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
