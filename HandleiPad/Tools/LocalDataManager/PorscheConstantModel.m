//
//  PorscheConstantModel.m
//  HandleiPad
//
//  Created by 岳小龙 on 2016/12/6.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheConstantModel.h"

@implementation PorscheConstantModel

+ (instancetype)constantAllModel
{
    PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
    model.cvsubid = @0;
    model.cvvaluedesc = @"全部";
    return model;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"children" : [PorscheSubConstant class]};
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"undefine %@",key);
}


@end

@implementation PorscheSubConstant


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"undefine %@",key);
}

+ (Class)transformedValueClass
{
    return [NSArray class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
