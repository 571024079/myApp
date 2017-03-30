//
//  HDRightViewController.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/11.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TeachnicianAdditionItemHeaderView.h"

typedef NS_ENUM(NSInteger, HDRightViewControllerStatusStyle) {
    HDRightViewControllerStyleStatusBilling = 1,// 开单信息
    HDRightViewControllerStyleStatusTechician,//技师增项
    HDRightViewControllerStyleStatusMaterial,//备件确认
    HDRightViewControllerStyleStatusService,//服务沟通
    HDRightViewControllerStyleStatusCustom,//客户确认
    //非流程节点状态
    HDRightViewControllerStatusStyleUnknow,
};

@interface HDRightViewController : BaseViewController

@property (nonatomic, assign) ViewControllerEntryStyle style;
//技师增项-headerView
@property (strong, nonatomic) TeachnicianAdditionItemHeaderView *headerView;
//当前流程状态
@property (nonatomic, assign) HDRightViewControllerStatusStyle stepStyle;

// 流程切换
- (void)changeBtAction:(NSDictionary *)dic;
// 备件库方案库返回  改变title和颜色
- (void)changeBackItemColor:(NSDictionary *)sender;
//接收车辆被点击的通知。更改右侧开单中顶部，备注，提醒，服务档案图标
- (void)changeItemColor:(NSDictionary *)noti;
//设置预计交车显示/隐藏
- (void)setheaderUserEnabled:(NSDictionary *)sender;
//设置工单基本信息显示
- (void)setSelectItemCount:(NSDictionary *)noti;
//根据权限  修改流程的文字颜色等；
- (void)changeBottomText;
//方案已添加提示
- (void)alertViewForAddedItem;
//设置单一车辆提醒数量
- (void)setSingleCarNotice:(NSNumber *)number;
//设置备注工单备注 小红点
- (void)setRemark:(NSNumber *)number;

@end
