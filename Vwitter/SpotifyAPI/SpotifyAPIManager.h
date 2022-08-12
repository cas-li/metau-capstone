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

@property (strong, nonatomic) SPTSessionManager *sessionManager;
@property (strong, nonatomic) SPTAppRemote *appRemote;

+ (instancetype)shared;

- (void)didAuthorizeWithSpotify:(NSString *)accessToken expiresInSeconds:(NSNumber *)expiresInSeconds;

- (void)playTrack:(NSString *)track;

- (void)pause;

- (void)getTracks:(NSString *)searchString withCompletion:(SpotifyTrackCompletion)completion;

- (void)getDurationWithCompletion:(DurationCompletion)completion;

- (void)seekToPosition:(NSInteger)position;

- (void)playTrack:(NSString *)trackUri startTimestamp:(NSInteger)startTimestamp endTimestamp:(NSInteger)endTimestamp;

@end

NS_ASSUME_NONNULL_END
