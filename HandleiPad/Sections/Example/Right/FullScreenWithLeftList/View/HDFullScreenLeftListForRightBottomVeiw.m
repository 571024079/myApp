//
//  HDFullScreenLeftListForRightBottomVeiw.m
//  HandleiPad
//
//  Created by handou on 16/10/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDFullScreenLeftListForRightBottomVeiw.h"

@implementation HDFullScreenLeftListForRightBottomVeiw

- (instancetype)initWithCustomFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"HDFullScreenLeftListForRightBottomVeiw" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    
    return self;
}

//确认返回方法
- (IBAction)bottomButtonAction:(UIButton *)sender {
    if (self.hDFullScreenLeftListForRightBottomVeiwBlock) {
        self.hDFullScreenLeftListForRightBottomVeiwBlock(sender);
    }
}


//交车操作
- (IBAction)jiaocheButtonAction:(UIButton *)sender {
    if (self.hDFullScreenLeftListForRightBottomVeiwBlock) {
        self.hDFullScreenLeftListForRightBottomVeiwBlock(sender);
    }
}


@end
