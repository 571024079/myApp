//
//  HDRightCustomVCHelper.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeachnicianAdditionItemHeaderView.h"
//开单
#import "KandanRightViewController.h"
//技师增项
#import "HDSlitViewRightViewController.h"
//备件确认
#import "HDRightMaterialDealViewController.h"

//服务沟通页面
#import "HDServiceViewController.h"

//客户确认界面
#import "HDClientConfirmViewController.h"

//方案库右侧
#import "HDSchemeRightViewController.h"
//备件库右侧
#import "MaterialRightViewController.h"

//服务档案(左侧)
#import "HDServiceRecordsRightVC.h"
//在厂车辆全屏的时候右侧控制器
#import "FullScreenLeftListForRightVC.h"

@interface HDRightCustomVCHelper : UIView

+ (NSDictionary *)getVCWithStyle:(TeachnicianAdditionItemHeaderViewStyle)style;




@end
