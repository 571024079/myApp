//
//  HDRightCustomVCHelper.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDRightCustomVCHelper.h"


@implementation HDRightCustomVCHelper

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (NSDictionary *)getVCWithStyle:(TeachnicianAdditionItemHeaderViewStyle)style {
    switch (style) {
            //开单信息
        case TeachnicianAdditionItemHeaderViewStyleBilling:
        {
            KandanRightViewController *vc = [KandanRightViewController new];
            vc.view.frame = CGRectMake(0, 109, HD_WIDTH - LEFT_WITH - 1, HD_HEIGHT - 109);
            NSDictionary *dic =  @{@"vc":vc,@"rect":[NSValue valueWithCGRect:vc.view.frame]};
            return dic;
        }
            break;
            //技师增项
        case TeachnicianAdditionItemHeaderViewStyleTechcian:
        {
            HDSlitViewRightViewController *vc = [HDSlitViewRightViewController new];
            vc.view.frame =  CGRectMake(0, 120 + 64, HD_WIDTH - LEFT_WITH - 1, HD_HEIGHT - 120);
            NSDictionary *dic =  @{@"vc":vc,@"rect":[NSValue valueWithCGRect:vc.view.frame]};
            return dic;
        }
            
            break;
            //备件确认
        case TeachnicianAdditionItemHeaderViewStyleMaterial:
            
        {
            
            HDRightMaterialDealViewController *vc = [HDRightMaterialDealViewController new];
            vc.view.frame =  CGRectMake(0, 120 + 64, HD_WIDTH - LEFT_WITH - 1, HD_HEIGHT - 120);
            NSDictionary *dic =  @{@"vc":vc,@"rect":[NSValue valueWithCGRect:vc.view.frame]};
            return dic;
        
        }
            
            break;
            //服务沟通
        case TeachnicianAdditionItemHeaderViewStyleService:
        {
            HDServiceViewController *vc = [HDServiceViewController new];
            vc.view.frame =  CGRectMake(0, 120 + 64, HD_WIDTH - LEFT_WITH - 1, HD_HEIGHT - 120);
            NSDictionary *dic =  @{@"vc":vc,@"rect":[NSValue valueWithCGRect:vc.view.frame]};
            return dic;
        }
            
            
            break;
            //客户确认
        case TeachnicianAdditionItemHeaderViewStyleCustomSure:
        {
            HDClientConfirmViewController *vc = [HDClientConfirmViewController new];
            vc.view.frame =  CGRectMake(0, 64 + 85, HD_WIDTH - LEFT_WITH - 1, HD_HEIGHT - 64 - 85);
            NSDictionary *dic =  @{@"vc":vc,@"rect":[NSValue valueWithCGRect:vc.view.frame]};
            return dic;
        }
            
            break;
            //预计交车时间
        case TeachnicianAdditionItemHeaderViewStylePreTime:
            
            break;
            //备件库
        case TeachnicianAdditionItemHeaderViewStyleMaterialCub:
        {
            MaterialRightViewController *vc = [[MaterialRightViewController alloc]initWithType:ControllerTypeWithMaterial];
            vc.view.frame = CGRectMake(0, 64, HD_WIDTH - LEFT_WITH - 1, HD_HEIGHT - 64);
            NSDictionary *dic =  @{@"vc":vc,@"rect":[NSValue valueWithCGRect:vc.view.frame]};
            return dic;
        }
            break;
            //工时库
        case TeachnicianAdditionItemHeaderViewStyleItemTimeCub:
        {
            MaterialRightViewController *vc = [[MaterialRightViewController alloc]initWithType:ControllerTypeWithWorkingHours];
            vc.view.frame = CGRectMake(0, 64, HD_WIDTH - LEFT_WITH - 1, HD_HEIGHT - 64);
            NSDictionary *dic =  @{@"vc":vc,@"rect":[NSValue valueWithCGRect:vc.view.frame]};
            return dic;
        }
            
            break;
            //方案库
        case TeachnicianAdditionItemHeaderViewStyleProjectCub:
        {
            HDSchemeRightViewController *vc = [HDSchemeRightViewController new];
            vc.view.frame = CGRectMake(0, 64, HD_WIDTH - LEFT_WITH - 1, HD_HEIGHT - 64);
            NSDictionary *dic =  @{@"vc":vc,@"rect":[NSValue valueWithCGRect:vc.view.frame]};
            return dic;
        }
            break;
            // 在厂车辆右侧
        case TeachnicianAdditionItemHeaderViewStyleCarInFactoryFull:
        {
            FullScreenLeftListForRightVC *vc = [FullScreenLeftListForRightVC new];
            vc.view.frame = CGRectMake(0, 64, HD_WIDTH - LEFT_WITH - 1, HD_HEIGHT - 64);
            NSDictionary *dic =  @{@"vc":vc,@"rect":[NSValue valueWithCGRect:vc.view.frame]};
            return dic;
        }
            break;
            //服务档案右侧
        case TeachnicianAdditionItemHeaderViewStyleServiceHistory:
        {
            HDServiceRecordsRightVC *vc = [HDServiceRecordsRightVC new];
            vc.view.frame = CGRectMake(0, 64, HD_WIDTH - LEFT_WITH - 1, HD_HEIGHT - 64);
            NSDictionary *dic =  @{@"vc":vc,@"rect":[NSValue valueWithCGRect:vc.view.frame]};
            return dic;
        }
            break;
            
        default:
            break;
    }
    return nil;
}


@end
