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

typedef void (^DurationCompletion)(NSUInteger duration, NSError *_Nullable error);

@interface SpotifyAPIManager : NSObject <SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>

@property (nonatomic) SPTSessionManager *sessionManager;
@property (strong, nonatomic) SPTAppRemote *appRemote;

- (void)didAuthorizeWithSpotify:(NSString *)accessToken expiresInSeconds:(NSNumber *)expiresInSeconds;

+ (instancetype)shared;

- (void)playTrack:(NSString *)track;

- (void)pause;

- (void)getTracks:(NSString *)searchString withCompletion:(SpotifyTrackCompletion)completion;

- (void)getDurationWithCompletion:(DurationCompletion)completion;

- (void)seekToPosition:(NSInteger)position;

- (void)playTrack:(NSString *)trackUri withPosition:(NSInteger)position;

@end

NS_ASSUME_NONNULL_END
