//
//  GroupMembership.m
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import "GroupMembership.h"
#import "GroupDetails.h"
#import "VWUser.h"

@implementation GroupMembership

@dynamic group;
@dynamic user;

+ (nonnull NSString *)parseClassName {
    return @"GroupMembership";
}

- (instancetype)initWithUser:(VWUser *)user withGroup:(GroupDetails *)group {
    if (self = [super init]) {
        self.user = user;
        self.group = group;
    }
    return self;
}

@end
