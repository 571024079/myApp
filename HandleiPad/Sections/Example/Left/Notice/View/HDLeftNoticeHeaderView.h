//
//  HDLeftNoticeHeaderView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/11.
//  Copyright © 2016年 Handlecar1. All rights reserved.




#import <UIKit/UIKit.h>
//-----------------------------------工单提醒headerView

//tag:1.新任务  2.增项通知  3.备件通知  4.状态更新  5.事件筛选  6. 清空
typedef void(^HDLeftNoticeHeaderViewBlock)(UIButton *);

@interface HDLeftNoticeHeaderView : UIView

//vin车型拍照
@property (weak, nonatomic) IBOutlet UITextField *vinSearchTF;
//时间筛选
@property (weak, nonatomic) IBOutlet UITextField *timeSearchTF;
@property (weak, nonatomic) IBOutlet UIButton *timeSearchBt;
//清空按钮
@property (weak, nonatomic) IBOutlet UIButton *cleanBt;

//新任务背景图
@property (weak, nonatomic) IBOutlet UIImageView *resentWorkImg;
//新任务按钮
@property (weak, nonatomic) IBOutlet UIButton *resentWorkBt;

//增项背景图
@property (weak, nonatomic) IBOutlet UIImageView *additionNoticeImg;
//增项按钮
@property (weak, nonatomic) IBOutlet UIButton *additionNoticeBt;

//备件通知背景图
@property (weak, nonatomic) IBOutlet UIImageView *materialImg;
//备件通知按钮
@property (weak, nonatomic) IBOutlet UIButton *materialBt;

//状态更新背景图
@property (weak, nonatomic) IBOutlet UIImageView *upStatusImg;
//状态更新按钮
@property (weak, nonatomic) IBOutlet UIButton *upStatusBt;

//视图按钮边框
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;


@property (nonatomic, strong) NSMutableArray *btArray;
@property (nonatomic, strong) NSMutableArray *bgArray;

//回调
@property (nonatomic, copy) HDLeftNoticeHeaderViewBlock hDLeftNoticeHeaderViewBlock;

// 清空按钮

//时间筛选按钮

//新任务，增项，备件通知，状态更新

- (IBAction)buttonAction:(UIButton *)sender;


- (instancetype)initWithCustomFrame:(CGRect)frame;


- (void)setButtonStatus:(NSInteger) status;

- (UIButton *)getButtonWithStatus:(NSInteger)status;

- (void)tipsDisplayStatusWithModel:(RemindModel *)model;

@end
