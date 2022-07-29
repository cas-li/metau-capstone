//
//  GroupMembership.h
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import <Parse/Parse.h>

#import "GroupDetails.h"
#import "VWUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupMembership : PFObject<PFSubclassing>

@property (strong, nonatomic) GroupDetails *group;
@property (strong, nonatomic) VWUser *user;

- (instancetype)initWithUser:(VWUser *)user withGroup:(GroupDetails *)group;

@end

NS_ASSUME_NONNULL_END
