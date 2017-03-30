//
//  UITextField+Regular.m
//  HandleiPad
//
//  Created by 岳小龙 on 2016/12/7.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "UITextField+Regular.h"

@implementation UITextField (Regular)


- (BOOL)isPriceStringChangeRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string validateNumber] || [string isEqualToString:@"."]) {
        //如果输入的是“.”  判断之前已经有"."或者字符串为空
        if ([string isEqualToString:@"."] && ([self.text rangeOfString:@"."].location != NSNotFound || [self.text isEqualToString:@""])) {
            return NO;
        }
        //拼出输入完成的str,判断str的长度大于等于“.”的位置＋4,则返回false,此次插入string失败 （"379132.424",长度10,"."的位置6, 10>=6+4）
        NSMutableString *str = [[NSMutableString alloc] initWithString:self.text];
        [str insertString:string atIndex:range.location];
        if (str.length >= [str rangeOfString:@"."].location+4){
            return NO;
        }
    } else {
        return NO;
    }
    
    return YES;
}

- (BOOL)isFloatStringChangeRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string validateNumber] || [string isEqualToString:@"."]) {
        //如果输入的是“.”  判断之前已经有"."或者字符串为空
        if ([string isEqualToString:@"."] && ([self.text rangeOfString:@"."].location != NSNotFound || [self.text isEqualToString:@""])) {
            return NO;
        }
        return YES;
    }
    
    return NO;
}

- (BOOL)isFloatStringToMaxLength:(NSInteger)MaxLength changeRange:(NSRange)range replacementString:(NSString *)string  {
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:self.text];
    [str insertString:string atIndex:range.location];
    if (str.length >= MaxLength+1){
        return NO;
    }
    return YES;
}


@end
