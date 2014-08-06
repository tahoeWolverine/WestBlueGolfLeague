#import "_WBTeam.h"

@class WBWeek;
@class WBYear;

// LeaderBoard keys
#define kLeaderboardTeamTotalPoints @"team_ranking"

#define kLeaderboardTeamAverageHandicap @"team_avg_handicap"
#define kLeaderboardTeamAverageMarginVictory @"team_avg_margin_victory"
#define kLeaderboardTeamAverageMarginNetVictory @"team_avg_margin_net_victory"
#define kLeaderboardTeamAverageNet @"team_avg_net_score"
#define kLeaderboardTeamAverageOpponentNetScore @"team_avg_opp_net_score"
#define kLeaderboardTeamAverageOpponentScore @"team_avg_opp_score"
//#define kLeaderboardTeamAveragePoints @"averagePoints" derived from total points
#define kLeaderboardTeamAverageScore @"team_avg_score"
#define kLeaderboardTeamIndividualWinLossRatio @"team_ind_win_loss_record"
#define kLeaderboardTeamMaxWeekPoints @"team_most_points_in_week"
#define kLeaderboardTeamTotalImproved @"team_season_improvement"
#define kLeaderboardTeamTotalWins @"team_total_match_wins"
#define kLeaderboardTeamWeeklyWinLossRatio @"team_win_loss_ratio"

#define kLeaderboardTeamTopPercentage @"topPercentage"
#define kLeaderboardTeamTopFivePercentage @"topFivePercentage"
#define kLeaderboardTeamTripleCrown @"tripleCrown"
#define kLeaderboardTeamPlayoffs @"playoffs"

@interface WBTeam : _WBTeam {}

+ (WBTeam *)createTeamWithName:(NSString *)name teamId:(NSInteger)teamId real:(BOOL)real inContext:(NSManagedObjectContext *)moc;
+ (WBTeam *)teamWithName:(NSString *)name teamId:(NSInteger)teamId real:(BOOL)real inContext:(NSManagedObjectContext *)moc;

+ (WBTeam *)teamWithId:(NSInteger)teamId inContext:(NSManagedObjectContext *)moc;
+ (WBTeam *)myTeam;

+ (WBTeam *)findWithId:(NSInteger)teamId;
+ (NSArray *)findAllForYear:(WBYear *)year inContext:(NSManagedObjectContext *)moc;
- (NSArray *)filterResultsForYear:(WBYear *)year goodData:(BOOL)goodData;
- (NSArray *)filterMatchupsForYear:(WBYear *)year;
- (NSArray *)filterPlayersForYear:(WBYear *)year;

- (NSString *)placeString;
- (NSString *)averagePointsString;
- (NSString *)recordStringForYear:(WBYear *)year;
- (NSString *)individualRecordStringForYear:(WBYear *)year;

- (NSInteger)totalResultsForYear:(WBYear *)year;
- (NSInteger)totalOpponentResultsForYear:(WBYear *)year;

- (NSInteger)seasonIndexForMostPointsInWeekForYear:(WBYear *)year;

- (NSInteger)rankPriorToWeek:(WBWeek *)week;

- (NSArray *)top4Players;

- (WBBoardData *)findTotalPointsBoardData;
- (WBBoardData *)findHandicapBoardData;
- (WBBoardData *)findWinLossRatioBoardData;
- (WBBoardData *)findImprovedBoardData;
- (WBBoardData *)findIndividualWinLossRatioBoardData;
@end
