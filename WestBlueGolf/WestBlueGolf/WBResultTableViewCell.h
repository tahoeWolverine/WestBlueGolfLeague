//
//  WBResultTableViewCell.h
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/17/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@class WBResult;

@interface WBResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateAndOpponentLabel;
@property (weak, nonatomic) IBOutlet UILabel *winLossLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (void)configureCellForResult:(WBResult *)result;

@end
