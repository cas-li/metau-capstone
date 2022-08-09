//
//  AudioSegmentPickerViewController.m
//  Vwitter
//
//  Created by Christina Li on 8/5/22.
//

#import "AudioSegmentPickerViewController.h"
#import "SpotifyAPIManager.h"
#import "VWHelpers.h"

#import <SpotifyiOS/SpotifyiOS.h>
#import <MARKRangeSlider/MARKRangeSlider.h>

@interface AudioSegmentPickerViewController ()

@property (nonatomic, strong, nullable) NSTimer *audioTimer;
@property (weak, nonatomic) IBOutlet MARKRangeSlider *rangeSlider;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;

@end

@implementation AudioSegmentPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SpotifyAPIManager shared] playTrack:self.selectedTrack.uriString];
    // Do any additional setup after loading the view.
    self.title = @"Choose Song Section";
    [self getSpotifyInfo];
    
}

- (void)getSpotifyInfo {
    __weak typeof(self) weakSelf = self;
    [[SpotifyAPIManager shared] getDurationWithCompletion:^(NSUInteger duration, NSError * _Nullable error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I died!");
            return;
        }
        if (!error) {
            NSLog (@"duration %lu", (unsigned long)duration);
            [self setUpViewComponentsWithDuration:duration];
        }
        else {
            NSLog (@"there was an error %@", error.localizedDescription);
        }
    }];
}


- (void)setSelectedTrack:(SpotifyTrack *)selectedTrack {
    _selectedTrack = selectedTrack;
}

- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider
{
    if (self.audioTimer) {
        [self.audioTimer invalidate];
    }
    // TODO: kick off 200ms timer here
    // reset any existing timer
    
    // this logic will be in the timer callback
    __weak typeof(self) weakSelf = self;
    self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f repeats:NO block:^(NSTimer * _Nonnull timer) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I died!");
            return;
        }
        [[SpotifyAPIManager shared] seekToPosition:strongSelf.rangeSlider.leftValue];
        [strongSelf updateRangeText];
        [strongSelf.delegate passSelectedTrack:strongSelf.selectedTrack withStartTimestamp:@(strongSelf.rangeSlider.leftValue) withEndTimestamp:@(strongSelf.rangeSlider.rightValue)];
    }];
    
}

- (void)setUpViewComponentsWithDuration:(NSUInteger)duration
{
    self.sectionLabel.numberOfLines = 1;
    self.sectionLabel.textColor = [UIColor blueColor];

    [self.rangeSlider addTarget:self
                         action:@selector(rangeSliderValueDidChange:)
               forControlEvents:UIControlEventValueChanged];
    [self.rangeSlider setMinValue:0.0 maxValue:(CGFloat)duration];
    [self.rangeSlider setLeftValue:0.0 rightValue:(CGFloat)duration];

    self.rangeSlider.minimumDistance = 5000;

    [self updateRangeText];

}

- (NSString *)timeStringFromSeconds:(double)seconds minutes:(double)minutes {
    NSString *secondString = nil;
    if (seconds < 10) {
        secondString = [NSString stringWithFormat:@"0%d", (int)seconds];
    } else {
        secondString = [NSString stringWithFormat:@"%d", (int)seconds];
    }
    
    return [NSString stringWithFormat:@"%d:%@", (int)minutes, secondString];
}

- (void)updateRangeText
{
    NSLog(@"%0.2f - %0.2f", self.rangeSlider.leftValue, self.rangeSlider.rightValue);
    
    CGFloat leftValueTotalSeconds = self.rangeSlider.leftValue / 1000.0;
    CGFloat leftValueMinutes = leftValueTotalSeconds / 60;
    CGFloat leftValueSeconds = leftValueTotalSeconds - ((int) leftValueMinutes) * 60;
    NSString *leftValueString = [self timeStringFromSeconds:leftValueSeconds minutes:leftValueMinutes];
    
    CGFloat rightValueTotalSeconds = self.rangeSlider.rightValue / 1000.0;
    CGFloat rightValueMinutes = rightValueTotalSeconds / 60;
    CGFloat rightValueSeconds = rightValueTotalSeconds - ((int) rightValueMinutes) * 60;
    
    NSString *rightValueString = [self timeStringFromSeconds:rightValueSeconds minutes:rightValueMinutes];
    
    self.sectionLabel.text = [NSString stringWithFormat:@"%@ - %@",
                       leftValueString, rightValueString];
    
}

@end
