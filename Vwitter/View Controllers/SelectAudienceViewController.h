//
//  SelectAudienceViewController.h
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "SpotifyTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectAudienceViewController : UIViewController

@property (strong, nonatomic) NSString *ventContent;
@property (strong, nonatomic) SpotifyTrack *selectedTrack;

@end

NS_ASSUME_NONNULL_END
