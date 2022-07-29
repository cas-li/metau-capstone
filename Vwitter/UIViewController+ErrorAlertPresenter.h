//
//  UIViewController+ErrorAlertPresenter.h
//  Vwitter
//
//  Created by Christina Li on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ErrorAlertPresenter)
- (void)presentErrorMessageWithTitle:(NSString *)title message:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
