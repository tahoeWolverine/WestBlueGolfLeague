//
//  WBMatchupResultCell.h
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/17/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBTeamMatchup;

@interface WBMatchupResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *team1NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *team1PointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *team1ScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *team2NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *team2PointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *team2ScoreLabel;

- (void)configureCellForMatchup:(WBTeamMatchup *)matchup;

@end
