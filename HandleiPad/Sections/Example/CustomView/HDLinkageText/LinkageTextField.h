//
//  LinkageTextField.h
//  MutipleAccessView
//
//  Created by Handlecar on 2017/2/17.
//  Copyright © 2017年 handlecar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LinkageTextField;

@protocol LinkageTextFieldDelegate <NSObject>

- (void)keyBoardDeleteBackward:(LinkageTextField *)textField;

@end

@interface LinkageTextField : UITextField
@property (nonatomic, weak) id<LinkageTextFieldDelegate>linkageDelegate;
@end
