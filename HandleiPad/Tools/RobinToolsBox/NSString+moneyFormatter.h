//
//  NSString+moneyFormatter.h
//  HandleiPad
//
//  Created by Robin on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (moneyFormatter)

+ (NSString *)formatMoneyStringWithFloat:(CGFloat)maney;
+ (NSString *)formatMoneyStringWithMilesFloat:(CGFloat)miles;

@end
