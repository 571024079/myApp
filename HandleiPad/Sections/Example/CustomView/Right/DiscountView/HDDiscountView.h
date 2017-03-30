//
//  HDDiscountView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HDDiscountView : UIView


//折扣超出权限相关

@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UILabel *noticeTitle;
//总计折扣不含折扣范围相关
@property (weak, nonatomic) IBOutlet UIView *adaptSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adaptViewHeght;


//原价
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLb;

//优惠数额
@property (weak, nonatomic) IBOutlet UITextField *disCountPriceTF;
//折扣
@property (weak, nonatomic) IBOutlet UITextField *disCountTF;
//实收
@property (weak, nonatomic) IBOutlet UITextField *endPriceTF;

@property (weak, nonatomic) IBOutlet UITextField *discountRange;

//原始高度
@property (nonatomic, assign) CGFloat originalHeight;


@property (nonatomic, strong) NSString *discount;

//折扣范围
- (IBAction)discountRangeBtAction:(UIButton *)sender;


//1.确定  2.取消
- (IBAction)buttonClickAction:(UIButton *)sender;

//默认尺寸 315-271 不包含提示 当折扣超限制时，提示
//中心点 和尺寸(355, 112, 315, 271)
+ (void)showDiscountViewWithPrice:(NSString *)price discount:(NSString *)discount discountPrice:(NSString *)discountPrice realPrice:(NSString *)realPrice sure:(void(^)(NSString *discount,NSString *discountPrice,NSString *realPrice,NSNumber *rangeId))sure withModel:(PorscheNewSchemews *)model;
//总计折扣《没有适用范围弹窗及按钮》
+ (void)showAllDiscountViewWithPrice:(NSString *)price discount:(NSString *)discount discountPrice:(NSString *)discountPrice realPrice:(NSString *)realPrice sure:(void(^)(NSString *discount,NSString *discountPrice,NSString *realPrice,NSNumber *rangeId))sure;

@end
