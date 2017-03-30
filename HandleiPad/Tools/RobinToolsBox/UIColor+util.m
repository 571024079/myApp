//
//  UIColor+util.m
//  HandleiPad//  Created by Handlecar on 2016/12/5.
//

//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "UIColor+util.h"

@implementation UIColor (util)

+ (NSDictionary *)getColorInfoWithColor:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    NSNumber *red = [NSNumber numberWithFloat:components[0]];
    NSNumber *green = [NSNumber numberWithFloat:components[1]];
    NSNumber *blue = [NSNumber numberWithFloat:components[2]];
    
    return @{@"red":red,@"green":green,@"blue":blue};
    
}

@end
