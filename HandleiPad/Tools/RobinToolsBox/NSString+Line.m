//
//  NSString+Line.m
//  HandleiPad
//
//  Created by Robin on 16/11/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "NSString+Line.h"

@implementation NSString (Line)

+ (NSAttributedString *)addLineWithSting:(NSString *)string {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    //在某个范围内增加下划线
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [str length])];

    return str;
}

+ (NSAttributedString *)changeFontWithSting:(NSString *)string range:(NSRange *)range {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    //修改某个范围内的字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:16.0] range:NSMakeRange(7,2)];
    //修改某个范围内字的颜色
    [str addAttribute:NSForegroundColorAttributeName value:Color(62, 190, 219)  range:NSMakeRange(7,2)];
    
    return str;
}

+ (NSMutableAttributedString *)boldText:(NSString *)string boldRange:(NSRange)boldrange {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attStr addAttribute:NSFontAttributeName
                   value:[UIFont boldSystemFontOfSize:12.f]
                   range:boldrange];
    return attStr;
}

@end
