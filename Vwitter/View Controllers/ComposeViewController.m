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
    
    self.songTitleLabel.frame = CGRectMake(
        0 - self.songTitleContainerView.frame.size.width, // x
        self.songTitleLabel.frame.origin.y, // y
        self.songTitleLabel.frame.size.width, // width
        self.songTitleLabel.frame.size.height // height
    );
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fadeAnimation];
    [UIView animateWithDuration:5.0f delay:0.0f options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.songTitleLabel.frame = CGRectMake(
            self.songTitleContainerView.frame.size.width, // x
            self.songTitleLabel.frame.origin.y, // y
            self.songTitleLabel.frame.size.width, // width
            self.songTitleLabel.frame.size.height // height
        );

    } completion:^(BOOL finished) {

    }];
    

}

- (void)fadeAnimation {
    
    self.songTitleLabel.alpha = 0;
    [UIView animateWithDuration:2.5f animations:^(void) {
        self.songTitleLabel.alpha = 1;
    }
    completion:^(BOOL finished){
       [UIView animateWithDuration:2.5f animations:^(void) {
        self.songTitleLabel.alpha = 0;
       } completion:^(BOOL finished) {
            [self fadeAnimation];
       }];
    }];
    
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
        
        SelectAudienceViewController *selectAudienceVC = [segue destinationViewController];
        selectAudienceVC.ventContent = self.ventContent.text;
        selectAudienceVC.selectedTrack = self.selectedTrack;
        
    }
    else if ([segue.identifier isEqualToString:@"songPickerSegue"]) {
        SongPickerViewController *songPickerVC = CAST_TO_CLASS_OR_NIL([segue destinationViewController], SongPickerViewController);
        songPickerVC.delegate = self;
    }
}

- (void)passSelectedTrack:(SpotifyTrack *)selectedTrack {
    self.selectedTrack = selectedTrack;
    self.songTitleLabel.text = selectedTrack.trackName;
}


@end
