//
//  WBFileSystem.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 2/7/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBFileSystem.h"
#import <sys/xattr.h>

#define FOLDER_NAME_PRIVATE_DOCS	@"wbg"

#define FILE_ATTRIBUTE_SKIP_BACKUP_KEY		"com.apple.MobileBackup"
#define FILE_ATTRIBUTE_SKIP_BACKUP_VALUE	1

static NSString *cachesDirectory = nil;
static NSString *libraryDirectory = nil;
static NSString *privateDocumentsDirectory = nil;

@implementation WBFileSystem

#pragma mark - File System Utility Methods

// This should only need to be added to the wln directory, as the attribute trickels down to all files contained
BOOL addSkipBackupAttributeToFile(NSString *path) {
	const char *filePath = [path fileSystemRepresentation];
	
	// We want to write a 1 (YES/true) to the MobileBackup attribute to flag the file as not backup
	const char *attrName = FILE_ATTRIBUTE_SKIP_BACKUP_KEY;
	u_int8_t attrValue = FILE_ATTRIBUTE_SKIP_BACKUP_VALUE;
	
	int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
	
	return result == 0;
}

BOOL createFolderWithPath(NSString *path, NSString *identifier) {
	NSError *error = nil;
	BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
	if (!success || error) {
		DLog(@"Error removing %@ file, error: %@", identifier, error);
	}
	return success;
}

BOOL deleteFileWithPath(NSString *path, NSString *identifier) {
	NSError *error = nil;
	BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
	if (!success || error) {
		DLog(@"Error removing %@ file, error: %@", identifier, error);
	}
	return success;
}

BOOL moveFileWithPath(NSString *path, NSString *destination, NSString *identifier) {
	// Delete the destination path before moving, if it exists. This is a requirement of the move API. Downloads should not have
	// anything at the location, but syncs need to do this.
	if ([[NSFileManager defaultManager] fileExistsAtPath:destination]) {
		if (!deleteFileWithPath(destination, identifier)) {
			return NO;
		}
	}
	
	NSError *error = nil;
	BOOL success = [[NSFileManager defaultManager] moveItemAtPath:path toPath:destination error:&error];
	if (!success || error) {
		DLog(@"Error moving %@ folder, error: %@", identifier, error);
	}
	return success;
}

#pragma mark - Directory Structures

+ (NSString *)documentsDirectory {
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return searchPaths[0];
}

+ (NSString *)cachesDirectory {
	if (!cachesDirectory) {
		NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		cachesDirectory = [searchPaths[0] copy];
	}
	return cachesDirectory;
}

+ (NSString *)libraryDirectory {
	if (!libraryDirectory) {
		NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		libraryDirectory = [searchPaths[0] copy];
	}
	return libraryDirectory;
}

+ (NSString *)privateDocumentsDirectory {
	if (!privateDocumentsDirectory) {
		// Use a temporary directory until the directory has successfully been created
		NSString *privateDocsDirectory = [[[self class] libraryDirectory] stringByAppendingPathComponent:FOLDER_NAME_PRIVATE_DOCS];
		if (![[NSFileManager defaultManager] fileExistsAtPath:privateDocsDirectory]) {
			if (!createFolderWithPath(privateDocsDirectory, @"private directory")) {
				ALog(@"Error creating private directory");
			}
		}
		
		// Value the static so that the path can be passed in the future
		privateDocumentsDirectory = [privateDocsDirectory copy];
		
		BOOL attributeSuccess = addSkipBackupAttributeToFile(privateDocumentsDirectory);
		if (!attributeSuccess) {
			ALog(@"Error adding skip backup attribute to private docs directory");
		}
	}
	return privateDocumentsDirectory;
}

@end
