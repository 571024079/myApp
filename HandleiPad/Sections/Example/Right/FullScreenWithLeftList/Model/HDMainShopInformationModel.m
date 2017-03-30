//
//  HDMainShopInformationModel.m
//  HandleiPad
//
//  Created by handlecar on 16/12/8.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDMainShopInformationModel.h"

@implementation HDMainShopInformationModel
+ (HDMainShopInformationModel *)dataFormDic:(NSDictionary *)dic {
    HDMainShopInformationModel *data = [[HDMainShopInformationModel alloc] init];
    
    [data setValuesForKeysWithDictionary:dic];
    
    return data;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"forUndefinedKey======%@", key);
}

@end
