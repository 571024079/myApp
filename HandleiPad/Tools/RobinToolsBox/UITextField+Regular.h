//
//  UITextField+Regular.h
//  HandleiPad
//
//  Created by 岳小龙 on 2016/12/7.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Regular)


/**
 输入的是否是价格格式
 */
- (BOOL)isPriceStringChangeRange:(NSRange)range replacementString:(NSString *)string;

/**
 输入是否为Float类型
 */
- (BOOL)isFloatStringChangeRange:(NSRange)range replacementString:(NSString *)string;

/**
 最长长度限制
 */
- (BOOL)isFloatStringToMaxLength:(NSInteger)MaxLength changeRange:(NSRange)range replacementString:(NSString *)string;
@end
