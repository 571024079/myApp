//
//  PorscheConstant.h
//  HandleiPad
//
//  Created by 岳小龙 on 2016/12/6.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PorscheConstantModel.h"
@interface PorscheConstant : NSObject

@property (nonatomic, strong) NSMutableDictionary *allListInfo;

+ (instancetype)shareConstant;


/**
 根据表名获取常量列表

 @param tableName 表名
 #define  CoreDataVersion            @"VERSIONLIST"                  // 版本列表
 #define  CoreDataBusinesstype       @"HC_BASIC_BUSINESSTYPE"        // 业务类型
 #define  CoreDataCancelReason       @"HC_BASIC_CANCELREASON"        // 取消原因列表
 #define  CoreDataInsuranceCompany   @"HC_BASIC_INSURANCECOMPANY"    // 保险公司列表
 #define  CoreDataURL                @"HC_BASIC_URL"                 // 网页链接列表
 #define  CoreDataCommonValue        @"HC_COMMON_VALUE"              // 常量
 #define  CoreDataDepartment         @"HC_STORE_DEPARTMENT"          // 部门列表
 #define  CoreDataGroup              @"HC_STORE_GROUP"               // 组列表
 #define  CoreDataPosition           @"HC_STORE_POSITION"            // 职位列表
 #define  CoreDataPartsGroup         @"HC_PARTS_GROUP"               // 备件主组
 #define  CoreDataWorkHourk          @"HC_WORK_HOUR_GROUP"           // 工时列表
 #define  CoreDataSchemeLevel        @"FAJB"                         // 方案级别列表
 #define  CoreDataPayWay             @"JSFS"                         // 结算方式列表
 #define  CoreDataStoreType          @"KCLX"                         // 库存类型列表
 #define  CoreDataWarranty           @"BXZT"                         // 保修状态列表
 #define  CoreDataOrderStatus        @"KDZT"                         // 开单状态列表
 #define  CoreDataInterval           @"JGYS"                         // 间隔月数
 @return 常量列表
 */
- (NSArray<PorscheConstantModel *> *)getConstantListWithTableName:(NSString *)tableName;
- (void)requestVersionList;
- (void)requestConstantListWithTableNames:(NSArray *)tableNames;
// 常量列表 带 全部 选项 全部在第一个位置
- (NSArray<PorscheConstantModel *> *)getConstantListHasAllItemAtFirstPostionWithTableName:(NSString *)tableName;
// 常量列表 带 全部 选项 全部在最后一个位置
- (NSArray<PorscheConstantModel *> *)getConstantListHasAllItemAtLastPostionWithTableName:(NSString *)tableName;

@end
