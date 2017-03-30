//
//  ItemListLeftHeaderView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
//开单信息界面 headerView
typedef NS_ENUM(NSInteger, ItemListLeftHeaderViewStyle) {
    ItemListLeftHeaderViewStyleTimeBt = 1,// 起始时间
    ItemListLeftHeaderViewStyleEndTimeBt,//截止时间Bt
    ItemListLeftHeaderViewStyleTodayBt,//今日bt
    ItemListLeftHeaderViewStyleThisWeekBt,//本周Bt
    ItemListLeftHeaderViewStyleProgressBt,//进度搜索
    ItemListLeftHeaderViewStyleCleanBt,//清空
    ItemListLeftHeaderViewStyleSearchBt,//搜索
    ItemListLeftHeaderViewStyleYujiJiaocheStartBt,//预计交车起始
    ItemListLeftHeaderViewStyleYujiJiaocheEndbt,//预计交车结束
    ItemListLeftHeaderViewStyleTodayJiaoBt,//今日交bt
    ItemListLeftHeaderViewStyleOverduejiaoBt,//过期交bt
};


typedef void(^ItemListLeftHeaderViewBlock)(ItemListLeftHeaderViewStyle,UIButton *);
@interface ItemListLeftHeaderView : UIView

//VIN TF
@property (weak, nonatomic) IBOutlet UITextField *VINSearchTF;
//进度搜索TF
@property (weak, nonatomic) IBOutlet UITextField *progressTF;
//进度搜索Bt
@property (weak, nonatomic) IBOutlet UIButton *progressSearchBt;
//搜索Bt
@property (weak, nonatomic) IBOutlet UIButton *searchBt;
//清空Bt
@property (weak, nonatomic) IBOutlet UIButton *cleanBt;

//起始时间TF
@property (weak, nonatomic) IBOutlet UITextField *TimeSearchTF;
//起始时间搜索Bt
@property (weak, nonatomic) IBOutlet UIButton *timeSearchBt;
//起始时间按钮bg
@property (weak, nonatomic) IBOutlet UIButton *timeBtbg;

//终止时间TF
@property (weak, nonatomic) IBOutlet UITextField *endTimeSearchTF;
//终止时间Bt
@property (weak, nonatomic) IBOutlet UIButton *endTimeSearchBt;
//终止时间按钮bg
@property (weak, nonatomic) IBOutlet UIButton *endTimebtbg;

//预计交车时间起始TF
@property (weak, nonatomic) IBOutlet UITextField *yujijiaocheStartTF;
//预计交车时间起始搜索button
@property (weak, nonatomic) IBOutlet UIButton *yujijiaocheStartSearchBtn;
//预计交车时间起始button
@property (weak, nonatomic) IBOutlet UIButton *yujijiaocheStartBtn;

//预计交车时间结束TF
@property (weak, nonatomic) IBOutlet UITextField *yujijiaocheEndTF;
//预计交车时间结束搜索button
@property (weak, nonatomic) IBOutlet UIButton *yujijiaocheEndSearchBtn;
//预计交车时间结束button
@property (weak, nonatomic) IBOutlet UIButton *yujijiaocheEndBtn;



//VIN TF、进度搜索TF、起始时间TF、终止时间TF、预计交车时间起始TF、预计交车时间结束TF，输入框合集，便于样式操作
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *tixtFieldArray;

//今日背景图片
@property (weak, nonatomic) IBOutlet UIImageView *todayimageView;
//本周背景图
@property (weak, nonatomic) IBOutlet UIImageView *thisWeekImageView;
//今日交背景图
@property (weak, nonatomic) IBOutlet UIImageView *todayJiaoImageView;
//过期交背景图
@property (weak, nonatomic) IBOutlet UIImageView *overdueJiaoImageView;

//今日Bt
@property (weak, nonatomic) IBOutlet UIButton *todayBt;
//本周Bt
@property (weak, nonatomic) IBOutlet UIButton *thisWeekBt;
//今日交Bt
@property (weak, nonatomic) IBOutlet UIButton *todayJiaoBt;
//过期交bt
@property (weak, nonatomic) IBOutlet UIButton *overdueJiaoBt;
//今日、本周、今日交、过期交，按钮合集，便于样式操作
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *littleBtArray;

//今日交数量
@property (weak, nonatomic) IBOutlet UILabel *todayJiaoNumberLabel;
//过期交数量
@property (weak, nonatomic) IBOutlet UILabel *overdueJiaoNumberLabel;
//今日交、过期交，集合，便于样式操作
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *numberLabelArray;


@property (nonatomic, copy) ItemListLeftHeaderViewBlock itemListLeftHeaderViewBlock;

- (instancetype)initWithCustomFrame:(CGRect)frame;


//进度按钮事件
- (IBAction)progressBtAction:(UIButton *)sender;
//搜索按钮事件
- (IBAction)searchBtAction:(UIButton *)sender;
//清空按钮事件
- (IBAction)cleanBtAction:(UIButton *)sender;
//截止时间开始按钮事件
- (IBAction)timeBtAction:(UIButton *)sender;
//截止时间结束按钮事件
- (IBAction)endTimeSearchBtAction:(UIButton *)sender;
//今日按钮事件
- (IBAction)todayBtAction:(UIButton *)sender;
//本周按钮事件
- (IBAction)thisWeekBtAction:(UIButton *)sender;
//预计交车时间开始按钮事件
- (IBAction)yujiJiaocheStartSearchBtAction:(UIButton *)sender;
//预计交车时间结束按钮事件
- (IBAction)yujiJiaocheEndSearchBtAction:(UIButton *)sender;
//今日交按钮事件
- (IBAction)todayJiaoBtAction:(UIButton *)sender;
//过期交按钮事件
- (IBAction)overdueJiaoBtAction:(UIButton *)sender;

//设置默认样式（今日、本周、今日交、过期交）
- (void)setLittleBtNormalStyleWithButton:(UIButton *)button withImageView:(UIImageView *)imageView;
//设置选中的样式（今日、本周、今日交、过期交）
- (void)setLittleBtSelectStyleWithButton:(UIButton *)button withImageView:(UIImageView *)imageView;
- (void)cleanTF;
- (void)cleanAllContent;
@end
