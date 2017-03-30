//
//  HDRightDateChooseView.h
//  HandleiPad
//
//  Created by handou on 16/10/6.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HDRightDateChooseViewStyle) {
    HDRightDateChooseViewStyleCancel = 1,// 取消
    HDRightDateChooseViewStyleSave,//保存
    HDRightDateChooseViewStyleBegin,//时间开始
    HDRightDateChooseViewStyleTimeEnd,//时间截止
};

typedef void(^HDRightDateChooseViewBlock)(HDRightDateChooseViewStyle,NSString *);

@interface HDRightDateChooseView : UIView
@property (nonatomic, copy) HDRightDateChooseViewBlock hDRightDateChooseViewBlock;
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
///****星期****/
//@property (weak, nonatomic) IBOutlet UIPickerView *weekPickerView;
///****上下午****/
//@property (weak, nonatomic) IBOutlet UIPickerView *AMAndPMPickerView;
/****辅助做圆角****/
@property (weak, nonatomic) IBOutlet UIView *auxiliaryView;

//区分是开始时间，还是截止时间
@property (nonatomic, assign) HDRightDateChooseViewStyle chooseViewStyle;

@property (nonatomic, assign) BOOL islimit;

//当前日期所在周的日期
@property (nonatomic, strong) NSMutableArray *dateArray;


- (IBAction)cancelBtAction:(UIButton *)sender;

- (IBAction)saveBtAction:(UIButton *)sender;

- (IBAction)datePickerViewValueChanged:(UIDatePicker *)sender;



+ (instancetype)getCustomFrame:(CGRect)frame;

- (NSString *)getEndDateString;
@end
