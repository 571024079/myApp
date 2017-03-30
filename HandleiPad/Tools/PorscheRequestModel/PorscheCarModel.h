//
//  PorscheCarModel.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/17.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCarTypeModel.h"
#import "ZLCamera.h"
#import "PorscheSchemeModel.h"
#import "RemindModel.h"

//技师增项数据被选择类型
typedef NS_ENUM(NSInteger, PorscheItemModelSelectedStyle) {
    PorscheItemModelSelected = 1,// 选中
    PorscheItemModelUnselected,//未选中
    PorscheItemModelSingleModel,//新增单独数据
    PorscheItemModelNewMaterial,//新增配件
};

//方案库数据类型
typedef NS_ENUM(NSInteger, PorscheItemModelCategooryStyle) {
    PorscheItemModelCategooryStyleSave = 1,//安全
    PorscheItemModelCategooryStyleHiddenDanger,//隐患
    PorscheItemModelCategooryStyleMessage,// 信息
    PorscheItemModelCategooryStyleCustom,//自定义
    PorscheItemModelCategooryStyleUnfinished,//未完成


    PorscheItemModelCategooryStyleMix,//混合类型
    PorscheItemModelCategooryStyleUnknow//未知状态
};

//公里数范围类型
typedef NS_ENUM(NSInteger, PorscheCarMileageRangeType) {
    
    PorscheCarMileageRangeTypeRange = 1,//公里数范围
    PorscheCarMileageRangeTypeFloat,//公里数左右
    PorscheCarMileageRangeTypeCycle//公里数循环
};

//业务分类
typedef NS_ENUM(NSInteger, PorscheCarBusinessType) {
    
    PorscheCarBusinessTypeUnknow = 1, //未分类
    PorscheCarBusinessTypeCarWash, //精洗
    PorscheCarBusinessTypeCarUpkeep, //保养
    PorscheCarBusinessTypeCarMaintain, //维修
    PorscheCarBusinessTypeCarMetal, //钣金
    PorscheCarBusinessTypeCarSpray, //喷漆
    PorscheCarBusinessTypeCarBeautify, // 美容
    PorscheCarBusinessTypeCarWheel //轮子
};

@class PorscheRemark;
@class ZLCamera;
@class PorscheNewScheme;
@class PorscheNewSchemews;
@class ProscheMaterialLocationModel;
@class PorscheCarVideoMessage;
@class PorscheCarSeriesModel;
@class OrderOptStatusDto;
@class PorscheNewWorkHourSchemews;
@class PorscheNewMaterialSchemews;
@interface PorscheCarModel : NSObject
@end

#pragma mark  开单信息model------
@interface PorscheNewCarMessage : NSObject

@property (nonatomic, strong) NSNumber *statememo;//备忘录状态：0:未读  1:已读
@property (nonatomic, strong) NSNumber *woid;//工单id
@property (nonatomic, strong) NSString *wodmsno;// dms工单号
@property (nonatomic, strong) NSString *woserialno;// 增项单号
@property (nonatomic, strong) NSString *woenyardtime;// 进厂时间（年月日时分）
@property (nonatomic, strong) NSString *wofinishtime; // 预计交车时间
//工单状态 -1.取消下单 1.开单信息 2.技师增项 3.备件确认 4.服务沟通 5.客户确认 7工单已确认 8.不在场
@property (nonatomic, strong) NSNumber *wostatus;
@property (nonatomic, strong) NSString *remark;//备注
@property (nonatomic, strong) NSString *customersigndate;//客户签名时间
@property (nonatomic, strong) NSString *customerconfirmtime;//客户确认时间
@property (nonatomic, strong) NSString *subcartime;//交车时间

@property (nonatomic, strong) NSString *wocancelpersonname;//取消人
@property (nonatomic, strong) NSNumber *wocancelperson;//取消人id
@property (nonatomic, strong) NSString *wocanceltime;//取消时间
@property (nonatomic, strong) NSNumber *canceldesid;//取消原因id
@property (nonatomic, strong) NSString *canceldes;//取消原因

@property (nonatomic, strong) NSNumber *editstatus;//编辑状态
@property (nonatomic, strong) NSNumber *editperson;//编辑人id
@property (nonatomic, strong) NSString *editpersonname;//编辑人
@property (nonatomic, strong) NSNumber *lastselectposition;  // 1 技师 2服务顾问

@property (nonatomic, strong) NSNumber *wocarid;//车辆id
@property (nonatomic, strong) NSNumber *crepair;// 保修状态 1：无保修 2：保修期内 3：延迟保修
@property (nonatomic, strong) NSString *crepairtime;// 保修到期日(yyyyMMdd)
@property (nonatomic, strong) NSString *cregisterdate;//首登日期
@property (nonatomic, strong) NSString *cvincode;// VIN
@property (nonatomic, strong) NSString *plateplace;//车籍
@property (nonatomic, strong) NSString *ccarplate;// 车牌
@property (nonatomic, strong) NSNumber *cinsurecomid;//保险公司ID
@property (nonatomic, strong) NSString *cinsurecomname;//保险公司名称
@property (nonatomic, strong) NSString *cinsureenddate;//保险到期日期

@property (nonatomic, strong) NSNumber *ccartypeid;//车型id 精确到排量
@property (nonatomic, strong) NSNumber *cycartypeid; // 车型id  精确到年款
@property (nonatomic, strong) NSNumber *pctype;
@property (nonatomic, strong) NSNumber *carsid;
@property (nonatomic, strong) NSNumber *cartypeid;
@property (nonatomic, strong) NSNumber *caryearid;
@property (nonatomic, strong) NSNumber *cardisplacementid;

@property (nonatomic, strong) NSString *wocarcatena; // 车系名称
@property (nonatomic, strong) NSString *wocarmodel; // 车型名称
@property (nonatomic, strong) NSString *woyearstyle; // 年款name
@property (nonatomic, strong) NSString *wooutputvolume;// 排量名称
@property (nonatomic, strong) NSString *wocarmodelcode;//车型code
@property (nonatomic, strong) NSString *wocarcatenacode;// 车系code
@property (nonatomic, strong) NSNumber *wocurmiles;// 当前公里数
@property (nonatomic, strong) NSNumber *isvaluables;//是否有贵重物品1.无 2.有

//包含保修配件或者工时，或者方案 0.无 1.技师申请保修 2. 服务顾问确认保修
@property (nonatomic, strong) NSNumber *existguarantee;//有确认的保
//@property (nonatomic, strong) NSNumber *existredguarantee;//有待确认的保
@property (nonatomic, strong) NSNumber *existinternalsettlement;//有内结
#warning 7:原等待备件 10：原保修待审批
//0.全部 1.进行中2.已完成3.备件通知4.确认通知5.增项备件通知6.增项通知7.保修待审批8.待开始，9.车间待确认 10.
@property (nonatomic, strong) NSNumber *statestart;//开单状态
@property (nonatomic, strong) NSNumber *stateincrease;//技师增项状态
@property (nonatomic, strong) NSNumber *statepart;//备件确认状态
@property (nonatomic, strong) NSNumber *stateserice;//服务沟通状态
@property (nonatomic, strong) NSNumber *statecustomer;//客户确认状态

@property (nonatomic, strong) NSNumber *createuserid;// 开单员id
@property (nonatomic, strong) NSString *createusername;// 开单员
@property (nonatomic, strong) NSNumber *technicianid;// 技师id
@property (nonatomic, strong) NSString *technicianname;// 技师名称
@property (nonatomic, strong) NSNumber *wopartsmanid;// 备件员id
@property (nonatomic, strong) NSString *wopartsmanname;// 备件员
@property (nonatomic, strong) NSNumber *serviceadvisorid;// 服务顾问id
@property (nonatomic, strong) NSString *serviceadvisorname;// 服务顾问

@property (nonatomic, strong) NSArray<PorscheResponserPictureVideoModel *> *attachments;//照片
@property (nonatomic, strong) NSArray<PorscheResponserPictureVideoModel *> *attachmentsforsign;//签字图片
@property (nonatomic, strong) NSArray<PorscheResponserPictureVideoModel *> *attachmentsfordrivinglicense;//行驶证
@property (nonatomic, copy) NSArray *carslist;//适配车型信息
@property (nonatomic, strong) NSNumber *solutioncnt;//方案个数

@property (nonatomic, strong) NSNumber *partsoriginalprice;//备件原价
@property (nonatomic, strong) NSNumber *workhouroriginalprice;//工时原价
@property (nonatomic, strong) NSNumber *ordertotaloriginalprice;//工单原价

@property (nonatomic, strong) NSNumber *partsoriginalprice1;//备件原价--技师备件显示 (不含保险内结)
@property (nonatomic, strong) NSNumber *workhouroriginalprice1;//工时原价--技师备件显示  (不含保险内结)
@property (nonatomic, strong) NSNumber *ordertotaloriginalprice1;//工单原价--技师备件显示

@property (nonatomic, strong) NSNumber *ordertotalprice;//工单总价
@property (nonatomic, strong) NSNumber *partsprice;//备件总价
@property (nonatomic, strong) NSNumber *workhourprice;//工时总价

@property (nonatomic, strong) NSArray<PorscheNewScheme *> *list1;//技师增项
@property (nonatomic, strong) NSArray<PorscheNewScheme *> *list2;//服务增项
@property (nonatomic, strong) NSArray<PorscheNewScheme *> *list3;//客户确认项目
@property (nonatomic, strong) NSMutableArray<PorscheNewScheme *> *solutionList;//整合方案list
@property (nonatomic, strong) NSNumber *lastaddstaffrole;//1.技师 3.服务顾问
@property (nonatomic, strong) OrderOptStatusDto *orderstatus;//状态model
@property (nonatomic, strong) RemindModel *msgcount;//提醒model
@property (nonatomic, strong) NSNumber *storeid;//4S店ID
//@property (nonatomic, strong) NSString *pctconfigure1;//车型配置
@property (nonatomic, strong) NSNumber *wodiscountprice;//折扣金额
@property (nonatomic, strong) NSNumber *discountprice; // 优惠金额
@property (nonatomic, strong) NSNumber *wodiscountrate;//折扣率
@property (nonatomic, strong) NSNumber *workhourdiscount;//工时折扣率
@property (nonatomic, strong) NSNumber *partdiscount;//备件折扣率



@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) ZLCamera *videoModel;

@property (nonatomic, copy) NSNumber *savecartypeid;  // 车型 最后一级pctid

//  服务档案专用的字段，因为cell使用的相同，不需要在重新定义了，直接使用，其他字段不使用
@property (nonatomic, strong) NSNumber *cid;//车辆id
@property (nonatomic, copy) NSString *carplate; //完整车牌
@property (nonatomic, copy) NSString *ccarcatena;  //车系
@property (nonatomic, copy) NSString *ccarmodel; //车型
@property (nonatomic, copy) NSString *cyearstyle;  //年款
//@property (nonatomic, copy) NSString *cvincode;//服务档案使用的VIN

// VIN 对应车型信息转化为四级列表
@property (nonatomic, copy) NSArray <PorscheCarSeriesModel *>*carSeries;
//// 固定VIN WP1AG2920DLA61285  车型信息
//@property (nonatomic, strong)PorscheCarSeriesModel *WP1AG2920DLA61285;
//// 固定VIN WPOAA2972FL003745  车型信息
//@property (nonatomic, strong)PorscheCarSeriesModel *WPOAA2972FL003745;
//// 固定VIN WP0AB2995AS720234  车型信息
//@property (nonatomic, strong)PorscheCarSeriesModel *WP0AB2995AS720234;
- (NSArray<PorscheCarSeriesModel *> *)parseVINCarseriesModelToPorscheCarSeriesModel;
- (NSArray *)getCarseries;
- (NSArray *)getCaroutputWithCarspctid:(NSNumber *)carspctid cartypepctid:(NSNumber *)cartypepctid caryearpctid:(NSNumber *)caryearpctid;
- (NSArray *)getCaryearWithCarspctid:(NSNumber *)carspctid cartypepctid:(NSNumber *)cartypepctid;
- (NSArray *)getCartypeWithCarspctid:(NSNumber *)pctid;
- (void)setDefaultSchemeList;//设置方案默认分类属性

// 如果当前车辆信息中没有 某个信息，那么就取旧的信息
+ (void)compareMergeCurrenCarinfo:(PorscheNewCarMessage *)currentCarinfo oldCarinfoInfo:(PorscheNewCarMessage *)oldCarinfo;

- (BOOL)isHasWofinishtime;

/**
 车辆是否在场

 @return 是否在场
 
 */
+ (BOOL)isOnFactoryWithWostatus:(NSNumber *)status;

/*
 车辆否在场并出提示
 */

/**
 如果车辆不在厂出提示

 @return 是否在厂
 */
+ (BOOL)isOnFactoryHintWithWostatus:(NSNumber *)status;

@end

@interface OrderOptStatusDto : NSObject
@property (nonatomic, strong) NSNumber *skipstep;//跳到哪个环节：0：当前页面   1：开单  2：技师增项  3：备件确认  4：服务沟通 5：客户确认
@property (nonatomic, strong) NSNumber *editable;//是否可编辑
@property (nonatomic, strong) NSNumber *statestart ;// 开单确认
@property (nonatomic, strong) NSNumber *stateincrease ;// 增项确认
@property (nonatomic, strong) NSNumber *statusworkshop ;// 车间确认
@property (nonatomic, strong) NSNumber *statepart ; // 备件确认

@property (nonatomic, strong) NSNumber *stateserice ;// 服务确认
@property (nonatomic, strong) NSNumber *statecustomer ;// 客户确认
@property (nonatomic, strong) NSNumber *stateguarantee ;// 保修确认

@property (nonatomic, strong) NSNumber *statuswaitpart ;//等待备件确认
@property (nonatomic, strong) NSNumber *statuswaitincrease ;//等待增项确认
@property (nonatomic, strong) NSNumber *statuswaitguarantee ;//等待保修确认
@property (nonatomic, strong) NSNumber *statuswaitworkshop ;//等待车间确认
//工单状态 -1.取消下单 1.开单信息 2.技师增项 3.备件确认 4.服务沟通 5.客户确认 7工单已确认 8.不在场 99 取消增项单
@property (nonatomic, strong) NSNumber *wostatus;
@property (nonatomic, strong) NSNumber *servicedisplay; // 1:显示保修审核中

- (BOOL)isShowBillingLighting;//开单确认
- (BOOL)isShowTechicianLighting;//技师确认
- (BOOL)isShowMaterialLighting;//备件确认
- (BOOL)isShowServiceConfirmBtLighting;//服务确认
- (BOOL)isShowCustomLighting;//客户确认

- (BOOL)isShowTechicianText;//技师确认/车间确认
- (NSInteger)getSwitch;//服务顾问七个跳转

@end


#pragma mark  业务分类model

@interface PorscheBusinessClassify : NSObject
@property (nonatomic, strong) NSNumber *businesstypeid;//业务分类ID
@property (nonatomic, strong) NSString *businesstypename;//分类名称
@property (nonatomic, strong) NSNumber *delstate;//删除0.未删除 1.已删除
@property (nonatomic, strong) NSNumber *deltime;//删除时间
@property (nonatomic, strong) NSNumber *deluserid;//删除人id
@property (nonatomic, strong) NSNumber *sorted;//排序
@property (nonatomic, strong) NSNumber *storeid;//门店id
- (instancetype)initWithDic:(NSDictionary *)dic;

@end

#pragma mark  保险公司

@interface PorscheInsuranceCompany : NSObject
@property (nonatomic, strong) NSNumber *woinsurecomid;//保险公司id
@property (nonatomic, strong) NSString *woinsurecomname;//保险公司名称
@property (nonatomic, strong) NSNumber *delstate;//删除0.未删除 1.已删除
@property (nonatomic, strong) NSNumber *deltime;//删除时间
@property (nonatomic, strong) NSNumber *deluserid;//删除人id
@property (nonatomic, strong) NSNumber *sorted;//排序
@property (nonatomic, strong) NSNumber *storeid;//门店id
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
#pragma mark  员工

@interface PorscheStaff : NSObject

@property (nonatomic, strong) NSNumber *storeid;//门店id
@property (nonatomic, strong) NSNumber *groupid;//员工部门id
@property (nonatomic, strong) NSString *groupname;//员工所在组名
@property (nonatomic, strong) NSNumber *departmentid;//员工部门id
@property (nonatomic, strong) NSString *departname;//员工所属部门
@property (nonatomic, strong) NSString *createtime;//员工添加时间
@property (nonatomic, strong) NSNumber *positionid;//员工职位id

@property (nonatomic, strong) NSString *deltime;//员工信息被删除时间
@property (nonatomic, strong) NSNumber *delstate;//删除状态
@property (nonatomic, strong) NSNumber *userid;//员工的账户id
//@property (nonatomic, strong) NSString *username;//员工的用户名
//@property (nonatomic, strong) NSString *password;//员工用户密码
@property (nonatomic, strong) NSString *positionname;//员工职位名称
@property (nonatomic, strong) NSString *nickname;//员工名字/昵称

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
#pragma mark  员工组别

@interface PorscheStaffGroup : NSObject
@property (nonatomic, strong) NSString *groupname;//组名
@property (nonatomic, strong) NSString *createtime;//组创建时间
@property (nonatomic, strong) NSNumber *groupid;//组id
@property (nonatomic, strong) NSNumber *storeid;//门店

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

#pragma mark  职位列表

@interface PorscheStaffPosition : NSObject
@property (nonatomic, strong) NSString *positionname;//组名
@property (nonatomic, strong) NSNumber *positionid;//组id
@property (nonatomic, strong) NSNumber *storeid;//门店

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

#pragma mark  方案级别
@interface PorscheSchemeLevel : NSObject

@property (nonatomic, strong) NSString *levelname;
@property (nonatomic, strong) NSNumber *levelid;

@end

#pragma mark  取消原因

@interface PorscheCancelBillingReason : NSObject
@property (nonatomic, strong) NSNumber *cancelreasonid;//保险公司id
@property (nonatomic, strong) NSString *cancelreason;//保险公司名称
@property (nonatomic, strong) NSNumber *delstate;//删除0.未删除 1.已删除
@property (nonatomic, strong) NSNumber *deltime;//删除时间
@property (nonatomic, strong) NSNumber *deluserid;//删除人id
@property (nonatomic, strong) NSNumber *sorted;//排序
@property (nonatomic, strong) NSNumber *storeid;//门店id
- (instancetype)initWithDic:(NSDictionary *)dic;

@end

#pragma mark  工时主组/子组数据
@interface PorscheItemTimeChildrenGroup : NSObject
@property (nonatomic, strong) NSNumber *value;//工时主组子组id
@property (nonatomic, strong) NSString *text;//工时主组子组名字
@property (nonatomic, strong) NSMutableArray *childrenList;//子组数组

@end
#pragma mark  备件主组ID
@interface PorscheMaterialMainGroup : NSObject
@property (nonatomic, strong) NSNumber *Id;//备件主组ID
@property (nonatomic, strong) NSString *groupname;//备件主组名称
- (instancetype)initWithDic:(NSDictionary *)dic;

@end

#pragma mark  开单信息视频地址------

@interface PorscheCarVideoMessage : NSObject
@property (nonatomic, strong) NSNumber *videoid;// 视频id
@property (nonatomic, strong) NSString *videourl;// 视频地址
@end

#pragma mark  备注信息------
@interface PorscheRemark : NSObject

@property (nonatomic, strong) NSString *womwoid;//所属工单号
@property (nonatomic, strong) NSString *womrecordperson;// 备注人
@property (nonatomic, strong) NSNumber *womtype; // 1 文字  2 录音
@property (nonatomic, strong) NSNumber *womid;//备注id
@property (nonatomic, strong) NSString *womrecorddate;//记录时间
@property (nonatomic, strong) NSString *remarkcontent;// 备注内容 或 录音url

@end

#pragma mark  新工单方案
@interface PorscheNewScheme : NSObject

@property (nonatomic, strong) NSNumber *statememo;//图片 0.未读  1.已读


@property (nonatomic, strong) NSNumber *schemeid;//方案在工单中id
@property (nonatomic, strong) NSNumber *wosstockid;//方案再库中的id
@property (nonatomic, strong) NSString *schemename;//方案名称
@property (nonatomic, strong) NSNumber *wossettlement;//结算方式 1.      内结  2.保修 3.自费
@property (nonatomic, strong) NSNumber *wosisconfirm;//客户是否确认过这个方案 1 确认过 其他没有确认过//确认结果 0：未确认  1：已选中 2已确认
@property (nonatomic, strong) NSString *wosremark;//方案备注
@property (nonatomic, strong) NSNumber *wosisguarantee;//保修是否被确认 0. 无 1.申请中(红保) 2确认(蓝保)
@property (nonatomic, strong) NSNumber *schemeaddstatus;//增项位置 2.技师 4.服务
@property (nonatomic, strong) NSNumber *workhouroriginalpriceforscheme;//方案工时原总计
@property (nonatomic, strong) NSNumber *partsoriginalpriceforscheme;//方案备件原总计
@property (nonatomic, strong) NSNumber *solutiontotaloriginalpriceforscheme;//方案原总计

@property (nonatomic, strong) NSNumber *workhouroriginalpriceforscheme1;//方案工时原总计--技师备件 显示
@property (nonatomic, strong) NSNumber *partsoriginalpriceforscheme1;//方案备件原总计--技师备件 显示
@property (nonatomic, strong) NSNumber *solutiontotaloriginalpriceforscheme1;//方案原总计--技师备件 显示

@property (nonatomic, strong) NSNumber *workhourpriceforscheme;//工时总计
@property (nonatomic, strong) NSNumber *partspriceforscheme;//备件总计
@property (nonatomic, strong) NSNumber *solutiontotalpriceforscheme;//方案总计

@property (nonatomic, strong) NSNumber *schemelevelid;//方案级别id 1.安全；2.隐患；3.信息；4.自定义
@property (nonatomic, strong) NSNumber *schemelevelname;//方案级别名称
@property (nonatomic, strong) NSMutableArray <PorscheNewSchemews *>*projectList;//备件工时列表
@property (nonatomic, strong) NSArray <PorscheNewWorkHourSchemews *>*workhours;//工时列表
@property (nonatomic, strong) NSArray <PorscheNewMaterialSchemews *>*parts;//备件列表
@property (nonatomic, strong) NSNumber *schemetype;//方案类型 1：厂方 2：本店;3 自定义方案
@property (nonatomic, strong) NSNumber *schemestate;//方案状态【0 临时 1：我的  2：待确认； 3:审核通过到本店 4：已发布 8：下架 9：已删除 】
@property (nonatomic, strong) NSNumber *schemeaddperson;//方案添加人
//操作参数
@property (nonatomic, strong) NSNumber *wosdiscountprice;//方案优惠价格
@property (nonatomic, strong) NSNumber *processflag;//增项状态值 1. 技师 2.服务顾问 3.客户确认
@property (nonatomic, strong) NSNumber *isshow;//是否显示增项标签。
@property (nonatomic, strong) NSNumber *shadowStatus;//方案是否显示工时和备件
@property (nonatomic, strong) NSNumber *isnew; // 1.当账户点击保存，另一个账户点击编辑，新增了方案；我查看时，这个新增方案右上角显示 NEW 图标（修改和删除，不特别显示） 工单中返回：isnew=1时显示

+ (NSArray *)componentWithTotalHeight:(CGFloat)totalHeight headerHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight rowHeight:(CGFloat)rowheight atDataSource:(NSArray * )dataSource;;

@end


#pragma mark  新工时备件列表
@interface PorscheNewSchemews : NSObject
@property (nonatomic, strong) NSNumber *wospwosid;//所属的方案在工单中id
@property (nonatomic, strong) NSNumber *schemewsid;//工时/备件id
@property (nonatomic, strong) NSNumber *stockid;//对应库id
@property (nonatomic, strong) NSNumber *schemesettlementway;//结算方式 1 内结 2 保修 3 自费
@property (nonatomic, strong) NSNumber *schemewsunitprice;//单价
@property (nonatomic, strong) NSNumber *schemewsunitprice_yuan;//原价
@property (nonatomic, strong) NSNumber *schemewstdiscount;//折扣率
@property (nonatomic, strong) NSNumber *schemewstotalprice;//工时/备件总计
@property (nonatomic, strong) NSNumber *schemewscount;//数量

@property (nonatomic, strong) NSString *schemewsname;//名称
@property (nonatomic, strong) NSString *customname;//自定义名称
@property (nonatomic, strong) NSString *parts_desc;//介绍
@property (nonatomic, strong) NSString *schemewscode;//工时/备件编号
@property (nonatomic, strong) NSString *schemewsphotocode;//备件图号

@property (nonatomic, strong) NSNumber *schemewsisconfirm;//备件库存是否确认 0未确认 1 确认
@property (nonatomic, strong) NSNumber *iscancel;//工时备件是否确认 0.未确认 1. 勾选 2.已确认
@property (nonatomic, strong) NSNumber *schemeswswarrantyconflg;//保修是否被确认 0无 1 申请中（红保） 2.确认（蓝保）


@property (nonatomic, strong) NSNumber *parts_status;//备件类型（1：厂方 2：本地 3 : 我的）',
@property (nonatomic, strong) NSNumber *parts_type;//发布状态（0：临时 1:待审批，2未发布 3：已发布 9:删除）


//--------------用到的参数，后台没给的
//@property (nonatomic, strong) NSNumber *wostockid;//所属方案在方案库的id
@property (nonatomic, strong) NSNumber *superschemesettlementway;//所属方案的结算方式//从方案获取
@property (nonatomic, strong) NSNumber *schemesubtype;//项目类型 1 工时 2备件
@property (nonatomic, strong) NSNumber *schemewsdiscounttotalprice;//工时/备件折扣总计
@property (nonatomic, strong) NSNumber *schemewstype;//1 方案附带工时/备件 2 临时自定义添加工时/备件 3.备件库工时库配件----在用

#warning 常备件参数变更
@property (nonatomic, strong) NSNumber *partsstocktype;//1表示常备件   0非常备件  !!(正常使用)
//@property (nonatomic, strong) NSNumber *partsstocktypebak;//1表示常备件   0非常备件  !!!(这个参数只在备件确认环节使用，帮助后台处理数据)
#warning 更换属性 只跟用户id有关
@property (nonatomic, strong) NSNumber *projectaddid;//添加人
//@property (nonatomic, strong) NSNumber *projectaddstatus;//在哪个状态添加的，1.技师添加 2.备件添加 3.服务添加

@property (nonatomic, strong) NSArray <ProscheMaterialLocationModel *>*partsstocklist;//库存列表

+ (instancetype)getSelfWithMarerial:(PorscheNewMaterialSchemews *)material;
+ (instancetype)getSelfWithWorkHour:(PorscheNewWorkHourSchemews *)workHour;

@end




@interface PorscheNewWorkHourSchemews : NSObject
//@property (nonatomic, strong) NSNumber *woshschemehourid;//'方案库工时主键ID',区分临时和备件库0.临时

@property (nonatomic, strong) NSNumber *woshschemeid;//工单方案id',
@property (nonatomic, strong) NSNumber *woshworkhourid;//工单工时id
@property (nonatomic, strong) NSNumber *woshstockid;//工时库工时id',
@property (nonatomic, strong) NSNumber *workhourstatus;//0:临时，1:待审批，2未发布 3：已发布  9：删除
@property (nonatomic, strong) NSString *workhourcodeall;//工时编号

@property (nonatomic, strong) NSString *workhourcode1;//工时编号',
@property (nonatomic, strong) NSString *workhourcode2;//工时编号',
@property (nonatomic, strong) NSString *workhourcode3;//工时编号',
@property (nonatomic, strong) NSString *workhourcode4;//工时编号',
@property (nonatomic, strong) NSString *workhourcode5;//工时编号',

@property (nonatomic, strong) NSString *woshworkhourname;//工时项目名称',
@property (nonatomic, strong) NSNumber *woshsettlement;//结算方式',

@property (nonatomic, strong) NSNumber *workhourprice;//单价',
@property (nonatomic, strong) NSNumber *workhourcount;//数量',
@property (nonatomic, strong) NSNumber *woshriginprice;//原价',
@property (nonatomic, strong) NSNumber *woshdiscountrate;//折扣率',
@property (nonatomic, strong) NSNumber *woshfinalprice;//折后价

@property (nonatomic, strong) NSNumber *woshisconfirm;//客户确认结果  0：未确认 1：选中 2：已确认',

@property (nonatomic, strong) NSNumber *woshisguarantee;//保修状态：0:无 1：申请中  2：已确认',
@property (nonatomic, strong) NSNumber *woshguaranteeperson;//保修确认人',
@property (nonatomic, strong) NSString *woshguaranteedate;//保修确认时间',

@property (nonatomic, strong) NSNumber *woshaddperson;//添加人id,
@property (nonatomic, strong) NSNumber *woshaddsource;//0:同方案一起加入 1：个别加入',


@end

@interface PorscheNewMaterialSchemews : NSObject
//@property (nonatomic, strong) NSNumber *wospschemepartid;//'方案库备件主键ID',

@property (nonatomic, strong) NSNumber *wospwosid;//工单方案id',
@property (nonatomic, strong) NSNumber *wospstockid;//备件库备件id',
@property (nonatomic, strong) NSNumber *wospid;//备件在工单中id',

@property (nonatomic, strong) NSNumber *wospsettlement;//结算方式',
@property (nonatomic, strong) NSNumber *price_after_tax;//单价',
@property (nonatomic, strong) NSNumber *parts_num;//数量',
@property (nonatomic, strong) NSNumber *wospriginprice;//原价',
@property (nonatomic, strong) NSNumber *wospdiscountrate;//折扣率',
@property (nonatomic, strong) NSNumber *wospfinalprice;//折后价',
@property (nonatomic, strong) NSNumber *wospisconfirm;//客户确认结果 0：未确认 1：选中 2： 已经确认',
@property (nonatomic, strong) NSNumber *wospstockisconfirm;//库存确认结果 1：已经确认 0：未确认',
@property (nonatomic, strong) NSNumber *wospisguarantee;//保修状态：0:无 1：申请中  2：已确认',

@property (nonatomic, strong) NSString *wosppartsname;//配件名称',
@property (nonatomic, strong) NSString *customname;//自定义名称',
@property (nonatomic, strong) NSString *parts_desc;//备件介绍',
@property (nonatomic, strong) NSString *parts_no_1;//备件编号1',
@property (nonatomic, strong) NSString *parts_no_2;//备件编号2',
@property (nonatomic, strong) NSString *parts_no_3;//备件编号3',
@property (nonatomic, strong) NSString *parts_no_4;//备件编号4',
@property (nonatomic, strong) NSString *parts_no_5;//
@property (nonatomic, strong) NSString *parts_no_6;//
@property (nonatomic, strong) NSString *image_no_1;//备件图号1',
@property (nonatomic, strong) NSString *image_no_2;//备件图号2',
@property (nonatomic, strong) NSString *image_no_3;//备件图号3',
@property (nonatomic, strong) NSString *image_no_4;//备件图号4',
@property (nonatomic, strong) NSString *image_no_5;//备件图号5',
@property (nonatomic, strong) NSString *image_no_all;//备件图号总名称',
@property (nonatomic, strong) NSString *parts_no_all;//备件编号总称',
@property (nonatomic, strong) NSNumber *parts_type;//备件类型（1：厂方 2：本地 3 : 我的）',
@property (nonatomic, strong) NSNumber *parts_status;//发布状态（0：临时 1:待审批，2未发布 3：已发布 9:删除）',

@property (nonatomic, strong) NSNumber *parts_stock_type;//0：非常备件  1：常备件
@property (nonatomic, strong) NSNumber *wospaddperson;//添加人id,
@property (nonatomic, strong) NSNumber *wospaddsource;//0:同方案一起加入 1：个别加入',
@property (nonatomic, strong) NSArray <ProscheMaterialLocationModel *>*partsstocklist;

@end
#pragma mark  库存列表
@interface ProscheMaterialLocationList : NSObject
@property (nonatomic, strong) NSNumber *stockid;//库存id
@property (nonatomic, strong) NSString *stockname;//库存名称

@end

#pragma mark  库存数据------
@interface ProscheMaterialLocationModel : NSObject
@property (nonatomic, strong) NSString *pbsamount;//库存数量
@property (nonatomic, strong) NSNumber *pbstockid;//库存类型 1：本店 2：PCN 3：PAG 4：无货 5:常备件
@property (nonatomic, strong) NSString *pbstockname;//库存名称

@property (nonatomic, strong) NSNumber *pbsid;//库存id
@property (nonatomic, strong) NSString *pbspbid;//备件库id
//手设参数
@property (nonatomic, strong) NSNumber *isAdd;//标记添加库存的按钮图片 0.删除 1.添加

@end

#pragma mark  结算方式model
@interface ProscheProjectSettlement : NSObject
@property (nonatomic, strong) NSNumber *settlementid;//结算方式id
@property (nonatomic, strong) NSString *settlementname;//结算方式名称

@end
#pragma mark  设置结算方式条件
@interface ProscheProjectSettlementCondition : NSObject
@property (nonatomic, strong) NSNumber *processstatus;//流程状态: 1、技师增项  2、服务沟通
@property (nonatomic, strong) NSNumber *schemeid;//方案id
@property (nonatomic, strong) NSNumber *settlementflg;//结算方式类型1.工时 2.备件 3.方案
@property (nonatomic, strong) NSNumber *settlementid;//结算方式id 1.内结 2.保修 3.自费
@property (nonatomic, strong) NSNumber *wsid;//工时/备件id

@end

#pragma mark  添加删除方案/工时至工单 条件model

@interface ProscheAdditionCondition : NSObject
@property (nonatomic, strong) NSNumber *processstatus;//流程状态
@property (nonatomic, strong) NSNumber *schemeid;//方案id
@property (nonatomic, strong) NSNumber *schemestockid;//库方案id
@property (nonatomic, strong) NSNumber *schemtype;//1.厂方2.本店 4.未完成  9.自定义方案
@property (nonatomic, strong) NSNumber *type;//方案:1.增加 2.删除      工时备件：1.工时2.备件
@property (nonatomic, strong) NSNumber *levelid;//方案级别 自定义项目需要


//工时/备件特殊需要 参数
// 添加
@property (nonatomic, strong) NSNumber *source;//工时备件来源//1.自定义2.库中
@property (nonatomic, strong) NSString *stockidbatch;//库中备件工时的id （多个时用 隔开拼接）
//删除 需要参数
@property (nonatomic, strong) NSNumber *wsid;

//匹配时 获取修改的图号和数量 价格
@property (nonatomic, strong) NSNumber *addnum;//备件数量
@property (nonatomic, strong) NSString *sparephotocode;////备件图号（跟前端约定，每段用' '分隔）
@property (nonatomic, strong) NSString *partsname;//添加的备件名称



@end

#pragma mark  编辑工单方案工时/备件 条件
@interface ProscheAdditionSchemewsCondition : NSObject
@property (nonatomic, strong) NSNumber *schemeid;//方案id
@property (nonatomic, strong) NSNumber *processstatus;//流程状态

//备件编辑
@property (nonatomic, strong) NSString *sparecode;//备件编号
@property (nonatomic, strong) NSNumber *sparecount;//备件数量
@property (nonatomic, strong) NSNumber *spareid;//备件id
@property (nonatomic, strong) NSString *sparename;//备件名称
@property (nonatomic, strong) NSNumber *spareunitprice;//备件单价
@property (nonatomic, strong) NSString *sparephotocode;//备件图号

//工时编辑
@property (nonatomic, strong) NSString *workhourcode;//工时编号 用“-”分开
@property (nonatomic, strong) NSNumber *workhourcount;//工时数量
@property (nonatomic, strong) NSNumber *workhourid;//工时id
@property (nonatomic, strong) NSString *workhourname;//工时名称
@property (nonatomic, strong) NSNumber *workhourunitprice;//工时单价

//工时/备件特殊需要 参数
// 添加
@property (nonatomic, strong) NSNumber *source;//工时备件来源//1.自定义2.库中
@property (nonatomic, strong) NSString *stockidbatch;//库中备件工时的id （多个时用-隔开拼接）
//删除 需要参数
@property (nonatomic, strong) NSNumber *wsid;

@end

#pragma mark  选择/不选 工时/备件/方案
@interface ProscheChooseSchemewsCondition : NSObject

@property (nonatomic, strong) NSNumber *projectid;//1:工时id or 2:备件id or 3:方案id
@property (nonatomic, strong) NSNumber *type;//1:工时 or 2:备件 or 3:方案
@property (nonatomic, strong) NSNumber *value;//0:未勾选    1：勾选


@end


#pragma mark  工时/备件 匹配参数

@interface ProscheSchemewsSearchCondition : NSObject
//工时增加参数
@property (nonatomic, strong) NSString *findtype;//1:厂方 2:本店
@property (nonatomic, strong) NSString *wocarcatena;//车系
@property (nonatomic, strong) NSString *wocarmodel;//车型
@property (nonatomic, strong) NSString *woyearstyle;//年款
@property (nonatomic, strong) NSString *storeid;//门店id

//重构之后工时编号匹配传递参数
@property (nonatomic, strong) NSNumber *pctid;//车系id；


//工时编号部分匹配
@property (nonatomic, strong) NSString *workhourcode1;//编号1
@property (nonatomic, strong) NSString *workhourcode2;//编号2
@property (nonatomic, strong) NSString *workhourcode3;//编号3
@property (nonatomic, strong) NSString *workhourcode4;//编号4
@property (nonatomic, strong) NSString *workhourcode5;//编号5
//工时全匹配/备件全匹配
@property (nonatomic, strong) NSString *data;//编号全称

//备件图号部分匹配
@property (nonatomic, strong) NSString *image_no_1;//图号1
@property (nonatomic, strong) NSString *image_no_2;//图号2
@property (nonatomic, strong) NSString *image_no_3;//图号3
@property (nonatomic, strong) NSString *image_no_4;//图号4
@property (nonatomic, strong) NSString *image_no_5;//图号5
//备件编号部分匹配
@property (nonatomic, strong) NSString *parts_no_1;//编号1
@property (nonatomic, strong) NSString *parts_no_2;//编号2
@property (nonatomic, strong) NSString *parts_no_3;//编号3
@property (nonatomic, strong) NSString *parts_no_4;//编号4
@property (nonatomic, strong) NSString *parts_no_5;//编号5
@property (nonatomic, strong) NSString *parts_no_6;//编号6
@property (nonatomic, strong) NSNumber *cartypeid;//车系id

@end
#pragma mark  折扣条件
@interface PorscheDiscountCondition : NSObject

@property (nonatomic, strong) NSNumber *wsid;//工时或者备件id
@property (nonatomic, strong) NSNumber *schemeid;//方案或者所属方案id
@property (nonatomic, strong) NSNumber *scope;//打折范围   1 当前   2 整个方案    3 整个方案的工时/备件     4 整单的工时/备件   5 整单（目前不用传5，没有该选项）
@property (nonatomic, strong) NSNumber *type;//1 工时    2 备件
@property (nonatomic, strong) NSNumber *rate;//折扣率


@end

#pragma mark  开单车辆提醒简单信息------

typedef NS_ENUM(NSInteger, PorscheCarMessageStyle) {
    PorscheCarMessageStyleUnread = 0,// 未读
    PorscheCarMessageStyleReaded,//已读
};
typedef NS_ENUM(NSInteger, PorscheCarMessageCategoryStyle) {
    PorscheCarMessageCategoryStyleItem = 0,// 方案
    PorscheCarMessageCategoryStylePrice,//价格
};

#pragma mark  提醒界面
@interface PorscheCarMessage : NSObject
//省会
@property (nonatomic, strong) NSString *carLocation;
//车牌号
@property (nonatomic, strong) NSString *carNumber;
//vin码
@property (nonatomic, strong) NSString *vinNumber;
//车型车系
@property (nonatomic, strong) NSString *carCategory;
//提示信息
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *changePrice;
@property (nonatomic, strong) NSNumber *schemeid;//方案id
@property (nonatomic, strong) NSNumber *noticeid;//key
//数据已读未读状态
@property (nonatomic, assign) PorscheCarMessageStyle modelStyle;

@property (nonatomic, assign) PorscheItemModelSelectedStyle selectedStyle;

@property (nonatomic, assign) NSString *categoryStyle;
- (instancetype)initWithDic:(NSDictionary *)dic;

+ (NSArray *)getCarNoticeModel:(NSInteger)integer;
//本店提醒数据
+ (NSArray *)getLocationCarNoticeModel:(NSInteger)integer;



@end

@class VINCartypeModel;
@interface VINCarseriesModel : NSObject

@property (nonatomic, strong) NSString *carscode;
@property (nonatomic, strong) NSString *cars;
@property (nonatomic, strong) NSArray <VINCartypeModel *> *cartypelist;
@property (nonatomic, strong) NSNumber *pctid;
@end

@class VINCarYearModel;
@interface VINCartypeModel : NSObject
@property (nonatomic, copy) NSString *cars;
@property (nonatomic, copy) NSString *carscode;
@property (nonatomic, copy) NSString *cartype;
@property (nonatomic, copy) NSString *cartypecode;
@property (nonatomic, copy) NSString *pctconfigure1;
@property (nonatomic, strong) VINCarYearModel *caryear;
@property (nonatomic, strong) NSNumber *pctid;

/*
 cars	车系名称	string	@mock=$order('Cayenne','Cayenne','Cayenne','Cayenne','Cayenne','Cayenne','Cayenne','Cayenne')
 carscode	车系code	string	@mock=$order('9PA','9PA','9PA','9PA','9PA','9PA','9PA','9PA')
 cartype	车型	string	@mock=$order('','Tiptronic','S','S Tiptronic','GTS','GTS Tiptronic','Turbo','Turbo S')
 cartypecode	车型gode	string	@mock=$order('AG7','AG1','AH7','AH1','AL7','AL1','AI1','AN1')
 caryear	年款	object
 displacement		object
 displacement	排量	string	@mock=3.6
 year		string	@mock=2009
 pctconfigure1		string	@mock=$order('','','','','','','','')
 */

@end

@class VINDsplacement;
@interface VINCarYearModel : NSObject
@property (nonatomic, copy) NSString *pctcartypeno; // cartypecode
@property (nonatomic, copy) NSString *pctcarsno;    // carscode
@property (nonatomic, copy) NSString *cartype;
@property (nonatomic, copy) NSString *cars;
@property (nonatomic, strong) NSArray <VINDsplacement *> *displacement;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *pctconfigure1;
@property (nonatomic, strong) NSNumber *pctid;

@end

@interface VINDsplacement : NSObject
@property (nonatomic, copy) NSString *displacement;
@property (nonatomic, strong) NSNumber *pctid;
@end
