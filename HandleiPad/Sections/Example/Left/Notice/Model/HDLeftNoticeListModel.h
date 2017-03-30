//
//  HDLeftNoticeListModel.h
//  HandleiPad
//
//  Created by handlecar on 16/12/1.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDLeftNoticeListModel : NSObject

@property (nonatomic, copy) NSString *ccarplate;//车牌
@property (nonatomic, copy) NSString *content;//提醒内容
@property (nonatomic, copy) NSString *ooutputvolume;//排量
@property (nonatomic, strong) NSNumber *orderid;//工单ID
@property (nonatomic, copy) NSString *plateplace;//车牌户籍
@property (nonatomic, strong) NSNumber *state;//0:需要读  1：需要操作
@property (nonatomic, strong) NSNumber *stateopt;//1:已操作
@property (nonatomic, strong) NSNumber *stateread;//1:已读
@property (nonatomic, strong) NSNumber *taskid;//任务ID
@property (nonatomic, copy) NSString *wocarcatena;//车系
@property (nonatomic, copy) NSString *wocarmodel;//车型
@property (nonatomic, copy) NSString *wovincode;//VIN
@property (nonatomic, copy) NSString *woyearstyle;//年款
@property (nonatomic, strong) NSNumber *wostatus;//工单当前状态
@property (nonatomic, strong) NSNumber *directtype; // '跳转页面 1：开单 2：技师 3：备件  4：服务沟通  5:客户确认',    任务提醒里跳转到哪个页面之前是根据职位来调 ，现在根据这个字段跳转页面


+ (HDLeftNoticeListModel *)dataFormDic:(NSDictionary *)dic;

@end


@interface HDLeftNoticeFanganModel : NSObject
@property (nonatomic, strong) NSNumber *totalcount;
@property (nonatomic, strong) NSNumber *noticeid;//key
@property (nonatomic, strong) NSNumber *readstate;//查看状态      【0：未查看；1：已查看】
@property (nonatomic, strong) NSNumber *schemeid;//方案id
@property (nonatomic, copy) NSString *schemename;//	方案名字

+ (HDLeftNoticeFanganModel *)dataFormDic:(NSDictionary *)dic;

@end
