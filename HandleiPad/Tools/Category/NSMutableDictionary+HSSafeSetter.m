//
//  NSMutableDictionary+HSSafeSetter.m
//  Navigator
//
//  Created by Cheney Lau on 24/09/2013.
//  Copyright (c) 2013 Hibu. All rights reserved.
//

#import "NSMutableDictionary+HSSafeSetter.h"

@implementation NSMutableDictionary (HSSafeSetter)

- (void)hs_setSafeValue:(id)value forKey:(NSString*)key
{
    if(value != nil && key != nil)
    {
        [self setValue:value forKey:key];
    }
}

- (void)hs_setSafeEmptyValue:(id)value forKey:(NSString*)key
{
    if(![value isEqual:@""])
    {
        [self hs_setSafeValue:value forKey:key];
    }
}

- (void)hs_setSafeValue:(id)value withDefault:(id)defaultForUnsafeValues forKey:(NSString*)key
{
    NSParameterAssert(defaultForUnsafeValues);
    [self setValue:value ? value : defaultForUnsafeValues forKey:key];
}

@end
