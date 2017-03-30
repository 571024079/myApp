//
//  HWDateHelper.h
//
//  Created by huwei_macmini1 on 16/3/18.
//  Copyright © 2016年 huwei123. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWDateHelper : NSObject


#pragma mark - date

+ (NSInteger)day:(NSDate *)date;


+ (NSInteger)month:(NSDate *)date;

+ (NSInteger)year:(NSDate *)date;

//+ (NSDate *)changeDateWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day;

//找到，一周第一天是周几
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;

+ (NSInteger)totaldaysInMonth:(NSDate *)date;

+ (NSDate *)lastMonth:(NSDate *)date;

+ (NSDate *)nextMonth:(NSDate *)date;

+ (NSDate *)lastDay:(NSDate *)date;

+ (NSDate *)nextDay:(NSDate *)date;

+ (NSInteger)weekDay:(NSDate *)date;

+ (NSInteger)hour:(NSDate *)date;

//获取当前日期2016-04-20 15:30
+ (NSString *)getStringOfCurrentDate:(NSDate *)date;
// yyyy-MM-dd HH:mm:ss a
+ (NSString *)getPreTime:(NSDate *)date;
// 2016-04-20
+ (NSString *)getStringOfCurrentNotHourDate:(NSDate *)date;

//获取当前日期 所在周的左右日期 起始位 原始周日

+ (NSMutableArray *)getDateArrayFromDate:(NSDate *)date;
//获取 当前周 所有日期 起始位 周一
+ (NSMutableArray *)getDateArrayMondayFromDate:(NSDate *)date;
//获取提前n年
+ (NSDate *)getLastYearFromNowWithNumber:(NSInteger)year;




@end
