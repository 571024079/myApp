//
//  RemarkListModel.h
//  HandleiPad
//
//  Created by Handlecar on 10/21/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemarkListModel : NSObject
@property (nonatomic, strong) NSNumber *stafftypeid; // 员工类型 id 开单 技师 备件 服务顾问
@property (nonatomic, strong) NSString *stafftype; // 员工类型  技师 开单员，服务顾问 备件
@property (nonatomic, strong) NSNumber *staffid; // 员工id
@property (nonatomic, strong) NSString *staffname; // 员工姓名
@property (nonatomic, strong) NSString *staffremark;


@property (nonatomic, strong) NSNumber *womid;//id
@property (nonatomic, strong) NSNumber *womwoid;//增项单id
@property (nonatomic, strong) NSNumber *womtype; //类型   1 文字  2 录音
@property (nonatomic, copy) NSString *womrecorddate;//记录时间
@property (nonatomic, copy) NSString *womrecordcontent;//记录内容
@property (nonatomic, copy) NSString *womsoundurl;//录音url
@property (nonatomic, copy) NSString *remarkcontent;//备注内容 或 录音url
@property (nonatomic, strong) NSNumber *womrecordperson;//记录人
@property (nonatomic, copy) NSString *departmentid;  //  //用户类型id
@property (nonatomic, copy) NSString *usertype;  //用户类型
@property (nonatomic, copy) NSString *nickname;     //显示昵称

@end
