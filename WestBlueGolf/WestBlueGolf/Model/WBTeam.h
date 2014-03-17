#import "_WBTeam.h"

// LeaderBoard keys
#define kLeaderboardTeamAverageHandicap @"averageHandicap"
#define kLeaderboardTeamAverageMarginVictory @"averageMarginOfVictory"
#define kLeaderboardTeamAverageMarginNetVictory @"averageMarginOfNetVictory"
#define kLeaderboardTeamAverageNet @"averageNet"
#define kLeaderboardTeamAverageOpponentNetScore @"averageOpponentNetScore"
#define kLeaderboardTeamAverageOpponentScore @"averageOpponentScore"
#define kLeaderboardTeamAveragePoints @"averagePoints"
#define kLeaderboardTeamAverageScore @"averageScore"
#define kLeaderboardTeamIndividualWinLossRatio @"individualWinLossRatio"
#define kLeaderboardTeamMaxWeekPoints @"maxWeekPoints"
#define kLeaderboardTeamTotalImproved @"totalImproved"
#define kLeaderboardTeamTotalWins @"totalWins"
#define kLeaderboardTeamWeeklyWinLossRatio @"weeklyWinLossRatio"

#define kLeaderboardTeamTopPercentage @"topPercentage"
#define kLeaderboardTeamTopFivePercentage @"topFivePercentage"
#define kLeaderboardTeamTripleCrown @"tripleCrown"
#define kLeaderboardTeamPlayoffs @"playoffs"

@interface WBTeam : _WBTeam {}

+ (WBTeam *)createTeamWithName:(NSString *)name teamId:(NSInteger)teamId;
+ (WBTeam *)teamWithName:(NSString *)name teamId:(NSInteger)teamId;

+ (WBTeam *)teamWithId:(NSInteger)teamId;
+ (WBTeam *)myTeam;

- (NSInteger)totalPointsForYear:(WBYear *)year;
- (NSString *)placeString;
- (NSString *)averagePointsString;
- (NSString *)record;
- (CGFloat)recordRatioForYear:(WBYear *)year;
- (NSString *)individualRecord;
- (CGFloat)individualRecordRatioForYear:(WBYear *)year;
- (NSArray *)individualRecordForYear:(WBYear *)year;
- (NSString *)improvedString;
- (NSInteger)improvedInYear:(WBYear *)year;
- (CGFloat)averageHandicapForYear:(WBYear *)year;
- (CGFloat)averageScoreForYear:(WBYear *)year;
- (CGFloat)averageNetScoreForYear:(WBYear *)year;
- (CGFloat)averageOpponentScoreForYear:(WBYear *)year;
- (CGFloat)averageOpponentNetScoreForYear:(WBYear *)year;
- (NSInteger)mostPointsInWeekForYear:(WBYear *)year;

- (CGFloat)averageMarginOfVictoryForYear:(WBYear *)year;
- (CGFloat)averageMarginOfNetVictoryForYear:(WBYear *)year;

- (NSArray *)findResultsForYear:(WBYear *)year goodData:(BOOL)goodData;
+ (NSArray *)findAllForYear:(WBYear *)year;

- (WBBoardData *)findTotalPointsBoardData;
- (WBBoardData *)findHandicapBoardData;
- (WBBoardData *)findWinLossRatioBoardData;
- (WBBoardData *)findImprovedBoardData;
- (WBBoardData *)findIndividualWinLossRatioBoardData;
@end
