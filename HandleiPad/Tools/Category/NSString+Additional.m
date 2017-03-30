//
//  NSString+Additional.m
//  Handlecar
//
//  Created by liuzhaoxu on 14-8-22.
//  Copyright (c) 2014年 HanDou. All rights reserved.
//

#import "NSString+Additional.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Additional)

- (NSString*)md5
{
	const char* string = [self UTF8String];
	unsigned char result[16];
	CC_MD5(string, (unsigned int)strlen(string), result);
	NSString* hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
					  result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
					  result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
	
	return [hash lowercaseString];
}

- (NSString *)convertFromFormat:(NSString *)aFormat toAnotherFormat:(NSString *)bFormat
{
    NSString *string;
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:aFormat];
    
    NSDate *date = [dateFormatter1 dateFromString:self];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:bFormat];
    
    string = [dateFormatter2 stringFromDate:date];
    
    if (string == nil || [self isEqualToString:@""]) {
        return @"";
    }
    
    return string;
}

- (BOOL)checkRegularExpression:(NSString*)regular regularOptions:(NSRegularExpressionOptions)regularOptions matchOptions:(NSMatchingOptions)matchOptions
{
    NSError* error = nil;
    NSRegularExpression* expression = [NSRegularExpression regularExpressionWithPattern:regular options:regularOptions error:&error];
    if (expression)
    {
        NSRange searchRange = NSMakeRange(0, [self length]);
        NSTextCheckingResult *firstMatch=[expression firstMatchInString:self options:matchOptions range:searchRange];
        if (firstMatch)
        {
            return YES;
        }
    }
    return NO;
}

-(id)JSONValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

- (NSMutableAttributedString *)changeToBottomLine {
    // 下划线
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self attributes:attribtDic];
    
    return attribtStr;
}

//剔除0开头数字
- (NSString *)removeFirstZero{
    
    NSString *text = self;
    do {
        if (text.length > 0 && [[text substringToIndex:1] isEqualToString:@"0"]) {
            if (text.length > 1) {
                text = [text substringFromIndex:1];
            }else {
                text = @"";
            }
        }
    } while (text.length > 0 && [[text substringToIndex:1] isEqualToString:@"0"]);
    
    return text;
}

//设置TF placeHolder
- (NSAttributedString *)setTFplaceHolderWithMainGray {
    return [self setTFplaceHolderWithMainGrayWithColor:Color(119, 119, 119)];
}

- (NSAttributedString *)setTFplaceHolderWithMainGrayWithColor:(UIColor *)color {
    NSString *string = self;
    if (!string) {
        string = @"";
    }
    return [[NSAttributedString alloc]initWithString:string attributes:@{NSForegroundColorAttributeName:color}];
}
//获取字符串中数字
- (NSString *)getNumberString{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    
    int number;
    [scanner scanInt:&number];
    NSString *num=[NSString stringWithFormat:@"%d",number];
    return num;
}
//去除空格和-
- (NSString *)getString {
    NSString *endString = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    endString = [endString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return endString;
}

//数字字符串转图号 000-00-00
- (NSString *)getCodeString {
    if (self.length > 3 &&self.length < 7) {
        return  [NSString stringWithFormat:@"%@-%@",[self substringToIndex:3],[self substringFromIndex:3]];
    }else if (self.length > 6) {
       return [NSString stringWithFormat:@"%@-%@-%@",[self substringToIndex:3],[self substringWithRange:NSMakeRange(3, 2)],[self substringFromIndex:5]];
    }else {
        return self;
    }
}
//数字字符串转编号 000 000 000 00 000
- (NSString *)getCodeListString {
    if (self.length > 13) {//正常编号14位
        return [NSString stringWithFormat:@"%@ %@ %@ %@ %@",[self substringToIndex:3],[self substringWithRange:NSMakeRange(3, 3)],[self substringWithRange:NSMakeRange(6, 3)],[self substringWithRange:NSMakeRange(9, 2)],[self substringFromIndex:11]];
    }
    
    return self;
}

// 将2016-12-12 14:45类型->201612121445
+ (NSString *)getStringForYearAndTime:(NSString *)str {
    NSString *tempStr = str;
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@":" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"AM" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"PM" withString:@""];
    
    if (!(tempStr.length > 8)) {
        tempStr = [tempStr convertFromFormat:@"yyyyMMdd" toAnotherFormat:@"yyyyMMddHHmmss"];
    }else if (!(tempStr.length > 12)) {
        tempStr = [tempStr convertFromFormat:@"yyyyMMddHHmm" toAnotherFormat:@"yyyyMMddHHmmss"];
    }
    return tempStr;
}
// 201612121445-->2016-12-12 14:45类型
+ (NSString *)getStringForAll:(NSString *)str {
    NSString *tempStr = str;
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@":" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"AM" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"PM" withString:@""];
    
    tempStr = [tempStr convertFromFormat:@"yyyyMMddHHmmss" toAnotherFormat:@"yyyy-MM-dd HH:mm"];
    return tempStr;
}
// 去除时间中的AM PM
+ (NSString *)removerTimeStrAMPMWithTime:(NSString *)timeStr {
    NSString *time = timeStr;
    if ([[timeStr substringFromIndex:timeStr.length - 3] containsString:@"M"]) {
        time = [timeStr substringWithRange:NSMakeRange(0, timeStr.length - 3)];
    }
    time = [time convertFromFormat:@"yyyy-MM-dd" toAnotherFormat:@"yyyyMMddHHmmss"];
    
    return time;
}


@end
