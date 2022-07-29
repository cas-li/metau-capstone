//
//  VentCell.h
//  Vwitter
//
//  Created by Christina Li on 7/14/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "Vent.h"

NS_ASSUME_NONNULL_BEGIN

@interface VentCell : UITableViewCell
@property (strong, nonatomic) Vent *vent;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *ventContent;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@end

NS_ASSUME_NONNULL_END
