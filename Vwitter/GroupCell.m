//
//  GroupCell.m
//  Vwitter
//
//  Created by Christina Li on 7/20/22.
//

#import "GroupCell.h"

@implementation GroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGroup:(GroupDetails *)group{
    _group = group;

    self.groupNameLabel.text = group.groupName;
}

@end
