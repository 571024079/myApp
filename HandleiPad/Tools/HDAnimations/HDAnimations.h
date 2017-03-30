//
//  HDAnimations.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/2.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HDAnimations : NSObject

//动画 组合 目前不分
+ (void)AnimationWithView:(UIView *)view style:(NSArray <NSNumber *>*)styleArray;

#pragma mark  ------基本动画------
//缩放
+ (CABasicAnimation *)scaleAnimation;
//旋转
+ (CABasicAnimation *)rotateAnimation;
//透明度
+ (CABasicAnimation *)opacityAnimation;
//位移
+ (CABasicAnimation *)positionAnimation;
//背景色变化
+ (CABasicAnimation *)backgroundAnimation;


@end
