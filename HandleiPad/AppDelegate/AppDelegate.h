//
//  AppDelegate.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/8/30.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PorscheEnterViewControllerType) {
    
    PorscheEnterViewControllerTypeLoginView, //登陆页面
    PorscheEnterViewControllerTypeMianView, //应用主页
    PorscheEnterViewControllerTypeReceiveRemoteNotification, // 接收到通知跳转到 消息页面
    PorscheEnterViewControllerTypeNone,
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) UIInterfaceOrientationMask currentOrientationMask;
@property (nonatomic, strong) NSDictionary *remoteNotificationUserInfo;

//进入登陆页面
- (void)loadEnterViewController:(PorscheEnterViewControllerType)enterType;
@end

