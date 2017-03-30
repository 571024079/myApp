//
//  BillingRightCollectionViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "BillingRightCollectionViewCell.h"

@implementation BillingRightCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _playBt.hidden = YES;
    // Initialization code
}

- (IBAction)playBtAction:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}
@end
