//
//  HDPreCheckModel.m
//  HandleiPad
//
//  Created by 程凯 on 2017/3/3.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "HDPreCheckModel.h"

@implementation HDPreCheckModel

+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"needfiles" : [PreCheckFile class],
             @"otherservices" : [PreCheckOtherService class],
             @"tyres" : [PreCheckTyre class],
             @"step1" : [PreCheckItem class],
             @"step2" : [PreCheckItem class],
             @"step4" : [PreCheckItem class],
             @"step5" : [PreCheckItem class],
             @"paytypes" : [PreCheckPayType class]};
    
}


@end


/*
 所需文件model
 修改的时候传下面两个参数
 */
@implementation PreCheckFile


@end



/*
 所需服务model
 */
@implementation PreCheckOtherService


@end

/*
 付款方式model
 修改的时候传下面两个参数
 */
@implementation PreCheckPayType

@end


/*
 轮胎信息
 */
@implementation PreCheckTyre


@end



/*
 步骤信息
 */
@implementation PreCheckItem


@end
