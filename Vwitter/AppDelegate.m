//
//  AppDelegate.m
//  Vwitter
//
//  Created by Christina Li on 7/6/22.
//

#import <Parse/Parse.h>

#import "AppDelegate.h"
#import "VWHelpers.h"

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
    
//    NSString *_Nullable previouslySavedAccessToken = CAST_TO_CLASS_OR_NIL([NSUserDefaults.standardUserDefaults objectForKey:@"spotify_token"], NSString);
//    if (previouslySavedAccessToken) {
//        // user previously authenticated with spotify
//        self.appRemote.connectionParameters.accessToken = previouslySavedAccessToken;
//    }
    
    // init app remote
    
    SPTConfiguration *configuration =
        [[SPTConfiguration alloc] initWithClientID:SpotifyClientID redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];
    
    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:configuration logLevel:SPTAppRemoteLogLevelDebug];
    
    BOOL spotifyInstalled = [self.appRemote authorizeAndPlayURI:@""];
    if (!spotifyInstalled) {
        /*
        * The Spotify app is not installed.
        * Use SKStoreProductViewController with [SPTAppRemote spotifyItunesItemIdentifier] to present the user
        * with a way to install the Spotify app.
        */
        NSString *adjustUrl = @"https://app.adjust.com/bdyga9?campaign=com.cyli.Vwitter";
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:adjustUrl]];
        [request setValue:@"spotify_campaign_user_agent" forHTTPHeaderField:@"User-Agent"];

        [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        }] resume];
        
        NSString *url = @"https://itunes.apple.com/app/spotify-music/id324684580?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];

    }

    
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


@end
