//
//  HDRightDateChooseView.m
//  HandleiPad
//
//  Created by handou on 16/10/6.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDRightDateChooseView.h"
#import "HWDateHelper.h"


@interface HDRightDateChooseView ()<UIPickerViewDelegate,UIPickerViewDataSource>


@end

@implementation HDRightDateChooseView


- (void)dealloc {
    
    NSLog(@"HDRightDateChooseView.dealloc");
}

+ (instancetype)getCustomFrame:(CGRect)frame {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDRightDateChooseView" owner:nil options:nil];
    HDRightDateChooseView *view = [array objectAtIndex:0];
    view.frame = frame;
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
//    [view setdefaultWeekDayAndAMPM:[NSDate date]];
    

    view.auxiliaryView.layer.masksToBounds = YES;
    view.auxiliaryView.layer.cornerRadius = 5;
    view.datePickerView.minimumDate = [HWDateHelper getLastYearFromNowWithNumber:20];
    view.islimit = NO;
    
    return view;
}

#pragma mark  ------dataSource------

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// returns the # of rows in each component..
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    if ([pickerView isEqual:_weekPickerView]) {
//        return 7;
//    }else if ([pickerView isEqual:_AMAndPMPickerView]){
//        return 2;
//    }
//    return 0;
//}

#pragma mark  ------delegate------


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 32;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if ([pickerView isEqual:_weekPickerView]) {
//        switch (row) {
//            case 0:
//                return @"星期日";
//                break;
//            case 1:
//                return @"星期一";
//                
//                break;
//            case 2:
//                return @"星期二";
//                
//                break;
//            case 3:
//                return @"星期三";
//                
//                break;
//            case 4:
//                return @"星期四";
//                
//                break;
//            case 5:
//                return @"星期五";
//                
//                break;
//            case 6:
//                return @"星期六";
//                
//                break;
//                
//            default:
//                return nil;
//                break;
//        }
//        
//    }else if ([pickerView isEqual:_AMAndPMPickerView]) {
//        switch (row) {
//            case 0:
//                return @"上午";
//                break;
//            case 1:
//                return @"下午";
//                break;
//            default:
//                return nil;
//                break;
//        }
//    }
//    return nil;
//}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    if ([pickerView isEqual:_weekPickerView]) {
//        self.datePickerView.date = self.dateArray[row];
//    }
//}

- (IBAction)cancelBtAction:(UIButton *)sender {
    
    if (self.hDRightDateChooseViewBlock) {
        self.hDRightDateChooseViewBlock(_chooseViewStyle,nil);
    }
    
}

- (IBAction)saveBtAction:(UIButton *)sender {
    if (self.hDRightDateChooseViewBlock) {
        self.hDRightDateChooseViewBlock(_chooseViewStyle,[self getEndDateString]);
    }
}

- (IBAction)datePickerViewValueChanged:(UIDatePicker *)sender {
    
    if (_islimit) {
        NSDate *date = [NSDate date];
        if (sender.date.timeIntervalSince1970 < date.timeIntervalSince1970) {
            sender.date = date;
        }
    }

}

//- (void)setdefaultWeekDayAndAMPM:(NSDate *)date {
//    
//    NSInteger weekDay = [HWDateHelper weekDay:date];
//    
//    [self.weekPickerView selectRow:weekDay - 1 inComponent:0 animated:YES];
//    
//}

- (NSMutableArray *)dateArray {
    if (!_dateArray) {
        _dateArray = [HWDateHelper getDateArrayFromDate:[NSDate date]];
    }
    return _dateArray;
}


//获取日期string(只要日期和星期)
- (NSString *)getEndDateString{
    //日期
    NSString *dateString =[[[HWDateHelper getPreTime: _datePickerView.date] componentsSeparatedByString:@" "] objectAtIndex:0];
    
    return dateString;
}

@end
