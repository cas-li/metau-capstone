//
//  UserCell.h
//  Vwitter
//
//  Created by Christina Li on 7/11/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "UserCellViewModel.h"
#import "VWUser.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UserCellDelegate <NSObject>

- (void)didFollowUserWithViewModel:(UserCellViewModel *)viewModel;

@end

@interface UserCell : UITableViewCell

@property (strong, nonatomic) VWUser *user;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followStatusButton;
@property (strong, nonatomic) UserCellViewModel *userCellViewModel;
@property (weak, nonatomic) id<UserCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
