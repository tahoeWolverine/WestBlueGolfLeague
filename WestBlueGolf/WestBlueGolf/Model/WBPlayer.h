#import "_WBPlayer.h"

@class WBYear;

// Leaderboard keys
#define kLeaderboardPlayerAverageNet @"averageNet"
#define kLeaderboardPlayerAverageOpponentScore @"averageOpponentScore"
#define kLeaderboardPlayerAveragePoints @"averagePoints"
#define kLeaderboardPlayerAverageScore @"averageScore"
#define kLeaderboardPlayerHandicap @"handicap"
#define kLeaderboardPlayerMaxPoints @"maxPoints"
#define kLeaderboardPlayerMinNet @"minNet"
#define kLeaderboardPlayerMinScore @"minScore"
#define kLeaderboardPlayerTotalImproved @"totalImproved"
#define kLeaderboardPlayerTotalPoints @"totalPoints"
#define kLeaderboardPlayerTotalWins @"totalWins"
#define kLeaderboardPlayerWinLossRatio @"winLossRatio"

#define kLeaderboardPlayerTopPercentage @"topPercentage"
#define kLeaderboardPlayerTopTenPercentage @"topTenPercentage"

@interface WBPlayer : _WBPlayer {}

// Player specific create function
+ (WBPlayer *)createPlayerWithName:(NSString *)name
				   currentHandicap:(NSInteger)currentHandicap
							onTeam:(WBTeam *)currentTeam;

+ (WBPlayer *)me;
- (void)setPlayerToMe;
- (void)setPlayerToNotMe;

+ (WBPlayer *)noShowPlayer;
+ (void)createNoShowPlayer;

+ (WBPlayer *)playerWithName:(NSString *)name;
//+ (NSArray *)fetchAllPlayersWithSorts:(NSArray *)sorts;

- (NSString *)shortName;
- (NSString *)firstName;
- (NSString *)currentHandicapString;
- (NSInteger)startingHandicapInYear:(WBYear *)year;
- (WBPlayerYearData *)thisYearData;

- (NSArray *)recordForYear:(WBYear *)year;
- (CGFloat)recordRatioForYear:(WBYear *)year;
- (NSString *)record;

- (NSInteger)lowRoundForYear:(WBYear *)year;
- (NSString *)lowRoundString;

- (NSInteger)lowNetForYear:(WBYear *)year;
- (NSString *)lowNetString;

- (CGFloat)averagePointsInYear:(WBYear *)year;
- (NSString *)averagePointsString;

- (CGFloat)averageScoreInYear:(WBYear *)year;
- (NSString *)averageScoreString;

- (NSInteger)improvedInYear:(WBYear *)year;
- (NSString *)improvedString;

@end
