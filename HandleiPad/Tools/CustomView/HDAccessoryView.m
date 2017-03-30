//
//  HDAccessoryView.m
//  HandleiPad
//
//  Created by Handlecar on 2016/12/30.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDAccessoryView.h"

@implementation HDAccessoryView
+ (void)accessoryViewWithTextField:(UITextField *)textField target:(id)target
{
    
    HDAccessoryView *topViewWithKeyBord = [[HDAccessoryView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(KEY_WINDOW.frame), 30)];
    topViewWithKeyBord.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:MAIN_BLUE forState:UIControlStateNormal];
    
    [button addTarget:topViewWithKeyBord action:@selector(handleKeybordButtonAction) forControlEvents:UIControlEventTouchUpInside];

    button.frame = CGRectMake(CGRectGetWidth(KEY_WINDOW.frame) - 100, 0, 80, 30);
    [topViewWithKeyBord addSubview:button];
    textField.inputAccessoryView = topViewWithKeyBord;
}

#pragma mark  ------ 公里数的键盘添加完成方法

- (void)handleKeybordButtonAction {
    [HD_KEYWINDOW endEditing:YES];
}

@end
