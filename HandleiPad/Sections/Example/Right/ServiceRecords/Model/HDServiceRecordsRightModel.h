//
//  HDServiceRecordsRightModel.h
//  HandleiPad
//
//  Created by handou on 16/10/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HDServiceRecordsCarflgModel;
@class HDServiceRecordsRightDetailCellModel;
@class HDserviceDetailCellCustomModel;
@class HDServiceYearListModel;

@interface HDServiceRecordsRightModel : NSObject
@property (nonatomic, copy) NSString *carplate;//车牌
@property (nonatomic, copy) NSString *cartype;//车型
@property (nonatomic, copy) NSString *carcatena;//车系
@property (nonatomic, copy) NSString *yearstyle;//年款
@property (nonatomic, strong) NSNumber *infactorycount; // 进厂辆次
@property (nonatomic, strong) NSNumber *cancelnum;// 取消次数
@property (nonatomic, strong) NSNumber *lastyearinfactorycount;//最近一年进厂次数
@property (nonatomic, strong) NSNumber *miles; // 公里数 单位km
@property (nonatomic, copy) NSString *plateplace;//	车籍
@property (nonatomic, strong) NSNumber *recommendfinishedrate; // 推荐完成率
@property (nonatomic, strong) NSNumber *totalcostprice;//	累计消费金额
@property (nonatomic, strong) NSNumber *unfinishedamount;//未完成金额
@property (nonatomic, strong) NSNumber *unfinishedschemecount;//未完成项目数
@property (nonatomic, copy) NSString *vin;//VIN
@property (nonatomic, strong) NSNumber *averagecost;     // 平均消费额
@property (nonatomic, strong) NSArray<HDServiceRecordsCarflgModel *> *carflglist;//标签列表
@property (nonatomic, strong) NSArray<HDServiceYearListModel *> *workorderlist;//历史工单列表

//@property (nonatomic, strong) NSMutableArray *areadyfinishedlist;//服务列表

//+ (HDServiceRecordsRightModel *)dataFrom;

@end


/*
    ************************** 标签列表对象model *****************************
 */
@interface HDServiceRecordsCarflgModel : NSObject
@property (nonatomic, strong) NSNumber *carid;//车辆id
@property (nonatomic, strong) NSNumber *targetid;//标签id
@property (nonatomic, copy) NSString *targetname;//标签名称
@property (nonatomic, strong) NSNumber *targetstockid;//标签库id
@property (nonatomic, strong) NSNumber *width;//标签的长度
@end

/*
 ************************** 下拉提示框标签列表对象model *****************************
 */
@interface HDServiceRecordsCarflgTableViewModel : NSObject
@property (nonatomic, strong) NSNumber *targetid;//标签id
@property (nonatomic, copy) NSString *targetname;//标签名称
@end



/*
 ************************** 历史工单列表对象model *****************************
 */
@interface HDServiceRecordsRightDetailCellModel : NSObject
@property (nonatomic, copy) NSString *finisheddate; // 服务完成时间
@property (nonatomic, strong) NSNumber *miles; // 公里数 单位km
@property (nonatomic, strong) NSNumber *orderid; // 工单id
@property (nonatomic, strong) NSNumber *ordertotalprice; // 总价
@property (nonatomic, strong) NSNumber *wostatus;//工单状态
@property (nonatomic, strong) NSNumber *orderyear;//年份
@property (nonatomic, strong) NSArray<HDserviceDetailCellCustomModel *> *finishedSolutionlist;//已完成方案列表
@property (nonatomic, strong) NSArray<HDserviceDetailCellCustomModel *> *unfinishedSolutionlist;//未完成方案列表
@property (nonatomic, strong) NSNumber *orderundototalprice;  // 工单未完成方案总价

//@property (nonatomic, strong) NSNumber *undomiles; // 未完成服务 公里数 单位km
//@property (nonatomic, strong) NSMutableArray *schemelist;//已完成列表
//@property (nonatomic, strong) NSMutableArray *undolist;//未完成列表
@end


/*
 ************************** 年份分类model *****************************
 */
@interface HDServiceYearListModel : NSObject
@property (nonatomic, strong) NSNumber *year;   //年份
@property (nonatomic, strong) NSArray<HDServiceRecordsRightDetailCellModel *> *workorderlistdetail;//每个年份的list

//@property (nonatomic, strong) NSMutableArray *orderlist;
@end

/*
 ************************** 已完成方案列表(未完成方案列表)model *****************************
 */
@interface HDserviceDetailCellCustomModel : NSObject
@property (nonatomic, strong) NSNumber *schemeid; // 方案id
@property (nonatomic, copy) NSString *schemename; // 方案名称
@property (nonatomic, strong) NSNumber *schemeprice;  // 方案价格
@property (nonatomic, strong) NSNumber *guranteeflag; //1: 含有保修方案
@property (nonatomic, strong) NSNumber *innerflag;//1: 含有内结方案
@property (nonatomic, strong) NSNumber *doneflag;// 是否完成

@property (nonatomic, assign) BOOL isSelect;//是否选中
@end






