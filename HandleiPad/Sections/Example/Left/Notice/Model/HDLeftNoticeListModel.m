//
//  HDLeftNoticeListModel.m
//  HandleiPad
//
//  Created by handlecar on 16/12/1.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDLeftNoticeListModel.h"

@implementation HDLeftNoticeListModel

+ (HDLeftNoticeListModel *)dataFormDic:(NSDictionary *)dic {
    HDLeftNoticeListModel *data = [[HDLeftNoticeListModel alloc] init];
    [data setValuesForKeysWithDictionary:dic];
    return data;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"forUndefinedKey-------:%@", key);
}

@end



@implementation HDLeftNoticeFanganModel
+ (HDLeftNoticeFanganModel *)dataFormDic:(NSDictionary *)dic {
    HDLeftNoticeFanganModel *data = [[HDLeftNoticeFanganModel alloc] init];
    [data setValuesForKeysWithDictionary:dic];
    return data;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"forUndefinedKey-------:%@", key);
}

@end
