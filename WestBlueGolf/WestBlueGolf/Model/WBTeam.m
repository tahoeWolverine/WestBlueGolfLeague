#import "WBTeam.h"
#import "WBCoreDataManager.h"
#import "WBMatch.h"
#import "WBPlayer.h"
#import "WBResult.h"
#import "WBTeamMatchup.h"
#import "WBWeek.h"
#import "WBYear.h"

@interface WBTeam ()

@end

@implementation WBTeam

+ (WBTeam *)createTeamWithName:(NSString *)name id:(NSInteger)teamId {
	//WBTeam *newTeam = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] managedObjectContext]];
	WBTeam *newTeam = (WBTeam *)[WBPeopleEntity baseCreatePeopleWithName:name];
	//newTeam.name = name;
	newTeam.teamIdValue = teamId;
	
	[WBCoreDataManager saveContext];
	return newTeam;
}

- (void)deleteTeam {
	[[[self class] managedObjectContext] deleteObject:self];
}

+ (WBTeam *)teamWithId:(NSInteger)teamId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamId = %@", [NSNumber numberWithInteger:teamId]];
	NSArray *teams = [[WBCoreDataManager class] findWithPredicate:predicate forEntity:[[self class] entityName]];
	return [teams lastObject];
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

- (BOOL)isMyTeam {
	return [self.players containsObject:[WBPlayer me]];
}

- (NSInteger)place {
	WBYear *year = [WBYear thisYear];
	NSInteger teamPoints = [self totalPointsForYear:year];
	
	NSArray *teams = [WBCoreDataManager findWithPredicate:Nil forEntity:[[self class] entityName]];
	NSInteger points = 0;
	NSInteger rank = 1;
	for (WBTeam *team in teams) {
		if (team == self) {
			continue;
		}

		points = [team totalPointsForYear:year];
		if (points > teamPoints) {
			rank++;
		}
	}
	return rank;
}

- (NSString *)placeString {
	NSInteger place = [self place];
	NSString *text = place == 1 ? @"st" : place == 2 ? @"nd" : place == 3 ? @"rd" : @"th";
	return [NSString stringWithFormat:@"%ld%@", (long)place, text];
}

- (NSInteger)totalPointsForYear:(WBYear *)year {
	NSArray *results = self.results.allObjects;
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@", year];
	NSArray *filtered = [results filteredArrayUsingPredicate:pred];
	NSInteger total = 0;
	for (WBResult *result in filtered) {
		total += result.pointsValue;
	}
	return total;
}

- (NSString *)averagePointsString {
	NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
	fmt.minimumFractionDigits = 1;
	NSNumber *avg = [NSNumber numberWithFloat:(CGFloat)[self totalPointsForYear:[WBYear thisYear]] / (CGFloat)[self.matchups count]];
	return avg.floatValue != 0.0f ? [fmt stringFromNumber:avg] : @"0.0";
}

- (NSString *)individualRecord {
	NSArray *record = [self individualRecordForYear:[WBYear thisYear]];
	BOOL hasTies = record[2] && [(NSNumber *)record[2] integerValue] != 0;
	return [NSString stringWithFormat:@"%@-%@%@%@", record[0], record[1], hasTies ? @"-" : @"", hasTies ? record[2] : @""];
}

- (NSArray *)individualRecordForYear:(WBYear *)year {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && team = %@", year, self];
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

- (NSString *)record {
	NSArray *record = [self recordForYear:[WBYear thisYear]];
	BOOL hasTies = record[2] && [(NSNumber *)record[2] integerValue] != 0;
	return [NSString stringWithFormat:@"%@-%@%@%@", record[0], record[1], hasTies ? @"-" : @"", hasTies ? record[2] : @""];
}

- (NSArray *)recordForYear:(WBYear *)year {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && team = %@", year, self];
	NSArray *results = [[WBCoreDataManager class] findWithPredicate:predicate forEntity:[WBResult entityName]];
	NSInteger wins = 0;
	NSInteger losses = 0;
	NSInteger ties = 0;
	NSMutableArray *weeks = [NSMutableArray arrayWithCapacity:self.matchups.count];
	for (NSInteger i = 0; i < self.matchups.count; i++) {
		weeks[i] = [NSNumber numberWithInteger:0];
	}
	
	NSInteger index = 0;
	for (WBResult *result in results) {
		index = result.match.teamMatchup.week.seasonIndexValue - 1;
		[weeks replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:[[weeks objectAtIndex:index] integerValue] + result.pointsValue]];
	}
	
	NSInteger value = 0;
	for (NSInteger i = 0; i < self.matchups.count; i++) {
		value = [[weeks objectAtIndex:i] integerValue];
		if (value > 48) {
			wins++;
		} else if (value < 48) {
			losses++;
		} else {
			ties++;
		}
	}
	
	
	return @[[NSNumber numberWithInteger:wins], [NSNumber numberWithInteger:losses], [NSNumber numberWithInteger:ties]];
}

- (NSInteger)improvedInYear:(WBYear *)year {
	NSInteger totalImproved = 0;
	for (WBPlayer *player in self.players) {
		totalImproved += [player improvedInYear:year];
	}
	return totalImproved;
}

- (NSString *)improvedString {
	NSInteger improved = [self improvedInYear:[WBYear thisYear]];
	return [NSString stringWithFormat:@"%@%ld", improved >= 0 ? @"+" : @"", (long)improved];
}

@end
