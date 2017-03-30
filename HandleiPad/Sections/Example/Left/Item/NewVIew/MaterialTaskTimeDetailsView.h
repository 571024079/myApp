//
//  MaterialTaskTimeDetailsView.h
//  KeyBoardDemo
//
//  Created by Robin on 2016/10/15.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DetailViewBackType) {
    
    DetailViewBackTypeJoinWorkOrder = 1, //加入工单
    DetailViewBackTypeSave, //保存
    DetailViewBackTypeSaveToMyScheme, //保存至我的方案
    DetailViewBackTypeDelete, //删除
    DetailViewBackTypeBack,//返回
    DetailViewBackTypeOther,
    DetailViewBackTypeSaveToMySchemeAndAddToOrder,
};

typedef void(^MaterialTaskTimeDetailsCustomViewClickBlock)(DetailViewBackType,NSInteger,id);

typedef void(^MaterialTaskTimeDetailsOrderViewClickBlock)(DetailViewBackType,PorscheSchemeModel *);

@interface MaterialTaskTimeDetailsView : UIView

@property (nonatomic, assign) MaterialTaskTimeDetailsType detailType;

//工时model数据源
@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, strong) NSMutableArray *carMileages;
@property (nonatomic, strong) NSMutableArray *carPlans;

@property (nonatomic, copy) MaterialTaskTimeDetailsCustomViewClickBlock backBlock;

@property (nonatomic, copy) MaterialTaskTimeDetailsOrderViewClickBlock orderBackBlock;

@property (nonatomic, assign) BOOL edit;
@property (nonatomic, assign) BOOL new_object;

//+ (instancetype)viewWithDataSource:(NSArray *)dataSource DetailType:(MaterialTaskTimeDetailsType)detailType;

/**
 初始化传入id   新建id传0

 @param modelid id
 @param detailType 类型
 */
+ (void)showWithID:(NSInteger)modelid detailType:(MaterialTaskTimeDetailsType)detailType;
+ (void)showWithID:(NSInteger)modelid detailType:(MaterialTaskTimeDetailsType)detailType clickAction:(MaterialTaskTimeDetailsCustomViewClickBlock)clickAction;

/**
 方案通知时使用接口

 @param schemeid 方案id
 @param noticeid 通知id
 */
+ (void)showNotificationSchemeDetail:(NSInteger)schemeid noticeID:(NSInteger)noticeid shouldAddToOrder:(BOOL)isShould clickAction:(MaterialTaskTimeDetailsCustomViewClickBlock)clickAction;

/**
 工单方案详情传入一个方案model

 @param orderSchemeModel 工单方案model
 @param detailType
 @param clickAction 
 */
+ (void)showOrderSchemeWithScheme:(PorscheSchemeModel *)orderSchemeModel clickAction:(MaterialTaskTimeDetailsOrderViewClickBlock)clickAction;

@end
