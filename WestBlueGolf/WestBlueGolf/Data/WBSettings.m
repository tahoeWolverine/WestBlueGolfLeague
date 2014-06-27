//
//  WBSettings.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 6/26/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBSettings.h"
#import "WBModels.h"

NSString * const kFavoritePlayers = @"FavoritePlayersKey";
NSString * const kMe = @"MeKey";

// replacement for device id
NSString * const kUniqueApplicationId = @"UniqueApplicationIdentifier";

@implementation WBSettings

#pragma mark - GCD-based Singleton method

+ (id)sharedSettings {
	static dispatch_once_t pred;
	static WBSettings *westBlueSettings = nil;
    
	dispatch_once(&pred, ^{ westBlueSettings = [[self alloc] init]; });
	return westBlueSettings;
}

#pragma mark - Persistent store management methods

- (void)save {
	[[NSUserDefaults standardUserDefaults] synchronize];
}

// clear out all user defaults except for the unique application id
- (void)resetUserDefaults {
	NSString *uniqueAppId = [self uniqueApplicationIdentifier];
	NSMutableDictionary *resetDictionary = [NSMutableDictionary dictionaryWithObject:uniqueAppId forKey:kUniqueApplicationId];
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:resetDictionary forName:[[NSBundle mainBundle] bundleIdentifier]];
}

/*!
 @method
 @abstract		configures "default" defaults
 @discussion	This method configures NSUserDefaults with the default values to use if not specified by user.
 */
+ (void)configureStandardDefaults {
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"WestBlueDefaultSettings" ofType:@"plist"];
	//NSDictionary *appSettings = [NSDictionary dictionaryWithContentsOfFile:path];
	
	//BOOL rememberMeState = [appSettings[@"WNRememberMe"] boolValue];

	//NSArray *keys = @[kEnvironmentKey, kRememberMeKey, kKMRememberMeKey, kSelectedHomeViewButtonKey, kDefaultDocumentDisplayOptions, kShowAnnotationsKey, kAnalyticsEnabledKey];
	//NSArray *values = @[environmentData, @(rememberMeState), @(rememberMeState), @(button), defaultDocumentDisplayOptionsData, @(showAnnotations), @YES];
    
	//NSDictionary *defaults = [NSDictionary dictionaryWithObjects:values forKeys:keys];
	//[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Unique application id accessors

- (void)setUniqueApplicationIdentifier:(NSString *)uniqueApplicationIdentifier {
	[[NSUserDefaults standardUserDefaults] setObject:uniqueApplicationIdentifier forKey:kUniqueApplicationId];
	[self save];
}

- (NSString *)uniqueApplicationIdentifier {
	return [[NSUserDefaults standardUserDefaults] stringForKey:kUniqueApplicationId];
}

#pragma mark - Custom defaults

- (NSArray *)favoritePlayerIds {
	return [[NSUserDefaults standardUserDefaults] objectForKey:kFavoritePlayers];
}

// This method is dangerous because some player objects may not be loaded in yet
/*- (NSArray *)favoritePlayers {
    NSArray *ids = [self favoritePlayerIds];
    NSMutableArray *players = [NSMutableArray array];
    WBPlayer *player = nil;
    for (NSNumber *playerId in ids) {
        player = [WBPlayer findWithId:[playerId integerValue]];
        [players addObject:player];
    }
    return players;
}*/

- (void)setFavoritePlayerIds:(NSArray *)favoritePlayerIds {
	[[NSUserDefaults standardUserDefaults] setObject:favoritePlayerIds forKey:kFavoritePlayers];
	[self save];
}

- (void)setFavoritePlayers:(NSArray *)favoritePlayers {
    NSMutableArray *playerIds = [NSMutableArray array];
    for (WBPlayer *player in favoritePlayers) {
        [playerIds addObject:player.id];
    }
    [self setFavoritePlayerIds:playerIds];
}

- (void)addFavoritePlayer:(WBPlayer *)player {
    [self addFavoritePlayerId:player.idValue];
}

- (void)addFavoritePlayerId:(NSInteger)playerId {
    NSMutableArray *playerIds = [NSMutableArray arrayWithArray:self.favoritePlayerIds];
    if (![playerIds containsObject:@(playerId)]) {
        [playerIds addObject:@(playerId)];
    }
    [self setFavoritePlayerIds:playerIds];
}

- (void)removeFavoritePlayer:(WBPlayer *)player {
    [self removeFavoritePlayerId:player.idValue];
}

- (void)removeFavoritePlayerId:(NSInteger)playerId {
    NSMutableArray *playerIds = [NSMutableArray arrayWithArray:self.favoritePlayerIds];
    if ([playerIds containsObject:@(playerId)]) {
        [playerIds removeObject:@(playerId)];
    }
    [self setFavoritePlayerIds:playerIds];
}

- (NSNumber *)mePlayerId {
	return [[NSUserDefaults standardUserDefaults] objectForKey:kMe];
}

- (WBPlayer *)mePlayer {
    return [WBPlayer findWithId:[self.mePlayerId integerValue]];
}

- (void)setMePlayerId:(NSNumber *)mePlayerId {
    [[NSUserDefaults standardUserDefaults] setObject:mePlayerId forKey:kMe];
	[self save];
}

- (void)setMePlayer:(WBPlayer *)mePlayer {
    [self setMePlayerId:mePlayer.id];
}

- (void)clearMePlayer {
    [self setMePlayerId:@0];
}

@end
