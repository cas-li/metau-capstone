//
//  Vent.h
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import <Parse/Parse.h>
#import "VWUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface Vent : PFObject<PFSubclassing>

@property (nonatomic, strong) VWUser *author;
@property (nonatomic, strong) NSString *authorUserId;
@property (nonatomic, strong) NSString *ventContent;

- (instancetype)initWithVentContent:(NSString *)ventContent;

@end

NS_ASSUME_NONNULL_END
