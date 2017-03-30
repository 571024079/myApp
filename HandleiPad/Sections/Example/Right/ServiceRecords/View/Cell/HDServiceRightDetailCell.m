//
//  HDServiceRightDetailCell.m
//  HandleiPad
//
//  Created by handou on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceRightDetailCell.h"

@implementation HDServiceRightDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (IBAction)rightButtonAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(cellButtonActionWithcell:withButton:)]) {
        [_delegate cellButtonActionWithcell:self withButton:sender];
    }
}




@end
