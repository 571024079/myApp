//
//  PrecheckSubTitleCollectionReusableView.h
//  HandleiPad
//
//  Created by Handlecar on 2017/3/2.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDPreCheckModel;
/*
    副标题
    工单号 检验员 车架号 车牌 日期 里程数等信息
 */

typedef enum {
    PrecheckSubTitleTF_orderNumTF = 1,//工单号输入框
    PrecheckSubTitleTF_checkStaffNameTF = 2,//检验员/检测员输入框
    PrecheckSubTitleTF_currentMileageTF = 3,//当前里程数输入框
}PrecheckSubTitleTF;

@interface PrecheckSubTitleCollectionReusableView : UICollectionReusableView

@property (strong, nonatomic) HDPreCheckModel *preCheckData;//数据源

@property (weak, nonatomic) IBOutlet UILabel *titleNameLb;//标题名称
@property (weak, nonatomic) IBOutlet UITextField *orderNumTF;//工单号输入框
@property (weak, nonatomic) IBOutlet UITextField *chejiahaoTF;//车架号输入框
@property (weak, nonatomic) IBOutlet UITextField *carPlateTF;//车牌号输入框
@property (weak, nonatomic) IBOutlet UITextField *checkStaffNameTF;//检验员/检测员输入框
@property (weak, nonatomic) IBOutlet UITextField *dateTF;//日期输入框
@property (weak, nonatomic) IBOutlet UITextField *currentMileageTF;//当前里程数输入框

@property (strong, nonatomic) NSNumber *viewForm;//界面从什么地方过来


@property (copy, nonatomic) void(^textFieldBlock)(PrecheckSubTitleTF tfType, UITextField *textField, PorscheConstantModel *orderData);

@end
