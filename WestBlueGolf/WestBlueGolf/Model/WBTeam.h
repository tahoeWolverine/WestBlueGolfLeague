#import "_WBTeam.h"

@interface WBTeam : _WBTeam {}

+ (WBTeam *)createTeamWithName:(NSString *)name id:(NSInteger)teamId;

- (void)deleteTeam;

+ (WBTeam *)teamWithId:(NSInteger)teamId;

- (BOOL)isMyTeam;

- (NSString *)placeString;
- (NSString *)averagePointsString;
- (NSString *)record;
- (NSString *)individualRecord;
- (NSString *)improvedString;

@end
