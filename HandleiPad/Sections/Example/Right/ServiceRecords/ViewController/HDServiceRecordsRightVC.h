//
//  HDServiceRecordsRightVC.h
//  HandleiPad
//
//  Created by handou on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "BaseViewController.h"
#import "HDServiceRecordsHelper.h"//助手
@class HDLeftListModel;


@interface HDServiceRecordsRightVC : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) PorscheNewCarMessage *leftServiceModel;

//显示状态(1->有购物车   2->没有购物车)
@property (nonatomic, strong) NSNumber *viewStatus;
//服务档案展开右侧的详情
- (void)serviceRightVCAction:(NSDictionary *)notif ;
@end
