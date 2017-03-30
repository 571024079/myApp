//
//  PResponseModel.h
//  HandleiPad
//
//  Created by Handlecar on 16/11/15.
//  Copyright © 2016年 Handlecar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PResponseModel : NSObject

/**
 status = 1;//状态码  100表示成功  否则失败
 msg;//错误描述
 Object;//返回对象信息
 list;//返回数组信息
 systemerrormsg;//系统报错
 currpage //当前页数
 totalrecords  //全件数
 totalpages //全页数
 */

@property (nonatomic) NSInteger status;  //
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) id object;
@property (nonatomic, copy) NSArray *list;
@property (nonatomic, copy) NSString *systemerrormsg;
@property (nonatomic) NSInteger currpage;
@property (nonatomic) NSInteger totalrecords;
@property (nonatomic) NSInteger totalpages;
@property (nonatomic, strong) NSNumber *orderstatus;  // 增项单状态:1:开单信息 2：等待技师增项确认 3：等待备件确认 4：等待服务沟通 5：等待客户确认 7：客户确认完成 8：离厂  99 ：工单取消',

@end
