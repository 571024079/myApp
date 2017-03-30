//
//  NSDate+HD.h
//  Handlecar
//
//  Created by liuzhaoxu on 14-7-25.
//  Copyright (c) 2014年 HanDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HD)

- (NSString*)stringWithSecondAccuracy;
- (NSString*)stringWithMinuteAccuracy;
- (NSString*)stringWithDayAccuracy;

- (NSString*)convertToString:(NSString*)aFormat;
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;


- (NSString *)caculateCurrentWeek;
- (NSString *)caculateCurrentMouth;
- (NSString *)caculateCurrentQuarter;
- (NSString *)caculateCurrentHalfYear;
- (NSString *)caculateCurrentYear;
- (NSString*)stringWithMinuteAccuracyForChinese;

//比较两个时间的大小(第一个是否大于第二个)
+ (BOOL)compareOneDate:(NSDate *)oneDate withTwoDate:(NSDate *)twoDate;
//比较两个时间的大小(第一个是否大于第二个)返回值使用  0 第一个小于第二个    1 第一个大于第二个   2 相等
+ (NSNumber *)compareAndReturnWithOneDate:(NSDate *)oneDate withTwoDate:(NSDate *)twoDate;
//将字符串转换成NSDate
+ (NSDate *)stringToDateWithString:(NSString *)timeStr;
+ (NSString *)currentSSS;
@end
