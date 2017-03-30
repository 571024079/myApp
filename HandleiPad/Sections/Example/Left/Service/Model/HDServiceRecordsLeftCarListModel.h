//
//  HDServiceRecordsLeftCarListModel.h
//  HandleiPad
//
//  Created by handlecar on 16/12/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDServiceRecordsLeftCarListModel : NSObject

@property (nonatomic, strong) NSNumber *cid;//车辆id
@property (nonatomic, copy) NSString *plateplace; //车籍
@property (nonatomic, copy) NSString *ccarplate; //车牌号码
@property (nonatomic, copy) NSString *carplate; //完整车牌
@property (nonatomic, copy) NSString *ccarcatena;  //车系
@property (nonatomic, copy) NSString *ccarmodel; //车型
@property (nonatomic, copy) NSString *cyearstyle;  //年款
@property (nonatomic, strong) NSNumber *statestart; //开单状态
@property (nonatomic, strong) NSNumber *stateincrease; //增项状态
@property (nonatomic, strong) NSNumber *statepart; //备件状态
@property (nonatomic, strong) NSNumber *stateserice; //服务状态
@property (nonatomic, strong) NSNumber *statecustomer;  //客户状态
@property (nonatomic, strong) NSNumber *stateguarantee; //保修状态
@property (nonatomic, strong) NSNumber *stateinner; //内结状态

@end
