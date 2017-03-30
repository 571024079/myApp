//
//  PorscheConstantModel.h
//  HandleiPad
//
//  Created by 岳小龙 on 2016/12/6.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PorscheSubConstant;

typedef NS_ENUM(NSInteger,PorscheConstantModelType ) {
    
    PorscheConstantModelTypeCoreDataBusinesstype = 1, // 业务类型
    PorscheConstantModelTypeCoreDataCancelReason, // 取消原因列表
    PorscheConstantModelTypeCoreDataInsuranceCompany, // 保险公司列表
    PorscheConstantModelTypeCoreDataURL, // 网页链接列表
    PorscheConstantModelTypeCoreDataCommonValue, // 常量
    PorscheConstantModelTypeCoreDataDepartment, // 部门列表
    PorscheConstantModelTypeCoreDataGroup, // 组列表
    PorscheConstantModelTypeCoreDataPosition, // 职位列表
    PorscheConstantModelTypeCoreDataPartsGroup,  // 备件主组
    PorscheConstantModelTypeCoreDataWorkHourk, // 工时列表
    PorscheConstantModelTypeCoreDataSchemeLevel, // 方案级别列表
    PorscheConstantModelTypeCoreDataPayWay, // 结算方式列表
    PorscheConstantModelTypeCoreDataStoreType, // 库存类型列表
    PorscheConstantModelTypeCoreDataWarranty, // 保修状态列表
    PorscheConstantModelTypeCoreDataOrderStatus, // 开单状态列表
    PorscheConstantModelTypeCoreDataInterval, // 间隔月数
    PorscheConstantModelTypeCoreDataFavorite //收藏夹
};


@interface PorscheConstantModel : NSObject

@property (nonatomic, assign) PorscheConstantModelType constantType;

@property (nonatomic, copy) NSString *cvvaluedesc;

@property (nonatomic, strong) NSNumber *cvsubid;
//添加一个新的字符串，只用于工时主组子组列表的获取使用，传递的id为字符串
@property (nonatomic, copy) NSString *cvsubidstr;

@property (nonatomic, strong) NSArray <PorscheSubConstant *> *children;

@property (nonatomic, copy) NSString *extrainfo;

@property (nonatomic, copy) NSString *configure;

@property (nonatomic, copy) NSString *descr;   // 车辆列表车型字段

// 年款使用 这个model 新增几个字段，供请求排量使用
@property (nonatomic, copy) NSString *cartype;          // 车型
@property (nonatomic, copy) NSString *pctcartypeno;     // 车型code
@property (nonatomic, copy) NSString *pctconfigure1;    // 配置信息
@property (nonatomic, copy) NSString *pctcarsno;        // 车系code
@property (nonatomic, copy) NSString *cars;             // 车系

@property (nonatomic, strong) NSNumber *secondID;//用于存放第二个id,暂时服务档案用

// 全部选项
+ (instancetype)constantAllModel;
@end

@interface PorscheSubConstant : NSObject

@property (nonatomic, copy) NSString *cvvaluedesc;

@property (nonatomic, copy) NSNumber *cvsubid;

@end
