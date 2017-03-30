//
//  HDLeftTabBarViewController.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/8.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDLeftTabBarViewControllerEntryStyle) {
    HDLeftTabBarViewControllerEntryStyleBilling = 1,// 开单接车
    HDLeftTabBarViewControllerEntryStyleCarInFac,// 在场车辆
    HDLeftTabBarViewControllerEntryStyleNotice,//服务提醒
    HDLeftTabBarViewControllerEntryStyleHistory,//服务档案
    HDLeftTabBarViewControllerEntryStyleProject,//方案库
    HDLeftTabBarViewControllerEntryStyleSet,//我的设置
    HDLeftTabBarViewControllerEntryStyleUnknow,//未知
};

@interface HDLeftTabBarViewController : UITabBarController
@property (nonatomic, assign) HDLeftTabBarViewControllerEntryStyle style;
- (void)changeBtAction:(NSDictionary *)dic;

- (void)setNotice:(NSNumber *)number;
@end
