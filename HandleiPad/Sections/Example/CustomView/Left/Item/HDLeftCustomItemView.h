//
//  HDLeftCustomItemView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HDLeftCustomItemViewStyle) {
    HDLeftCustomItemViewStyleSafe = 1,// 安全
    HDLeftCustomItemViewStyleHiddenDanger,//隐患
    HDLeftCustomItemViewStyleMessage,//信息
    HDLeftCustomItemViewStyleCustom,//自定义
};

@interface HDLeftCustomItemView : UIView


+ (void)showCustomViewWithModelArray:(NSArray *)levelArray aroundView:(UIView *)aroundView direction:(UIPopoverArrowDirection)direction complete:(void(^)(PorscheConstantModel *model))complete;

- (instancetype)initWithCustomFrame:(CGRect)frame;

@end
