//
//  HDLeftNoticeViewController.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLeftViewController.h"

@interface HDLeftNoticeViewController : BaseLeftViewController

// 1 单车提醒
@property (nonatomic, strong) NSNumber *viewStatus;

@property (nonatomic, assign) NSNumber *dataCount;

//单车任务提醒
@property (nonatomic, strong) NSNumber *isSingleNotice;
//单车任务提醒
- (void)singleCarNotifination:(NSDictionary *)sender;

// 切换通知
- (void)reloadDataWithInfo:(NSDictionary *)userInfo;
// 刷新通知
- (void)reloadNoticeData;

- (void)upadeRedTip;
@end
