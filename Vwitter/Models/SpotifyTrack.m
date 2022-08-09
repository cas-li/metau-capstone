//
//  SpotifyTrack.m
//  Vwitter
//
//  Created by Christina Li on 7/28/22.
//

#import "SpotifyTrack.h"
#import "VWHelpers.h"

@implementation SpotifyTrack

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        self.uriString = CAST_TO_CLASS_OR_NIL(dictionary[@"uri"], NSString);
        if (!self.uriString) {
            NSLog(@"uriString not a string");
        }
        self.trackName = CAST_TO_CLASS_OR_NIL(dictionary[@"name"], NSString);
        if (!self.trackName) {
            NSLog(@"trackName not a string");
        }
        self.trackId = CAST_TO_CLASS_OR_NIL(dictionary[@"id"], NSString);
        if (!self.trackId) {
            NSLog(@"trackId not a string");
        }
    }
    return self;
}

@end
