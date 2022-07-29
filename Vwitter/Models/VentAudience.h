//
//  VentAudience.h
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import <Parse/Parse.h>

#import "Vent.h"
#import "GroupDetails.h"
#import "VWUser.h"

@interface VentAudience : PFObject<PFSubclassing>

@property (strong, nonatomic) Vent * _Nonnull vent;
@property (strong, nonatomic) VWUser * _Nullable user;
@property (strong, nonatomic) GroupDetails * _Nullable group;

- (instancetype)initWithUserAudience:(VWUser *)user withVent:(Vent *)vent;

- (instancetype)initWithGroupAudience:(GroupDetails *)group withVent:(Vent *)vent;


@end

