//
//  UIImageView+CircleStyleAndColor.m
//  HandleiPad
//
//  Created by handlecar on 16/12/1.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "UIImageView+CircleStyleAndColor.h"

@implementation UIImageView (CircleStyleAndColor)
- (void)filledCircleImageWithColor:(UIColor *)color withImageView:(UIImageView *)imageView {
    UIImage *image = [UIImage imageNamed:@"hd_kaidan_leftcell_round_blue"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.image = image;
    imageView.tintColor = color;
}

- (void)circleRoundImageWithColor:(UIColor *)color withImageView:(UIImageView *)imageView {
    UIImage *image = [UIImage imageNamed:@"hd_kaidan_leftcell_round_blue_white"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.image = image;
    imageView.tintColor = color;
}

- (void)pointImageWithColor:(UIColor *)color withImageView:(UIImageView *)imageView {
    UIImage *image = [UIImage imageNamed:@"hd_kaidan_leftcell_round_white_double.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.image = image;
    imageView.tintColor = color;
}

@end
