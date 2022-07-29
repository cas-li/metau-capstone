//
//  UIViewController+ErrorAlertPresenter.m
//  Vwitter
//
//  Created by Christina Li on 7/11/22.
//

#import "UIViewController+ErrorAlertPresenter.h"

@implementation UIViewController (ErrorAlertPresenter)

- (void)presentErrorMessageWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                               message:message
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
