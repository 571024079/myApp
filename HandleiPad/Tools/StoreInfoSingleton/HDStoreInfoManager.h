//
//  HDStoreInfoManager.h
//  HandleiPad
//
//  Created by Handlecar on 16/11/15.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

// 门店信息 登录人信息
@interface HDStoreInfoManager : NSObject

@property (nonatomic, strong) NSNumber *userid;     // 用户id
@property (nonatomic, strong) NSNumber *storeid;    // 门店id
@property (nonatomic, strong) NSNumber *groupid;    // 组别id
@property (nonatomic, strong) NSNumber *departmentid;    // 部门id
@property (nonatomic, strong) NSNumber *positionid;    // 职位id

@property (nonatomic, strong) NSNumber *delstate;    //
@property (nonatomic, strong) NSNumber *deluserid;    //
@property (nonatomic, strong) NSNumber *carorderid; // 工单id 当前操作的工单
@property (nonatomic, copy) NSString *plateplace;//当前操作的工单的车籍
@property (nonatomic, copy) NSString *carplate;//当前操作工单的车牌号
@property (nonatomic, strong) NSNumber *currpage;  // 当前页数
@property (nonatomic, strong) NSNumber *pagesize;  // 每页显示数量

@property (nonatomic, strong) NSString *username;  //  用户名
@property (nonatomic, copy) NSString *nickname; //用户昵称
@property (nonatomic, copy) NSString *createtime; //用户创建时间
@property (nonatomic, copy) NSString *weburl; // 分享链接


+ (instancetype)shareManager;

/*
 userid;//用户ID
 storeid;//4S店ID
 reqdata;{}请求额外参数对象
 currpage = 0;  //当前页数
 pagesize=10;//每页显示数量
 carorderid;
 modifytype;
 list;请求数组
 */

- (void)cleanData;
- (void)setAlias;
@end
