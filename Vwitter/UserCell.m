//
//  UserCell.m
//  Vwitter
//
//  Created by Christina Li on 7/11/22.
//

#import "UserCell.h"
#import "Follow.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserCellViewModel:(UserCellViewModel *)userCellViewModel{
    _userCellViewModel = userCellViewModel;
    
    self.user = self.userCellViewModel.user;

    NSString *at = @"@";
    self.usernameLabel.text = [NSString stringWithFormat:@"%@%@", at, self.userCellViewModel.username];
    
    if (self.userCellViewModel.isFollowing == YES) {
        [self.followStatusButton setTitle:@"Following" forState:UIControlStateNormal];
    }
    else {
        [self.followStatusButton setTitle:@"Follow" forState:UIControlStateNormal];
    }
}

- (IBAction)didFollow:(id)sender {
    [self.delegate didFollowUserWithViewModel:self.userCellViewModel];
}


@end
