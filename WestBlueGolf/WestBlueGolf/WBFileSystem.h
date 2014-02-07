//
//  WBFileSystem.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 2/7/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@interface WBFileSystem : NSObject

+ (NSString *)documentsDirectory ;
+ (NSString *)cachesDirectory;
+ (NSString *)libraryDirectory;
+ (NSString *)privateDocumentsDirectory;

@end
