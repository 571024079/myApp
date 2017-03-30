//
//  PorscheCarSeriesModel.h
//  HandleiPad
//
//  Created by Handlecar on 2016/12/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PorscheCarTypeModel;
@class PorscheCarYearModel;
@class PorscheCarOutputModel;


@interface PorscheCarSeriesModel : NSObject
/*
 cars           车系名称        string	@mock=$order('Boxster','Cayman','911','Cayenne','Panamera','Cayenne','911','Boxster','Cayenne     (Unused)','Cayman','918','cayenne','Macan')
 carscode       车系code       string	@mock=$order('987','987','997','9PA','970','92A','991','981','92A','981','918','92A','95B')
 cartypelist            object
 */

@property (nonatomic, copy) NSString *cars;
@property (nonatomic, copy) NSString *carscode;
@property (nonatomic, copy)  id  cartypelist;
@property (nonatomic, copy) NSNumber *pctid;
// 自定义字段  全部车型选择列表使用 记录数据
@property (nonatomic, strong) NSMutableArray *selectCartypeArray;  // 选中车型
// 自定义字段 记录当前选中车车型信息  单选
@property (nonatomic, strong) PorscheCarTypeModel* cartypeInfo;
@property (nonatomic) BOOL isSelectAllCartypes;

- (void)clearSelectCartypeArray;

- (PorscheConstantModel *)constantModel; //转出常量model 用于列表选择
@end


@interface PorscheCarTypeModel : NSObject

/*
 cars           车系          string	@mock=$order('Cayman','Cayman','Cayman','Cayman')
 carscode       车系code      string	@mock=$order('987','987','987','987')
 cartype        车型          string	@mock=$order('','S','','')
 cartypecode	车型code      string	@mock=$order('11','12','13','78')
 caryear        年款
 pctconfigure1	车型配置       string	@mock=$order('','','Black Edition','R')
 */
@property (nonatomic, copy) NSNumber *pctid;
@property (nonatomic, copy) NSString *cars;
@property (nonatomic, copy) NSString *carscode;
@property (nonatomic, copy) NSString *cartype;
@property (nonatomic, copy) NSString *cartypecode;
@property (nonatomic, copy) NSString *caryear;
@property (nonatomic, copy) NSString *pctconfigure1;
// 自定义字段  全部车型选择列表使用 记录数据
@property (nonatomic, strong) NSMutableArray *selectCaryearArray;  // 选中年款
// 自定义字段 记录当前选中年款信息   单选
@property (nonatomic, strong) PorscheCarYearModel* caryearInfo; // 当前选择年款
@property (nonatomic) BOOL isSelectAllCaryears;
- (void)clearSelectCaryearArray;

- (PorscheConstantModel *)constantModel; //转出常量model 用于列表选择

@end

@interface PorscheCarYearModel : NSObject

/*
 displacement       排量
 year               年款	string	@mock=$order('2009','2010','2011','2012')
 */
@property (nonatomic, copy) NSString *displacement;
@property (nonatomic, copy) NSString *year;
// 接口后续修改新增字段
@property (nonatomic, copy) NSString *cartype;          // 车型
@property (nonatomic, copy) NSString *pctcartypeno;     // 车型code
@property (nonatomic, copy) NSString *pctconfigure1;    // 配置信息
@property (nonatomic, copy) NSString *pctcarsno;        // 车系code
@property (nonatomic, copy) NSString *cars;             // 车系
@property (nonatomic, copy) NSNumber *pctid;



// 自定义字段  全部车型选择列表使用 记录数据
@property (nonatomic, strong) NSMutableArray *selectCaroutputArray;  // 选中排量字段
// 自定义字段 记录当前选中排量信息   单选
@property (nonatomic, strong) PorscheCarOutputModel* caroutputInfo; // 当前选择排量
@property (nonatomic) BOOL isSelectAllCaroutputs;

- (void)clearSelectCaroutputArray;

- (PorscheConstantModel *)constantModel; //转出常量model 用于列表选择

@end


@interface PorscheCarOutputModel : NSObject
//displacement	排量	string	@mock=2.9  单选
@property (nonatomic, copy) NSString *displacement;
@property (nonatomic, copy) NSNumber *pctid;

- (PorscheConstantModel *)constantModel; //转出常量model 用于列表选择

@end
