//
//  UserCellViewModel.h
//  Vwitter
//
//  Created by Christina Li on 7/18/22.
//

#import <Foundation/Foundation.h>

#import "VWUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCellViewModel : NSObject

@property (strong, nonatomic) VWUser *user;
@property (strong, nonatomic) NSString *username;
@property (nonatomic, assign) BOOL isFollowing;
@property (strong, nonatomic) NSString *userId;

- (instancetype)initWithUser:(VWUser *)user withUserId:(NSString *)userId withUsername:(NSString *)username withIsFollowing:(BOOL)isFollowing;

@end

NS_ASSUME_NONNULL_END
