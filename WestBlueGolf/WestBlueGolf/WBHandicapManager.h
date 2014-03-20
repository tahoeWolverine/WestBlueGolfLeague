//
//  WBHandicapManager.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/10/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBYear;

@interface WBHandicapManager : NSObject

- (void)calculateHandicapsForYear:(WBYear *)year moc:(NSManagedObjectContext *)moc;

@end
