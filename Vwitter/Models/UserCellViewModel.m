//
//  UserCellViewModel.m
//  Vwitter
//
//  Created by Christina Li on 7/18/22.
//

#import "UserCellViewModel.h"

@implementation UserCellViewModel

- (instancetype)initWithUser:(VWUser *)user withUserId:(NSString *)userId withUsername:(NSString *)username withIsFollowing:(BOOL)isFollowing {
    UserCellViewModel *newUCVW = [UserCellViewModel new];
    newUCVW.user = user;
    newUCVW.userId = userId;
    newUCVW.username = username;
    newUCVW.isFollowing = isFollowing;
    return newUCVW;
}


@end
