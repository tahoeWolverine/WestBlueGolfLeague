#import "WBResult.h"
#import "WBCoreDataManager.h"
#import "WBMatch.h"
#import "WBPlayer.h"

@interface WBResult ()

@end

@implementation WBResult

+ (WBResult *)createResultForMatch:(WBMatch *)match
						 forPlayer:(WBPlayer *)player
						withPoints:(NSInteger)points
					 priorHandicap:(NSInteger)priorHandicap
							 score:(NSInteger)score {
	BOOL found = NO;
	for (WBPlayer *p in match.players) {
		if (player.objectID == p.objectID) {
			found = YES;
		}
	}
	
	if (!found) {
		ALog(@"Attempting to add result for player not in match");
	}
	
	if (match.results.count > 0 && [(WBResult *)match.results.allObjects[0] pointsValue] + points != 24) {
		ALog(@"Attempting to add result with points that do not total 24");
	}
	
	WBResult *newResult = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] managedObjectContext]];
	newResult.pointsValue = points;
	newResult.priorHandicapValue = priorHandicap;
	newResult.scoreValue = score;
	
	[match addResultsObject:newResult];
	[player addResultsObject:newResult];
	
	[WBCoreDataManager saveContext];
	return newResult;
}

- (void)deleteResult {
	[[[self class] managedObjectContext] deleteObject:self];
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

- (WBResult *)opponentResult {
	WBMatch *match = self.match;
	for (WBResult *result in match.results) {
		if (result != self) {
			return result;
		}
	}
	ALog(@"Could not find opponent result for WBResult");
	return nil;
}

@end
