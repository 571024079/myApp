//
//  HDCancelBillingView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HdCancelBillingViewBlock)(NSString *reasonString);
@interface HDCancelBillingView : UIScrollView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *reasonTF;

@property (weak, nonatomic) IBOutlet UIButton *reasonFulBt;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *centerView;


- (IBAction)pullDownBtAction:(UIButton *)sender;

+ (void)showCancelViewBlock:(HdCancelBillingViewBlock) completion;
//取消/确定按钮
- (IBAction)sureOrCancelBtAction:(UIButton *)sender;



@end
