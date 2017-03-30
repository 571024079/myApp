//
//  HDOrangeModel.h
//  HandleiPad
//
//  Created by handlecar on 16/12/1.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#ifndef HDOrangeModel_h
#define HDOrangeModel_h

#define TICK   NSDate *startTime = [NSDate date];
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow]);


#import "HDUtils.h"//用户缓存
#import "HDLeftNoticeListModel.h" //提醒左侧列表
#import "HDServiceRecordsRightModel.h" //服务档案右侧数据
#import "HDServiceRecordsLeftCarListModel.h" //服务档案左侧车辆列表的数据
#import "RemarkListModel.h"//备注列表model
#import "HDPermissionManager.h"

#import "VersionControlManager.h"//自动更新


#endif /* HDOrangeModel_h */
