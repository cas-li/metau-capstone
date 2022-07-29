//
//  AudienceMemberCell.h
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "VWUser.h"
#import "GroupDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface AudienceMemberCell : UITableViewCell

@property (strong, nonatomic) VWUser *user;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) GroupDetails *group;

@end

NS_ASSUME_NONNULL_END
