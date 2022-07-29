//
//  GroupDetails.m
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import "GroupDetails.h"

@implementation GroupDetails

@dynamic groupName;
@dynamic groupAuthor;
@dynamic groupAuthorUserId;

+ (nonnull NSString *)parseClassName {
    return @"GroupDetails";
}

- (instancetype)initWithGroupName:(NSString *)groupName withGroupAuthor:(VWUser *)groupAuthor {
    if (self = [super init]) {
        self.groupAuthor = groupAuthor;
        self.groupAuthorUserId = self.groupAuthor.objectId;
        self.groupName = groupName;
    }
    return self;
}

@end
