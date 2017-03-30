//
//  ItemListLeftHeaderView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ItemListLeftHeaderView.h"
#import "HWDateHelper.h"

@interface ItemListLeftHeaderView ()<UITextFieldDelegate>


@end

@implementation ItemListLeftHeaderView

- (void)dealloc {
    self.TimeSearchTF.delegate = nil;
    self.progressTF.delegate = nil;
    self.endTimeSearchTF.delegate = nil;
    self.VINSearchTF.delegate = nil;
    self.yujijiaocheStartTF.delegate = nil;
    self.yujijiaocheEndTF.delegate = nil;
}

- (instancetype)initWithCustomFrame:(CGRect)frame {
        
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ItemListLeftHeaderView" owner:self options:nil];
    self.frame = frame;
    self = [array objectAtIndex:0];
    
    self.TimeSearchTF.delegate = self;
    self.progressTF.delegate = self;
    self.endTimeSearchTF.delegate = self;
    self.VINSearchTF.delegate = self;
    self.yujijiaocheStartTF.delegate = self;
    self.yujijiaocheEndTF.delegate = self;
    
    //设置数量label的样式
    for (UILabel *label in _numberLabelArray) {
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 5;
    }
    //输入框的样式
    for (UITextField *textField in _tixtFieldArray) {
        [AlertViewHelpers setupCellTFView:textField save:NO];
    }
    //设置button的样式
    for (UIButton *btn in _littleBtArray) {
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    //默认选中今日
//    [self todayBtAction:_todayBt];
    
    return self;
}



- (IBAction)timeBtAction:(UIButton *)sender {
    [self.superview resignFirstResponder];

    if (self.itemListLeftHeaderViewBlock) {
        self.itemListLeftHeaderViewBlock(ItemListLeftHeaderViewStyleTimeBt,sender);
    }
}

- (IBAction)endTimeSearchBtAction:(UIButton *)sender {
    [self.superview resignFirstResponder];

    if (self.itemListLeftHeaderViewBlock) {
        self.itemListLeftHeaderViewBlock(ItemListLeftHeaderViewStyleEndTimeBt,sender);
    }

}

- (IBAction)todayBtAction:(UIButton *)sender {
    [self.superview resignFirstResponder];
    
    _yujijiaocheStartTF.text = @"";
    _yujijiaocheEndTF.text = @"";

    [self setLittleBtNormalStyleWithButton:_thisWeekBt withImageView:_thisWeekImageView];
    [self setLittleBtSelectStyleWithButton:_todayBt withImageView:_todayimageView];
    
    [self setLittleBtNormalStyleWithButton:_todayJiaoBt withImageView:_todayJiaoImageView];
    [self setLittleBtNormalStyleWithButton:_overdueJiaoBt withImageView:_overdueJiaoImageView];
    
    // 点击了今日按钮之后，前面的时间选择显示改变
    NSString *time = [HWDateHelper getStringOfCurrentNotHourDate:[NSDate date]];
    self.TimeSearchTF.text = [NSString stringWithFormat:@"%@ AM", time];
    self.endTimeSearchTF.text = [NSString stringWithFormat:@"%@ PM", time];
    
    if (self.itemListLeftHeaderViewBlock) {
        self.itemListLeftHeaderViewBlock(ItemListLeftHeaderViewStyleTodayBt,sender);
    }

}
//本周
- (IBAction)thisWeekBtAction:(UIButton *)sender {
    [self.superview resignFirstResponder];
    
    _yujijiaocheStartTF.text = @"";
    _yujijiaocheEndTF.text = @"";
    
    [self setLittleBtNormalStyleWithButton:_todayBt withImageView:_todayimageView];
    [self setLittleBtSelectStyleWithButton:_thisWeekBt withImageView:_thisWeekImageView];
    
    [self setLittleBtNormalStyleWithButton:_todayJiaoBt withImageView:_todayJiaoImageView];
    [self setLittleBtNormalStyleWithButton:_overdueJiaoBt withImageView:_overdueJiaoImageView];

    // 点击了本周按钮之后，前面的时间选择显示改变
    NSMutableArray *timeArray = [HWDateHelper getDateArrayMondayFromDate:[NSDate date]];
    
    NSString *startTime = [HWDateHelper getStringOfCurrentNotHourDate:timeArray.firstObject];
    //17-02-03  czz 要求本周显示从周一到周日,不在显示周一到今天的日期
//    NSString *endTime = [HWDateHelper getStringOfCurrentNotHourDate:[NSDate date]];
    NSString *endTime = [HWDateHelper getStringOfCurrentNotHourDate:timeArray.lastObject];
    self.TimeSearchTF.text = [NSString stringWithFormat:@"%@ AM", startTime];
    self.endTimeSearchTF.text = [NSString stringWithFormat:@"%@ PM", endTime];
    
    if (self.itemListLeftHeaderViewBlock) {
        self.itemListLeftHeaderViewBlock(ItemListLeftHeaderViewStyleThisWeekBt,sender);
    }
}
//今日交按钮事件
- (IBAction)todayJiaoBtAction:(UIButton *)sender {
    [self.superview resignFirstResponder];
    
    _TimeSearchTF.text = @"";
    _endTimeSearchTF.text = @"";
    _yujijiaocheStartTF.text = @"";
    _yujijiaocheEndTF.text = @"";
    
    [self setLittleBtNormalStyleWithButton:_overdueJiaoBt withImageView:_overdueJiaoImageView];
    [self setLittleBtSelectStyleWithButton:_todayJiaoBt withImageView:_todayJiaoImageView];
    
    [self setLittleBtNormalStyleWithButton:_todayBt withImageView:_todayimageView];
    [self setLittleBtNormalStyleWithButton:_thisWeekBt withImageView:_thisWeekImageView];
    
    if (self.itemListLeftHeaderViewBlock) {
        self.itemListLeftHeaderViewBlock(ItemListLeftHeaderViewStyleTodayJiaoBt,sender);
    }
}
//过期交按钮事件
- (IBAction)overdueJiaoBtAction:(UIButton *)sender {
    [self.superview resignFirstResponder];
    
    _TimeSearchTF.text = @"";
    _endTimeSearchTF.text = @"";
    _yujijiaocheStartTF.text = @"";
    _yujijiaocheEndTF.text = @"";
    
    [self setLittleBtNormalStyleWithButton:_todayJiaoBt withImageView:_todayJiaoImageView];
    [self setLittleBtSelectStyleWithButton:_overdueJiaoBt withImageView:_overdueJiaoImageView];
    
    [self setLittleBtNormalStyleWithButton:_todayBt withImageView:_todayimageView];
    [self setLittleBtNormalStyleWithButton:_thisWeekBt withImageView:_thisWeekImageView];
    
    if (self.itemListLeftHeaderViewBlock) {
        self.itemListLeftHeaderViewBlock(ItemListLeftHeaderViewStyleOverduejiaoBt,sender);
    }
}

- (IBAction)progressBtAction:(UIButton *)sender {
    [self.superview resignFirstResponder];

    if (self.itemListLeftHeaderViewBlock) {
        self.itemListLeftHeaderViewBlock(ItemListLeftHeaderViewStyleProgressBt,sender);
    }
}
- (IBAction)searchBtAction:(UIButton *)sender {
    [self.superview resignFirstResponder];
    
    if (self.itemListLeftHeaderViewBlock) {
        self.itemListLeftHeaderViewBlock(ItemListLeftHeaderViewStyleSearchBt,sender);
    }
}
- (IBAction)yujiJiaocheStartSearchBtAction:(UIButton *)sender {
    [self.superview resignFirstResponder];
    
    if (self.itemListLeftHeaderViewBlock) {
        self.itemListLeftHeaderViewBlock(ItemListLeftHeaderViewStyleYujiJiaocheStartBt,sender);
    }
}
//预计交车时间结束按钮事件
- (IBAction)yujiJiaocheEndSearchBtAction:(UIButton *)sender {
    [self.superview resignFirstResponder];
    
    if (self.itemListLeftHeaderViewBlock) {
        self.itemListLeftHeaderViewBlock(ItemListLeftHeaderViewStyleYujiJiaocheEndbt,sender);
    }
}

- (IBAction)cleanBtAction:(UIButton *)sender {
    [self cleanAllContent];
    [self.superview resignFirstResponder];
    
    if (self.itemListLeftHeaderViewBlock) {
        self.itemListLeftHeaderViewBlock(ItemListLeftHeaderViewStyleCleanBt,sender);
    }
}

- (void)cleanAllContent
{
    //情况输入框内容
    
    [self cleanTF];
    //重置右侧按钮的样式
    for (UIButton *btn in _littleBtArray) {
        switch (btn.tag) {
            case 10001://今日
                [self setLittleBtNormalStyleWithButton:btn withImageView:_todayimageView];
                break;
            case 10002://本周
                [self setLittleBtNormalStyleWithButton:btn withImageView:_thisWeekImageView];
                break;
            case 10003://今日交
                [self setLittleBtNormalStyleWithButton:btn withImageView:_todayJiaoImageView];
                break;
            case 10004://过期交
                [self setLittleBtNormalStyleWithButton:btn withImageView:_overdueJiaoImageView];
                break;
            default:
                break;
        }
    }
}

- (void)cleanTF {
    _progressTF.text = @"";
    _VINSearchTF.text = @"";
    _TimeSearchTF.text = @"";
    _endTimeSearchTF.text = @"";
    _yujijiaocheStartTF.text = @"";
    _yujijiaocheEndTF.text = @"";
}


//设置默认样式（今日、本周、今日交、过期交）
- (void)setLittleBtNormalStyleWithButton:(UIButton *)button withImageView:(UIImageView *)imageView {
    imageView.image = [UIImage imageNamed:@""];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
}
//设置选中的样式（今日、本周、今日交、过期交）
- (void)setLittleBtSelectStyleWithButton:(UIButton *)button withImageView:(UIImageView *)imageView {
    imageView.image = [UIImage imageNamed:@"hd_work_list_clean.png"];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.layer.cornerRadius = 0;
    button.layer.borderWidth = 0;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == _VINSearchTF)
    {
        [self searchBtAction:nil];
    }
    
    return YES;
}

@end
