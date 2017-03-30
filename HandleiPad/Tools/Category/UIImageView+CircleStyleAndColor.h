//
//  UIImageView+CircleStyleAndColor.h
//  HandleiPad
//
//  Created by handlecar on 16/12/1.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CircleStyleAndColor)
/**
 实心圆
 */
- (void)filledCircleImageWithColor:(UIColor *)color withImageView:(UIImageView *)imageView;
/**
 空心圈
 */
- (void)circleRoundImageWithColor:(UIColor *)color withImageView:(UIImageView *)imageView;
/**
 有实心点的圈
 */
- (void)pointImageWithColor:(UIColor *)color withImageView:(UIImageView *)imageView;
@end
