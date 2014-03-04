#import "_WBResult.h"

@interface WBResult : _WBResult {}

+ (WBResult *)createResultForMatch:(WBMatch *)match
						 forPlayer:(WBPlayer *)player
						withPoints:(NSInteger)points
					 priorHandicap:(NSInteger)priorHandicap
							 score:(NSInteger)score;

- (void)deleteResult;

- (WBResult *)opponentResult;

@end
