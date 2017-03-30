//
//  NSString+Additional.h
//  Handlecar
//
//  Created by liuzhaoxu on 14-8-22.
//  Copyright (c) 2014年 HanDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additional)

/*
 * Returns the MD5 value of the string
 */
- (NSString*)md5;

- (NSString *)convertFromFormat:(NSString *)aFormat toAnotherFormat:(NSString *)bFormat;

- (BOOL)checkRegularExpression:(NSString*)regular regularOptions:(NSRegularExpressionOptions)regularOptions matchOptions:(NSMatchingOptions)matchOptions;
-(id)JSONValue;

//添加底部下划线
- (NSMutableAttributedString *)changeToBottomLine;
//剔除0开头数字
- (NSString *)removeFirstZero;
//设置TF placeholder
- (NSAttributedString *)setTFplaceHolderWithMainGray;
//设置TF placeholder 颜色
- (NSAttributedString *)setTFplaceHolderWithMainGrayWithColor:(UIColor *)color;
//获取数字字符串
- (NSString *)getNumberString;
//去除空格和-
- (NSString *)getString;
//数字字符串转图号 000-00-00
- (NSString *)getCodeString;
//数字字符串转编号 000 000 000 00 000
- (NSString *)getCodeListString;
// 将2016-12-12 14:45类型->201612121445
+ (NSString *)getStringForYearAndTime:(NSString *)str;
// 去除时间中的AM PM
+ (NSString *)removerTimeStrAMPMWithTime:(NSString *)timeStr;
// 201612121445-->2016-12-12 14:45类型
+ (NSString *)getStringForAll:(NSString *)str;
@end
