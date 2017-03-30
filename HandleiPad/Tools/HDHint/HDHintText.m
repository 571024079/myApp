//
//  HDHintText.m
//  HandleiPad
//
//  Created by Handlecar on 2017/2/16.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "HDHintText.h"

typedef enum : NSUInteger {
    HDHintOptionNormal,             // 正常提示 √
    HDHintOptionException,          // 异常提示 X
} HDHintOption;

@implementation HDHintText

+ (void)showNormalHintWithMessage:(NSString *)mesage
{
    [HDHintText showHintMessage:mesage option:HDHintOptionNormal];
}


+ (void)showExceptionHint:(NSString *)mesage
{
    [HDHintText showHintMessage:mesage option:HDHintOptionException];
}

+ (void)showHintMessage:(NSString *)message option:(HDHintOption)option
{
    
    UIImage *image = nil;
    switch (option) {
        case HDHintOptionNormal:
            
            break;
        case HDHintOptionException:
            image = [UIImage imageNamed:@"alert_notice_delete.png"];
            break;
        default:
            break;
    }
    
    [AlertViewHelpers saveDataActionWithImage:image message:message height:60 center:HD_FULLView.center superView:HD_FULLView];
}

@end
