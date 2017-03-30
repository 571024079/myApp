//
//  HDLeftBillingDateChooseView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDLeftBillingDateChooseViewStyle) {
    HDLeftBillingDateChooseViewStyleCancel = 1,// 取消
    HDLeftBillingDateChooseViewStyleSave,//保存
    HDLeftBillingDateChooseViewStyleTimeBegin,//时间开始
    HDLeftBillingDateChooseViewStyleTimeEnd,//时间截止
};

typedef void(^HDLeftBillingDateChooseViewBlock)(HDLeftBillingDateChooseViewStyle,NSString *string);


@interface HDLeftBillingDateChooseView : UIView

@property (nonatomic, copy) HDLeftBillingDateChooseViewBlock hDLeftBillingDateChooseViewBlock;

/****背景图片****/
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
/****取消****/
@property (weak, nonatomic) IBOutlet UIButton *cancelBt;
/****标题****/
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLb;
/****存储****/
@property (weak, nonatomic) IBOutlet UIButton *saveBt;
/****日期****/
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
/****星期****/
@property (weak, nonatomic) IBOutlet UIPickerView *weekPickerView;
/****上下午****/
@property (weak, nonatomic) IBOutlet UIPickerView *AMAndPMPickerView;
/****辅助做圆角****/
@property (weak, nonatomic) IBOutlet UIView *auxiliaryView;

//传递进来的date
@property (nonatomic, strong) NSDate *inputDate;

//区分是开始时间，还是截止时间
@property (nonatomic, assign) HDLeftBillingDateChooseViewStyle chooseViewStyle;

@property (nonatomic, strong) NSMutableArray *dateArray;

- (IBAction)cancelBtAction:(UIButton *)sender;

- (IBAction)saveBtAction:(UIButton *)sender;

- (IBAction)satePickerViewValueChanged:(UIDatePicker *)sender;


//添加方法获取传进来的时间，不是当前的时间
+ (instancetype)getCustomFrame:(CGRect)frame withDate:(NSDate *)date;
+ (instancetype)getCustomFrame:(CGRect)frame;
//设置显示时间
- (void)setdefaultWeekDayAndAMPM:(NSDate *)date;
//输出数据
- (NSString *)getEndDateString;

@end
