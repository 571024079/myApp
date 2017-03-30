//
//  HDInputVINView.m
//  Handlecar
//
//  Created by liuzhaoxu on 14-9-5.
//  Copyright (c) 2014年 HanDou. All rights reserved.
//

#import "HDInputVINView.h"

#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"


@interface HDInputVINView ()<UITextFieldDelegate>

//@property (strong, nonatomic) UITextField *textField;

@property (nonatomic, weak) id<HDInputVinViewDelegate>delegate;

@property (nonatomic, strong) UIButton *currentButton;

@end

@implementation HDInputVINView

HD_SINGLETON_IMPL(HDInputVINView);
HD_SINGLETON_DESTORY();

- (void)showInputView:(id<HDInputVinViewDelegate>)delegate originalVINNo:(NSString *)vinNo textField:(UITextField *)textField
{
    
    textField.delegate = self;
    
    self.delegate = delegate;
    //给VIN 辅助视图赋值
    NSLog(@"Length is %lu",(unsigned long)vinNo.length);
    for (int i = 1; i < 18; i++)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:i];
        if (i <= vinNo.length)
        {
            [btn setTitle:[vinNo substringWithRange:NSMakeRange(i - 1, 1)] forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitle:@" " forState:UIControlStateNormal];
        }
    }

    //设置默认显示输入的行
    UIButton *button;
    if (vinNo.length == 0) {
        button =(UIButton *)[self viewWithTag:1];
    }else {
        button =(UIButton *)[self viewWithTag:vinNo.length];

    }
    
    [self textButtonAction:button];
}

- (void)setHighlightButton:(UIButton *)button
{
    self.currentButton.layer.borderWidth = 0;
    
    button.layer.borderWidth = 1;
    
    self.currentButton = button;
}

- (void)awakeFromNib
{
    
    [super awakeFromNib];
    
    self.layer.cornerRadius = 6;
    
    self.layer.masksToBounds = YES;
    
    for (int i = 1; i < 18; i ++ ) {
        UIButton *button = (UIButton *)[self viewWithTag:i];
        
        button.layer.cornerRadius = 3;
        
        button.layer.borderColor = Color(203, 70, 73).CGColor;
    }
    
    _VINLb.layer.masksToBounds = YES;
    _VINLb.layer.cornerRadius = 3;
    _VINLb.layer.borderWidth = 1;
    _VINLb.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
}

- (IBAction)textButtonAction:(id)sender {

    [self setHighlightButton:sender];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    textField.text = [self getAllTitleString];
    NSString *endStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    textField.text = endStr;
////    if (textField.text.length == 17) {
//    if (self.hDInputVINViewFInishVINInputBlock) {
//        self.hDInputVINViewFInishVINInputBlock(endStr);
////        }
        if ([self.delegate respondsToSelector:@selector(inputVINView:inputVIN:)])
        {
            [self.delegate inputVINView:self inputVIN:endStr];
        }
//    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
 
    [_currentButton setTitle:[string uppercaseString] forState:UIControlStateNormal];
    
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum]invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    if (canChange==NO)
    {
        [_currentButton setTitle:@"" forState:UIControlStateNormal];
        return NO;
    }
    
    if ([string isEqualToString:@""])
    {
        if (_currentButton.tag - 1 > 0) {
            UIButton *btn = (UIButton *)[self viewWithTag:_currentButton.tag - 1];
            btn.layer.borderWidth = 1;
            [self setHighlightButton:btn];
        }
    }
    
    else
    {
        if (_currentButton.tag + 1 < 18) {
            UIButton *btn = (UIButton *)[self viewWithTag:_currentButton.tag + 1];
            btn.layer.borderWidth = 1;
            [self setHighlightButton:btn];
        }
    }
    //去空格
    textField.text= [self getStringWithoutSpaceWithString:[self getAllTitleString]];
    
    if (textField.text.length == 17) {

        return NO;
    }

    return NO;
}

- (NSString *)getStringWithoutSpaceWithString:(NSString *)string {
    //过滤 字符串前空格
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤 字符串中空格
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}

- (NSString*)getAllTitleString
{
    NSString* str=[[NSString alloc] init];
    for (int i=1; i<19; i++)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:i];
        if ([btn titleForState:UIControlStateNormal]!=nil)
        {
            str=[NSString stringWithFormat:@"%@%@",str,[btn titleForState:UIControlStateNormal]];
        }
    }
//    str=[NSString stringWithFormat:@"%@%@",str,@"X"];
    return str;
}

@end
