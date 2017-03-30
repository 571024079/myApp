//
//  HDServiceRightTextFieldView.h
//  HandleiPad
//
//  Created by handou on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDServiceRightTextFieldViewDelegate <NSObject>
- (void)serviceRightTextFieldViewShouldReturn:(UITextField *)textField;

@end

@interface HDServiceRightTextFieldView : UIView
@property (nonatomic, assign) id<HDServiceRightTextFieldViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *textField;


- (instancetype)initWithCustomFrame:(CGRect)frame;
@end
