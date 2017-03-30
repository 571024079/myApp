//
//  PorscheStoreModel.h
//  HandleiPad
//
//  Created by Handlecar on 2016/12/1.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PorscheStoreModel : NSObject

@property (nonatomic, strong) NSString *address;       // 地址	string	@mock=枫林路485号
@property (nonatomic, strong) NSString *contractuser;  // 联系人	string	@mock=
@property (nonatomic, strong) NSNumber *createperson;  // createperson	创建人ID	number	@mock=0
@property (nonatomic, strong) NSString *createtime;    // 创建时间	string	@mock=2016-11-12 22:09:37.0
@property (nonatomic, strong) NSString *email;         // 邮箱	string	@mock=
@property (nonatomic, strong) NSString *inteladdress;  // 网址
@property (nonatomic, strong) NSString *phoneappointment; // 预约电话
@property (nonatomic, strong) NSString *phoneservice;      // 售后电话
@property (nonatomic, strong) NSString *postcode;       // 邮编
@property (nonatomic, strong) NSString *pricedif;        // 报价差异	string	@mock=
@property (nonatomic, strong) NSString *privicevalid;    // 报价有效期
@property (nonatomic, strong) NSNumber *storeid;         // 店铺id
@property (nonatomic, strong) NSString *storename;       // 店铺名称
@property (nonatomic, strong) NSString *switchboard;     // 总机	string	@mock=

@end
