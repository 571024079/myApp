//
//  HDDiscountView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDDiscountView.h"
#import "PorscheMultipleListhView.h"
#import "HDAccessoryView.h"

typedef void(^HDDiscountViewBlock)(NSString *discount,NSString *discountPrice,NSString *realPrice,NSNumber *rangeId);
@interface HDDiscountView ()<UITextFieldDelegate>

@property (nonatomic, copy) HDDiscountViewBlock hDDiscountViewBlock;

@property (weak, nonatomic) IBOutlet UIView *listView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *listViewWidth;

@property (nonatomic, strong) NSNumber *selectedid;

@property (nonatomic, strong) PorscheNewSchemews *model;



@end

@implementation HDDiscountView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//方案总小计折扣框
+ (void)showAllDiscountViewWithPrice:(NSString *)price discount:(NSString *)discount discountPrice:(NSString *)discountPrice realPrice:(NSString *)realPrice sure:(void(^)(NSString *discount,NSString *discountPrice,NSString *realPrice,NSNumber *rangeId))sure {
    HDDiscountView *view = [HDDiscountView getCustomFrame:KEY_WINDOW.frame];
    view.hDDiscountViewBlock = sure;
    view.oldPriceLb.text = price;
    
    view.disCountPriceTF.text = @"";
    view.disCountTF.text = @"";
    view.endPriceTF.text = @"";
    view.listViewWidth.constant = 240;
    view.originalHeight = 240;
    view.adaptViewHeght.constant = 0;
    view.adaptSuperView.hidden = YES;
    if (discountPrice.length > 0) {
        view.disCountPriceTF.placeholder = discountPrice ;
        
        
        view.disCountTF.placeholder = discount.length > 0 ? discount : @"0.00";
        
        view.endPriceTF.placeholder = realPrice;
    }
    
    [HD_FULLView addSubview:view];
    [view.disCountTF becomeFirstResponder];
}

//*超出权限范围，您的权限最多只能打折10%

+ (void)showDiscountViewWithPrice:(NSString *)price discount:(NSString *)discount discountPrice:(NSString *)discountPrice realPrice:(NSString *)realPrice sure:(void(^)(NSString *discount,NSString *discountPrice,NSString *realPrice,NSNumber *rangeId))sure withModel:(PorscheNewSchemews *)model {
    HDDiscountView *view = [HDDiscountView getCustomFrame:KEY_WINDOW.frame];
    view.hDDiscountViewBlock = sure;
    view.oldPriceLb.text = price;
    view.disCountPriceTF.text = @"";
    view.disCountTF.text = @"";
    view.endPriceTF.text = @"";
    view.listViewWidth.constant = 276;
    view.originalHeight = 276;
    NSInteger permission = 0;
    if ([model.schemesubtype integerValue] == 1) {
        permission = HDOrder_FuWuGouTong_SchemeTimeDiscount_Rate;
    }else {
        permission = HDOrder_FuWuGouTong_SchemeSpacePartDiscount_Rate;
    }
    view.discount = [HDPermissionManager getDiscountSchemeThisPermission:permission];

    view.noticeTitle.text = /*[NSString stringWithFormat:@"*超出权限范围，您的权限最多只能打折%@%%", @(100 - [view.discount floatValue] * 10)]*/@"*超出权限范围";
    view.selectedid = @1;
    
    view.model = model;
    view.discountRange.text = [model.schemesubtype isEqualToNumber:@1] ? @"此工时":@"此备件";
    if (discountPrice.length > 0) {
        view.disCountPriceTF.placeholder = discountPrice ;
        
        
        view.disCountTF.placeholder = discount.length > 0 ? discount : @"0.00";
        
        view.endPriceTF.placeholder = realPrice;
    }
    
//    if ([model.schemesubtype integerValue] == 1) {//工时
//        view.discountRange.text = @"此工时";
//        view.selectedid = @1;
//    }else if ([model.schemesubtype integerValue] == 2) {//备件
//        view.discountRange.text = @"此备件";
//        view.selectedid = @1;
//    }
    
    [HD_FULLView addSubview:view];
    [view.disCountTF becomeFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *endString;
    if (![string isEqualToString:@""]) {
        endString =[textField.text stringByAppendingString:string];
    }else {
        if (textField.text.length > 0) {
            endString = [textField.text substringToIndex:textField.text.length - 1];
        }else {
            endString = @"";
            
        }
    }

    //优惠.不能大于原价
    if ([textField isEqual:_disCountPriceTF]) {
        //不大于原价
        if ([endString floatValue] >[_oldPriceLb
            .text floatValue]) {
            return NO;
        }
        
        BOOL ret = [HDUtil textFieldFilter:textField shouldChangeCharactersInRange:range replacementString:string];
        if (!ret) {
            return  NO;
        }
        
        if (endString.length > 0) {
            NSString *realPrice = [NSString stringWithFormat:@"%.2f",[_oldPriceLb.text floatValue]  - [endString floatValue] ];
            NSString *discountString;
            
            if (_oldPriceLb.text.length) {
                discountString =[NSString stringWithFormat:@"%.2f", [endString floatValue] * 100 / [_oldPriceLb.text floatValue]];
            }
            _disCountTF.text = discountString;
            _endPriceTF.text = realPrice;
            [self changeListViewHeightWithDiscount:discountString];

        }else {
            _disCountPriceTF.text = @"";
            _endPriceTF.text = @"";
            _disCountTF.text = @"";
        }
        
    }
    
    if ([textField isEqual:_disCountTF]) {
        //折扣不能大于100；
        if ([endString floatValue] / 100 > 1) {
            
            return NO;
        }
        BOOL ret = [HDUtil textFieldFilter:textField shouldChangeCharactersInRange:range replacementString:string];
        if (!ret) {
            return  NO;
        }
        if (endString.length > 0) {
            NSString *discountPriceString= [NSString stringWithFormat:@"%.2f",[endString floatValue] * [_oldPriceLb.text floatValue] /100];
            
            NSString *realPrice = [NSString stringWithFormat:@"%.2f", [_oldPriceLb.text floatValue] - [discountPriceString floatValue]];
            _endPriceTF.text = realPrice;
            _disCountPriceTF.text = discountPriceString;
            [self changeListViewHeightWithDiscount:endString];

        }else {
            _disCountPriceTF.text = @"";
            _endPriceTF.text = @"";
            _disCountTF.text = @"";
        }
        
    }
    
    if ([textField isEqual:_endPriceTF]) {
        if ([textField.text floatValue] < 0) {
            return NO;
        }
        BOOL ret = [HDUtil textFieldFilter:textField shouldChangeCharactersInRange:range replacementString:string];
        if (!ret) {
            return  NO;
        }
        if (endString.length > 0) {
            NSString *discountString = [NSString stringWithFormat:@"%.2f",[_oldPriceLb.text floatValue] - [endString floatValue]];
            
            NSString *discount = [NSString stringWithFormat:@"%.2f",[discountString floatValue] * 100 /[_oldPriceLb.text floatValue]];
            
            _disCountPriceTF.text = discountString;
            
            _disCountTF.text = discount;
            [self changeListViewHeightWithDiscount:discount];

        }else {
            _disCountPriceTF.text = @"";
            _endPriceTF.text = @"";
            _disCountTF.text = @"";
        }

    }
    return YES;
}

- (void)changeListViewHeightWithDiscount:(NSString *)discount{
    if ([discount floatValue] > [_discount floatValue] * 10) {
        _listViewWidth.constant = _originalHeight + 25;
        _noticeView.hidden = NO;
    }else {
        _listViewWidth.constant = _originalHeight;
        _noticeView.hidden = YES;
    }
}

+ (instancetype)getCustomFrame:(CGRect)frame {
    HDDiscountView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    view.frame = frame;
    
    view.disCountPriceTF.inputView = [[PorscheNumericKeyboard alloc] init];
    view.disCountTF.inputView = [[PorscheNumericKeyboard alloc] init];
    view.endPriceTF.inputView = [[PorscheNumericKeyboard alloc] init];
    
    [HDAccessoryView accessoryViewWithTextField:view.disCountPriceTF target:self];
    [HDAccessoryView accessoryViewWithTextField:view.disCountTF target:self];
    [HDAccessoryView accessoryViewWithTextField:view.endPriceTF target:self];

    
    view.listViewWidth.constant = 271;
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    view.listView.layer.masksToBounds = YES;
    view.listView.layer.cornerRadius = 5;
    return view;
}


- (IBAction)buttonClickAction:(UIButton *)sender {
    if (sender.tag == 1) {//确定
        if (self.hDDiscountViewBlock) {
            NSString *dis;
            if ([_disCountTF.text isEqualToString:@""]) {
                dis = _disCountTF
                .placeholder  ;

            }else {
                dis = _disCountTF.text;
            }
            
            if ([dis floatValue] > [_discount floatValue]*10) {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:_noticeTitle.text height:60 center:HD_FULLView.center superView:HD_FULLView];
                return;
            }
            
            float endDis = 100 - [dis floatValue];
            self.hDDiscountViewBlock([NSString stringWithFormat:@"%f",endDis],_disCountPriceTF.text,_endPriceTF.text,self.selectedid);
            [self removeFromSuperview];

        }
    }else {
        [self removeFromSuperview];
    }
    
}
- (IBAction)discountRangeBtAction:(UIButton *)sender {
    
    WeakObject(self);
    NSArray *dataSource = [NSArray array];
    if ([_model.schemesubtype integerValue] == 1) {//工时
        dataSource = @[@"此工时",@"此方案所有工时",@"此方案工时和备件",@"整单工时"];//1.3.2.4
    }else if ([_model.schemesubtype integerValue] == 2) {//备件
        dataSource = @[@"此备件",@"此方案所有备件",@"此方案工时和备件",@"整单备件"];
    }
    NSMutableArray *data = [NSMutableArray array];
    for (NSString *str in dataSource) {
        PorscheConstantModel *model = [PorscheConstantModel new];
        model.cvvaluedesc = str;
        [data addObject:model];
    }
    //默认是第一位
    
    [PorscheMultipleListhView showSingleListViewFrom:sender dataSource:data selected:nil showArrow:NO direction:ListViewDirectionDown complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
    

        self.discountRange.text = constantModel.cvvaluedesc;
        if (idx == 1) {
            selfWeak.selectedid = @(3);
        }else if (idx == 2) {
            selfWeak.selectedid = @(2);
        }else {
            selfWeak.selectedid = @(idx + 1);
        }
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (CGRectContainsPoint(self.listView.frame, point)) {
        
        return [super hitTest:point withEvent:event];
    }
    [self removeFromSuperview];
    
    return nil;
}

@end
