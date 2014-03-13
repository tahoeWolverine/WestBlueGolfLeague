//
//  WBResultTableViewCell.h
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/17/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBResult;

@class WBTeam;
@class WBTeamMatchup;

@interface WBResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateAndOpponentLabel;
@property (weak, nonatomic) IBOutlet UILabel *winLossLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (void)configureCellForResult:(WBResult *)result;
- (void)configureCellForResultsOfTeam:(WBTeam *)team matchup:(WBTeamMatchup *)matchup;

@end
