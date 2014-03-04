#import "WBPlayer.h"
#import "WBCoreDataManager.h"
#import "WBTeam.h"

@interface WBPlayer ()

@end

@implementation WBPlayer

+ (WBPlayer *)baseCreatePlayerWithName:(NSString *)name
					  currentHandicap:(NSInteger)currentHandicap
							   onTeam:(WBTeam *)currentTeam {
	WBPlayer *newPlayer = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] managedObjectContext]];
	newPlayer.name = name;
	newPlayer.currentHandicapValue = currentHandicap;
	
	[currentTeam addPlayersObject:newPlayer];
	return newPlayer;
}

+ (WBPlayer *)createPlayerWithName:(NSString *)name
				   currentHandicap:(NSInteger)currentHandicap
							onTeam:(WBTeam *)currentTeam {
	WBPlayer *newPlayer = [WBPlayer baseCreatePlayerWithName:name currentHandicap:currentHandicap onTeam:currentTeam];
	
	[WBCoreDataManager saveContext];
	return newPlayer;
}

- (void)deletePlayer {
	[[[self class] managedObjectContext] deleteObject:self];
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

- (NSString *)shortName {
	NSString *firstName = [self.name componentsSeparatedByString:@" "][0];
	NSString *shortFirstName = [NSString stringWithFormat:@"%@.", [firstName substringToIndex:1]];
	return [self.name stringByReplacingOccurrencesOfString:firstName withString:shortFirstName];
}

@end
