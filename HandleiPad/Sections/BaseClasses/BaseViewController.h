//
//  BaseViewController.h
//  TableViewDrag
//
//  Created by OS X EI Capitan on 16/8/23.
//  Copyright © 2016年 OrangeCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ViewControllerEntryStyle) {
    ViewControllerEntryStyleBilling = 1,// 开单接车
    ViewControllerEntryStyleCarInFac,// 在场车辆
    ViewControllerEntryStyleNotice,//服务提醒
    ViewControllerEntryStyleHistory,//服务档案
    ViewControllerEntryStyleProject,//方案库
    ViewControllerEntryStyleSet,//我的设置
    ViewControllerEntryStyleUnknow,
};


@interface BaseViewController : UIViewController
////子类重写，区别区域，销毁下次点击事件之前的视图。
//- (void)touchStart:(NSNotification *)notification;
//NSNumber转换成货币类型
- (NSString *)setStringStyleWithNumber:(NSNumber *)number withStyle:(NSNumberFormatterStyle)style;


- (void)baseReloadData;

@end
