//
//  ComposeViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import "ComposeViewController.h"
#import "Vent.h"
#import "SelectAudienceViewController.h"
#import "SongPickerViewController.h"
#import "VWHelpers.h"
#import "SpotifyAPIManager.h"
#import "UIViewController+ErrorAlertPresenter.h"

@import UITextView_Placeholder;

@interface ComposeViewController () <UITextViewDelegate, SongPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *ventContent;
@property (strong, nonatomic) NSString *placeholderText;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *songTitleContainerView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ventContent.delegate = self;

    self.placeholderText = @"Let it out!";
    
    self.ventContent.placeholder = self.placeholderText;
    self.ventContent.placeholderColor = [UIColor lightGrayColor];
    
    self.songTitleContainerView.clipsToBounds = YES;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.songTitleLabel.text) {
        [[SpotifyAPIManager shared] pause];
    }
    [self.songTitleLabel sizeToFit];
    [self setSongTitleLabelX:0 - self.songTitleLabel.frame.size.width];
}

- (void)animate {
    [self.songTitleLabel sizeToFit];
    [self setSongTitleLabelX:0 - self.songTitleLabel.frame.size.width];
    
    [UIView animateWithDuration:5.0f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.songTitleLabel.frame = CGRectMake(
            self.songTitleContainerView.frame.size.width, // x
            self.songTitleLabel.frame.origin.y, // y
            self.songTitleLabel.frame.size.width, // width
            self.songTitleLabel.frame.size.height // height
        );

    } completion:^(BOOL finished) {
        if (finished) {
            [self animate];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CAGradientLayer *rightGradient = [CAGradientLayer layer];
    rightGradient.frame = self.songTitleContainerView.bounds;
    rightGradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:1 green:1 blue:1 alpha:0].CGColor, (id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor, nil];
    [rightGradient setStartPoint:CGPointMake(0.9, 0.95)];
    [rightGradient setEndPoint:CGPointMake(1.0, 0.95)];
    [self.songTitleContainerView.layer addSublayer:rightGradient];
    
    CAGradientLayer *leftGradient = [CAGradientLayer layer];
    leftGradient.frame = self.songTitleContainerView.bounds;
    leftGradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:1 green:1 blue:1 alpha:0].CGColor, (id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor, nil];
    [leftGradient setStartPoint:CGPointMake(0.1, 0.05)];
    [leftGradient setEndPoint:CGPointMake(0.0, 0.05)];
    [self.songTitleContainerView.layer addSublayer:leftGradient];
    
    [self animate];
}

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    [[SpotifyAPIManager shared] pause];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"selectAudienceSegue"]) {
        if ([self.ventContent.text isEqualToString:@""]) {
            [self presentErrorMessageWithTitle:@"Error" message:@"Vent cannot be blank."];
            return;
        }

        SelectAudienceViewController *selectAudienceVC = [segue destinationViewController];
        selectAudienceVC.ventContent = self.ventContent.text;
        selectAudienceVC.selectedTrack = self.selectedTrack;
        
    }
    else if ([segue.identifier isEqualToString:@"songPickerSegue"]) {
        SongPickerViewController *songPickerVC = CAST_TO_CLASS_OR_NIL([segue destinationViewController], SongPickerViewController);
        songPickerVC.delegate = self;
    }
}

- (void)setSongTitleLabelX:(CGFloat)x {
    self.songTitleLabel.frame = CGRectMake(
        x, // x
        self.songTitleLabel.frame.origin.y, // y
        self.songTitleLabel.frame.size.width, // width
        self.songTitleLabel.frame.size.height // height
    );
    
}

- (void)passSelectedTrack:(SpotifyTrack *)selectedTrack {
    self.selectedTrack = selectedTrack;
    self.songTitleLabel.text = selectedTrack.trackName;
    [self.songTitleLabel sizeToFit];
    [self setSongTitleLabelX:0 - self.songTitleLabel.frame.size.width];
    
}


@end
