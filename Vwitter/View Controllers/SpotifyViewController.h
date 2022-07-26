//
//  SpotifyViewController.h
//  Vwitter
//
//  Created by Christina Li on 7/26/22.
//
@import UIKit;

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyViewController : UIViewController <SPTSessionManagerDelegate>

@property (nonatomic) SPTSessionManager *sessionManager;

@end

NS_ASSUME_NONNULL_END
