//
//  SpotifyAPIManager.m
//  Vwitter
//
//  Created by Christina Li on 7/28/22.
//

#import "SpotifyAPIManager.h"
#import "AppDelegate.h"
#import "VWHelpers.h"
#import "SpotifyTrack.h"

static NSString * const SpotifyClientID = @"e4185723643e4db9bcf48af28e078cff";
static NSString * const SpotifyRedirectURLString = @"vwitter://callback/";

@interface SpotifyAPIManager ()

@property (strong, nonatomic, nullable) NSString *accessToken;
@property (strong, nonatomic, nullable) NSNumber *accessTokenExpirationTimestampSeconds;

@end

@implementation SpotifyAPIManager

static NSString *const kExpirationKey = @"spotify_expires_timestamp";

+ (instancetype)shared {
    static SpotifyAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)didAuthorizeWithSpotify:(NSString *)accessToken expiresInSeconds:(NSNumber *)expiresInSeconds {
    self.accessToken = accessToken;
    self.accessTokenExpirationTimestampSeconds = @(NSDate.date.timeIntervalSince1970 + expiresInSeconds.doubleValue);
    self.appRemote.connectionParameters.accessToken = accessToken;
}

- (BOOL)hasValidSpotifyAuthorization {
    NSTimeInterval timestampSeconds = NSDate.date.timeIntervalSince1970;
    return (self.accessToken != nil
            && self.accessTokenExpirationTimestampSeconds != nil
            && self.accessTokenExpirationTimestampSeconds.doubleValue > timestampSeconds);
}

- (void)setupAppRemote {
    /*
     Scopes let you specify exactly what types of data your application wants to
     access, and the set of scopes you pass in your call determines what access
     permissions the user is asked to grant.
     For more information, see https://developer.spotify.com/web-api/using-scopes/.
     */
    SPTScope scope = SPTUserLibraryReadScope | SPTPlaylistReadPrivateScope;

    /*
     Start the authorization process. This requires user input.
     */
    if (@available(iOS 11, *)) {
        // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
        [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption];
        NSLog(@"authorized spotify session");
    } else {
        // Use this on iOS versions < 11 to use SFSafariViewController
        NSLog(@"iOS version too old");
    }
    
    SPTConfiguration *configuration =
        [[SPTConfiguration alloc] initWithClientID:SpotifyClientID redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];

    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:configuration logLevel:SPTAppRemoteLogLevelDebug];
}

- (void)authorizeSpotify {
    [self setupAppRemote];
    [self.appRemote authorizeAndPlayURI:@"spotify:artist:2YZyLoL8N0Wb9xBt1NhZWg"];
}

- (void)playTrack:(NSString *)trackUri {
    if (!self.hasValidSpotifyAuthorization) {
        [self authorizeSpotify];
    }
    
    if (!self.appRemote.playerAPI) {
        [self.appRemote connect];
    }
    
    [self.appRemote.playerAPI play:trackUri callback:^(id  _Nullable result, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"track playing");
        }
        else {
            NSLog(@"cell track failed to play %@", error.localizedDescription);
        }
    }];
}

- (void)pause {
    [self.appRemote.playerAPI pause:^(id  _Nullable result, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"track paused");

        }
        else {
            NSLog(@"track not paused, %@", error.localizedDescription);
        }
    }];
    
}

- (void)getTracks:(NSString *)searchString withCompletion:(SpotifyTrackCompletion)completion {
    if (!self.hasValidSpotifyAuthorization) {
        [self authorizeSpotify];
    }
    
    NSString *bearerToken = [[NSString alloc] initWithFormat:@"Bearer %@", self.appRemote.connectionParameters.accessToken];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *convertedSearchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@", @"https://api.spotify.com/v1/search?q=", convertedSearchString, @"&type=track"];
    NSURL *url = [NSURL URLWithString:urlString];

    [request setValue:bearerToken forHTTPHeaderField:@"Authorization"];
    [request setURL:url];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
      [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSMutableArray *spotifyTracksArray = [[NSMutableArray alloc] init];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            // JSON with song is here
            NSLog(@"JSON: %@", json);
            NSArray *tracksArray = json[@"tracks"][@"items"];
            NSArray *castedTracksArray = CAST_TO_CLASS_OR_NIL(tracksArray, NSArray);
            
            for (id track in castedTracksArray) {
                SpotifyTrack *currentTrack = [[SpotifyTrack alloc] initWithDictionary:track];
                [spotifyTracksArray addObject:currentTrack];
            }
            
            completion(spotifyTracksArray, nil);
            
        }
        else {
            NSLog(@"searching tracks had an error %@", error.localizedDescription);
            completion(nil, error);
        }
    }] resume];

}

- (void)getDurationWithCompletion:(DurationCompletion)completion {
    
    [self.appRemote.playerAPI getPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
        if (!error) {
//            SPTAppRemotePlayerState *playerState = CAST_TO_CLASS_OR_NIL(result, SPTAppRemotePlayerState);
            id<SPTAppRemotePlayerState> playerState = result;
            completion(playerState.track.duration, nil);
        }
        else {
            NSLog(@"getting remote player state had error %@", error.localizedDescription);
            completion(0, error);
        }
    }];
}

- (void)seekToPosition:(NSInteger)position {
    
    [self.appRemote.playerAPI seekToPosition:position callback:^(id  _Nullable result, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"seeked to track playing");
        }
        else {
            NSLog(@"seeked to track failed to play %@", error.localizedDescription);
        }
    }];
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"disconnected: %@", error.localizedDescription);
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error {
    NSLog(@"connection failed: %@", error.localizedDescription);
}

- (void)appRemoteDidEstablishConnection:(nonnull SPTAppRemote *)appRemote {
    NSLog(@"connected");
    self.appRemote.playerAPI.delegate = self;
    [self.appRemote.playerAPI subscribeToPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"subscribed to player state");
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}


- (void)playerStateDidChange:(nonnull id<SPTAppRemotePlayerState>)playerState {
    NSLog(@"player state changed");
    NSLog(@"Track name: %@", playerState.track.name);
}


@end
