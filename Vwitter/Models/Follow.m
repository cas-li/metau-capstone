//
//  Follow.m
//  Vwitter
//
//  Created by Christina Li on 7/11/22.
//

#import "Follow.h"
#import "VWUser.h"

@implementation Follow

@dynamic followingUser;
@dynamic currentUser;
@dynamic approved;
@dynamic followingUserId;
@dynamic currentUserId;

+ (nonnull NSString *)parseClassName {
    return @"Follow";
}

- (instancetype)initWithFollowing:(VWUser *)followingUser withApproved:(BOOL)approved {
    if (self = [super init]) {
        self.currentUser = [VWUser currentUser];
        self.currentUserId = self.currentUser.objectId;
        self.followingUser = followingUser;
        self.followingUserId = self.followingUser.objectId;
        self.approved = approved;
        
    }
    return self;
}

@end

