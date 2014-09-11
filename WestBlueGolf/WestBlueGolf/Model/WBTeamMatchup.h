#import "_WBTeamMatchup.h"

typedef enum {
	WBPlayoffTypeNone,
	WBPlayoffTypeChampionship,
	WBPlayoffTypeBronze,
	WBPlayoffTypeConsolation,
	WBPlayoffTypeLexis
} WBPlayoffType;

@interface WBTeamMatchup : _WBTeamMatchup {}

+ (WBTeamMatchup *)createTeamMatchupBetweenTeam:(WBTeam *)team1
										andTeam:(WBTeam *)team2
										forWeek:(WBWeek *)week
                                      matchupId:(NSInteger)matchupId
								  matchComplete:(BOOL)matchComplete
                                    playoffType:(WBPlayoffType)playoffType
											moc:(NSManagedObjectContext *)moc;

+ (WBTeamMatchup *)matchupForTeam:(WBTeam *)team inWeek:(WBWeek *)week inContext:(NSManagedObjectContext *)moc;

- (WBTeam *)opponentTeamOfTeam:(WBTeam *)team;

- (NSInteger)totalPointsForTeam:(WBTeam *)team;
- (NSString *)totalPointsStringForTeam:(WBTeam *)team;
- (NSString *)totalScoreStringForTeam:(WBTeam *)team;

- (NSArray *)displayStrings;
- (NSArray *)displayStringsForTeam:(WBTeam *)team;

- (NSString *)timeLabel;
- (NSString *)shortTime;

- (NSArray *)orderedMatches;

- (WBTeam *)teamWithName:(NSString *)name;

@end
