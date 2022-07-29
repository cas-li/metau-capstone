//
//  VWUser.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import "VWUser.h"

@implementation VWUser

@dynamic screenName;

- (instancetype)initWithScreenName:(NSString *)screenName withUsername:(NSString *)username withPassword:(NSString *)password {
    if (self = [super init]) {
        self.screenName = screenName;
        self.username = username;
        self.password = password;
    }
    return self;
}

@end
