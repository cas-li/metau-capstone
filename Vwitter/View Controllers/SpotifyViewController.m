//
//  SpotifyViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/26/22.
//
@import UIKit;

#import "SpotifyViewController.h"
#import "UIViewController+ErrorAlertPresenter.h"

static NSString * const SpotifyClientID = @"e4185723643e4db9bcf48af28e078cff";
static NSString * const SpotifyRedirectURLString = @"vwitter://spotify-login-callback";

@interface SpotifyViewController ()

@end

@implementation SpotifyViewController

- (void)viewDidLoad {
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
    __weak typeof(self) weakSelf = self;
    [SPTAppRemote checkIfSpotifyAppIsActive:^(BOOL active) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (active) {
            // Prompt the user to connect Spotify here
            [self presentErrorMessageWithTitle:@"Spotify is installed" message:@"Spotify is installed"];
        }
        else {
            [self presentErrorMessageWithTitle:@"Spotify not installed" message:@"Spotify not installed"];
        }
    }];
}

#pragma mark - SPTSessionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
//    [self presentAlertControllerWithTitle:@"Authorization Succeeded"
//                                  message:session.description
//                              buttonTitle:@"Nice"];
    [self presentErrorMessageWithTitle:@"Auth succeeded" message:@"Nice"];
}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{
//    [self presentAlertControllerWithTitle:@"Authorization Failed"
//                                  message:error.description
//                              buttonTitle:@"Bummer"];
    [self presentErrorMessageWithTitle:@"Auth failed" message:@"rip"];
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
//    [self presentAlertControllerWithTitle:@"Session Renewed"
//                                  message:session.description
//                              buttonTitle:@"Sweet"];
    [self presentErrorMessageWithTitle:@"Auth renewed" message:@"Nice"];
}

@end
