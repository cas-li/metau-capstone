//
//  SpotifyAPIManager.m
//  Vwitter
//
//  Created by Christina Li on 7/28/22.
//

#import "SpotifyAPIManager.h"
#import "AppDelegate.h"
#import "VWHelpers.h"

@interface SpotifyAPIManager ()

@property (nonatomic) BOOL didAuthorize;

@end

@implementation SpotifyAPIManager

+ (instancetype)shared {
    static SpotifyAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)authorizeSpotify {
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
}

- (void)playTrack:(NSString *)trackUri {
    AppDelegate *appDelegate = CAST_TO_CLASS_OR_NIL(UIApplication.sharedApplication.delegate, AppDelegate);
    
    [appDelegate.appRemote.playerAPI play:trackUri callback:^(id  _Nullable result, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"track playing");
        }
        else {
            NSLog(@"cell track failed to play %@", error.localizedDescription);
        }
    }];
    
}


@end
