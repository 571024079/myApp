//
//  PorscheUserTool.m
//  HandleiPad
//
//  Created by Robin on 16/11/16.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheUserTool.h"

@implementation PorscheUserTool

+ (void)saveUserName:(NSString *)username password:(NSString *)password {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *userinfo;
    if ([userDefaults objectForKey:@"userinfo"]) {
        userinfo = [[NSMutableDictionary alloc] initWithDictionary:[userDefaults objectForKey:@"userinfo"]];
    } else {
        
        userinfo = [[NSMutableDictionary alloc] init];
    }
    [userinfo setObject:password forKey:username];
    [userinfo setObject:username forKey:@"lastLoginUserName"];
    //保存数据 用户信息；用户名；用户密码
    [userDefaults setObject:userinfo  forKey:@"userinfo" ];
//    userDefaults
    [userDefaults synchronize];
};

+ (NSDictionary *)getUserInfo {
    
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
    
    NSString *username = [userinfo objectForKey:@"lastLoginUserName"];
    NSString *password = [userinfo objectForKey:username];

    if (!username) {
        username = @"";
        password = @"";
    }
    
    NSDictionary *lastUserInfo = @{@"username":username,
                                   @"password":password};
    return lastUserInfo;
}

+ (void)removePasswordWith:(NSString *)username {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:username];
}

+ (void)removeUserNameWith:(NSString *)username {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:username];
}

+ (void)setUserLogined:(BOOL)logined {
    
    [[NSUserDefaults standardUserDefaults] setObject:@(logined) forKey:@"userLogined"];
}

+ (BOOL)userLogined {
    
    NSNumber *loginedNum = [[NSUserDefaults standardUserDefaults] valueForKey:@"userLogined"];
    BOOL logined = [loginedNum boolValue];
    
    BOOL password = ![[[PorscheUserTool getUserInfo] objectForKey:@"password"] isEqualToString:@""];
    return logined && password;
}

@end
