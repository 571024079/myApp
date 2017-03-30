//
//  HDWorkListDateChooseView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDWorkListDateChooseView.h"
#import "HWDateHelper.h"
@interface HDWorkListDateChooseView ()<UIPickerViewDelegate,UIPickerViewDataSource>


@end

@implementation HDWorkListDateChooseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    NSLog(@"HDWorkListDateChooseView.dealloc");
}

+ (instancetype)getCustomFrame:(CGRect)frame {

    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDWorkListDateChooseView" owner:nil options:nil];
    HDWorkListDateChooseView *view = [array objectAtIndex:0];
    view.frame = frame;
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.auxiliaryView.layer.masksToBounds = YES;
    view.auxiliaryView.layer.cornerRadius = 5;
    
    NSDate *date = [NSDate date];
    view.date = date;
    view.bilingDatePicker.date = date;
    NSInteger integer = [HWDateHelper weekDay:date];
    
    [view.bilingWeekPicker selectRow:integer - 1 inComponent:0 animated:YES];
    
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [HD_FULLView endEditing:YES];
}

#pragma mark  ------dataSource------

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 7;
}

#pragma mark  ------delegate------

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    return 80;
//}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 32;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (row) {
        case 0:
            return @"星期日";
            break;
        case 1:
            return @"星期一";

            break;
        case 2:
            return @"星期二";

            break;
        case 3:
            return @"星期三";

            break;
        case 4:
            return @"星期四";

            break;
        case 5:
            return @"星期五";

            break;
        case 6:
            return @"星期六";

            break;
            
        default:
            return nil;
            break;
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDate *date = self.dateArray[row];
    NSDate *dateNow = [NSDate date];
    
    if (date.timeIntervalSince1970 < dateNow.timeIntervalSince1970) {
        date = dateNow;
    }
    
    self.bilingDatePicker.date = date;
    
    NSInteger weekDay = [HWDateHelper weekDay:date];
    
    [self.bilingWeekPicker selectRow:weekDay - 1 inComponent:0 animated:YES];
}

- (IBAction)cancelBtAction:(UIButton *)sender {
    if (self.hDWorkListDateChooseViewBlock) {
        self.hDWorkListDateChooseViewBlock(HDWorkListDateChooseViewStyleCancel,nil);
    }
}

- (IBAction)sureBtAction:(UIButton *)sender {
    if (self.hDWorkListDateChooseViewBlock) {
        self.hDWorkListDateChooseViewBlock(HDWorkListDateChooseViewStyleSure,[self getEndDateString]);
    }
}

#pragma mark  ------datePicker的值改变------

- (IBAction)datePickerChangeAction:(UIDatePicker *)sender {
    //日期不早于现在
    NSDate *date = [NSDate date];
    
    if (sender.date.timeIntervalSince1970 < date.timeIntervalSince1970) {
        sender.date = date;
        
        if (_bilingTimePicker.date.timeIntervalSince1970 < date.timeIntervalSince1970) {
            _bilingTimePicker.date = date;
        }
    }
    //NSLog(@"%ld",[HWDateHelper weekDay:self.bilingDatePicker.date]);
    
    [self.dateArray removeAllObjects];

    NSInteger weekDay = [HWDateHelper weekDay:sender.date];

    [self.bilingWeekPicker selectRow:weekDay - 1 inComponent:0 animated:YES];

    self.dateArray = [HWDateHelper getDateArrayFromDate:self.bilingDatePicker.date];
    
    
}

- (IBAction)timePickerAction:(UIDatePicker *)sender {
    //时间不早于现在
    NSDate *date = [NSDate date];
    if (!(_bilingDatePicker.date.timeIntervalSince1970 > date.timeIntervalSince1970)) {
        
        if (_bilingTimePicker.date.timeIntervalSince1970 <= self.date.timeIntervalSince1970) {
            if (sender.date.timeIntervalSince1970 <= self.date.timeIntervalSince1970) {
                sender.date = [NSDate date];
            }
        }
    }
    
}

- (NSMutableArray *)dateArray {
    if (!_dateArray) {
        _dateArray = [HWDateHelper getDateArrayFromDate:[NSDate date]];
    }
    return _dateArray;
}

//获取日期string
- (NSString *)getEndDateString {
    //日期
    NSString *dateString =[[[HWDateHelper getPreTime: _bilingDatePicker.date] componentsSeparatedByString:@" "] objectAtIndex:0];
    NSLog(@"_bilingDatePicker.data:%@",_bilingDatePicker.date);
    //时间
    NSString *timeString = [[[HWDateHelper getPreTime:_bilingTimePicker.date]componentsSeparatedByString:@" "] objectAtIndex:1];
    NSLog(@"_bilingTimePicker.date:%@",_bilingTimePicker.date);
    
    NSDate *date = [NSDate date];
    
    //AM,PM     (10-06去除AM/PM显示)
    //    NSString *AMString = [[[HWDateHelper getPreTime:selfWeak.dateView.bilingTimePicker.date]componentsSeparatedByString:@" "] objectAtIndex:2];
    //合成
    NSString *endString = [dateString stringByAppendingString:[NSString stringWithFormat:@" %@",timeString]];
    
    //与当前日期相比，预计交车时间应该是只能选择目前日期之后	
    if (_bilingDatePicker.date.timeIntervalSince1970 < self.date.timeIntervalSince1970) {
            endString = [self getEndStringWith:date];
    }else if (_bilingDatePicker.date.timeIntervalSince1970 == self.date.timeIntervalSince1970) {
        if (_bilingTimePicker.date.timeIntervalSince1970 <= date.timeIntervalSince1970) {
            endString = [self getEndStringWith:date];
        }
    }
    
    return endString;
}

- (NSString *)getEndStringWith:(NSDate *)date {
    NSString *dateString1 = [[[HWDateHelper getPreTime:date] componentsSeparatedByString:@" "] objectAtIndex:0];
    NSString *timeString1 = [[[HWDateHelper getPreTime:date] componentsSeparatedByString:@" "]objectAtIndex:1];
    NSString *endString = [dateString1 stringByAppendingString:[NSString stringWithFormat:@" %@",timeString1]];
    return endString;
}


@end
