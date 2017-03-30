//
//  HDServiceDealView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HDServiceDealViewNormal,
    HDServiceDealViewTechinian,
    HDServiceDealViewThreeHandle,// 三个处理
    HDServiceDealViewToTechAndSpare, // 去技师或者备件
    HDServiceDealViewThreeHandleEnterGuarantee,// 三个处理 进入保修审批流程
    HDServiceDealViewThreeHandleCheckGuarantee,// 三个处理 保修审批
    HDServiceDealViewToSeviceAndTech,          // 备件 两个处理，服务和技师
    HDServiceDealViewFourHandleEnterGuarantee,// 四个处理 进入保修审批流程
    HDServiceDealViewFourHandleCheckGuarantee,// 四个处理 保修审批

} HDServiceDealViewType;

@interface HDServiceDealView : UIView

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *rightLb;
@property (weak, nonatomic) IBOutlet UILabel *leftLb;


+ (void)showMakeSureViewAroundView:(UIView *)view direction:(UIPopoverArrowDirection)direction titleArr:(NSArray *)titleArr  first:(void(^)())custom second:(void(^)())material;

+ (void)showMakeSureViewAroundView:(UIView *)view viewType:(HDServiceDealViewType)type  direction:(UIPopoverArrowDirection)direction titleArr:(NSArray *)titleArr  first:(void(^)())custom second:(void(^)())material three:(void (^)())three;
+ (void)showMakeSureViewAroundView:(UIView *)view viewType:(HDServiceDealViewType)type  direction:(UIPopoverArrowDirection)direction titleArr:(NSArray *)titleArr  first:(void(^)())custom second:(void(^)())material three:(void (^)())three four:(void(^)())four;


@end
