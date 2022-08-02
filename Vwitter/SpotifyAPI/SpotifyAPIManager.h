//
//  SpotifyAPIManager.h
//  Vwitter
//
//  Created by Christina Li on 7/28/22.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^SpotifyTrackCompletion)(NSMutableArray *_Nullable results, NSError *_Nullable error);

@interface SpotifyAPIManager : NSObject <SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>

@property (nonatomic) SPTSessionManager *sessionManager;
@property (strong, nonatomic) SPTAppRemote *appRemote;


+ (instancetype)shared;

- (void)authorizeSpotify;

- (void)playTrack:(NSString *)track;

- (void)pause;

- (void)getTracks:(NSString *)searchString withCompletion:(SpotifyTrackCompletion)completion;

@end

NS_ASSUME_NONNULL_END
