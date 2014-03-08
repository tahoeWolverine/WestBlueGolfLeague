#import "_WBTeamMatchup.h"

@interface WBTeamMatchup : _WBTeamMatchup {}

+ (WBTeamMatchup *)createTeamMatchupBetweenTeam:(WBTeam *)team1 andTeam:(WBTeam *)team2 forWeek:(WBWeek *)week;

- (void)deleteTeamMatchup;

+ (WBTeamMatchup *)matchupForTeam:(WBTeam *)team inWeek:(WBWeek *)week;

- (NSString *)totalPointsStringForTeam:(WBTeam *)team;
- (NSString *)totalScoreStringForTeam:(WBTeam *)team;

- (NSArray *)displayStrings;

@end
