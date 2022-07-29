//
//  SignupViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import "SignupViewController.h"
#import "VWUser.h"
#import "UIViewController+ErrorAlertPresenter.h"

@interface SignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *screennameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)registerUser {
    
    VWUser *newUser =  [[VWUser alloc] initWithScreenName:self.screennameField.text withUsername:self.usernameField.text withPassword:self.passwordField.text];
    
    __weak typeof(self) weakSelf = self;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            [strongSelf presentErrorMessageWithTitle:@"Error" message:error.localizedDescription];
            
        } else {
            NSLog(@"User registered successfully");
            [strongSelf performSegueWithIdentifier:@"signupSegue" sender:nil];
        }
    }];
}

- (IBAction)didTapSignup:(id)sender {
    [self registerUser];
}

@end
