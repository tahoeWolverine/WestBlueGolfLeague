//
//  WBSettings.h
//  WestBlueGolf
//
//  Created by Michael Harlow on 6/26/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

extern NSString * const kFavoritePlayers;
extern NSString * const kMe;

extern NSString * const kUniqueApplicationIdentifier;

@class WBPlayer;

@interface WBSettings : NSObject

// replacement for device id.  Unique to each install of the app
@property (copy, nonatomic) NSString *uniqueApplicationIdentifier;

@property (strong, nonatomic) NSArray *favoritePlayerIds;
@property (strong, nonatomic) NSNumber *mePlayerId;

+ (WBSettings *)sharedSettings;
+ (void)configureStandardDefaults;

- (void)save;
- (void)resetUserDefaults;

- (void)addFavoritePlayer:(WBPlayer *)player;
- (void)removeFavoritePlayer:(WBPlayer *)player;
//- (NSArray *)favoritePlayers;

- (WBPlayer *)mePlayer;
- (void)setMePlayer:(WBPlayer *)mePlayer;
- (void)clearMePlayer;

@end
