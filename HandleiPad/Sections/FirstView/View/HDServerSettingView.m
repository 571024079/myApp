//
//  HDServerSettingView.m
//  HandleiPad
//
//  Created by Handlecar on 2017/2/20.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "HDServerSettingView.h"

#define SA @"servivAddress" //当前服务器地址
#define SAD @"serverAddressDic" //保存的所有的服务器地址

@interface HDServerSettingView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIView *popView;

@end

@implementation HDServerSettingView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.center = KEY_WINDOW.center;
    
    self.popView.layer.borderWidth = 0.5;
    self.popView.layer.borderColor = MAIN_PLACEHOLDER_GRAY.CGColor;
    self.popView.layer.cornerRadius = 10;
    self.popView.layer.masksToBounds = YES;
    
    self.inputTextField.delegate = self;
    
    if ([[HDUtils readCustomClassConfig:SA] length]) {
        NSDictionary *serverAddressDic = [HDUtils readCustomClassConfig:SAD];
        for (NSString *key in serverAddressDic.allKeys) {
            if ([serverAddressDic[key] isEqualToString:[HDUtils readCustomClassConfig:SA]]) {
                self.inputTextField.text = key;
            }
        }
    }
    
    
}

//确定操作
- (IBAction)cofirmButtonAction:(UIButton *)sender {
    
    if (self.inputTextField.text.length) {
        if ([[HDUtils readCustomClassConfig:SA] length]) {
            
            NSDictionary *serverAddressDic = [HDUtils readCustomClassConfig:SAD];
            if ([serverAddressDic.allKeys containsObject:self.inputTextField.text]) {
                [HDUtils removeConfig:SA];
                [HDUtils setCustomClassConfig:SA value:serverAddressDic[self.inputTextField.text]];
                [HDUtils saveConfig];
                [self removeFromSuperview];
            }else {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"店铺不存在" height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
            }
        }else {
            NSDictionary *serverAddressDic = [HDUtils readCustomClassConfig:SAD];
            if ([serverAddressDic.allKeys containsObject:self.inputTextField.text]) {
                [HDUtils setCustomClassConfig:SA value:serverAddressDic[self.inputTextField.text]];
                [HDUtils saveConfig];
                [self removeFromSuperview];
            }else {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"店铺不存在" height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
            }
        }
    }else {
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"请输入店铺名称" height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
    }
    
}

//取消操作
- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self removeFromSuperview];
}

//空白点击操作
- (IBAction)backButtonAction:(UIButton *)sender {
    //不要旁边点击取消的操作,只能点击取消
    if (self.inputTextField.isFirstResponder) {
        [self.inputTextField resignFirstResponder];
    }
//    else {
//        [self removeFromSuperview];
//    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.inputTextField resignFirstResponder];
    return YES;
}

@end
