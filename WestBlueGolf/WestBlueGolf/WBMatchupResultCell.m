//
//  WBMatchupResultCell.m
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/17/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBMatchupResultCell.h"
#import "WBModels.h"

@implementation WBMatchupResultCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellForMatchup:(WBTeamMatchup *)matchup {
	//DLog(@"%ld", (long)matchup.week.seasonIndexValue);

	NSArray *displayStrings = [matchup displayStrings];
    //DLog(@"displayStrings: %@", displayStrings);
    TRAssert(displayStrings && displayStrings.count > 3, @"Display string didn't have 4 strings as needed");
	self.team1NameLabel.text = displayStrings[0];
	self.team1NameSmall.text = displayStrings[0];
	self.team2NameLabel.text = displayStrings[3];
	self.team2NameSmall.text = displayStrings[3];

	if (matchup.matchCompleteValue) {
        TRAssert(displayStrings && displayStrings.count > 5, @"Display string didn't have 6 strings as needed");
        
		self.team1NameLabel.font = [UIFont boldSystemFontOfSize:17.0f];
		
		self.team1PointsLabel.text = displayStrings[1];
		self.team2PointsLabel.text = displayStrings[4];
	
		self.team1ScoreLabel.text = displayStrings[2];
		self.team2ScoreLabel.text = displayStrings[5];
		
		self.team1NameSmall.text = displayStrings[0];
		self.team2NameSmall.text = displayStrings[3];
		
		NSArray *matches = [matchup orderedMatches];
        //TRAssert(matches && matches.count == 4, @"Attempting to display less than 4 matches");
		
		NSArray *match1DisplayStrings = [(WBMatch *)matches[0] displayStrings];
        TRAssert(match1DisplayStrings && match1DisplayStrings.count > 4, @"P1 Display string didn't have 5 strings as needed");
		self.team1Player1Name.text = match1DisplayStrings[0];
		self.team1Player1Score.text = match1DisplayStrings[1];
		self.team2Player1Name.text = match1DisplayStrings[2];
		self.team2Player1Score.text = match1DisplayStrings[3];
		self.match1Points.text = match1DisplayStrings[4];
		
		NSArray *match2DisplayStrings = [(WBMatch *)matches[1] displayStrings];
        TRAssert(match2DisplayStrings && match2DisplayStrings.count > 4, @"P2 Display string didn't have 5 strings as needed");
		self.team1Player2Name.text = match2DisplayStrings[0];
		self.team1Player2Score.text = match2DisplayStrings[1];
		self.team2Player2Name.text = match2DisplayStrings[2];
		self.team2Player2Score.text = match2DisplayStrings[3];
		self.match2Points.text = match2DisplayStrings[4];
		
        if (matches.count > 2) {
            NSArray *match3DisplayStrings = [(WBMatch *)matches[2] displayStrings];
            TRAssert(match3DisplayStrings && match3DisplayStrings.count > 4, @"P3 Display string didn't have 5 strings as needed");
            self.team1Player3Name.text = match3DisplayStrings[0];
            self.team1Player3Score.text = match3DisplayStrings[1];
            self.team2Player3Name.text = match3DisplayStrings[2];
            self.team2Player3Score.text = match3DisplayStrings[3];
            self.match3Points.text = match3DisplayStrings[4];
        } else {
            self.team1Player3Name.text = @"";
            self.team1Player3Score.text = @"";
            self.team2Player3Name.text = @"";
            self.team2Player3Score.text = @"";
            self.match3Points.text = @"";
        }
        
		if (matches.count > 3) {
            NSArray *match4DisplayStrings = [(WBMatch *)matches[3] displayStrings];
            TRAssert(match4DisplayStrings && match4DisplayStrings.count > 4, @"P4 Display string didn't have 5 strings as needed");
            self.team1Player4Name.text = match4DisplayStrings[0];
            self.team1Player4Score.text = match4DisplayStrings[1];
            self.team2Player4Name.text = match4DisplayStrings[2];
            self.team2Player4Score.text = match4DisplayStrings[3];
            self.match4Points.text = match4DisplayStrings[4];
        } else {
            self.team1Player4Name.text = @"";
            self.team1Player4Score.text = @"";
            self.team2Player4Name.text = @"";
            self.team2Player4Score.text = @"";
            self.match4Points.text = @"";
        }
	} else {
		self.team1PointsLabel.text = [matchup timeLabel];
		self.team2PointsLabel.text = @"";
		
		self.team1ScoreLabel.text = @"";
		self.team2ScoreLabel.text = @"";
		
		if (matchup.teams.count == 2) {
			WBTeam *team1 = [matchup teamWithName:displayStrings[0]];
			WBTeam *team2 = [matchup teamWithName:displayStrings[3]];
			if (team1.realValue) {
				NSArray *team1TopPlayers = [team1 top4Players];
                TRAssert(team1TopPlayers && team1TopPlayers.count == 4, @"Team 1 did not have 4 players");
				self.team1Player1Name.text = [(WBPlayer *)team1TopPlayers[0] shortName];
				self.team1Player1Score.text = [(WBPlayer *)team1TopPlayers[0] currentHandicapString];
				self.team1Player2Name.text = [(WBPlayer *)team1TopPlayers[1] shortName];
				self.team1Player2Score.text = [(WBPlayer *)team1TopPlayers[1] currentHandicapString];
				self.team1Player3Name.text = [(WBPlayer *)team1TopPlayers[2] shortName];
				self.team1Player3Score.text = [(WBPlayer *)team1TopPlayers[2] currentHandicapString];
				self.team1Player4Name.text = [(WBPlayer *)team1TopPlayers[3] shortName];
				self.team1Player4Score.text = [(WBPlayer *)team1TopPlayers[3] currentHandicapString];
			}
			
			if (team2.realValue) {
				NSArray *team2TopPlayers = [team2 top4Players];
                TRAssert(team2TopPlayers && team2TopPlayers.count == 4, @"Team 2 did not have 4 players");
				self.team2Player1Name.text = [(WBPlayer *)team2TopPlayers[0] shortName];
				self.team2Player1Score.text = [(WBPlayer *)team2TopPlayers[0] currentHandicapString];
				self.team2Player2Name.text = [(WBPlayer *)team2TopPlayers[1] shortName];
				self.team2Player2Score.text = [(WBPlayer *)team2TopPlayers[1] currentHandicapString];
				self.team2Player3Name.text = [(WBPlayer *)team2TopPlayers[2] shortName];
				self.team2Player3Score.text = [(WBPlayer *)team2TopPlayers[2] currentHandicapString];
				self.team2Player4Name.text = [(WBPlayer *)team2TopPlayers[3] shortName];
				self.team2Player4Score.text = [(WBPlayer *)team2TopPlayers[3] currentHandicapString];
			}
		}
	}
}

@end
