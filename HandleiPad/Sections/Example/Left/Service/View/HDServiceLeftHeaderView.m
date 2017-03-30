//
//  HDServiceLeftHeaderView.m
//  HandleiPad
//
//  Created by handou on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceLeftHeaderView.h"

@interface HDServiceLeftHeaderView ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *bottomImageArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bottomButtonArray;

@end

@implementation HDServiceLeftHeaderView

- (instancetype)initWithCustomFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"HDServiceLeftHeaderView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    
    for (UIView *view in self.subviews) {
        if (![view isKindOfClass:[UILabel class]]) {
            if (view == _viewTopThree) {
                for (UIView *viewSub in view.subviews) {
                    viewSub.layer.masksToBounds = YES;
                    viewSub.layer.cornerRadius = 3;
                    viewSub.layer.borderWidth = 1;
                    viewSub.layer.borderColor = [UIColor lightGrayColor].CGColor;
                }
            }else {
                view.layer.masksToBounds = YES;
                view.layer.cornerRadius = 3;
                view.layer.borderWidth = 1;
                view.layer.borderColor = [UIColor lightGrayColor].CGColor;
            }
            
        }
    }
    
    self.textFTopOne.delegate = self;
    self.textFTopTwo.delegate = self;
    self.textFMiddleOne.delegate = self;
    self.textFMiddleTwo.delegate = self;
    self.textFMiddleThree.delegate = self;
    self.textFieldBottomFour.delegate = self;
    
    [self buttonAction:_buttonBottomOne];
    
    return self;
}

#pragma mark - button的点击事件
- (IBAction)buttonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    //在厂、常客、VIP
    if ([_bottomButtonArray containsObject:button]) {
        button.selected = !button.selected;
        if (button.selected) {
            [self setSelectStyleWithButton:button];
        }else {
            [self setNarmalStyleWithButton:button];
        }
    }
    if (button == _clearButton) {
        [self clearAllStatus];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(serviceLeftHeaderButtonAction:withStyle:)]) {
        [_delegate serviceLeftHeaderButtonAction:button withStyle:(ServiceLeftHeaderStyle)button.tag];
    }
}

- (void)selectOnFactory
{
    _buttonBottomOne.selected = NO;
    [self buttonAction:_buttonBottomOne];
}

#pragma mark - 清空所有的输入状态
- (void)clearAllStatus {
    _textFTopOne.text = @"";
    _textFTopTwo.text = @"";
    _textFMiddleOne.text = @"";
    _textFMiddleTwo.text = @"";
    _textFMiddleThree.text = @"";
    _textFieldBottomFour.text = @"";
    for (UIButton *button in _bottomButtonArray) {
        button.selected = NO;
        [self setNarmalStyleWithButton:button];
    }
}

#pragma mark - 输入框输入代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(serviceLeftHeaderViewShouldReturn:)]) {
        [_delegate serviceLeftHeaderViewShouldReturn:textField];
    }
    return YES;
}

#pragma mark - 处理类别按钮点击的样式
- (void)setNarmalStyleWithButton:(UIButton *)button {
    UIImageView *imageView = [self viewWithTag:button.tag + 100];
    imageView.hidden = YES;
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}
- (void)setSelectStyleWithButton:(UIButton *)button {
    UIImageView *imageView = [self viewWithTag:button.tag + 100];
    imageView.hidden = NO;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)clear
{
    [self buttonAction:_clearButton];
}
@end
