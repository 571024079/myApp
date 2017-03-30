//
//  PrecheckFileTitleCollectionReusableView.h
//  HandleiPad
//
//  Created by Handlecar on 2017/3/2.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDPreCheckModel;

typedef enum {
    DingdanGailanType_none = 0,//不选
    DingdanGailanType_jiyougenghuanfuwu = 1,//机油更换服务
    DingdanGailanType_zhognjibaoyang = 2,//中级保养
    DingdanGailanType_baoyang = 3,//保养
    DingdanGailanType_qita = 4,//其他
}DingdanGailanType;//订单概览

// 所需文件:   21=行驶证, 22=客户授权书, 23=保修和保养手册, 24=车轮防盗螺栓套筒, 25=驾驶证, 26=延保证书

// 付款方式:   31=现金, 32=借记/信用卡, 33=其他

@interface PrecheckFileTitleCollectionReusableView : UICollectionReusableView

@property (strong, nonatomic) HDPreCheckModel *preCheckData;//数据源

@property (weak, nonatomic) IBOutlet UILabel *dingdangaishuNameLb;//订单概述名称
@property (weak, nonatomic) IBOutlet UILabel *suoxuwenjianLb;//所需文件名称

@property (copy, nonatomic) void(^selectDingdanGailanBlock)(DingdanGailanType selectBtnType);//订单概览 -> 回调选择按钮的点击事件
@property (copy, nonatomic) void(^selectSuoxuWenjianBlock)(NSMutableArray *selectArray);//所需文件 -> 回调选择的项目
@property (copy, nonatomic) void(^selectShifouZaichangBlock)(NSNumber  *isStay);//接受车辆客户是否在场 -> 回调选择按钮的点击事件
@property (copy, nonatomic) void(^selectJinxingShijiaBlock)(NSNumber *isShijia);//是否在遇到噪音和驾驶动态问题时进行试驾 -> 回调选择按钮的点击事件
@property (copy, nonatomic) void(^selectPayTypeBlock)(NSMutableArray *selectArray);//付款方式 -> 回调选择的项目

@property (strong, nonatomic) NSNumber *viewForm;//界面从什么地方过来

@end
