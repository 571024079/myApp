//
//  NSString+moneyFormatter.m
//  HandleiPad
//
//  Created by Robin on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "NSString+moneyFormatter.h"

@implementation NSString (moneyFormatter)
/*
 numberFormatter == 12,345,678.89
 numberFormatter == 12,345,678.89
 numberFormatter == $12,345,678.89
 numberFormatter == 1,234,567,889%
 numberFormatter == 1.234567889E7
 numberFormatter == twelve million three hundred forty-five thousand six hundred seventy-eight point eight nine
 numberFormatter == 12,345,679th
 numberFormatter == 3,429:21:19
 numberFormatter == USD12,345,678.89
 numberFormatter == 12,345,678.89 US dollars
 */

+ (NSString *)formatMoneyStringWithFloat:(CGFloat)maney {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle =kCFNumberFormatterCurrencyStyle;
    NSString *newAmount = [formatter stringFromNumber:[NSNumber numberWithFloat:maney]];
    newAmount = [newAmount stringByReplacingOccurrencesOfString:@"$" withString:@"￥"];
    return newAmount;
}


+ (NSString *)formatMoneyStringWithMilesFloat:(CGFloat)miles {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle =kCFNumberFormatterDecimalStyle;
    NSString *newAmount = [formatter stringFromNumber:[NSNumber numberWithFloat:miles]];
    newAmount = [newAmount stringByReplacingOccurrencesOfString:@"$" withString:@"￥"];
    return newAmount;
}

@end
