//
//  UILabel+JustfyLabel.m
//  HandleiPad
//
//  Created by handlecar on 16/11/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "UILabel+JustfyLabel.h"

@implementation UILabel (JustfyLabel)

- (void)setJustfyForLabelWithText:(NSString *)contentText withMaxValue:(NSInteger)value withAlignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentText];
    //内容长度
    CGSize textSize = [contentText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.font} context:nil].size;
    //单个字符的长度
    CGFloat textSingleWidth = textSize.width / contentText.length;
    //多出空间的长度
    CGFloat space = (value * textSingleWidth) - (textSingleWidth * contentText.length);
    //字符之间的间距
    NSNumber *number = @(space / (contentText.length - 1));
    //给字符之间添加间距
    [str addAttribute:NSKernAttributeName value:number range:NSMakeRange(0, contentText.length)];
    
    [self setAttributedText:str];
    [self setTextAlignment:alignment];
}

@end
