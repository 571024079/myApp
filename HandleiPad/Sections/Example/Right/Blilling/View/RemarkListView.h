//
//  RemarkListView.h
//  HandleiPad
//
//  Created by Handlecar on 10/21/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 typedef NS_ENUM(NSInteger, HDRightViewControllerStatusStyle) {
 HDRightViewControllerStyleStatusBilling = 1,// 开单信息
 HDRightViewControllerStyleStatusTechician,//技师增项
 HDRightViewControllerStyleStatusMaterial,//备件确认
 HDRightViewControllerStyleStatusService,//服务沟通
 HDRightViewControllerStyleStatusCustom,//客户确认
 };
 */
typedef enum{
    ViewForm_serviceRecordsWorkOrder ,//工单备注
    ViewForm_serviceRecordsRightBtn  //服务档案cell上右侧标签
}ViewForm;

@interface RemarkListView : UIView
@property (nonatomic) NSInteger type; // 1 开单信息 2 技师增项 3 备件确认  4 服务沟通 5 客户确认

@property (nonatomic, assign) ViewForm viewFormStyle;

@property (nonatomic, strong) NSMutableArray *dataSource;
//- (void)reloadData;
@end
