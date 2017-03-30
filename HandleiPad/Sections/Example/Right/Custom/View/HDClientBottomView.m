//
//  HDClientBottomView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDClientBottomView.h"

@implementation HDClientBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCustomFrame:(CGRect)frame {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    
    self = array.firstObject;
    self.frame = frame;
    
    
    
    return self;
}

- (void)setupViewSave:(PorscheNewCarMessage *)message isSave:(BOOL)isSave{
    [self.customSureBt setBackgroundImage:[UIImage imageNamed:isSave ? @"gray_backGroundImage.png" : @"sure_bg_blue.png"] forState:UIControlStateNormal];
    self.customSureBt.userInteractionEnabled = !isSave;

#pragma mark  已确认  不能再确认
    if (!isSave) {
        if (message) {
            if (![message.orderstatus isShowCustomLighting]) {
                [_customSureBt setBackgroundImage:[UIImage imageNamed:@"gray_backGroundImage.png"] forState:UIControlStateNormal];
                _customSureBt.userInteractionEnabled = NO;
            }
        }
    }
    
    UIImage *image = [UIImage imageNamed:@"hd_item_cancelAffirm.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    /*
    // 打印预览按钮状态
    BOOL isEnable = (message != nil);
    
    self.printBt.enabled = isEnable;
    self.preViewBt.enabled = isEnable;
    self.shareBt.enabled = isEnable;
    
    // 设置打印预览分享按钮显示颜色
    [self setPrintPrewShareButtonStatus:isEnable];
    */
    
    // 取消确认按钮是否可以点击
    if (message == nil || [message.orderstatus isShowCustomLighting])
    {
        self.cancelAffirmBt.enabled = NO;
        self.cancelLabel.textColor = MAIN_PLACEHOLDER_GRAY;
        self.cancelImageView.tintColor = MAIN_PLACEHOLDER_GRAY;
    }
    else
    {
        self.cancelAffirmBt.enabled = YES;
        self.cancelLabel.textColor = Color(85, 85, 85);
        self.cancelImageView.tintColor = MAIN_BLUE;
    }
    self.cancelImageView.image = image;
}

- (void)setPrintPrewShareButtonStatus:(BOOL)isEnable
{
    UIImage *printImage = self.printBt.imageView.image;
    printImage = [printImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImage *shareBt = self.shareBt.imageView.image;
    shareBt = [shareBt imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImage *preViewBt = self.shareBt.imageView.image;
    preViewBt = [preViewBt imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if (isEnable)
    {
        self.printBt.imageView.tintColor = MAIN_BLUE;
        self.preViewBt.imageView.tintColor = MAIN_BLUE;
        self.shareBt.imageView.tintColor = MAIN_BLUE;
    }
    else
    {
        self.printBt.imageView.tintColor = MAIN_PLACEHOLDER_GRAY;
        self.preViewBt.imageView.tintColor = MAIN_PLACEHOLDER_GRAY;
        self.shareBt.imageView.tintColor = MAIN_PLACEHOLDER_GRAY;
    }
    
    [self.printBt setImage:printImage forState:UIControlStateNormal];
    [self.shareBt setImage:shareBt forState:UIControlStateNormal];
    [self.preViewBt setImage:preViewBt forState:UIControlStateNormal];

}

- (IBAction)buttonClickAction:(UIButton *)sender {
    if (self.hDClientBottomViewBlock) {
        self.hDClientBottomViewBlock(sender);
    }
    
}



@end
