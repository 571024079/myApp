//
//  PorscheSchemeModel.h
//  HandleiPad
//
//  Created by Robin on 2016/11/17.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PorscheCarModel.h"

@class PorscheSchemeCarModel,PorscheSchemeMilesModel,PorscheSchemeMonthModel,PorscheSchemeSpareModel,PorscheBusinessModel,PorscheSchemeWorkHourModel,PorscheSchemeFavoriteModel,PorscheNewScheme;
@interface PorscheSchemeModel : NSObject

@property (nonatomic, strong) NSMutableArray<PorscheSchemeCarModel *> *carlist; //车系
@property (nonatomic, strong) PorscheSchemeMilesModel *miles; //公里数相关
@property (nonatomic, strong) PorscheSchemeMonthModel *month; //月数相关
@property (nonatomic, strong) NSNumber *schemeid; //方案id
@property (nonatomic, strong) NSNumber *schemelevelid; //方案级别id 1.安全；2.隐患；3.信息；4.自定义
@property (nonatomic, copy) NSString *schemelevelname; //方案级别名称
@property (nonatomic, copy) NSString *schemename; //方案名称
@property (nonatomic, strong) NSNumber *schemeprice; //方案小计
@property (nonatomic, strong) NSNumber *schemetype; //方案类型【1：厂方 2：本店;3 我的 4.自定义
@property (nonatomic, strong) NSNumber *schemestate; //方案状态【1：待确认； 2:审核通过到本店；3：审核未通过】
@property (nonatomic, strong) NSNumber *schemefabustate; //	发布状态
@property (nonatomic, strong) NSString *woserialno;//增项单号
@property (nonatomic, strong) NSArray<PorscheSchemeSpareModel *> *sparelist; //备件
@property (nonatomic, strong) NSNumber *sparepriceall; //备件小计
@property (nonatomic, strong) NSNumber *storeid; //4s店id
@property (nonatomic, strong) NSArray<PorscheBusinessModel *> *typelist; //类型
@property (nonatomic, strong) NSArray<PorscheSchemeWorkHourModel *> *workhourlist; 	//工时
@property (nonatomic, strong) NSNumber *workhourpriceall; //工时小计
@property (nonatomic, strong) NSArray<PorscheSchemeFavoriteModel *> *favoritelist; //收藏夹
@property (nonatomic, strong) NSString *favoriteids;//修改后的收藏夹的id数组字符串  1,2,3
@property (nonatomic, strong) NSNumber *scfid;//key
@property (nonatomic, strong) NSString *workhourgroupfuname;//主组
@property (nonatomic, strong) NSString *workhourgroupsname;//子组

@property (nonatomic, assign) BOOL inFavorite; //前端使用，用于判断是否为收藏夹内的方案
@property (nonatomic, assign) BOOL notSelect; //前端使用，用于判断是否可加入工单
@property (nonatomic, strong) NSString *business; //业务分类
@property (nonatomic, strong) NSNumber *source; // 1 来源于收藏夹

/****开单相关 多出来的参数****/
@property (nonatomic, strong) NSNumber *orderschemeid;//区分未完成晚安在老工单中的方案id

@property (nonatomic, strong) NSNumber *ordersolutionid;//方案再工单中的id
@property (nonatomic, strong) NSNumber *flag;//0当前方案不在工单 1当前方案在工单
@property (nonatomic, strong) NSNumber *schemeisempty;//方案是否为空
@property (nonatomic, strong) NSNumber *shadowStatus;//用户操作，不传后台:方案下拉 状态 @1默认显示下拉  @2不显示下拉工时，备件
@property (nonatomic, strong) NSNumber *wosisconfirm;//客户确认状态 其他客户未确认, @1客户确认,
@property (nonatomic, strong) NSNumber *wosisfinished;//方案是否选择  1选择 0未选择
@property (nonatomic, strong) NSString *wosoperator;// 方案添加人
@property (nonatomic, strong) NSNumber *schemeaddstatus;//在哪个节点添加的项目：1技师 2服务沟通
@property (nonatomic, strong) NSNumber *wossource;//方案来源 1 方案 2 自定义项目 3个人修改
@property (nonatomic, strong) NSNumber *wossettlement;//方案结算方式 1. 内结  2.保修 3.自费
@property (nonatomic, strong) NSNumber *schemeswarranty;//方案保修确认状态 1 技师保修  2 服务保修 其他无保修;

@property (nonatomic, strong) NSNumber *schemesettlementwaystatus;//结算方式设置的流程状态 1 技师  2 服务;
@property (nonatomic, assign) NSNumber *isshow;//方案是否显示确认状态 显示总是处于类别数组的第一个  <客户已确认，技师增项，服务增项> 0不显示确认/增项标记 1显示确认/增项标记
@property (nonatomic, strong) NSString *schemeworkhourtotalprice;// 方案工时总计
@property (nonatomic, strong) NSString *schemeworkhouroriginaltotalprice;// 方案工时原总计
@property (nonatomic, strong) NSString *schemesparetotalprice;// 方案备件总计
@property (nonatomic, strong) NSString *schemespareoriginaltotalprice;// 方案备件原总计
@property (nonatomic, strong) NSString *schemeremark;// 方案备注
@property (nonatomic, strong) NSString *schemepreferentialprice;// 方案优惠金额
@property (nonatomic, strong) NSString *schemenowprice;// 方案总计
@property (nonatomic, strong) NSNumber *schemerelationorderid; // 工单来源id
@property (nonatomic, strong) NSNumber *saveType;  // 1 保存为我的方案并加入工单

- (NSString *)checkParameter;

@end

@interface PorscheSchemeCarModel : NSObject

@property (nonatomic, strong) NSNumber *orderid; //车id
@property (nonatomic, strong) NSNumber *scarid; //key 修改的时候传，添加的时候为0
@property (nonatomic, copy) NSString *wocarcatena; //车系
@property (nonatomic, copy) NSString *wocarcatenacode; //车系code
@property (nonatomic, copy) NSString *wocarmodel; //车型
@property (nonatomic, copy) NSString *wocarmodelcode; //车型code
@property (nonatomic, copy) NSString *wooutputvolume; //排量配置
@property (nonatomic, copy) NSString *woyearstyle; //年款
@property (nonatomic, strong) NSNumber *flag; //操作类型【0.所有；1.基础；2.间隔时间；3.公里数；4.车型；5.工时；6.备件；7.业务类型】
@property (nonatomic, copy) NSNumber *scartypeid; // 车型最后一层 pctid

- (NSString *)carSting;
- (NSString *)cartypename;
@end

/**
 方案公里数相关
 */
@interface PorscheSchemeMilesModel : NSObject

@property (nonatomic, strong) NSNumber *milesid; //公里数id
@property (nonatomic, strong) NSNumber *rangetype; //1：公里范围 2:公里数浮动 3：公里数循环
@property (nonatomic, strong) NSNumber *beginmiles; //公里数起始
@property (nonatomic, strong) NSNumber *endmiles; //公里数结束
@property (nonatomic, strong) NSNumber *allmiles; //总公里数
@property (nonatomic, strong) NSNumber *personmemiles; //公里数基准[每多少公里]
@property (nonatomic, strong) NSNumber *startmiles; //首次公里数
@property (nonatomic, strong) NSNumber *upfloatmiles; //公里数上浮
@property (nonatomic, strong) NSNumber *downfloatmiles; //公里数下浮

@property (nonatomic, strong) NSNumber *workhourid;//工时id

- (NSString *)milesString;

@end

/**
 方案月数相关
 */
@interface PorscheSchemeMonthModel : NSObject

@property (nonatomic, strong) NSNumber *downfloatmonth; //下浮月数
@property (nonatomic, strong) NSNumber *monthid; //月数id
@property (nonatomic, strong) NSNumber *startmonth; //适用开始月数
@property (nonatomic, strong) NSNumber *timeintervalmonth; //适用间隔月数
@property (nonatomic, strong) NSNumber *upfloatmonth; //上浮月数

- (NSString *)monthString;

@end

#pragma mark - 备件
@interface PorscheSchemeSpareModel : NSObject

@property (nonatomic, copy) NSString *parts_no_1; //备件编号1
@property (nonatomic, copy) NSString *parts_no_2;
@property (nonatomic, copy) NSString *parts_no_3;
@property (nonatomic, copy) NSString *parts_no_4;
@property (nonatomic, copy) NSString *parts_no_5;
@property (nonatomic, copy) NSString *parts_no_6;

@property (nonatomic, strong) NSNumber *scspid; //key
@property (nonatomic, strong) NSNumber *parts_num; //备件数量
@property (nonatomic, strong) NSNumber *group_id; //备件组别id
@property (nonatomic, copy) NSString *group_name; //备件组别名字
@property (nonatomic, strong) NSNumber *parts_id; //备件id
@property (nonatomic, copy) NSString *parts_name; //备件名称
@property (nonatomic, copy) NSString *image_no_1; //备件图号1
@property (nonatomic, copy) NSString *image_no_2; //备件图号2
@property (nonatomic, copy) NSString *image_no_3; //备件图号3
@property (nonatomic, copy) NSString *image_no_4; //备件图号4
@property (nonatomic, strong) NSNumber *price_after_tax; //备件单价/税后价格
@property (nonatomic, strong) NSNumber *sparepriceall; //备件单条总价
@property (nonatomic, strong) NSNumber *parts_type; //备件类型（1：厂方 2：本地 3 : 我的）

@property (nonatomic, assign) BOOL inFavorite; //返回参数没有 用于方案收藏夹在库中的筛选

//备件详情
@property (nonatomic, strong) NSNumber *auditer;//审核人
@property (nonatomic, strong) NSNumber *creater;//创建人
@property (nonatomic, strong) NSNumber *deleter;//删除人
@property (nonatomic, copy) NSString *parts_area; //区域
@property (nonatomic, strong) NSNumber *parts_check_status;//备件审核状态（1：待确认 2:已确认） 确认后修改备件类型为本地
@property (nonatomic, copy) NSString * parts_desc; //备件描述
@property (nonatomic, strong) NSNumber *parts_level; //备件级别ID
@property (nonatomic, copy) NSString *levelname; //备件级别名
@property (nonatomic, strong) NSNumber *parts_stock_type; //库存类型（1：常备件 0：不是常备件）
@property (nonatomic, strong) NSNumber *price_before_tax; //税前价格
//@property (nonatomic, strong) NSNumber *send_status; //发布状态（0:未发布，1：已发布）
@property (nonatomic, strong) NSNumber *store_id; //4sID

//工单详情 必须参数
@property (nonatomic, strong) NSNumber *orderspareid; //
@property (nonatomic, strong) NSNumber *parts_status; //  `parts_status` int(1) DEFAULT '0' COMMENT '发布状态（0：临时 1:待审批，2未发布 3：已发布 9:删除）',


- (NSString *)speraCode; //完整编号

- (NSString *)speraImageCode; //完整图号

- (void)setupPartNumber:(NSString *)sting; //更具字符串设置编号 要求字符之间用" "分开
- (void)setupPartNumberWithArray:(NSArray<NSString *> *)array;

- (void)setupImageNumber:(NSString *)sting; //更具字符串设置图号 要求字符之间用" "分开
- (void)setupImageNumberWithArray:(NSArray<NSString *>*)imagenos;//
- (NSString *)checkParameter; //判断是否数据完整
- (NSString *)checkSchemeSpareParameter; //判断方案中是否数据完整


- (NSArray *)spareCodes;   // 编号
- (NSArray *)spareImageCodes; // 图号

- (void)setParts_no:(NSString *)no atIndex:(NSInteger)index;
- (void)setImage_no:(NSString *)no atIndex:(NSInteger)index;

@end

/**
 类型
 */
@interface PorscheBusinessModel : NSObject

@property (nonatomic, strong) NSNumber *businesstypeid; //业务类型id
@property (nonatomic, copy) NSString *businesstypename; //业务名称
@property (nonatomic, strong) NSNumber *sbid; //key	修改的时候传，添加的时候为0

//备件用的
@property (nonatomic, strong) NSNumber *relationId; //关联ID

@end


#pragma mark - 工时
@interface PorscheSchemeWorkHourModel : NSObject

@property (nonatomic, strong) NSMutableArray <PorscheSchemeCarModel *> *cars; //适用车型

@property (nonatomic, strong) NSNumber *schid; //key 修改的时候传，添加的时候为0
@property (nonatomic, copy) NSString *workhourcode1; //工时编号1
@property (nonatomic, copy) NSString *workhourcode2;
@property (nonatomic, copy) NSString *workhourcode3;
@property (nonatomic, copy) NSString *workhourcode4;
@property (nonatomic, copy) NSString *workhourcode5;
@property (nonatomic, strong) NSNumber *workhourcount; //工时数量
@property (nonatomic, strong) NSString *workhourgroupfuid; //工时主组id
@property (nonatomic, copy) NSString *workhourgroupfuname; //工时主组名字
@property (nonatomic, strong) NSString *workhourgroupid; //工时子组id
@property (nonatomic, copy) NSString *workhourgroupname; //工时子组名字
@property (nonatomic, strong) NSNumber *workhourid; //工时id
@property (nonatomic, copy) NSString *workhourname; //工时名称
@property (nonatomic, strong) NSNumber *workhourprice; //工时项目单价
@property (nonatomic, strong) NSNumber *workhourpriceall; //工时单条总价
@property (nonatomic, strong) NSNumber *workhourtype;	//工时类型（0:厂方 1:本店 2:我的备件
@property (nonatomic, strong) NSNumber *creater;//创建者

@property (nonatomic, assign) BOOL inFavorite; //返回参数没有 用于方案收藏夹在库中的筛选

@property (nonatomic, strong) NSString *cartypename;//车系相关
//详情
@property (nonatomic, strong) NSNumber *workhourlevel;//工时级别
@property (nonatomic, copy) NSString *workhourlevelname;//工时级别名称
@property (nonatomic, strong) NSNumber *storeid; //4s店ID
@property (nonatomic, copy) NSString *workhourcodeall;//	编号全称


//显示详情参数 必须
@property (nonatomic, strong) NSNumber *orderworkhourid; //

@property (nonatomic, strong) NSNumber *workhourstatus; //  `parts_status` int(1) DEFAULT '0' COMMENT '发布状态（0：临时 1:待审批，2未发布 3：已发布 9:删除）',


- (void)setupWorkHourNumber:(NSString *)sting;
- (void)setupWorkHourNumberWithArray:(NSArray<NSString *> *)array;

- (NSString *)workHourCode; //获取完整编号
- (NSArray *)workHourCodes;

- (NSString *)checkParameter; //判断是否数据完整

- (NSString *)checkSchemeWorkhourParameter; //判断方案中数据完整
- (void)setWorkhourcode:(NSString *)code atIndex:(NSInteger)index;
@end

#pragma mark - 收藏夹
@interface PorscheSchemeFavoriteModel : NSObject

@property (nonatomic, strong) NSNumber *favoriteid; //	收藏夹id
@property (nonatomic, copy) NSString *favoritename; //	收藏夹名称
@property (nonatomic, strong) NSArray<PorscheSchemeModel *> *schemelist; //方案
@property (nonatomic, strong) NSNumber *storeid; //4s店ID

@end
