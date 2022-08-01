//
//  AppDelegate.m
//  Vwitter
//
//  Created by Christina Li on 7/6/22.
//

#import <Parse/Parse.h>

#import "AppDelegate.h"
#import "VWHelpers.h"
#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>
#import "SpotifyAPIManager.h"

static NSString * const SpotifyClientID = @"e4185723643e4db9bcf48af28e078cff";
static NSString * const SpotifyRedirectURLString = @"vwitter://callback/";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

        NSString *path = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

        configuration.applicationId = [dict objectForKey: @"applicationId"];
        configuration.clientKey = [dict objectForKey: @"clientKey"];
//        configuration.server = @"http://localhost:1337/parse";
        configuration.server = @"https://parseapi.back4app.com";
    }];

    [Parse initializeWithConfiguration:config];

    // init app remote
    SpotifyAPIManager *spotifyAPIManager = [[SpotifyAPIManager alloc] init];
    [spotifyAPIManager authorizeSpotify];
    
    SPTConfiguration *configuration =
        [[SPTConfiguration alloc] initWithClientID:SpotifyClientID redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];

    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:configuration logLevel:SPTAppRemoteLogLevelDebug];

    BOOL spotifyInstalled = [self.appRemote authorizeAndPlayURI:@"spotify:artist:2YZyLoL8N0Wb9xBt1NhZWg"];

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSDictionary *params = [self.appRemote authorizationParametersFromURL:url];
    NSString *token = params[SPTAppRemoteAccessTokenKey];
    if (token) {
        self.appRemote.connectionParameters.accessToken = token;
        
        // save the token if needed
        [NSUserDefaults.standardUserDefaults setObject:token forKey:@"spotify_token"];
        
    } else if (params[SPTAppRemoteErrorDescriptionKey]) {
        NSLog(@"%@", params[SPTAppRemoteErrorDescriptionKey]);
    }
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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

- (void)applicationWillResignActive:(UIApplication *)application {
    if (self.appRemote.isConnected) {
        NSLog(@"appRemote disconnected");
        [self.appRemote disconnect];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (self.appRemote.connectionParameters.accessToken) {
        NSLog(@"app remote connected");
        [self.appRemote connect];
    }
    else {
        NSLog(@"cannot connect, no accesstoken");
    }
}

@end
