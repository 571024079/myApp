//
//  HDPopSelectTableViewCell.m
//  HandleiPad
//
//  Created by handlecar on 2017/3/10.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "HDPopSelectTableViewCell.h"

@implementation HDPopSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)rightButtonAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(tableViewCellRightButtonActionWith:withCell:)]) {
        [_delegate tableViewCellRightButtonActionWith:sender withCell:self];
    }
    
}


@end
