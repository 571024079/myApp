//
//  HDServiceRightTextFieldView.m
//  HandleiPad
//
//  Created by handou on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceRightTextFieldView.h"
@interface HDServiceRightTextFieldView ()<UITextFieldDelegate>

@end

@implementation HDServiceRightTextFieldView

- (instancetype)initWithCustomFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"HDServiceRightTextFieldView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    
    self.textField.delegate = self;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(serviceRightTextFieldViewShouldReturn:)]) {
        [_delegate serviceRightTextFieldViewShouldReturn:textField];
    }
    return YES;
}

@end
