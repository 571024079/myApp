//
//  UIView+DrawClearRect.m
//  HandleiPad
//
//  Created by Robin on 16/11/7.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "UIView+DrawClearRect.h"

@implementation UIView (DrawClearRect)

- (void)drawClearRect:(CGRect)rect {
    
    [[UIColor colorWithWhite:0 alpha:0.5] setFill];
    
    //透明的区域
    CGRect holeRection = rect;

    CGRect holeiInterSection = CGRectIntersection(holeRection, self.bounds);
    [[UIColor clearColor] setFill];

    UIRectFill(holeiInterSection);
}

@end
