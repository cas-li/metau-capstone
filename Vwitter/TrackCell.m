//
//  TrackCell.m
//  Vwitter
//
//  Created by Christina Li on 7/28/22.
//

#import "TrackCell.h"

@implementation TrackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTrack:(SpotifyTrack *)track{
    _track = track;

    [self refreshData];

}

-(void)refreshData {
    
    self.trackNameLabel.text = self.track.trackName;
    
}

@end
