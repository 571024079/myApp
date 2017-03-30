//
//  NSString+Line.h
//  HandleiPad
//
//  Created by Robin on 16/11/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Line)

/**
 给文字添加下划线

 @param string 要添加的文字
 @return
 */
+ (NSAttributedString *)addLineWithSting:(NSString *)string;

/**
 修改文字某段的字体大小

 @param string <#string description#>
 @param range <#range description#>
 @return <#return value description#>
 */
+ (NSAttributedString *)changeFontWithSting:(NSString *)string range:(NSRange *)range;



@end
