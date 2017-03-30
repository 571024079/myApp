//
//  HDLeftBillingDateChooseView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDLeftBillingDateChooseView.h"
#import "HWDateHelper.h"

@interface HDLeftBillingDateChooseView ()<UIPickerViewDelegate,UIPickerViewDataSource>

//保存传递进来的时间
@property (nonatomic, strong) NSDate *passDate;

@end

@implementation HDLeftBillingDateChooseView

- (void)dealloc {
    
    NSLog(@"HDLeftBillingDateChooseView.dealloc");
}

//添加方法获取传进来的时间，不是当前的时间
+ (instancetype)getCustomFrame:(CGRect)frame withDate:(NSDate *)date {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDLeftBillingDateChooseView" owner:nil options:nil];
    HDLeftBillingDateChooseView *view = [array objectAtIndex:0];
    
    view.frame = frame;
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.auxiliaryView.layer.masksToBounds = YES;
    if (date) {
        [view setdefaultWeekDayAndAMPM:date];
        view.passDate = date;
        view.datePickerView.date = date;

    }else {
        [view setdefaultWeekDayAndAMPM:[NSDate date]];
        view.passDate = nil;
    }
    
    view.auxiliaryView.layer.cornerRadius = 5;
    
    return view;
}

- (void)setInputDate:(NSDate *)inputDate {
    _inputDate = inputDate;
    if (_inputDate) {
        [self setdefaultWeekDayAndAMPM:_inputDate];
        self.passDate = _inputDate;
        self.datePickerView.date = _inputDate;
    }
}

+ (instancetype)getCustomFrame:(CGRect)frame {
    
     return [HDLeftBillingDateChooseView getCustomFrame:frame withDate:nil];
}

#pragma mark  ------dataSource------

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:_weekPickerView]) {
        return 7;
    }else if ([pickerView isEqual:_AMAndPMPickerView]){
        return 2;
    }
    return 0;
}

#pragma mark  ------delegate------


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 32;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:self.weekPickerView]) {
        NSDate *temp = self.dateArray[row];
        if (self.passDate) {
            if (self.chooseViewStyle == HDLeftBillingDateChooseViewStyleTimeEnd) {
                
                if (![NSDate compareOneDate:temp withTwoDate:self.passDate]) {
                    self.datePickerView.date = self.passDate;
                    [self setdefaultWeekDayAndAMPM:self.datePickerView.date];
                }else {
                    self.datePickerView.date = temp;
                }
                
            }else if (self.chooseViewStyle == HDLeftBillingDateChooseViewStyleTimeBegin) {
                if ([NSDate compareOneDate:temp withTwoDate:self.passDate]) {
                    self.datePickerView.date = self.passDate;
                    [self setdefaultWeekDayAndAMPM:self.datePickerView.date];
                }else {
                    self.datePickerView.date = temp;
                }
            }
        }else {
            
            self.datePickerView.date = temp;
        }
    }else if ([pickerView isEqual:self.AMAndPMPickerView]) {
        if (self.passDate) {
            NSNumber *resultCompare = [NSDate compareAndReturnWithOneDate:self.datePickerView.date withTwoDate:self.passDate];
            NSInteger lastHour = [HWDateHelper hour:self.passDate];
            if (self.chooseViewStyle == HDLeftBillingDateChooseViewStyleTimeEnd) {
                //先判断是不是当天
                if ([resultCompare integerValue] == 2) {
                    if (row == 0 && lastHour == 12) {
                        [self setdefaultWeekDayAndAMPM:self.datePickerView.date];
                    }
                    
                }
            }else if (self.chooseViewStyle == HDLeftBillingDateChooseViewStyleTimeBegin) {
                //先判断是不是当天
                if ([resultCompare integerValue] == 2) {
                    if (row == 1 && lastHour == 0) {
                        [self setdefaultWeekDayAndAMPM:self.datePickerView.date];
                    }
                }
            }
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:_weekPickerView]) {
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
    
    }else if ([pickerView isEqual:_AMAndPMPickerView]) {
        switch (row) {
            case 0:
                return @"上午";
                break;
            case 1:
                return @"下午";
                break;
            default:
                return nil;
                break;
        }
    }
    return nil;
}



- (IBAction)cancelBtAction:(UIButton *)sender {
    
    if (self.hDLeftBillingDateChooseViewBlock) {
        self.hDLeftBillingDateChooseViewBlock(_chooseViewStyle,nil);
    }
    
}

- (IBAction)saveBtAction:(UIButton *)sender {
    if (self.hDLeftBillingDateChooseViewBlock) {
        self.hDLeftBillingDateChooseViewBlock(_chooseViewStyle,[self getEndDateString]);
    }
}

- (IBAction)satePickerViewValueChanged:(UIDatePicker *)sender {
    if (self.passDate) {
        if (self.chooseViewStyle == HDLeftBillingDateChooseViewStyleTimeEnd) {
            
            if (![NSDate compareOneDate:sender.date withTwoDate:self.passDate]) {
                sender.date = self.passDate;
            }
            
        }else if (self.chooseViewStyle == HDLeftBillingDateChooseViewStyleTimeBegin) {
            if ([NSDate compareOneDate:sender.date withTwoDate:self.passDate]) {
                sender.date = self.passDate;
            }
        }
    }
//    else {
        [self.dateArray removeAllObjects];
        
        [self setdefaultWeekDayAndAMPM:sender.date];
        
        self.dateArray = [HWDateHelper getDateArrayFromDate:sender.date];
//    }
}

- (void)setdefaultWeekDayAndAMPM:(NSDate *)date {
    
    NSInteger weekDay = [HWDateHelper weekDay:date];
    
    [self.weekPickerView selectRow:weekDay - 1 inComponent:0 animated:YES];
    
    NSInteger hour = [HWDateHelper hour:date];
    
    if (hour >= 12) {
        [self.AMAndPMPickerView selectRow:1 inComponent:0 animated:YES];
    }else {
        [self.AMAndPMPickerView selectRow:0 inComponent:0 animated:YES];
        
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
    NSString *dateString =[[[HWDateHelper getPreTime:_datePickerView.date] componentsSeparatedByString:@" "] objectAtIndex:0];
    //    //时间
    //    NSString *timeString = [[[HWDateHelper getPreTime:selfWeak.datePickerView.bilingTimePicker.date]componentsSeparatedByString:@" "] objectAtIndex:1];
    //AM,PM
    NSInteger row =  [_AMAndPMPickerView selectedRowInComponent:0];
    
    NSString *string;
    if (row == 0) {
        string = @"AM";
    }else {
        string = @"PM";
    }
    
    //合成
    NSString *endString = [dateString stringByAppendingString:[NSString stringWithFormat:@" %@",string]];
    
    return endString;
}

@end
