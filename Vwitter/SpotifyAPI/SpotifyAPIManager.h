//
//  SpotifyAPIManager.h
//  Vwitter
//
//  Created by Christina Li on 7/28/22.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyAPIManager : NSObject

@property (nonatomic) SPTSessionManager *sessionManager;

+ (instancetype)shared;

- (void)authorizeSpotify;

- (void)playTrack:(NSString *)track;

@end

NS_ASSUME_NONNULL_END
