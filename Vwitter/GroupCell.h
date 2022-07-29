//
//  GroupCell.h
//  Vwitter
//
//  Created by Christina Li on 7/20/22.
//

#import <UIKit/UIKit.h>
#import "GroupDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (strong, nonatomic) GroupDetails *group;

@end

NS_ASSUME_NONNULL_END
