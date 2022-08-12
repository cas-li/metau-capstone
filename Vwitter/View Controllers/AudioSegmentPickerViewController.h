//
//  AudioSegmentPickerViewController.h
//  Vwitter
//
//  Created by Christina Li on 8/5/22.
//

#import <UIKit/UIKit.h>
#import "SpotifyTrack.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AudioSegmentPickerViewControllerDelegate <NSObject>

- (void)passSelectedTrack:(SpotifyTrack *)selectedTrack withStartTimestamp:(NSNumber *)startTimeStamp withEndTimestamp:(NSNumber *)endTimestamp;

@end

@interface AudioSegmentPickerViewController : UIViewController

@property (strong, nonatomic) SpotifyTrack *selectedTrack;
@property (weak, nonatomic) id<AudioSegmentPickerViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
