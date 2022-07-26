//
//  AppDelegate.m
//  Vwitter
//
//  Created by Christina Li on 7/6/22.
//

#import <Parse/Parse.h>
#import <SpotifyiOS/SpotifyiOS.h>

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

        NSString *path = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

        configuration.applicationId = [dict objectForKey: @"applicationId"];
        configuration.clientKey = [dict objectForKey: @"clientKey"];
        configuration.server = @"http://localhost:1337/parse";
//        configuration.server = @"https://parseapi.back4app.com";
    }];

    [Parse initializeWithConfiguration:config];
    
    return YES;
}

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
//{
//    NSDictionary *params = [self.appRemote authorizationParametersFromURL:url];
//    NSString *token = params[SPTAppRemoteAccessTokenKey];
//    if (token) {
//        self.appRemote.connectionParameters.accessToken = token;
//    } else if (params[SPTAppRemoteErrorDescriptionKey]) {
//        NSLog(@"%@", params[SPTAppRemoteErrorDescriptionKey]);
//    }
//    return YES;
//}


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
