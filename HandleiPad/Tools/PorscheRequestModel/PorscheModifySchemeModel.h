//
//  PorscheModifySchemeModel.h
//  HandleiPad
//
//  Created by Robin on 2016/11/17.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PorscheModifySchemeModel : PorscheSchemeModel

//修改方案
@property (nonatomic, strong) NSNumber *caozuotype; // 操作类型【0.所有；1.基础；2.间隔时间；3.公里数；4.车型；5.工时；6.备件；7.业务类型】
@property (nonatomic, copy) NSString *createname; // 创建人
@property (nonatomic, copy) NSString *createtime; // 创建时间
@property (nonatomic, strong) NSNumber *savestate; //保存状态【0：我的方案；1：本店方案】
@property (nonatomic, strong) NSNumber *woid;//工单id

@end

