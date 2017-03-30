//
//  FullScreenLeftListForRightVC.h
//  HandleiPad
//
//  Created by handou on 16/10/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "BaseViewController.h"
//下拉选择的状态
//0.全部 1.进行中2.已完成3.备件通知4.确认通知6.增项通知 8.待开始，9.车间待确认 10.车间进行中 11.车间已确认
typedef enum {
    FullScreenListForRightHeaderBottomPopViewStatus_none = 0,//全部显示
    FullScreenListForRightHeaderBottomPopViewStatus_ing = 1,//进行中
    FullScreenListForRightHeaderBottomPopViewStatus_finish = 2,//已完成
    FullScreenListForRightHeaderBottomPopViewStatus_waltStart = 8,//待开始
    FullScreenListForRightHeaderBottomPopViewStatus_chejianFinish = 11,//车间已确认
    FullScreenListForRightHeaderBottomPopViewStatus_add_noti = 6,//增项通知
    FullScreenListForRightHeaderBottomPopViewStatus_spareParts_noti = 3,//备件通知
    FullScreenListForRightHeaderBottomPopViewStatus_affirm_noti = 4,//确认通知
    FullScreenListForRightHeaderBottomPopViewStatus_chejianIng = 10,//车间进行中
    FullScreenListForRightHeaderBottomPopViewStatus_chejianWait_affirm = 9,//车间待确认
}FullScreenListForRightHeaderBottomPopViewStatus;

@interface FullScreenLeftListForRightVC : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataSource;
//接收左侧滑动
- (void)setTableViewContentOffSize:(NSNumber *)noti;
//接收左侧数据
- (void)loadDataForLeftListViewWithArray:(NSMutableArray *)noti;

@end
