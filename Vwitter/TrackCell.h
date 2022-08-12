//
//  TrackCell.h
//  Vwitter
//
//  Created by Christina Li on 7/28/22.
//

#import <UIKit/UIKit.h>

#import "SpotifyTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrackCell : UITableViewCell
@property (strong, nonatomic) SpotifyTrack *track;
@property (weak, nonatomic) IBOutlet UILabel *trackNameLabel;

@end

NS_ASSUME_NONNULL_END
