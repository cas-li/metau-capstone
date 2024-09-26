//
//  SongPickerViewController.h
//  Vwitter
//
//  Created by Christina Li on 7/28/22.
//

#import <UIKit/UIKit.h>
#import "SpotifyTrack.h"
#import "AudioSegmentPickerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SongPickerViewControllerDelegate <NSObject>

- (void)passSelectedTrack:(SpotifyTrack *)selectedTrack;

@end

@interface SongPickerViewController : UIViewController
@property (weak, nonatomic) id<SongPickerViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
