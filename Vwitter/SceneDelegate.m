//
//  SceneDelegate.m
//  Vwitter
//
//  Created by Christina Li on 7/6/22.
//

#import <Parse/Parse.h>
#import <SpotifyiOS/SpotifyiOS.h>

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "VWHelpers.h"
#import "SpotifyAPIManager.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    if (PFUser.currentUser) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    }

}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    
    NSLog(@"scene delegate open URL getting called");
    NSURL *url = [[URLContexts allObjects] firstObject].URL;
    
    SpotifyAPIManager *spotifyAPIManager = CAST_TO_CLASS_OR_NIL([SpotifyAPIManager shared], SpotifyAPIManager);
    
    NSDictionary *params = [spotifyAPIManager.appRemote authorizationParametersFromURL:url];
    NSString *token = params[SPTAppRemoteAccessTokenKey];
    if (token) {
        spotifyAPIManager.appRemote.connectionParameters.accessToken = token;
        
        // save the token if needed
        [NSUserDefaults.standardUserDefaults setObject:token forKey:@"spotify_token"];
        
    } else if (params[SPTAppRemoteErrorDescriptionKey]) {
        NSLog(@"%@", params[SPTAppRemoteErrorDescriptionKey]);
    }

}

- (void)sceneDidBecomeActive:(UIScene *)scene {
    SpotifyAPIManager *spotifyAPIManager = CAST_TO_CLASS_OR_NIL([SpotifyAPIManager shared], SpotifyAPIManager);
    if (spotifyAPIManager.appRemote.connectionParameters.accessToken) {
        NSLog(@"app remote connected");
        [spotifyAPIManager.appRemote connect];
    }
    else {
        NSLog(@"cannot connect, no accesstoken");
    }
}

@end
