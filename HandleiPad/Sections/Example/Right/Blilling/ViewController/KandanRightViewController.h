//
//  KandanRightViewController.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/7.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BlillingMessageCenterView.h"

@interface KandanRightViewController : BaseViewController

//开单信息视图
@property (nonatomic, strong) BlillingMessageCenterView *billingView;

//滑动
@property (strong, nonatomic) UIView *containerView;
//新建工单
- (void)bottomNewBillingAction;

@end

