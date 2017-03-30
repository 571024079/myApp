//
//  HDStoreInfoManager.m
//  HandleiPad
//
//  Created by Handlecar on 16/11/15.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDStoreInfoManager.h"
#import "JPUSHService.h"

@implementation HDStoreInfoManager
+ (instancetype)shareManager
{
    static HDStoreInfoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HDStoreInfoManager alloc] init];
    });
    return manager;
}

- (void)cleanData {
    _carorderid = nil;
    _carplate = nil;
    _plateplace = nil;
}

- (void)setAlias
{
    // 注册别名
    NSString *alias = [NSString stringWithFormat:@"%@_user_alias_%@",self.storeid,self.userid];
    [JPUSHService setTags:nil alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"别名回调");
    }];
//    [JPUSHService setAlias:alias callbackSelector:@selector(aliasCallBack:) object:self];
}


@end
