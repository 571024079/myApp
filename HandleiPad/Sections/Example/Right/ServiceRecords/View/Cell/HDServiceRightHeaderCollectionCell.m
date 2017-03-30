//
//  HDServiceRightHeaderCollectionCell.m
//  HandleiPad
//
//  Created by handou on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceRightHeaderCollectionCell.h"

@implementation HDServiceRightHeaderCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (UIView *view in self.subviews) {
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 6;
    }
}

#pragma mark - 删除方法
- (IBAction)deleteButtonAction:(UIButton *)sender {
    if (_deleteBlock) {
        _deleteBlock(self);
    }
}


@end
