//
//  HDPermissionModel.h
//  HandleiPad
//
//  Created by handlecar on 16/12/22.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDPermissionDefine.h"

@interface HDPermissionManager : NSObject
// 权限列表
@property (nonatomic, strong) NSArray *dataSourceForPermission;
@property (nonatomic, strong) NSArray *needArray;

+ (instancetype)sharePermission;


/**
 *  判断是否有该权限
 *
 *  @param permissionCode 权限id
 *
 *  @return YES为有
 */
+ (BOOL)isHasThisPermission:(NSInteger)permissionCode;

/**
 *  判断是否有该权限
 *
 *  @param permissionCode    权限id
 *  @param isNeedShowMessage 是否需要显示提示信息
 *
 *  @return YES为有该权限
 */
+ (BOOL)isHasThisPermission:(NSInteger)permissionCode isNeedShowMessage:(BOOL)isNeedShowMessage;

/**
 *  判断是否没有该权限
 *
 *  @param permissionCode 权限id 有Alert
 *
 *  @return YES为没有该权限
 */
+ (BOOL)isNotThisPermission:(NSInteger)permissionCode;
/**
 *  判断是否没有该权限
 *
 *  @param permissionCode 权限id 无Alert
 *
 *  @return YES为没有该权限
 */
+ (BOOL)isNotWithNOAlertViewThisPermission:(NSInteger)permissionCode;

/**
 *  返回打折的方案
 *
 *  @param permissionCode 权限id
 *
 *  @return 折扣类型字符串
 */
+ (NSString *)getDiscountSchemeThisPermission:(NSInteger)permissionCode;

+ (BOOL)isHasHDOrder_JiShiZengXiang_EditServiceAdviser;

@end
