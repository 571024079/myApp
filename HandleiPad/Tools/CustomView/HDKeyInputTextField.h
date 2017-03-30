//
//  HDKeyInputTextField.h
//  HandleiPad
//
//  Created by Handlecar on 2017/2/9.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol keyInputTextFieldDelegate <NSObject>

- (void)deleteBackward:(UITextField *)textField;

@end

@interface HDKeyInputTextField : UITextField

@property (nonatomic, weak) id<keyInputTextFieldDelegate>deleteBackwardDelegate;

@end
