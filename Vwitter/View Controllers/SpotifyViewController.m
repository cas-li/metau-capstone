//
//  SpotifyViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/26/22.
//
@import UIKit;

#import "SpotifyViewController.h"
#import "UIViewController+ErrorAlertPresenter.h"
#import "AppDelegate.h"
#import "VWHelpers.h"

static NSString * const SpotifyClientID = @"e4185723643e4db9bcf48af28e078cff";
static NSString * const SpotifyRedirectURLString = @"vwitter://callback/";

@interface SpotifyViewController ()

@end

@implementation SpotifyViewController

- (void)viewDidLoad {
    
    AppDelegate *appDelegate = CAST_TO_CLASS_OR_NIL(UIApplication.sharedApplication.delegate, AppDelegate);
    
    /*
     This configuration object holds your client ID and redirect URL.
     */
    SPTConfiguration *configuration = [SPTConfiguration configurationWithClientID:SpotifyClientID
                                                                      redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];
    /*
     The session manager lets you authorize, get access tokens, and so on.
     */
    self.sessionManager = [SPTSessionManager sessionManagerWithConfiguration:configuration
                                                                    delegate:self];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"spotify:"]]) {
//        [self presentErrorMessageWithTitle:@"Spotify is installed" message:@"Spotify is installed"];
//    }
//    else {
//        [self presentErrorMessageWithTitle:@"Spotify not installed" message:@"Spotify not installed"];
//    }
//    __weak typeof(self) weakSelf = self;
//    [SPTAppRemote checkIfSpotifyAppIsActive:^(BOOL active) {
//        typeof(self) strongSelf = weakSelf;
//        if (!strongSelf) {
//            NSLog(@"I got killed!");
//            return;
//        }
//        if (active) {
//            // Prompt the user to connect Spotify here
//            [self presentErrorMessageWithTitle:@"Spotify is installed" message:@"Spotify is installed"];
//        }
//        else {
////            [self presentErrorMessageWithTitle:@"Spotify not installed" message:@"Spotify not installed"];
//            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"spotify:"]]) {
//                [self presentErrorMessageWithTitle:@"Spotify is installed" message:@"Spotify is installed"];
//            }
//            else {
//                [self presentErrorMessageWithTitle:@"Spotify not installed" message:@"Spotify not installed"];
//            }
//        }
//    }];
    
//    appDelegate.appRemote.delegate = self;
//    [appDelegate.appRemote connect];
}

- (IBAction)didTapConnect:(id)sender {
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
    } else {
        // Use this on iOS versions < 11 to use SFSafariViewController
        NSLog(@"iOS version too old");
    }
}
#pragma mark - SPTSessionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{

    [self presentErrorMessageWithTitle:@"Auth succeeded" message:@"Nice"];
}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{

    [self presentErrorMessageWithTitle:@"Auth failed" message:@"rip"];
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{

    [self presentErrorMessageWithTitle:@"Auth renewed" message:@"Nice"];
}

@end
