#import "WBCaptain.h"
#import "WBCoreDataManager.h"
#import "WBTeam.h"

@interface WBCaptain ()

@end

@implementation WBCaptain

+ (WBCaptain *)createCaptainWithId:(NSInteger)captainId
						  username:(NSString *)username
						  password:(NSString *)password
							  name:(NSString *)name
				   currentHandicap:(NSInteger)currentHandicap
							onTeam:(WBTeam *)currentTeam {
	WBCaptain *newCaptain = (WBCaptain *)[self baseCreatePlayerWithName:name currentHandicap:currentHandicap onTeam:currentTeam];
	newCaptain.captainIdValue = captainId;
	newCaptain.username = username;
	newCaptain.password = password;
	
	[WBCoreDataManager saveContext];
	return newCaptain;
}

- (void)deleteCaptain {
	[[[self class] managedObjectContext] deleteObject:self];
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
