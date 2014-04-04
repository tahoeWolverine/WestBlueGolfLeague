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

// expanded cell
@property (weak, nonatomic) IBOutlet UILabel *team1NameSmall;
@property (weak, nonatomic) IBOutlet UILabel *team2NameSmall;

@property (weak, nonatomic) IBOutlet UILabel *team1Player1Name;
@property (weak, nonatomic) IBOutlet UILabel *team1Player1Score;
@property (weak, nonatomic) IBOutlet UILabel *team1Player2Name;
@property (weak, nonatomic) IBOutlet UILabel *team1Player2Score;
@property (weak, nonatomic) IBOutlet UILabel *team1Player3Name;
@property (weak, nonatomic) IBOutlet UILabel *team1Player3Score;
@property (weak, nonatomic) IBOutlet UILabel *team1Player4Name;
@property (weak, nonatomic) IBOutlet UILabel *team1Player4Score;

@property (weak, nonatomic) IBOutlet UILabel *team2Player1Name;
@property (weak, nonatomic) IBOutlet UILabel *team2Player1Score;
@property (weak, nonatomic) IBOutlet UILabel *team2Player2Name;
@property (weak, nonatomic) IBOutlet UILabel *team2Player2Score;
@property (weak, nonatomic) IBOutlet UILabel *team2Player3Name;
@property (weak, nonatomic) IBOutlet UILabel *team2Player3Score;
@property (weak, nonatomic) IBOutlet UILabel *team2Player4Name;
@property (weak, nonatomic) IBOutlet UILabel *team2Player4Score;

@property (weak, nonatomic) IBOutlet UILabel *match1Points;
@property (weak, nonatomic) IBOutlet UILabel *match2Points;
@property (weak, nonatomic) IBOutlet UILabel *match3Points;
@property (weak, nonatomic) IBOutlet UILabel *match4Points;

- (void)configureCellForMatchup:(WBTeamMatchup *)matchup;

@end
