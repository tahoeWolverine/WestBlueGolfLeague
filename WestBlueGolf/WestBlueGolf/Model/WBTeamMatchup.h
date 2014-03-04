#import "_WBTeamMatchup.h"

@interface WBTeamMatchup : _WBTeamMatchup {}

+ (WBTeamMatchup *)createTeamMatchupBetweenTeam:(WBTeam *)team1 andTeam:(WBTeam *)team2 forWeek:(WBWeek *)week;

@end
