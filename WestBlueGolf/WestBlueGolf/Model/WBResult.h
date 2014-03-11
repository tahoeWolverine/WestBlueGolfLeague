#import "_WBResult.h"

@interface WBResult : _WBResult {}

+ (WBResult *)createResultForMatch:(WBMatch *)match
						 forPlayer:(WBPlayer *)player
							  team:(WBTeam *)team
						withPoints:(NSInteger)points
					 priorHandicap:(NSInteger)priorHandicap
							 score:(NSInteger)score;

- (WBResult *)opponentResult;

- (BOOL)wasWin;
- (BOOL)wasTie;
- (BOOL)wasLoss;

- (NSInteger)scoreDifference;
- (NSInteger)netScoreDifference;

@end
