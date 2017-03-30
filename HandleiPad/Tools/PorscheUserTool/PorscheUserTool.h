//
//  PorscheUserTool.h
//  HandleiPad
//
//  Created by Robin on 16/11/16.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PorscheUserTool : NSObject


/**
 保存用户信息

 @param username 用户名
 @param password 用户登陆密码
 */
+ (void)saveUserName:(NSString *)username password:(NSString *)password;


/**
 获取用户信息

 @return 返回一个包含用户账号密码的字典 --> @{@"username":@"admin",@"password":@"111111"}
 */
+ (NSDictionary *)getUserInfo;

/**
 移除用户密码

 @param username 要移除的用户名
 */
+ (void)removePasswordWith:(NSString *)username;

/**
 移除用户名

 @param username 要移除的用户名
 */
+ (void)removeUserNameWith:(NSString *)username;

/**
 设置用户登录状态

 @param logined 是否登录
 */
+ (void)setUserLogined:(BOOL)logined;

/**
 获取用户登陆状态(如果没有记住密码返回NO)

 @return 是否已登录
 */
+ (BOOL)userLogined;

@end
