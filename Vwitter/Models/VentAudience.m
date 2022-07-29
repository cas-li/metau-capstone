//
//  VentAudience.m
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import "VentAudience.h"

@implementation VentAudience

@dynamic vent;
@dynamic user;
@dynamic group;

+ (nonnull NSString *)parseClassName {
    return @"VentAudience";
}

- (instancetype)initWithUserAudience:(VWUser *)user withVent:(Vent *)vent {
    VentAudience *newVA = [VentAudience new];
    newVA.vent = vent;
    newVA.group = nil;
    newVA.user = user;
    
    return newVA;
}

- (instancetype)initWithGroupAudience:(GroupDetails *)group withVent:(Vent *)vent {
    VentAudience *newVA = [VentAudience new];
    newVA.vent = vent;
    newVA.group = group;
    newVA.user = nil;
    
    return newVA;
}

@end
