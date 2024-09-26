//
//  TrackCell.m
//  Vwitter
//
//  Created by Christina Li on 7/28/22.
//

#import "TrackCell.h"

@implementation TrackCell

-(void)setTrack:(SpotifyTrack *)track{
    _track = track;

    [self refreshData];

}

-(void)refreshData {
    
    self.trackNameLabel.text = self.track.trackName;
    
}

@end
