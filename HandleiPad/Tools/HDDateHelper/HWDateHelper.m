//
//  HWDateHelper.m
//
//  Created by huwei_macmini1 on 16/3/18.
//  Copyright © 2016年 huwei123. All rights reserved.
//

#import "HWDateHelper.h"

@implementation HWDateHelper

#pragma mark - date

+ (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


+ (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

+ (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

+ (NSInteger)weekDay:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | kCFCalendarUnitWeekday) fromDate:date];
    return [components weekday];
}



+ (NSInteger)hour:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | kCFCalendarUnitWeekday | NSCalendarUnitHour) fromDate:date];
    return [components hour];
}

+ (NSInteger)minute:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | kCFCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    return [components minute];
}

//找到，一周第一天是周几
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

+ (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

+ (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSDate *)lastDay:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSDate *)nextDay:(NSDate *)date; {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSString *)getStringOfCurrentDate:(NSDate *)date{
    
    NSString *dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",(long)[HWDateHelper year:date],(long)[HWDateHelper month:date],(long)[HWDateHelper day:date],(long)[HWDateHelper hour:date],(long)[HWDateHelper minute:date]];
    
    return dateString;
}

+ (NSString *)getPreTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss a"];
    NSString *ampm = [formatter stringFromDate:date];
    return ampm;
}

+ (NSString *)getStringOfCurrentNotHourDate:(NSDate *)date {
    NSString *dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)[HWDateHelper year:date],(long)[HWDateHelper month:date],(long)[HWDateHelper day:date]];
    
    return dateString;
}

+ (NSMutableArray *)getDateArrayFromDate:(NSDate *)date {
    NSMutableArray *array = [NSMutableArray array];
    NSInteger weekNumber = [HWDateHelper weekDay:date];
    NSDate * tmpDate = date;
    
    for (int i = 0; i < weekNumber - 1; i ++ ) {
        NSDate *dateNew = [HWDateHelper lastDay:date];
        date = dateNew;
        [array insertObject:dateNew atIndex:0];
    }
    [array addObject:tmpDate];
    
    for (int i = (int)weekNumber - 1; i < 6; i ++) {
        NSDate *dateNew = [HWDateHelper nextDay:tmpDate];
        tmpDate = dateNew;
        [array addObject:dateNew];
    }
    
    return array;
}

+ (NSMutableArray *)getDateArrayMondayFromDate:(NSDate *)date {
    NSMutableArray *array = [NSMutableArray array];
    NSInteger weekNumber = [HWDateHelper weekDay:date];
    NSDate * tmpDate = date;
    
    if (weekNumber == 1) {
        weekNumber = 7;
    }else {
        weekNumber = weekNumber - 1;
    }
    
    
    for (int i = 0; i < weekNumber - 1; i ++ ) {
        NSDate *dateNew = [HWDateHelper lastDay:date];
        date = dateNew;
        [array insertObject:dateNew atIndex:0];
    }
    [array addObject:tmpDate];
    
    for (int i = (int)weekNumber - 1; i < 6; i ++) {
        NSDate *dateNew = [HWDateHelper nextDay:tmpDate];
        tmpDate = dateNew;
        [array addObject:dateNew];
    }
    
    return array;
}

//获取提前n年
+ (NSDate *)getLastYearFromNowWithNumber:(NSInteger)year {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = -year;
    NSDate *date = [NSDate date];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


@end
