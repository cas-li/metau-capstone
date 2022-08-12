//
//  SpotifyTrack.h
//  Vwitter
//
//  Created by Christina Li on 7/28/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyTrack : NSObject
@property (strong, nonatomic) NSString *uriString;
@property (strong, nonatomic) NSString *trackName;
@property (strong, nonatomic) NSString *trackId;
@property (strong, nonatomic) NSNumber *startTimestamp;
@property (strong, nonatomic) NSNumber *endTimestamp;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
