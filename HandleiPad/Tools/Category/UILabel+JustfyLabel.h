//
//  UILabel+JustfyLabel.h
//  HandleiPad
//
//  Created by handlecar on 16/11/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (JustfyLabel)

/*
    输入的是了label的字，和相比其他label显示对齐效果的最大的字符数
 */
- (void)setJustfyForLabelWithText:(NSString *)contentText withMaxValue:(NSInteger)value withAlignment:(NSTextAlignment)alignment;

@end
