//
//  GroupDetails.h
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import <Parse/Parse.h>
#import "VWUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupDetails : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *groupName;
@property (strong, nonatomic) VWUser *groupAuthor;
@property (strong, nonatomic) NSString *groupAuthorUserId;

- (instancetype)initWithGroupName:(NSString *)groupName withGroupAuthor:(VWUser *)groupAuthor;

@end

NS_ASSUME_NONNULL_END
