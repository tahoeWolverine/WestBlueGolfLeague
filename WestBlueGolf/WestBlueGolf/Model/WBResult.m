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
	WBResult *newResult = [NSEntityDescription insertNewObjectForEntityForName:@"WBResult" inManagedObjectContext:[[self class] managedObjectContext]];
	newResult.pointsValue = points;
	newResult.priorHandicapValue = priorHandicap;
	newResult.scoreValue = score;
	
	[match addResultsObject:newResult];
	[player addResultsObject:newResult];
	
	[[WBCoreDataManager sharedManager] saveContext];
	return newResult;
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
