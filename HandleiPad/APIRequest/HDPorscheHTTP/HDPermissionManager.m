//
//  HDPermissionModel.m
//  HandleiPad
//
//  Created by handlecar on 16/12/22.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDPermissionManager.h"


@interface HDPermissionManager ()

@end

@implementation HDPermissionManager

+ (instancetype)sharePermission {
    static HDPermissionManager *permission = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        permission = [[HDPermissionManager alloc] init];
    });
    return permission;
}

+ (BOOL)isNotWithNOAlertViewThisPermission:(NSInteger)permissionCode {
    
    return ![HDPermissionManager isHasThisPermission:permissionCode isNeedShowMessage:NO];

}
+ (BOOL)isNotThisPermission:(NSInteger)permissionCode {

    return ![HDPermissionManager isHasThisPermission:permissionCode isNeedShowMessage:YES];

}

+ (BOOL)isHasThisPermission:(NSInteger)permissionCode {
//    return YES;
    return [HDPermissionManager isHasThisPermission:permissionCode isNeedShowMessage:YES];
}


+ (BOOL)isHasThisPermission:(NSInteger)permissionCode isNeedShowMessage:(BOOL)isNeedShowMessage {
    /*
    //大权限
    for (NSNumber *numbder in [HDPermissionManager sharePermission].needArray) {
        if (permissionCode == [numbder integerValue]) {
            return YES;
        }
    }
    */
    return  [HDPermissionManager basePermission:permissionCode isNeedShowMessage:isNeedShowMessage];
}

+ (BOOL)basePermission:(NSInteger)permissionCode isNeedShowMessage:(BOOL)isNeedShowMessage {
    
    NSArray *permissionArray = [HDPermissionManager sharePermission].dataSourceForPermission;
    
    for (NSDictionary *dic in permissionArray) {
        if ([dic[@"authid"] integerValue] == permissionCode) {
            return YES;
        }
    }
    
    if (isNeedShowMessage) {
        [HDPermissionManager showAlertWithAutoDisappear:@"您无权限操作"];
    }
    
    return NO;
}




//开单，技师，备件，服务，客户，保修审批，工时打折，配件打折，交车，取消确认
- (NSArray *)needArray {
    if (!_needArray) {
        _needArray = @[@(HDOrder_Kaidan),@(HDOrder_Jishizengxiang),@(HDOrder_Beijianqueren),@(HDOrder_Fuwugoutong),@(HDOrder_Kehuqueren),@(HDOrder_FuWuGouTong_BaoXiuShenPi),@(HDOrder_FuWuGouTong_SchemeTimeDiscount_Rate),@(HDOrder_FuWuGouTong_SchemeSpacePartDiscount_Rate),@(HDOrder_JiShiZengXiang_WorkshopAffirm),@(HDOrder_ClientAffirm_CanCelAffirm)];
    }
    return _needArray;
}

+ (NSString *)getDiscountSchemeThisPermission:(NSInteger)permissionCode {
    NSString *discountScheme = @"";
    
    NSArray *permissionArray = [HDPermissionManager sharePermission].dataSourceForPermission;
    
    for (NSDictionary *dic in permissionArray) {
        if ([dic[@"authid"] integerValue] == permissionCode) {
            discountScheme = dic[@"extrainfo"];
        }
    }
    return discountScheme;
}

+ (void)showAlertWithAutoDisappear:(NSString *)text {
//    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:text height:60 center:HD_FULLView.center superView:HD_FULLView];
//    
    [MBProgressHUD showMessageText:text toView:KEY_WINDOW anutoHidden:YES];
}

+ (BOOL)isHasHDOrder_JiShiZengXiang_EditServiceAdviser
{
    /*
     #define HDOrder_JiShiZengXiang_CancelScheme                                     10404001    //服务顾问的增项(取消方案)
     #define HDOrder_JiShiZengXiang_CancelSchemeTime                                 10404002    //服务顾问的增项(取消方案工时)
     #define HDOrder_JiShiZengXiang_CancelSchemeSpacePart                            10404003    //服务顾问的增项(取消方案备件)
     */
    BOOL isHasHDOrder_JiShiZengXiang_CancelScheme = [HDPermissionManager isHasThisPermission:HDOrder_JiShiZengXiang_CancelScheme isNeedShowMessage:NO];
    
    BOOL isHasHDOrder_JiShiZengXiang_CancelSchemeTime = [HDPermissionManager isHasThisPermission:HDOrder_JiShiZengXiang_CancelSchemeTime isNeedShowMessage:NO];

    BOOL isHasHDOrder_JiShiZengXiang_CancelSchemeSpacePart = [HDPermissionManager isHasThisPermission:HDOrder_JiShiZengXiang_CancelSchemeSpacePart isNeedShowMessage:NO];

    if (isHasHDOrder_JiShiZengXiang_CancelScheme || isHasHDOrder_JiShiZengXiang_CancelSchemeTime || isHasHDOrder_JiShiZengXiang_CancelSchemeSpacePart)
    {
        return YES;
    }
    
    return NO;
}

@end
