//
//  HDCancelBillingView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDCancelBillingView.h"
#import "HDMoreListView.h"

@interface HDCancelBillingView ()<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, copy) HdCancelBillingViewBlock completion;
@property (nonatomic, strong) UIView *clearView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HDCancelBillingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (void)showCancelViewBlock:(HdCancelBillingViewBlock)completion {
    HDCancelBillingView *view = [[HDCancelBillingView alloc]initWithCustomFrame:KEY_WINDOW.frame];
    view.completion = completion;
    
    [KEY_WINDOW addSubview:view];
}

- (instancetype)initWithCustomFrame:(CGRect)frame {
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    self = nibArray.firstObject;
    self.frame =frame;
    _contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self setborder];
    return self;
}

- (void)setborder {
    _centerView.layer.masksToBounds = YES;
    _centerView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 3;
    _textView.layer.borderColor = Color(200, 200, 200).CGColor;
    _textView.layer.borderWidth = 0.5;
    _reasonTF.attributedPlaceholder = [@"请选择取消原因" setTFplaceHolderWithMainGrayWithColor:Color(170, 170, 170)];
}

#pragma mark  代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.textColor = Color(119, 119, 119);
    if ([textView.text isEqualToString:@"选择中如没有，请在这里填写"]) {
        textView.text = nil;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.textColor = Color(170, 170, 170);

        textView.text = @"选择中如没有，请在这里填写";
    }
}

- (IBAction)sureOrCancelBtAction:(UIButton *)sender {
    if (sender.tag == 1) {//保存
        if (self.completion) {
            if ([_textView.text isEqualToString:@"选择中如没有，请在这里填写"]) {
                self.completion(_reasonTF.text);
            }else {
                self.completion(_textView.text);
            }
        }
    }else {//取消
        
    }
    [self removeFromSuperview];
}

- (IBAction)pullDownBtAction:(UIButton *)sender {
    WeakObject(self);
    if (self.dataSource.count) {
        [self showListView];
    }else {
        __block MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
        [PorscheRequestManager getCancelBillingReasonListComplate:^(NSMutableArray * _Nonnull classifyArray, PResponseModel * _Nonnull responser) {
            [hud hideAnimated:YES];
            selfWeak.dataSource = classifyArray;
            [selfWeak showListView];
        }];
    }
}

- (void)showListView {
    WeakObject(self);
    NSMutableArray *titleArray = [NSMutableArray array];
    for (PorscheCancelBillingReason *model in self.dataSource) {
        [titleArray addObject:model.cancelreason];
    }
    [HDMoreListView showListViewWithView:_reasonFulBt Data:titleArray direction:UIPopoverArrowDirectionDown complete:^(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx) {
        
        selfWeak.reasonTF.text = contentOne.cvvaluedesc;
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (CGRectContainsPoint(self.centerView.frame, point)) {
        return [super hitTest:point withEvent:event];
    }
    [self removeFromSuperview];
    
    return nil;
}

@end
