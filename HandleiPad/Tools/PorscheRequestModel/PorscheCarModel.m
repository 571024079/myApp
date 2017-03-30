//
//  PorscheCarModel.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/17.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheCarModel.h"
#import "HDLeftSingleton.h"
#import "HDHintText.h"
@implementation PorscheCarModel

@end
#pragma mark  库存列表
@implementation ProscheMaterialLocationList



@end
#pragma mark  ------库存model
@implementation ProscheMaterialLocationModel



@end
#pragma mark  结算方式model
@implementation ProscheProjectSettlement

@end
#pragma mark  结算方式条件
@implementation ProscheProjectSettlementCondition


@end
#pragma mark  ------添加方案至工单条件 model
@implementation ProscheAdditionCondition


@end

#pragma mark  编辑工单方案工时 条件
@implementation ProscheAdditionSchemewsCondition


@end
#pragma mark  选择 配件/工时/方案
@implementation ProscheChooseSchemewsCondition

@end
#pragma mark  工时/备件 匹配参数

@implementation ProscheSchemewsSearchCondition

@end
#pragma mark  保险公司

@implementation PorscheInsuranceCompany
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

#pragma mark  员工
@implementation PorscheStaff
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
#pragma mark  员工组别

@implementation PorscheStaffGroup
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

#pragma mark  员工职位

@implementation PorscheStaffPosition
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

#pragma mark  取消原因

@implementation PorscheCancelBillingReason
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

#pragma mark  业务分类

@implementation PorscheBusinessClassify

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
#pragma mark  工时主组/子组

@implementation PorscheItemTimeChildrenGroup

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"children"]) {
        if (value) {
            NSMutableArray *array = (NSMutableArray *)value;
            if (array.count) {
                for (NSDictionary *dic in array) {
                    PorscheItemTimeChildrenGroup *model = [PorscheItemTimeChildrenGroup new];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.childrenList addObject:model];
                }
            }
            
        }
    }
}
- (NSMutableArray *)childrenList {
    if (!_childrenList) {
        _childrenList = [NSMutableArray array];
    }
    return _childrenList;
}

@end


#pragma mark  备件主组

@implementation PorscheMaterialMainGroup

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _Id = value;
    }
}

@end



@implementation PorscheNewScheme

+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"workhours" : [PorscheNewWorkHourSchemews class],
             @"parts" : [PorscheNewMaterialSchemews class]};
}


+ (NSArray *)componentWithTotalHeight:(CGFloat)totalHeight headerHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight rowHeight:(CGFloat)rowheight atDataSource:(NSArray *)dataSource
{
    NSMutableArray *componentArrays = [NSMutableArray array];
    
    // 当前页面内容的高度
    CGFloat currentPageHeight = 0;
    
    for (PorscheNewScheme *porscheme in dataSource)
    {
        // 一个方案 sectionHeader 的高度
        CGFloat schemeGroupHeight = headerHeight;
        currentPageHeight += schemeGroupHeight;
        
        // 当前方案工时备件组合
        NSMutableArray *wsArray = [NSMutableArray array];
        
        // 方案的 sectionHeader + sectionFooter 的高度，再加上每个方案中工时或备件行的高度
        for (PorscheNewSchemews *ws in porscheme.projectList )
        {
            currentPageHeight += rowheight;
            // 当前页的高度大于页面限制高度 需要进行分页处理
            if (currentPageHeight > totalHeight)
            {
                
                porscheme.projectList = wsArray;
                
                
            }
            // 如果当前页面的高度不超过页面高度限制，那么直接记录
            else
            {
                [wsArray addObject:ws];
            }
        }
    }
    
    return componentArrays;
}

@end

@implementation PorscheNewCarMessage
+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"attachments" : [PorscheResponserPictureVideoModel class],
             @"list1" : [PorscheNewScheme class],
             @"list2" : [PorscheNewScheme class],
             @"list3" : [PorscheNewScheme class],
             @"carslist" : [VINCarseriesModel class],
             @"attachmentsforsign":[PorscheResponserPictureVideoModel class],
             @"attachmentsfordrivinglicense":[PorscheResponserPictureVideoModel class]};
}

- (void)setDefaultSchemeList {
    [self setupProcessflag];
    [self setupSolutionList];
    [self setSchemePorperty];
    [self setupDiscountPrice];
}

- (void)setupProcessflag {
    [self setupSchemeProcessflag:_list1 number:@1];
    [self setupSchemeProcessflag:_list2 number:@2];
    [self setupSchemeProcessflag:_list3 number:@3];
}

- (BOOL)isHasWofinishtime
{
    if (self.wofinishtime.length)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isOnFactoryWithWostatus:(NSNumber *)status;
{
    if ([status isEqualToNumber:@8] || [status isEqualToNumber:@99])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
+ (BOOL)isOnFactoryHintWithWostatus:(NSNumber *)status
{
    BOOL ret = [PorscheNewCarMessage isOnFactoryWithWostatus:status];
    
    if (ret == NO)
    {
        NSString *message = nil;
        if ([status isEqualToNumber:@8])
        {
            message = HDAreadyTakeCarHintText;
        }
        else if ([status isEqualToNumber:@99])
        {
            message = HDAreadyCancelOrderHintText;
        }
        if (message.length)
        {
            [HDHintText showExceptionHint:message];
        }
        return  ret;
    }
    return YES;
}
+ (void)compareMergeCurrenCarinfo:(PorscheNewCarMessage *)currentCarinfo oldCarinfoInfo:(PorscheNewCarMessage *)oldCarinfo
{
    
        // 保修状态
    if ([currentCarinfo.crepair integerValue] < 1)
    {
        currentCarinfo.crepair = oldCarinfo.crepair;
    }
        // 保修到期日
    if (currentCarinfo.crepairtime.length == 0)
    {
        currentCarinfo.crepairtime = oldCarinfo.crepairtime;
    }
        // 首登日期
    if (currentCarinfo.cregisterdate.length == 0)
    {
        currentCarinfo.cregisterdate = oldCarinfo.cregisterdate;
    }
        // 车型信息
    if ([oldCarinfo.savecartypeid integerValue] > 0)
    {
        currentCarinfo.carsid =  oldCarinfo.carsid;
        currentCarinfo.cartypeid = oldCarinfo.cartypeid;
        currentCarinfo.caryearid = oldCarinfo.caryearid;
        currentCarinfo.cardisplacementid = oldCarinfo.cardisplacementid;
        
        currentCarinfo.savecartypeid = oldCarinfo.ccartypeid;
        /*
         @property (nonatomic, strong) NSString *wocarcatena; // 车系名称
         @property (nonatomic, strong) NSString *wocarmodel; // 车型名称
         @property (nonatomic, strong) NSString *woyearstyle; // 年款name
         @property (nonatomic, strong) NSString *wooutputvolume;// 排量名称
         */
        currentCarinfo.wocarcatena = oldCarinfo.wocarcatena;
        currentCarinfo.wocarmodel = oldCarinfo.wocarmodel;
        currentCarinfo.woyearstyle = oldCarinfo.woyearstyle;
        currentCarinfo.wooutputvolume = oldCarinfo.wooutputvolume;
        
    }
    
    
    if (oldCarinfo.cvincode.length > 0)
    {
        currentCarinfo.cvincode = oldCarinfo.cvincode;
    }
    
    
    if (oldCarinfo.ccarplate.length && oldCarinfo.plateplace.length)
    {
        currentCarinfo.ccarplate = oldCarinfo.ccarplate;
        currentCarinfo.plateplace = oldCarinfo.plateplace;
    }
    
        // 保险公司
    if (currentCarinfo.cinsurecomname.length == 0)
    {
        currentCarinfo.cinsurecomid = oldCarinfo.cinsurecomid;
        currentCarinfo.cinsurecomname = oldCarinfo.cinsurecomname;
    }
        // 保险到期日
    if (currentCarinfo.cinsureenddate.length == 0)
    {
        currentCarinfo.cinsureenddate = oldCarinfo.cinsureenddate;
    }
}

- (void)setupSchemeProcessflag:(NSArray *)array number:(NSNumber *)number {

    if (array.count) {
        for (int i = 0; i < array.count; i ++) {
            PorscheNewScheme *scheme = array[i];
            
            scheme.processflag = number;
            scheme.shadowStatus = @1;
            scheme.isshow = @0;
//            scheme.wosdiscountprice = @([scheme.solutiontotaloriginalpriceforscheme floatValue] - [scheme.solutiontotalpriceforscheme floatValue]);
            
            [self setupProjectListWithScheme:scheme];
            
//            if ([_wostatus isEqual:@7]) {//客户确认过了
                if (i == 0) {
                    scheme.isshow = @1;
                }
        }
    }
}

- (void)setupProjectListWithScheme:(PorscheNewScheme *)scheme {
    scheme.projectList = [NSMutableArray array];
    if (scheme.workhours.count) {
        for (PorscheNewWorkHourSchemews *workHour in scheme.workhours) {
            PorscheNewSchemews *schemews = [PorscheNewSchemews getSelfWithWorkHour:workHour];
            [scheme.projectList  addObject:schemews];
        }
    }
    
    if (scheme.parts.count) {
        for (PorscheNewMaterialSchemews *material in scheme.parts) {
            PorscheNewSchemews *schemews = [PorscheNewSchemews getSelfWithMarerial:material];
            [scheme.projectList  addObject:schemews];
        }
    }
}

- (void)setupSolutionList {
    _solutionList = [NSMutableArray new];
    if ([_lastaddstaffrole isEqual:@1]) {//技师
        [_solutionList addObjectsFromArray:_list1];
        [_solutionList addObjectsFromArray:_list2];
        [_solutionList addObjectsFromArray:_list3];
    }else {
        [_solutionList addObjectsFromArray:_list2];
        [_solutionList addObjectsFromArray:_list1];
        [_solutionList addObjectsFromArray:_list3];
    }
}

- (void)setupDiscountPrice {
    _wodiscountprice = _discountprice;//@([_ordertotaloriginalprice floatValue] - [_ordertotalprice floatValue]);
}

- (void)setSchemePorperty {
    [HDLeftSingleton shareSingleton].carModel = self;
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    
}

- (NSNumber *)cycartypeid
{
    NSNumber *cycartypeid = nil;
    if ([self.carsid integerValue])
    {
        cycartypeid = self.carsid;
    }
    
    if ([self.cartypeid integerValue])
    {
        cycartypeid = self.cartypeid;
    }
    
    if ([self.caryearid integerValue])
    {
        cycartypeid = self.caryearid;
    }
    return cycartypeid;
}

- (NSArray<PorscheCarSeriesModel *> *)parseVINCarseriesModelToPorscheCarSeriesModel
{
    
    NSMutableArray *carSeries = [NSMutableArray array];
    for (VINCarseriesModel *VINcars in self.carslist) {
        
        PorscheCarSeriesModel *cars = [[PorscheCarSeriesModel alloc] init];
        cars.cars = VINcars.cars;
        cars.carscode = VINcars.carscode;
        cars.pctid = VINcars.pctid;
        
        for (VINCartypeModel *VINCartype in VINcars.cartypelist)
        {
            PorscheCarTypeModel *cartype = [[PorscheCarTypeModel alloc] init];
            cartype.cars = VINCartype.cars;
            cartype.pctid = VINCartype.pctid;

            // 添加年款
            PorscheCarYearModel *year = [[PorscheCarYearModel alloc] init];
            year.year = VINCartype.caryear.year;
            /*
             @property (nonatomic, copy) NSString *cartype;          // 车型
             @property (nonatomic, copy) NSString *pctcartypeno;     // 车型code
             @property (nonatomic, copy) NSString *pctconfigure1;    // 配置信息
             @property (nonatomic, copy) NSString *pctcarsno;        // 车系code
             @property (nonatomic, copy) NSString *cars;             // 车系
             */
            year.cartype = VINCartype.caryear.cartype;
            year.pctcartypeno = VINCartype.caryear.pctcartypeno;
            year.pctconfigure1 = VINCartype.caryear.pctconfigure1;
            year.pctcarsno = VINCartype.caryear.pctcarsno;
            year.cars = VINCartype.caryear.cars;
            year.pctid = VINCartype.caryear.pctid;

            
            cartype.cars = VINCartype.caryear.cars;
            cartype.carscode = VINCartype.caryear.pctcarsno;
            cartype.cartypecode = VINCartype.caryear.pctcartypeno;
            cartype.cartype = VINCartype.caryear.cartype;;
            cartype.pctconfigure1 = VINCartype.pctconfigure1;
            
            
            
            // 添加排量
            for (VINDsplacement *displacement in VINCartype.caryear.displacement) {
                PorscheCarOutputModel *output = [[PorscheCarOutputModel alloc] init];
                output.displacement = displacement.displacement;
                output.pctid = displacement.pctid;
                
                [year.selectCaroutputArray addObject:output];
            }
            
            [cartype.selectCaryearArray addObject:year];
            
            [cars.selectCartypeArray  addObject:cartype];
            
        }
        [carSeries addObject:cars];
    }
    
    // 设置默认值
    
    // 设置默认值
    self.savecartypeid = self.ccartypeid;
    
    self.carSeries = carSeries;
    return carSeries;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

- (NSArray *)getCarseries
{
    NSMutableArray *carseries = [NSMutableArray array];
    for (PorscheCarSeriesModel *cars in self.carSeries)
    {
        PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
        model.cvvaluedesc = cars.cars;
        model.extrainfo = cars.carscode;
        model.cvsubid = cars.pctid;
        [carseries addObject:model];
    }
    return carseries;
}

- (PorscheCarSeriesModel *)getOneCarsWithCarspctid:(NSNumber *)pctid
{
    PorscheCarSeriesModel *carseries = nil;
    for (PorscheCarSeriesModel *one in self.carSeries)
    {
        if ([one.pctid isEqualToNumber:pctid])
        {
            carseries = one;
            break;
        }
    }
    return carseries;
}

- (NSArray *)getCartypeWithCarspctid:(NSNumber *)pctid
{
    PorscheCarSeriesModel *carseries = [self getOneCarsWithCarspctid:pctid];
    
    if (!carseries)
    {
        return @[];
    }
    NSMutableArray *cartypes = [NSMutableArray array];
    
    for (PorscheCarTypeModel *cartype in carseries.selectCartypeArray)
    {
        PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
        model.cvvaluedesc = [NSString stringWithFormat:@"%@ %@",cartype.cars,cartype.cartype];
        model.extrainfo = cartype.cartypecode;
        model.configure = cartype.pctconfigure1;
        model.descr = cartype.cartype;
        model.cvsubid = cartype.pctid;
        [cartypes addObject:model];
    }
    
    return cartypes;
}

- (PorscheCarTypeModel *)getOneCartypeWithCarspctid:(NSNumber *)carspctid cartypepctid:(NSNumber *)cartypepctid
{
    PorscheCarSeriesModel *carseries = [self getOneCarsWithCarspctid:carspctid];
    PorscheCarTypeModel *cartypeInfo = nil;
    
    for (PorscheCarTypeModel *oneCartype in carseries.selectCartypeArray)
    {
        if ([oneCartype.pctid isEqualToNumber:cartypepctid])
        {
            cartypeInfo = oneCartype;
            break;
        }
    }
    return cartypeInfo;
}
- (NSArray *)getCaryearWithCarspctid:(NSNumber *)carspctid cartypepctid:(NSNumber *)cartypepctid
{
    PorscheCarSeriesModel *carseries = [self getOneCarsWithCarspctid:carspctid];
    PorscheCarTypeModel *cartypeInfo = [self getOneCartypeWithCarspctid:carspctid cartypepctid:cartypepctid];
    if (!carseries)
    {
        return @[];
    }
    
    if (!cartypeInfo)
    {
        return @[];
    }
    
    NSMutableArray *years = [NSMutableArray array];
    for (PorscheCarYearModel *caryear in cartypeInfo.selectCaryearArray )
    {
        PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
        model.cvvaluedesc = caryear.year;
        model.extrainfo = caryear.year;
/*
 @property (nonatomic, copy) NSString *cartype;          // 车型
 @property (nonatomic, copy) NSString *pctcartypeno;     // 车型code
 @property (nonatomic, copy) NSString *pctconfigure1;    // 配置信息
 @property (nonatomic, copy) NSString *pctcarsno;        // 车系code
 @property (nonatomic, copy) NSString *cars;             // 车系

 */
        model.cartype = caryear.cartype;
        model.pctcartypeno = caryear.pctcartypeno;
        model.pctconfigure1 = caryear.pctconfigure1;
        model.pctcarsno = caryear.pctcarsno;
        model.cars = caryear.cars;
        model.cvsubid = caryear.pctid;

        [years addObject:model];
    }

    
    return years;
}



- (PorscheCarYearModel *)getOneYearWithCarspctid:(NSNumber *)carspctid cartypepctid:(NSNumber *)cartypepctid caryearpctid:(NSNumber *)caryearpctid
{
    PorscheCarTypeModel *cartypeInfo = [self getOneCartypeWithCarspctid:carspctid cartypepctid:cartypepctid];
    PorscheCarYearModel *caryear = nil;
    for (PorscheCarYearModel *years in cartypeInfo.selectCaryearArray)
    {
        if ([years.pctid isEqualToNumber:caryearpctid])
        {
            caryear = years;
            break;
        }
    }
    return caryear;

}
- (NSArray *)getCaroutputWithCarspctid:(NSNumber *)carspctid cartypepctid:(NSNumber *)cartypepctid caryearpctid:(NSNumber *)caryearpctid
{
    PorscheCarSeriesModel *carseries = [self getOneCarsWithCarspctid:carspctid];
    PorscheCarTypeModel *cartypeInfo = [self getOneCartypeWithCarspctid:carspctid cartypepctid:cartypepctid];
    
    if (!carseries)
    {
        return @[];
    }
    if (!cartypeInfo)
    {
        return @[];
    }
    
    NSMutableArray *outputs = [NSMutableArray array];
    PorscheCarYearModel *caryear = [self getOneYearWithCarspctid:carspctid cartypepctid:cartypepctid caryearpctid:caryearpctid];

    for (PorscheCarOutputModel *output in caryear.selectCaroutputArray)
    {
        PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
        model.cvvaluedesc = output.displacement;
        model.extrainfo = output.displacement;
        model.cvsubid = output.pctid;
        [outputs addObject:model];
    }

    return outputs;
}



- (PorscheCarSeriesModel *)configDataWP1AG2920DLA61285
{
    PorscheCarSeriesModel *carseries = [[PorscheCarSeriesModel alloc] init];
    carseries.cars = @"Cayenne";
    carseries.carscode = @"92A";
    
    PorscheCarTypeModel *cartype = [[PorscheCarTypeModel alloc] init];
    cartype.cartype = @"S";
    cartype.cartypecode = @"AH1";
    PorscheCarYearModel *caryear = [[PorscheCarYearModel alloc] init];
    caryear.year = @"2014";
    PorscheCarOutputModel *output = [[PorscheCarOutputModel alloc] init];
    output.displacement = @"3.0T";
    [caryear.selectCaroutputArray addObject:output];
    [cartype.selectCaryearArray addObject:caryear];
    
    [carseries.selectCartypeArray addObject:cartype];
    
    
    
    PorscheCarTypeModel *cartype1 = [[PorscheCarTypeModel alloc] init];
    cartype1.cartype = @"S Hybrid";
    cartype1.cartypecode = @"AM1";
    PorscheCarYearModel *caryear1 = [[PorscheCarYearModel alloc] init];
    caryear1.year = @"2014";
    PorscheCarOutputModel *output1 = [[PorscheCarOutputModel alloc] init];
    output1.displacement = @"3.0T";
    [caryear1.selectCaroutputArray addObject:output1];
    [cartype1.selectCaryearArray addObject:caryear1];
    [carseries.selectCartypeArray addObject:cartype1];
    
    
    PorscheCarTypeModel *cartype2 = [[PorscheCarTypeModel alloc] init];
    cartype2.cartype = @"GTS";
    cartype2.cartypecode = @"AL1";
    PorscheCarYearModel *caryear2 = [[PorscheCarYearModel alloc] init];
    caryear2.year = @"2014";
    PorscheCarOutputModel *output2 = [[PorscheCarOutputModel alloc] init];
    output2.displacement = @"3.0T";
    [caryear2.selectCaroutputArray addObject:output2];
    [cartype2.selectCaryearArray addObject:caryear2];
    [carseries.selectCartypeArray addObject:cartype2];
    
    
    
    
    PorscheCarTypeModel *cartype3 = [[PorscheCarTypeModel alloc] init];
    cartype3.cartype = @"Turbo";
    cartype3.cartypecode = @"AI1";
    PorscheCarYearModel *caryear3 = [[PorscheCarYearModel alloc] init];
    caryear3.year = @"2014";
    PorscheCarOutputModel *output3 = [[PorscheCarOutputModel alloc] init];
    output3.displacement = @"3.0T";
    [caryear3.selectCaroutputArray addObject:output3];
    [cartype3.selectCaryearArray addObject:caryear3];
    [carseries.selectCartypeArray addObject:cartype3];
    
    
    PorscheCarTypeModel *cartype4 = [[PorscheCarTypeModel alloc] init];
    cartype4.cartype = @"Turbo S";
    cartype4.cartypecode = @"AN1";
    PorscheCarYearModel *caryear4 = [[PorscheCarYearModel alloc] init];
    caryear4.year = @"2014";
    PorscheCarOutputModel *output4 = [[PorscheCarOutputModel alloc] init];
    output4.displacement = @"3.0T";
    [caryear4.selectCaroutputArray addObject:output4];
    [cartype4.selectCaryearArray addObject:caryear4];
    [carseries.selectCartypeArray addObject:cartype4];
    
    return carseries;
}
- (PorscheCarSeriesModel *)configWPOAA2972FL003745
{
    PorscheCarSeriesModel *carseries = [[PorscheCarSeriesModel alloc] init];
    carseries.cars = @"Panamera";
    carseries.carscode = @"970";
    
    PorscheCarTypeModel *cartype = [[PorscheCarTypeModel alloc] init];
    cartype.cartype = @"4";
    cartype.cartypecode = @"410";
    PorscheCarYearModel *caryear = [[PorscheCarYearModel alloc] init];
    caryear.year = @"2016";
    PorscheCarOutputModel *output = [[PorscheCarOutputModel alloc] init];
    output.displacement = @"3.6T";
    [caryear.selectCaroutputArray addObject:output];
    [cartype.selectCaryearArray addObject:caryear];
    
    [carseries.selectCartypeArray addObject:cartype];
    
    
    PorscheCarTypeModel *cartype1 = [[PorscheCarTypeModel alloc] init];
    cartype1.cartype = @"S";
    cartype1.cartypecode = @"120";
    PorscheCarYearModel *caryear1 = [[PorscheCarYearModel alloc] init];
    caryear1.year = @"2016";
    PorscheCarOutputModel *output1 = [[PorscheCarOutputModel alloc] init];
    output1.displacement = @"3.6T";
    [caryear1.selectCaroutputArray addObject:output1];
    [cartype1.selectCaryearArray addObject:caryear1];
    [carseries.selectCartypeArray addObject:cartype1];
    
    
    PorscheCarTypeModel *cartype2 = [[PorscheCarTypeModel alloc] init];
    cartype2.cartype = @"S E-Hybrid";
    cartype2.cartypecode = @"130";
    PorscheCarYearModel *caryear2 = [[PorscheCarYearModel alloc] init];
    caryear2.year = @"2016";
    PorscheCarOutputModel *output2 = [[PorscheCarOutputModel alloc] init];
    output2.displacement = @"3.6T";
    [caryear2.selectCaroutputArray addObject:output2];
    [cartype2.selectCaryearArray addObject:caryear2];
    [carseries.selectCartypeArray addObject:cartype2];
    
    
    PorscheCarTypeModel *cartype3 = [[PorscheCarTypeModel alloc] init];
    cartype3.cartype = @"4S";
    cartype3.cartypecode = @"420";
    PorscheCarYearModel *caryear3 = [[PorscheCarYearModel alloc] init];
    caryear3.year = @"2016";
    PorscheCarOutputModel *output3 = [[PorscheCarOutputModel alloc] init];
    output3.displacement = @"3.6T";
    [caryear3.selectCaroutputArray addObject:output3];
    [cartype3.selectCaryearArray addObject:caryear3];
    [carseries.selectCartypeArray addObject:cartype3];
    
    
    PorscheCarTypeModel *cartype4 = [[PorscheCarTypeModel alloc] init];
    cartype4.cartype = @"GTS";
    cartype4.cartypecode = @"740";
    PorscheCarYearModel *caryear4 = [[PorscheCarYearModel alloc] init];
    caryear4.year = @"2016";
    PorscheCarOutputModel *output4 = [[PorscheCarOutputModel alloc] init];
    output4.displacement = @"3.6T";
    [caryear4.selectCaroutputArray addObject:output4];
    [cartype4.selectCaryearArray addObject:caryear4];
    [carseries.selectCartypeArray addObject:cartype4];
    
    
    PorscheCarTypeModel *cartype5 = [[PorscheCarTypeModel alloc] init];
    cartype5.cartype = @"Turbo";
    cartype5.cartypecode = @"430";
    PorscheCarYearModel *caryear5 = [[PorscheCarYearModel alloc] init];
    caryear5.year = @"2016";
    PorscheCarOutputModel *output5 = [[PorscheCarOutputModel alloc] init];
    output5.displacement = @"3.6T";
    [caryear5.selectCaroutputArray addObject:output5];
    [cartype5.selectCaryearArray addObject:caryear5];
    [carseries.selectCartypeArray addObject:cartype5];
    
    PorscheCarTypeModel *cartype6 = [[PorscheCarTypeModel alloc] init];
    cartype6.cartype = @"Turbo S";
    cartype6.cartypecode = @"480";
    PorscheCarYearModel *caryear6 = [[PorscheCarYearModel alloc] init];
    caryear6.year = @"2016";
    PorscheCarOutputModel *output6 = [[PorscheCarOutputModel alloc] init];
    output6.displacement = @"3.6T";
    [caryear6.selectCaroutputArray addObject:output6];
    [cartype6.selectCaryearArray addObject:caryear6];
    [carseries.selectCartypeArray addObject:cartype6];
    return carseries;
}

- (PorscheCarSeriesModel *)configWP0AB2995AS720234
{
    PorscheCarSeriesModel *carseries = [[PorscheCarSeriesModel alloc] init];
    carseries.cars = @"911";
    carseries.carscode = @"997";
    
    PorscheCarTypeModel *cartype = [[PorscheCarTypeModel alloc] init];
    cartype.cartype = @"Carrera";
    cartype.cartypecode = @"11";
    PorscheCarYearModel *caryear = [[PorscheCarYearModel alloc] init];
    caryear.year = @"2011";
    PorscheCarOutputModel *output = [[PorscheCarOutputModel alloc] init];
    output.displacement = @"3.8T";
    [caryear.selectCaroutputArray addObject:output];
    [cartype.selectCaryearArray addObject:caryear];
    
    [carseries.selectCartypeArray addObject:cartype];
    
    
    PorscheCarTypeModel *cartype1 = [[PorscheCarTypeModel alloc] init];
    cartype1.cartype = @"Carrera S";
    cartype1.cartypecode = @"12";
    PorscheCarYearModel *caryear1 = [[PorscheCarYearModel alloc] init];
    caryear1.year = @"2011";
    PorscheCarOutputModel *output1 = [[PorscheCarOutputModel alloc] init];
    output1.displacement = @"3.8T";
    [caryear1.selectCaroutputArray addObject:output1];
    [cartype1.selectCaryearArray addObject:caryear1];
    
    [carseries.selectCartypeArray addObject:cartype1];
    
    
    PorscheCarTypeModel *cartype2 = [[PorscheCarTypeModel alloc] init];
    cartype2.cartype = @"Carrera 4";
    cartype2.cartypecode = @"41";
    PorscheCarYearModel *caryear2 = [[PorscheCarYearModel alloc] init];
    caryear2.year = @"2011";
    PorscheCarOutputModel *output2 = [[PorscheCarOutputModel alloc] init];
    output2.displacement = @"3.8T";
    [caryear2.selectCaroutputArray addObject:output2];
    [cartype2.selectCaryearArray addObject:caryear2];
    
    [carseries.selectCartypeArray addObject:cartype2];
    
    PorscheCarTypeModel *cartype3 = [[PorscheCarTypeModel alloc] init];
    cartype3.cartype = @"Carrera 4S";
    cartype3.cartypecode = @"43";
    PorscheCarYearModel *caryear3 = [[PorscheCarYearModel alloc] init];
    caryear3.year = @"2011";
    PorscheCarOutputModel *output3 = [[PorscheCarOutputModel alloc] init];
    output3.displacement = @"3.8T";
    [caryear3.selectCaroutputArray addObject:output3];
    [cartype3.selectCaryearArray addObject:caryear3];
    
    [carseries.selectCartypeArray addObject:cartype3];
    
    
    PorscheCarTypeModel *cartype4 = [[PorscheCarTypeModel alloc] init];
    cartype4.cartype = @"Speedster";
    cartype4.cartypecode = @"72";
    PorscheCarYearModel *caryear4 = [[PorscheCarYearModel alloc] init];
    caryear4.year = @"2011";
    PorscheCarOutputModel *output4 = [[PorscheCarOutputModel alloc] init];
    output4.displacement = @"3.8T";
    [caryear4.selectCaroutputArray addObject:output4];
    [cartype4.selectCaryearArray addObject:caryear4];
    
    [carseries.selectCartypeArray addObject:cartype4];
    
    PorscheCarTypeModel *cartype5 = [[PorscheCarTypeModel alloc] init];
    cartype5.cartype = @"Carrera GTS";
    cartype5.cartypecode = @"15";
    PorscheCarYearModel *caryear5 = [[PorscheCarYearModel alloc] init];
    caryear5.year = @"2011";
    PorscheCarOutputModel *output5 = [[PorscheCarOutputModel alloc] init];
    output5.displacement = @"3.8T";
    [caryear5.selectCaroutputArray addObject:output5];
    [cartype5.selectCaryearArray addObject:caryear5];
    
    [carseries.selectCartypeArray addObject:cartype5];
    
    PorscheCarTypeModel *cartype6 = [[PorscheCarTypeModel alloc] init];
    cartype6.cartype = @"Turbo";
    cartype6.cartypecode = @"42";
    PorscheCarYearModel *caryear6 = [[PorscheCarYearModel alloc] init];
    caryear6.year = @"2011";
    PorscheCarOutputModel *output6 = [[PorscheCarOutputModel alloc] init];
    output6.displacement = @"3.8T";
    [caryear6.selectCaroutputArray addObject:output6];
    [cartype6.selectCaryearArray addObject:caryear6];
    
    [carseries.selectCartypeArray addObject:cartype6];
    
    
    PorscheCarTypeModel *cartype7 = [[PorscheCarTypeModel alloc] init];
    cartype7.cartype = @"Turbo S";
    cartype7.cartypecode = @"45";
    PorscheCarYearModel *caryear7 = [[PorscheCarYearModel alloc] init];
    caryear7.year = @"2011";
    PorscheCarOutputModel *output7 = [[PorscheCarOutputModel alloc] init];
    output7.displacement = @"3.8T";
    [caryear7.selectCaroutputArray addObject:output7];
    [cartype7.selectCaryearArray addObject:caryear7];
    
    [carseries.selectCartypeArray addObject:cartype7];
    
    return carseries;
}


@end

@implementation OrderOptStatusDto
/**
 * 状态说明：
 1：开单环节
 statestart：1  开单确认按钮亮着
 2：技师增项环节
	if   statuswaitworkshop=1，显示车间确认按钮并且亮着
	else	 stateincrease=1 or statuswaitincrease=1 显示技师确认按钮：亮着
 
 否则技师确认按钮灰色
 
 点击技师确认按钮
 if statusworkshop=1 出现提示：进入车间确认流程
 
	3.备件确认环节
 statepart = 1 or statuswaitpart = 1 备件确认按钮亮着，否则灰色
 
 4.服务沟通环节
 if  stateserice ==1 && stateincrease ==1 出现左右手，直接让客户确认还是让技师确认 ，原来画面：7
 
 if  stateserice ==1 && statepart ==1 出现左右手，直接让客户确认还是让备件确认 ，原来画面：6
 
 if  stateserice ==1 && stateguarantee ==1 出现左右手，直接让客户确认还是保修员审批 ，原来画面：2
 
 if  stateserice ==0 && stateguarantee ==1 进入保修审批流程 ，原来画面：1
 
 if  stateserice ==0 && stateincrease ==1 进入技师确认流程 ，原来画面：5
 
 if  stateserice ==0 && statepart ==1  进入件确认 ，原来画面：4
 
 if  stateserice=1 其他几个都为0：进去客户确认流程： 原来画面：3
 
 都为0的情况： 服务确认按钮灰色
 
	5： 客户确认
 
 statecustomer=1：客户确认按钮亮着 否则灰色
 
 */
#pragma mark  开单确认
- (BOOL)isShowBillingLighting {
    if ([_statestart isEqual:@0]) {
        return NO;
    }else {
        return YES;
    }
}

#pragma mark  技师确认/车间确认
//--显示技师确认/车间确认
- (BOOL)isShowTechicianText {
    if ([_statuswaitworkshop  isEqual: @1]) {
        return NO;//显示车间确认 并且亮着
    }
    return YES;//显示技师确认
}

//技师确认亮着
- (BOOL)isShowTechicianLighting {
    /*if ([_statuswaitworkshop  isEqual: @1]) {
        return NO;
    }else */
    if ([_stateincrease  isEqual: @1] || [_statuswaitincrease  isEqual: @1] || [_statusworkshop isEqualToNumber:@1]) {
        return YES;
    }else {
        return NO;
    }
}
#pragma mark  备件确认
- (BOOL)isShowMaterialLighting {
    if ([_statepart  isEqual: @1] || [_statuswaitpart  isEqual: @1]) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark  服务确认
- (BOOL)isShowServiceConfirmBtLighting
{
    
    if ([_statuswaitguarantee integerValue] == 1)
    {
        return YES;
    }
    
    if ([self isAllZero:@[_stateserice,_statepart,_stateincrease,_stateguarantee]])
    {
        return NO;
    }
    
    return YES;
}



/****
 *
 //stateincrease = 0;// 增项确认
 //statepart = 0; // 备件确认
 //stateserice = 0;// 服务确认
 //stateguarantee = 0;// 保修确认
 ****/
- (BOOL)isAllZero:(NSArray <NSNumber *>*)array {
    BOOL isZero = YES;
    if (array.count) {
        for (NSNumber *number in array) {
            if ([number isEqual:@1]) {
                isZero = NO;
            }
        }
    }
    return isZero;
}
//开关
- (NSInteger)getSwitch {
    NSInteger integer = 3;
    
    
    
    if ([_stateserice  isEqual: @0] && [_statuswaitguarantee  isEqual:@1]) {
        integer = 1;
    }
    else if ([_stateserice  isEqual: @0] && [_stateguarantee  isEqual:@1]) {
        integer = 8;
    }
    else if ([_stateserice  isEqual:@1] && [_stateguarantee  isEqual:@1]) {
        integer = 2;
    }
    
    else if (![self isAllZero:@[_stateserice]] && [self isAllZero:@[_stateguarantee,_stateincrease,_statepart]]) {
        integer = 3;
    }
    
    else if ([_stateserice  isEqual:@0] && [_statepart  isEqual:@1] ) {
        integer = 4;
    }
    
   else if ([_stateserice  isEqual:@0] && [_stateincrease  isEqual:@1]) {
        integer = 5;
    }
    
   else if ([_stateserice  isEqual:@1] && [_statepart  isEqual:@1]) {
        integer = 6;
    }
    
   else if ([_stateserice  isEqual:@1] && [_stateincrease  isEqual:@1]) {
        integer = 7;
    }
    
    return integer;
}

#pragma mark  客户确认
- (BOOL)isShowCustomLighting {
    if ([_statecustomer  isEqual: @1]) {
        return YES;
    }else {
        return NO;
    }
}

@end

@implementation PorscheNewWorkHourSchemews

@end

@implementation PorscheNewMaterialSchemews
+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"partsstocklist" : [ProscheMaterialLocationModel class]};
}

@end



@implementation PorscheNewSchemews

+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"partsstocklist" : [ProscheMaterialLocationModel class]};
}

+ (instancetype)getSelfWithMarerial:(PorscheNewMaterialSchemews *)material {
    PorscheNewSchemews *schemews= [PorscheNewSchemews new];
    schemews.wospwosid = material.wospwosid;//所属方案再工单中的id
    schemews.schemewsid = material.wospid;//在工单中id
    schemews.stockid = material.wospstockid;//在库中id
    if (![material.wospsettlement isEqual:@1] && ![material.wospsettlement isEqual:@2] && ![material.wospsettlement isEqual:@3]) {
        material.wospsettlement = @3;
    }
    schemews.schemesettlementway = material.wospsettlement;//结算方式
    schemews.schemewsunitprice = material.price_after_tax;//单价
    schemews.schemewscount = material.parts_num;//数量
    schemews.schemewsunitprice_yuan = material.wospriginprice;//原价
    schemews.schemewstotalprice = material.wospfinalprice;//折后价
    schemews.schemewstdiscount = material.wospdiscountrate;//折扣率
    
    schemews.schemewsname = material.wosppartsname;//配件名称
    schemews.customname = material.customname;//自定义名字
    schemews.parts_desc = material.parts_desc;//描述
    schemews.schemewscode = material.parts_no_all;//编号
    schemews.schemewsphotocode = material.image_no_all;//图号
    schemews.schemewsisconfirm = material.wospstockisconfirm;//库存确认
    schemews.iscancel = material.wospisconfirm;//确认
    schemews.schemeswswarrantyconflg = material.wospisguarantee;//保修确认
    schemews.parts_status = material.parts_status;//备件类型
    schemews.parts_type = material.parts_type;//发布状态

    
    //转换参数
    schemews.schemesubtype = @2;//类型：备件
    schemews.schemewsdiscounttotalprice = @([material.wospriginprice floatValue]-[material.wospfinalprice floatValue]);//优惠
    
    if ([material.wospaddsource isEqual:@0] && [material.parts_status integerValue] > 1) {//方案库自带 ，并且大于1
        schemews.schemewstype = @1;
    }else {
        if ([material.parts_status isEqual:@0] || [material.parts_status isEqualToNumber:@1])
        {
            schemews.schemewstype = @2;
        }else {
            schemews.schemewstype = @3;
        }
    }
    schemews.projectaddid = material.wospaddperson;//添加人
    schemews.partsstocktype = material.parts_stock_type;//常备件
//    schemews.partsstocktypebak = material.parts_stock_type;//后台用常备件
    schemews.partsstocklist = material.partsstocklist;//备件库存
    
    #pragma mark - 处理备件的数据(在数据中添加常备件数据,后台不返回,只能自己创造)
    if ([schemews.partsstocktype integerValue] == 1) {
        ProscheMaterialLocationModel *locaModel = [[ProscheMaterialLocationModel alloc] init];
        locaModel.pbsamount = [@0 stringValue];
        locaModel.pbstockname = @"常备件";
        locaModel.pbstockid = @5;
        locaModel.pbsid = @0;
        locaModel.pbspbid = [schemews.stockid stringValue];
        NSMutableArray *temp = [NSMutableArray arrayWithArray:schemews.partsstocklist];
        if (schemews.partsstocklist.count) {
            [temp insertObject:locaModel atIndex:0];
        }else {
            [temp addObject:locaModel];
        }
        schemews.partsstocklist = temp;
    }
    return schemews;
}
+ (instancetype)getSelfWithWorkHour:(PorscheNewWorkHourSchemews *)workHour {
    PorscheNewSchemews *schemews= [PorscheNewSchemews new];
    schemews.wospwosid = workHour.woshschemeid;//所属方案再工单中的id
    schemews.schemewsid = workHour.woshworkhourid;//在工单中id
    schemews.stockid = workHour.woshstockid;//在库中id
    if (![workHour.woshsettlement isEqual:@1] && ![workHour.woshsettlement isEqual:@2] && ![workHour.woshsettlement isEqual:@3]) {
        workHour.woshsettlement = @3;
    }
    schemews.schemesettlementway = workHour.woshsettlement;//结算方式
    schemews.schemewsunitprice = workHour.workhourprice;//单价
    schemews.schemewscount = workHour.workhourcount;//数量
    schemews.schemewsunitprice_yuan = workHour.woshriginprice;//原价
    schemews.schemewstotalprice = workHour.woshfinalprice;//折后价
    schemews.schemewstdiscount = workHour.woshdiscountrate;//折扣率
    schemews.schemewsname = workHour.woshworkhourname;//名称
    schemews.schemewscode = workHour.workhourcodeall;//编号
    schemews.iscancel = workHour.woshisconfirm;//确认
    schemews.schemeswswarrantyconflg = workHour.woshisguarantee;//保修确认
    schemews.parts_type = workHour.workhourstatus;//发布状态
    //转换参数
    schemews.schemesubtype = @1;//类型：工时
    schemews.schemewsdiscounttotalprice = @([workHour.woshriginprice floatValue]-[workHour.woshfinalprice floatValue]);//优惠
    if ([workHour.woshaddsource isEqual:@0] && [workHour.workhourstatus integerValue] > 1) {//方案库自带
        schemews.schemewstype = @1;
    }else {
        if ([workHour.workhourstatus isEqual:@0] || [workHour.workhourstatus isEqual:@1]) {
            schemews.schemewstype = @2;
        }else {
            schemews.schemewstype = @3;
        }
    }
    schemews.projectaddid = workHour.woshaddperson;//添加人
    return schemews;
}
@end

#pragma mark  折扣请求条件

@implementation PorscheDiscountCondition

@end

@implementation PorscheCarMessage

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


+ (NSArray *)getCarNoticeModel:(NSInteger)integer {
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    NSArray *carNumberArray = @[@"XNI596",@"OKI596",@"HGF596",@"YIJ596",@"OIN596",@"DBX596"];
    
    for (int i = 0; i < integer; i ++) {
        NSInteger idx = arc4random() % 6;
        NSInteger readStyle = arc4random() % 2;
        PorscheCarMessage *model = [[PorscheCarMessage alloc]initWithDic:@{@"carLocation":@"沪",@"carNumber":carNumberArray[idx],@"vinNumber":@"WEI1DH2921ELA29654",@"carCategory":@"911 Camera S 2016款",@"message":@"等待您确认备件",}];
        model.modelStyle = readStyle;
        model.selectedStyle = PorscheItemModelUnselected;
        
        [dataArray addObject:model];
    }
    return dataArray;
    
}

+ (NSArray *)getLocationCarNoticeModel:(NSInteger)integer {
    
//    NSArray *messageArray =[NSArray arrayWithObjects:@"911保养促销",@"备件:叉车片价格更新为",nil];
    NSArray *priceArray = @[@"500.00",@"2800.00"];
    
    //    NSArray *category = @[@"方案",@"价格"];
    NSArray *array = [PorscheCarMessage getCarNoticeModel:integer];
    for (PorscheCarMessage *model in array) {
        
        NSLog(@"调用+1");
//        NSInteger idx = arc4random() % 2;
        NSInteger idx2 = arc4random() % 2;
        
        model.message = @"911保养促销";
        model.changePrice = priceArray[idx2];
        //        model.categoryStyle = category[idx];
    }
    return array;
    
}

@end

@implementation VINCarseriesModel

+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"cartypelist" : [VINCartypeModel class]};
}

@end

@implementation VINCartypeModel

+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"caryear" : [VINCarYearModel class]};
}


@end

@implementation VINCarYearModel

+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"displacement" : [VINDsplacement class]};
}


@end

@implementation VINDsplacement

@end
