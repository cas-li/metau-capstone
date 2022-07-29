//
//  SpotifyTrack.m
//  Vwitter
//
//  Created by Christina Li on 7/28/22.
//

#import "SpotifyTrack.h"

@implementation SpotifyTrack

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        self.uriString = dictionary[@"uri"];
        self.trackName = dictionary[@"name"];
        self.trackId = dictionary[@"id"];
    }
    return self;
}

@end
