//
//  PorscheItemModel.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
////技师增项数据被选择类型
//typedef NS_ENUM(NSInteger, PorscheItemModelSelectedStyle) {
//    PorscheItemModelSelected = 1,// 选中
//    PorscheItemModelUnselected,//未选中
//    PorscheItemModelSingleModel,//新增单独数据
//    PorscheItemModelNewMaterial,//新增配件
//};
//
////方案库数据类型
//typedef NS_ENUM(NSInteger, PorscheItemModelCategooryStyle) {
//    PorscheItemModelCategooryStyleSave = 1,//安全
//    PorscheItemModelCategooryStyleHiddenDanger,//隐患
//    PorscheItemModelCategooryStyleMessage,// 信息
//    PorscheItemModelCategooryStyleCustom,//自定义
//
//    PorscheItemModelCategooryStyleMix,//混合类型
//    PorscheItemModelCategooryStyleUnfinished,//未完成
//    PorscheItemModelCategooryStyleUnknow//未知状态
//};
////库存待确认 字段
//typedef NS_ENUM(NSInteger, PorscheItemModelCubStyle) {
//    PorscheItemModelCubStyleNeedConfirm = 1,// 库存待确认
//    PorscheItemModelCubStyleNoConfirm,//无需确认<字段出现环境   1.数据是空无需确认，  2.已确认>
//};
//
////工时备件区分
//typedef NS_ENUM(NSInteger, PorscheItemModelStyle) {
//    PorscheItemModelStyleMaterial = 1,// <#content#>
//    PorscheItemModelStyleItemTime,
//};
//
//typedef NS_ENUM(NSInteger, PorscheMaterialAndItemTimeGuaranteeStyle) {
//    PorscheMaterialAndItemTimeGuaranteeStyleGuarantee = 1,// 保修
//    PorscheMaterialAndItemTimeGuaranteeStylePayInside,//内结
//    PorscheMaterialAndItemTimeGuaranteeStyleSelfPay,//自费
//};

@interface PorscheItemModel : NSObject
//
//
//
//+ (NSMutableArray *)getAllItemData;

@end


//#pragma mark  ------配件的存储地及数量------
//@interface ProscheMaterialLocationModel : NSObject
////配件仓库位置
//@property (nonatomic, strong) NSString *location;
////仓库对应数量
//@property (nonatomic, strong) NSString *count;
//
//
//@end

#pragma mark  ------方案库model------
@interface PorscheItemDetialModel : NSObject

////数据是否库存待确认
//@property (nonatomic, assign) PorscheItemModelCubStyle cubStyle;
//
////左侧数据选中类型
//@property (nonatomic, assign) PorscheItemModelSelectedStyle modelLeftSelectedStyle;
//
////数据分类类型< 非未完成model添加至右边技师增项之后，只是model状态值改变，左侧不作删除，未完成项目添加至右侧，左侧删除该model，右侧删除未完成项目，将添加至左侧未完成区域>
////数据基本类型<信息，安全，隐患，自定义>
//@property (nonatomic, assign) PorscheItemModelCategooryStyle modelCategoryStyle;
////方案库用户类型<自定义，未完成>
//@property (nonatomic, assign) PorscheItemModelCategooryStyle modelUserType;
////右侧数据选中类型
//@property (nonatomic, assign) PorscheItemModelSelectedStyle modelRightSelectedStyle;
////区分工时还是备件
//@property (nonatomic, assign) PorscheItemModelStyle modelStyle;
////是否保修
//@property (nonatomic, assign) PorscheMaterialAndItemTimeGuaranteeStyle guaranteeStyle;
//
////是否是新增配件
//@property (nonatomic, assign) BOOL modelIsNewMaretial;
////是否是单独添加项目<单独添加项目，删除之后，左边没影响>
//@property (nonatomic, assign) BOOL  isSingleAddModel;
//
////是否是可以添加工时的model<自定义项目可以添加工时>
//@property (nonatomic, assign) BOOL isCanAddItemTime;



////服务图号
//@property (nonatomic, strong) NSString *itemFigueNumber;
//
////服务编号
//@property (nonatomic, strong) NSString *itemNumberList;
////服务名
//@property (nonatomic, strong) NSString *itemName;
////服务单价
//@property (nonatomic, strong) NSString *itemPrice;
////服务数量
//@property (nonatomic, strong) NSString *itemCount;
////服务小计
//@property (nonatomic, strong) NSString *itemTotalPrice;
////打折
//@property (nonatomic, strong)  NSNumber *dicsount;
////优惠后总价
//@property (nonatomic, strong) NSString *discountTotalPrice;
//
////项目名
//@property (nonatomic, strong) NSString *projectName;

/****配件四个位置****/
//本店
//@property (nonatomic, strong) ProscheMaterialLocationModel *localLocation;
////PCN
//@property (nonatomic, strong) ProscheMaterialLocationModel *PCNlocation;
////PAG
//@property (nonatomic, strong) ProscheMaterialLocationModel *PAGLocation;
////无库存
//@property (nonatomic, strong) ProscheMaterialLocationModel *emptyLocation;


//+ (PorscheItemDetialModel *)getModelWithArray:(NSArray *)array;
//
//- (instancetype)initWithFigueNumber:(NSString *)figueNumber listNumber:(NSString *)listNumber name:(NSString *)name price:(NSString *)price count:(NSString *)count totalPrice:(NSString *)totalPrice;

@end

#pragma mark  ------开单车辆提醒简单信息------

//typedef NS_ENUM(NSInteger, PorscheCarMessageStyle) {
//    PorscheCarMessageStyleUnread = 0,// 未读
//    PorscheCarMessageStyleReaded,//已读
//    
//};
//typedef NS_ENUM(NSInteger, PorscheCarMessageCategoryStyle) {
//    PorscheCarMessageCategoryStyleItem = 0,// 方案
//    PorscheCarMessageCategoryStylePrice,//价格
//    
//};

//@interface PorscheCarMessage : NSObject
//省会
//@property (nonatomic, strong) NSString *carLocation;
////车牌号
//@property (nonatomic, strong) NSString *carNumber;
////vin码
//@property (nonatomic, strong) NSString *vinNumber;
////车型车系
//@property (nonatomic, strong) NSString *carCategory;
////提示信息
//@property (nonatomic, strong) NSString *message;
//@property (nonatomic, strong) NSString *changePrice;
////数据已读未读状态
//@property (nonatomic, assign) PorscheCarMessageStyle modelStyle;
//
//@property (nonatomic, assign) PorscheItemModelSelectedStyle selectedStyle;
//
//@property (nonatomic, assign) NSString *categoryStyle;
//
//
//- (instancetype)initWithDic:(NSDictionary *)dic;
//
//
//+ (NSArray *)getCarNoticeModel:(NSInteger)integer;
////本店提醒数据
//+ (NSArray *)getLocationCarNoticeModel:(NSInteger)integer;


//
//@end




