//
//  HDStatusChangeManager.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/12/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HDRightStatusStyle) {
    HDRightStatusStyleSelf = -1,// 当前控制器
    HDRightStatusStyleBilling = 0,// 开单信息
    HDRightStatusStyleTechician = 1,// 技师增项
    HDRightStatusStyleMaterial = 2,// 备件确认
    HDRightStatusStyleService = 3,// 服务沟通
    HDRightStatusStyleCustom = 4,// 客户确认
    HDRightStatusStyleMaterialCub = 5,// 备件库
    HDRightStatusStyleWorkTimeCub = 6,// 工时库
    HDRightStatusStyleSchemeCub = 7,// 方案库
    HDRightStatusStyleServiceHistory = 8,// 服务档案
    HDRightStatusStyleCarInFac = 9,// 在厂车辆
    
    
};
//0.开单信息 1.提醒  2.方案库左侧  3设置    5.备件库 6.工时库 7.方案库 8服务档案
typedef NS_ENUM(NSInteger, HDLeftStatusStyle) {
    HDLeftStatusStyleSelf = -1,// 当前控制器
    HDLeftStatusStyleBilling = 0,// 开单信息
    HDLeftStatusStyleNotice = 1,// 提醒
    HDLeftStatusStyleSchemeLeft = 2,// 方案库左侧
    HDLeftStatusStyleSet = 3,// 设置
    HDLeftStatusStyleNet = 4,// 网络
    HDLeftStatusStyleMaterialCub = 5,// 备件库
    HDLeftStatusStyleWorkTimeCub = 6,// 工时库
    HDLeftStatusStyleSchemeCub = 7,// 方案库
    HDLeftStatusStyleServiceHistory = 8,// 服务档案
};

@interface HDStatusChangeManager : NSObject

+ (void)changeStatusLeft:(HDLeftStatusStyle)left right:(HDRightStatusStyle)right;
+ (void)removeNetVC;





@end
