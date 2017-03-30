//
//  UILabel+Addition.h
//  MiTableView
//
//  Created by JUN on 16/5/30.
//  Copyright © 2016年 HuWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Addition)
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;
@end
