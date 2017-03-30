//
//  NSDate+HD.m
//  Handlecar
//
//  Created by liuzhaoxu on 14-7-25.
//  Copyright (c) 2014年 HanDou. All rights reserved.
//

#import "NSDate+HD.h"

@implementation NSDate (HD)

- (NSString*)stringWithSecondAccuracy
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

- (NSString*)stringWithMinuteAccuracy
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

- (NSString*)stringWithDayAccuracy
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

- (NSString*)convertToString:(NSString*)aFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:aFormat];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

- (NSString *)caculateCurrentWeek
{
    NSString *current = [self convertToString:@"EEE"];
    NSTimeInterval interval = 0;
    if ([current isEqualToString:@"Mon"] || [current isEqualToString:@"周一"]) {
        interval = 0;
    }
    else if ([current isEqualToString:@"Tue"] || [current isEqualToString:@"周二"])
    {
        interval = 2*24*60*60;
    }
    else if ([current isEqualToString:@"Wed"] || [current isEqualToString:@"周三"])
    {
        interval = 3*24*60*60;
    }
    else if ([current isEqualToString:@"Thu"] || [current isEqualToString:@"周四"])
    {
        interval = 4*24*60*60;
    }
    else if ([current isEqualToString:@"Fri"] || [current isEqualToString:@"周五"])
    {
        interval = 5*24*60*60;
    }
    else if ([current isEqualToString:@"Sat"] || [current isEqualToString:@"周六"])
    {
        interval = 6*24*60*60;
    }
    else if ([current isEqualToString:@"Sun"] || [current isEqualToString:@"周日"])
    {
        interval = 7*24*60*60;
    }
    
    NSTimeInterval since1970 = [self timeIntervalSince1970];
    
    
    NSString *startTime = [[NSDate dateWithTimeIntervalSince1970:since1970 - interval] convertToString:@"yyyy-MM-dd"];
    
    return startTime;
}

- (NSString *)caculateCurrentMouth
{
    NSString *startTime = [self convertToString:@"yyyy-MM"];
    
    startTime = [startTime stringByAppendingString:@"-01"];
    
    return startTime;
}

- (NSString *)caculateCurrentQuarter
{
    NSString *currentMouth = [self convertToString:@"MM"];
    NSString *needAppendString = @"";
    switch ([currentMouth intValue]) {
        case 1:
        case 2:
        case 3:
            needAppendString = @"-01-01";
            break;
        case 4:
        case 5:
        case 6:
            needAppendString = @"-04-01";
            break;
        case 7:
        case 8:
        case 9:
            needAppendString = @"-07-01";
            break;
        case 10:
        case 11:
        case 12:
            needAppendString = @"-10-01";
            break;
        default:
            break;
    }
    NSString *startTime = [self convertToString:@"yyyy"];
    startTime = [startTime stringByAppendingString:needAppendString];
    return startTime;
}

- (NSString *)caculateCurrentHalfYear
{
    NSString *currentMouth = [self convertToString:@"MM"];
    NSString *needAppendString = @"";
    switch ([currentMouth intValue]) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
            needAppendString = @"-01-01";
            break;
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
            needAppendString = @"-07-01";
            break;
        default:
            break;
    }
    
    NSString *startTime = [self convertToString:@"yyyy"];
    startTime = [startTime stringByAppendingString:needAppendString];
    return startTime;
}

- (NSString *)caculateCurrentYear
{
    NSString *startTime = [self convertToString:@"yyyy"];
    
    startTime = [startTime stringByAppendingString:@"-01-01"];
    
    return startTime;
}
- (NSString*)stringWithMinuteAccuracyForChinese
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}


//比较两个时间的大小(第一个是否大于第二个)
+ (BOOL)compareOneDate:(NSDate *)oneDate withTwoDate:(NSDate *)twoDate {

//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
////    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *oneDayStr = [dateFormatter stringFromDate:oneDate];
//    NSString *anotherDayStr = [dateFormatter stringFromDate:twoDate];
//    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
//    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
//    NSComparisonResult result = [dateA compare:dateB];
//    if (result == NSOrderedDescending) {
//        //NSLog(@"oneDay  is in the future");
//        return YES;;
//    }
//    else if (result == NSOrderedAscending){
//        //NSLog(@"oneDay is in the past");
//    }
//    //NSLog(@"Both dates are the same");
//    return NO;
    
    NSNumber *result = [self compareAndReturnWithOneDate:oneDate withTwoDate:twoDate];
    if ([result integerValue] != 1) {
        return NO;
    }else {
        return YES;
    }
}
//比较两个时间的大小(第一个是否大于第二个)返回值使用  0 第一个小于第二个    1 第一个大于第二个   2 相等
+ (NSNumber *)compareAndReturnWithOneDate:(NSDate *)oneDate withTwoDate:(NSDate *)twoDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDate];
    NSString *anotherDayStr = [dateFormatter stringFromDate:twoDate];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //NSLog(@"oneDay  is in the future");
        return @1;;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"oneDay is in the past");
        return @0;
    }
    else {
        //NSLog(@"Both dates are the same");
        return @2;
    }
}

//将字符串转换成NSDate
+ (NSDate *)stringToDateWithString:(NSString *)timeStr {
    NSString *tempString1 = [NSString removerTimeStrAMPMWithTime:timeStr];
    NSString *tempString2 = [NSString getStringForYearAndTime:tempString1];
    NSDateFormatter *inputForM = [[NSDateFormatter alloc] init];
    [inputForM setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputForM setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [inputForM dateFromString:tempString2];
    
    return date;
}

+ (NSString *)currentSSS
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +SSS"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;

}

@end
