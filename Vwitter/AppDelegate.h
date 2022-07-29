//
//  AppDelegate.h
//  Vwitter
//
//  Created by Christina Li on 7/6/22.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>

@property (strong, nonatomic) SPTAppRemote *appRemote;

@end

