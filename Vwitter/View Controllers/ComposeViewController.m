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

@import UITextView_Placeholder;

@interface ComposeViewController () <UITextViewDelegate, SongPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *ventContent;
@property (strong, nonatomic) NSString *placeholderText;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ventContent.delegate = self;

    self.placeholderText = @"Let it out!";
    
    self.ventContent.placeholder = self.placeholderText;
    self.ventContent.placeholderColor = [UIColor lightGrayColor];
}

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
}


@end
