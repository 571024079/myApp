//
//  SpareSettingTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar on 2016/12/22.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "SpareSettingTableViewCell.h"

@implementation SpareSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    /*
    self.orderTypeLabel.layer.cornerRadius = 3;
    self.orderTypeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.orderTypeLabel.layer.borderWidth = 0.5f;
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)orderTypeButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(spareSettingTableViewCell:orderTypeButtonClick: )])
    {
        [self.delegate spareSettingTableViewCell:self orderTypeButtonClick:sender];
    }
}

@end
