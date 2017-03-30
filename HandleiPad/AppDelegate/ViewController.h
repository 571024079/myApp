//
//  ViewController.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/7.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ViewController : UIViewController
@property (nonatomic, assign) ViewControllerEntryStyle style;
@property (nonatomic, strong) UINavigationController *masterNav;
@property (nonatomic, strong) UINavigationController *detailNav;

// 返回首页
- (void)billingBackToFirstView;
//打印界面
- (void)showPreView:(NSDictionary *)noti;

@end
