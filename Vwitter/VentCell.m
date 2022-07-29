//
//  VentCell.m
//  Vwitter
//
//  Created by Christina Li on 7/14/22.
//

#import "VentCell.h"
#import "VWHelpers.h"
#import "VWUser.h"
#import "DateTools.h"

@implementation VentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVent:(Vent *)vent{
    _vent = vent;

    [self refreshData];

}

- (void)refreshData {

    NSString *at = @"@";
    self.ventContent.text = self.vent.ventContent;
    
    self.date.text = self.vent.createdAt.shortTimeAgoSinceNow;
    __weak typeof(self) weakSelf = self;
    [self.vent.author fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable author, NSError * _Nullable error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"bad");
            return;
        }
        else if (error) {
            NSLog(@"there was an error :( %@", error.localizedDescription);
            return;
        }
        else if (!author) {
            NSLog(@"the object does not exist");
            return;
        }
        
        VWUser *authorUser = CAST_TO_CLASS_OR_NIL(author, VWUser);
        
        strongSelf.username.text = [NSString stringWithFormat:@"%@%@", at, authorUser.username];
        strongSelf.screenName.text = authorUser.screenName;
        
        
    }];
    
    

}

@end
