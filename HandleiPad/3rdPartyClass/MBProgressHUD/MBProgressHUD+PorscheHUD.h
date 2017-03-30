//
//  MBProgressHUD+PorscheHUD.h
//  HandleiPad
//
//  Created by Robin on 16/11/16.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (PorscheHUD)


/**
 显示纯文字 自动消失？若果NO 自己调用消失方法 [hub hideAnimated:YES afterDelay:delay];

 @param message 显示的文字内容
 @param view 提示框所在的父视图
 @param autoHidden 是否自动隐藏
 @return
 */
+ (MBProgressHUD *)showMessageText:(NSString *)message toView:(UIView *)view anutoHidden:(BOOL)autoHidden;

/**
 纯文字样式 自定义消失时间

 @param message 显示的文字内容
 @param view 提示框所在的父视图
 @param delay 延时时间
 @return 
 */
+ (MBProgressHUD *)showMessageText:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)delay;

/**
 自定义样式

 @param message 显示的文字内容
 @param model 样式
 @param view 提示框所在的父视图
 @return
 */
+ (MBProgressHUD *)showMessage:(NSString *)message progressMode:(MBProgressHUDMode)model toView:(UIView *)view;


/**
 菊花样式

 @param message 显示的文字内容
 @param view 提示框所在的父视图
 @return
 */
+ (MBProgressHUD *)showProgressMessage:(NSString *)message toView:(UIView *)view;

/**
 切换样式

 @param message 显示的文字内容
 @param view 提示框所在的父视图
 */
- (void)changeTextModeMessage:(NSString *)message toView:(UIView *)view;
@end
