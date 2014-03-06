#import "WBPlayer.h"
#import "WBCoreDataManager.h"
#import "WBResult.h"
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

+ (WBPlayer *)playerWithName:(NSString *)name {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
	NSArray *players = [[WBCoreDataManager class] findWithPredicate:predicate forEntity:[[self class] entityName]];
	return [players lastObject];
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

- (NSString *)shortName {
	NSString *firstName = [self.name componentsSeparatedByString:@" "][0];
	NSString *shortFirstName = [NSString stringWithFormat:@"%@.", [firstName substringToIndex:1]];
	return [self.name stringByReplacingOccurrencesOfString:firstName withString:shortFirstName];
}

- (NSString *)record {
	NSArray *record = [self recordForYear:[WBYear thisYear]];
	BOOL hasTies = record[2] && [(NSNumber *)record[2] integerValue] != 0;
	return [NSString stringWithFormat:@"%@-%@%@%@", record[0], record[1], hasTies ? @"-" : @"", hasTies ? record[2] : @""];
}

- (NSArray *)recordForYear:(WBYear *)year {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && player = %@", year, self];
	NSArray *results = [[WBCoreDataManager class] findWithPredicate:predicate forEntity:[WBResult entityName]];
	NSInteger wins = 0;
	NSInteger losses = 0;
	NSInteger ties = 0;

	for (WBResult *result in results) {
		if ([result wasWin]) {
			wins++;
		} else if ([result wasLoss]) {
			losses++;
		} else {
			ties++;
		}
	}

	return @[[NSNumber numberWithInteger:wins], [NSNumber numberWithInteger:losses], [NSNumber numberWithInteger:ties]];
}

- (NSString *)currentHandicapString {
	NSInteger adjusted = self.currentHandicapValue - 36;
	BOOL isPositive = adjusted > 0;
	return [NSString stringWithFormat:@"%@%ld", isPositive ? @"+" : @"", adjusted];
}

@end
