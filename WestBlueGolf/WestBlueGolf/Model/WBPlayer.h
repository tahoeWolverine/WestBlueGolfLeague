#import "_WBPlayer.h"

@class WBTeam;
@class WBYear;

// Leaderboard keys
#define kLeaderboardPlayerAverageNet @"averageNet"
#define kLeaderboardPlayerAverageOpponentNetScore @"averageOpponentNetScore"
#define kLeaderboardPlayerAverageOpponentScore @"averageOpponentScore"
#define kLeaderboardPlayerAveragePoints @"averagePoints"
#define kLeaderboardPlayerAverageScore @"averageScore"
#define kLeaderboardPlayerHandicap @"handicap"
#define kLeaderboardPlayerMaxPoints @"maxPoints"
#define kLeaderboardPlayerMinNet @"minNet"
#define kLeaderboardPlayerMinScore @"minScore"
#define kLeaderboardPlayerTotalImproved @"totalImproved"
#define kLeaderboardPlayerTotalPoints @"totalPoints"
#define kLeaderboardPlayerTotalRounds @"totalRounds"
#define kLeaderboardPlayerTotalWins @"totalWins"
#define kLeaderboardPlayerWinLossRatio @"winLossRatio"

#define kLeaderboardPlayerTopPercentage @"topPercentage"
#define kLeaderboardPlayerTopTenPercentage @"topTenPercentage"
#define kLeaderboardPlayerAverageMarginVictory @"averageMarginOfVictory"
#define kLeaderboardPlayerAverageMarginNetVictory @"averageMarginOfNetVictory"

#define kLeaderboardPlayerTripleCrown @"tripleCrown"
#define kLeaderboardPlayerTripleCrown2 @"tripleCrown2"

#define kNoShowPlayerName @"No Show"

@interface WBPlayer : _WBPlayer {}

// Player specific create function
+ (WBPlayer *)createPlayerWithId:(NSInteger)playerId
                            name:(NSString *)name
                 currentHandicap:(NSInteger)currentHandicap
                            real:(BOOL)real
                       inContext:(NSManagedObjectContext *)moc;
+ (WBPlayer *)playerWithId:(NSInteger)playerId
                      name:(NSString *)name
           currentHandicap:(NSInteger)currentHandicap
                      real:(BOOL)real
                 inContext:(NSManagedObjectContext *)moc;

+ (WBPlayer *)me;
- (void)setPlayerToMe;
- (void)setPlayerToNotMe;
- (WBTeam *)currentTeam;

/*+ (WBPlayer *)noShowPlayer;
+ (void)createNoShowPlayerInContext:(NSManagedObjectContext *)moc;
- (BOOL)isNoShowPlayer;*/

+ (WBPlayer *)playerWithName:(NSString *)name inContext:(NSManagedObjectContext *)moc;

+ (NSArray *)findAllForYear:(WBYear *)year inContext:(NSManagedObjectContext *)moc;
- (NSArray *)filterResultsForYear:(WBYear *)year goodData:(BOOL)goodData;
- (NSArray *)filterResultsForYear:(WBYear *)year goodData:(BOOL)goodData sorts:(NSArray *)sorts;
- (WBPlayerYearData *)filterYearDataForYear:(WBYear *)year;
- (WBPlayerYearData *)thisYearData;
- (NSInteger)startingHandicapInYear:(WBYear *)year;
- (NSInteger)finishingHandicapInYear:(WBYear *)year;

- (NSInteger)thisYearHandicap;
- (NSString *)currentHandicapString;

- (NSArray *)recordForYear:(WBYear *)year;
- (CGFloat)recordRatioForYear:(WBYear *)year;
- (NSString *)recordStringForYear:(WBYear *)year;

- (NSInteger)lowRoundForYear:(WBYear *)year inContext:(NSManagedObjectContext *)moc;
- (NSString *)lowRoundString;
- (NSInteger)seasonIndexForLowRoundForYear:(WBYear *)year;

- (NSInteger)lowNetForYear:(WBYear *)year;
- (NSString *)lowNetString;
- (NSInteger)seasonIdexForLowNetForYear:(WBYear *)year;

- (CGFloat)averagePointsInYear:(WBYear *)year;
- (NSString *)averagePointsString;

- (NSInteger)improvedInYear:(WBYear *)year;
- (NSString *)improvedString;

- (CGFloat)averageScoreForYear:(WBYear *)year;
- (NSString *)averageScoreString;
- (CGFloat)averageNetScoreForYear:(WBYear *)year;
- (CGFloat)averageOpponentScoreForYear:(WBYear *)year;
- (CGFloat)averageOpponentNetScoreForYear:(WBYear *)year;

- (NSInteger)mostPointsInMatchForYear:(WBYear *)year;
- (NSInteger)seasonIndexForMostPointsInMatchForYear:(WBYear *)year;
- (NSInteger)totalPointsForYear:(WBYear *)year;

- (CGFloat)averageMarginOfVictoryForYear:(WBYear *)year;
- (CGFloat)averageMarginOfNetVictoryForYear:(WBYear *)year;

- (WBBoardData *)findHandicapBoardData;
- (WBBoardData *)findWinLossBoardData;
- (WBBoardData *)findLowScoreBoardData;
- (WBBoardData *)findAveragePointsBoardData;
- (WBBoardData *)findImprovedBoardData;
- (WBBoardData *)findLowNetBoardData;

@end
