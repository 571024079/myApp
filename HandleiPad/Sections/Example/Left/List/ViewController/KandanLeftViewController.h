//
//  KandanLeftViewController.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/6.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLeftViewController.h"

@interface KandanLeftViewController : BaseLeftViewController

- (void)setTFregisterFirst;

- (void)setFullBtTitle;

@property (nonatomic, strong) NSNumber *fullScreenNumber;

//刷新相关
- (void)getCarInFactionListAction:(NSNumber *)noti;
//新开单 下面的title 切换为看车辆进度
- (void)setBottomBt;
//在场车辆全屏返回
- (void)helpActionWithRightView:(NSDictionary *)noti;
//全屏滚动
- (void)setTableViewContentOffSize:(NSNumber *)noti;
//全屏右侧触发 当前界面刷新
- (void)reloadtableViewData:(NSMutableDictionary *)noti;


@end
