//
//  HDTakePhotoUpData.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDTakePhotoUpData.h"

@implementation HDTakePhotoUpData

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)updatePhotoAction:(UIButton *)sender {
    if (self.hdupdatePhotoBlock) {
        self.hdupdatePhotoBlock(sender);
    }
}

#pragma mark  本地上传/拍照上传
+ (instancetype)getUpDatePhotoViewFrame:(CGRect)frame {
    
    NSArray *array =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HDTakePhotoUpData class]) owner:nil options:nil];
    HDTakePhotoUpData *view = array.firstObject;
    view.frame = frame;
    return view;
}
@end
