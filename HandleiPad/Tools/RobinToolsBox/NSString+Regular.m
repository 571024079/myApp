//
//  NSString+Regular.m
//  HandleiPad
//
//  Created by Robin on 2016/11/28.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "NSString+Regular.h"

@implementation NSString (Regular)

- (BOOL)validateNumber
{
    NSString* number=@"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:self];
}


@end
