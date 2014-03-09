#import "_WBTeam.h"

// LeaderBoard keys
#define kLeaderboardTeamAverageHandicap @"averageHandicap"
#define kLeaderboardTeamAverageNet @"averageNet"
#define kLeaderboardTeamAverageOpponentScore @"averageOpponentScore"
#define kLeaderboardTeamAveragePoints @"averagePoints"
#define kLeaderboardTeamAverageScore @"averageScore"
#define kLeaderboardTeamIndividualWinLossRatio @"individualWinLossRatio"
#define kLeaderboardTeamMaxWeekPoints @"maxWeekPoints"
#define kLeaderboardTeamTotalWins @"totalWins"
#define kLeaderboardTeamWeeklyWinLossRatio @"weeklyWinLossRatio"

#define kLeaderboardTeamTopPercentage @"topPercentage"
#define kLeaderboardTeamTopFivePercentage @"topFivePercentage"

@interface WBTeam : _WBTeam {}

+ (WBTeam *)createTeamWithName:(NSString *)name id:(NSInteger)teamId;

- (void)deleteTeam;

+ (WBTeam *)teamWithId:(NSInteger)teamId;

- (BOOL)isMyTeam;

- (NSString *)placeString;
- (NSString *)averagePointsString;
- (NSString *)record;
- (NSString *)individualRecord;
- (NSString *)improvedString;

@end
