//
//  HDWorkListDateChooseView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDWorkListDateChooseViewStyle) {
    HDWorkListDateChooseViewStyleCancel = 1,// 取消
    HDWorkListDateChooseViewStyleSure,//确定
    
    HDWorkListDateChooseViewStyleTimeBegin,//起始时间
    HDWorkListDateChooseViewStyleTimeEnd,//截止时间
};

typedef void(^HDWorkListDateChooseViewBlock)(HDWorkListDateChooseViewStyle style,NSString *);

@interface HDWorkListDateChooseView : UIView

@property (nonatomic, copy) HDWorkListDateChooseViewBlock hDWorkListDateChooseViewBlock;

@property (nonatomic, assign) HDWorkListDateChooseViewStyle dateViewStyle;



@property (weak, nonatomic) IBOutlet UILabel *preTimeLb;

//日期
@property (weak, nonatomic) IBOutlet UIDatePicker *bilingDatePicker;
//自定义周
@property (weak, nonatomic) IBOutlet UIPickerView *bilingWeekPicker;
//时、分选择器
@property (weak, nonatomic) IBOutlet UIDatePicker *bilingTimePicker;

//辅助视图，用来切底部圆
@property (weak, nonatomic) IBOutlet UIView *auxiliaryView;

//背景图
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//时间选择器背景图
@property (weak, nonatomic) IBOutlet UIView *datePickerSuperView;

//当前日期所在周 的日期数组
@property (nonatomic, strong) NSMutableArray *dateArray;

@property (nonatomic, strong) NSDate *date;

- (IBAction)cancelBtAction:(UIButton *)sender;


- (IBAction)sureBtAction:(UIButton *)sender;

- (IBAction)datePickerChangeAction:(UIDatePicker *)sender;

- (IBAction)timePickerAction:(UIDatePicker *)sender;


+ (instancetype)getCustomFrame:(CGRect)frame;

- (NSString *)getEndDateString;






@end
