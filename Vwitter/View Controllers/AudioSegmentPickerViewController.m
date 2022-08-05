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

static CGFloat const kViewControllerRangeSliderWidth = 290.0;
static CGFloat const kViewControllerLabelWidth = 100.0;

@interface AudioSegmentPickerViewController ()

@property (nonatomic, strong) MARKRangeSlider *rangeSlider;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic) NSUInteger duration;

@end

@implementation AudioSegmentPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SpotifyAPIManager shared] playTrack:self.selectedTrack.uriString];
    // Do any additional setup after loading the view.
    self.title = @"Choose Song Section";
    [self getSpotifyInfo];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)getSpotifyInfo {
    [[SpotifyAPIManager shared] getDurationWithCompletion:^(NSUInteger duration, NSError * _Nullable error) {
        if (!error) {
            NSLog (@"duration %lu", (unsigned long)duration);
            self.duration = duration;
            [self setUpViewComponents];
        }
        else {
            NSLog (@"there was an error %@", error.localizedDescription);
        }
    }];
}


- (void)setSelectedTrack:(SpotifyTrack *)selectedTrack {
    _selectedTrack = selectedTrack;
    
    [self setUpViewComponents];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat labelX = (CGRectGetWidth(self.view.frame) - kViewControllerLabelWidth) / 2;
    self.label.frame = CGRectMake(labelX, 110.0, kViewControllerLabelWidth, 20.0);

    CGFloat sliderX = (CGRectGetWidth(self.view.frame) - kViewControllerRangeSliderWidth) / 2;
    self.rangeSlider.frame = CGRectMake(sliderX, CGRectGetMaxY(self.label.frame) + 20.0, 290.0, 20.0);
}

- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider
{
    [[SpotifyAPIManager shared] seekToPosition:self.rangeSlider.leftValue];
    [self updateRangeText];
    [self.delegate passSelectedTrack:self.selectedTrack withStartTimestamp:@(self.rangeSlider.leftValue) withEndTimestamp:@(self.rangeSlider.rightValue)];
}

- (void)setUpViewComponents
{
    // Text label
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.numberOfLines = 1;
    self.label.textColor = [UIColor blueColor];

    // Init slider
    self.rangeSlider = [[MARKRangeSlider alloc] initWithFrame:CGRectZero];
    [self.rangeSlider addTarget:self
                         action:@selector(rangeSliderValueDidChange:)
               forControlEvents:UIControlEventValueChanged];
    [self.rangeSlider setMinValue:0.0 maxValue:(CGFloat)self.duration];
    [self.rangeSlider setLeftValue:0.0 rightValue:(CGFloat)self.duration];

    // adjust this to be 5 seconds
    self.rangeSlider.minimumDistance = 0.2;

    [self updateRangeText];

    [self.view addSubview:self.label];
    [self.view addSubview:self.rangeSlider];
}

- (void)updateRangeText
{
    NSLog(@"%0.2f - %0.2f", self.rangeSlider.leftValue, self.rangeSlider.rightValue);
    self.label.text = [NSString stringWithFormat:@"%0.2f - %0.2f",
                       self.rangeSlider.leftValue, self.rangeSlider.rightValue];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
