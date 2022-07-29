//
//  Follow.h
//  Vwitter
//
//  Created by Christina Li on 7/11/22.
//

#import <Parse/Parse.h>
#import "VWUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface Follow : PFObject<PFSubclassing>

@property (strong, nonatomic) VWUser *followingUser;
@property (strong, nonatomic) VWUser *currentUser;
@property (strong, nonatomic) NSString *followingUserId;
@property (strong, nonatomic) NSString *currentUserId;
@property (nonatomic, assign) BOOL approved;

- (instancetype)initWithFollowing:(VWUser *)followingUser withApproved:(BOOL)approved;

@end

NS_ASSUME_NONNULL_END
