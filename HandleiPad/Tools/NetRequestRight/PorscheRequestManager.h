//
//  PorscheRequestManager.h
//  HandleiPad
//
//  Created by Robin on 2016/11/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PorscheModel.h"
#import "PorscheCarSeriesModel.h"




NS_ASSUME_NONNULL_BEGIN
typedef void(^PorscheRequestManagerBlock)(id _Nullable model,NSError * _Nullable error);
typedef void(^PorscheRequestSuccessBlock)(BOOL success, PResponseModel* _Nullable responser, NSString * _Nullable message);
typedef void(^PorscheRequestManagerArrayBlock)(NSArray *dataSource);
typedef void(^UploadServiceResponse)(NSURLResponse *response, PResponseModel* responser, NSError *error);//照片上传block

//删除类型
typedef NS_ENUM(NSInteger, PorscheSchemeRequestDeteleMode) {
    
    PorscheSchemeRequestDeteleModeAll = 0, // 全部
    PorscheSchemeRequestDeteleModeBase,  // 基础
    PorscheSchemeRequestDeteleModeInterval, //间隔时间
    PorscheSchemeRequestDeteleModeMiles, //公里数
    PorscheSchemeRequestDeteleModeCar, //车型
    PorscheSchemeRequestDeteleModeWorkingHours, //工时
    PorscheSchemeRequestDeteleModeSpare, //备件
    PorscheSchemeRequestDeteleModeBusiness //业务类型
};

@class PorscheCarSeriesModel;
@interface PorscheRequestManager : NSObject

@property (nonatomic, copy) PorscheRequestManagerBlock hdrequestrihjtBlock;

//*******************************公共接口***********************************
#pragma mark  常量
+ (void)getMaterialBusinessList:(void(^)(NSMutableArray *classifyArray,NSMutableArray *titleArray,PResponseModel* responser))complete;//业务分类
+ (void)getItemTimeGroupList:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complete; //工时主子组
+ (void)getMaterialMianList:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complete;//备件主组
+ (void)getSecureCompanyListComplate:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complate;//获取保险公司
+ (void)getStaffListTestWithGroupId:(NSNumber *)groupId positionId:(NSNumber *)positionId complete:(void(^)(NSMutableArray * _Nonnull classifyArray, PResponseModel * _Nonnull responser))complete;//开单中获取员工列表
+ (void)getBillingStaffGroupListComplate:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complate;//开单中获取组列表 （只包含组名数组）
+ (void)getBillingStaffPositionListComplate:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complate;//员工职位列表
+ (void)getPorscheSchemeLevelListComplete:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complete;//方案级别
+ (void)getPorscheProjectSettltmentComplete:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complete;//结算方式
+ (void)getMaterialCubListComplete:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complete;//获取备件库存列表
+ (void)upDateMaterialCubListWithid:(NSNumber *)partid isDelete:(BOOL)isDelete complete:(void(^)(NSInteger status,PResponseModel *responser))complete;//添加/删除备件库存
+ (void)editMaterialCubListWithDic:(NSDictionary *)dic complete:(void(^)(NSInteger status,PResponseModel *responser))complete;//添加备件库存
#pragma mark  开单接口
/****
        新开单操作
 ****/
+ (void)setupBillingNewCarComplete:(PorscheRequestManagerBlock)complete;//新开单操作
/****
 *      取消开单
 ****/
+ (void)cancelBillingNewCarReason:(NSString *)reasonStr complete:(void(^)(NSInteger status,PResponseModel *responser))complete;//取消开单

/****
 *      根据车牌获取车辆信息
 ****/
+ (void)getCarMessage:(NSDictionary *)carNumberDic complete:(void(^)(PResponseModel * _Nullable responser, NSError * _Nullable error))complete;//根据车牌获取车辆信息
/****
 *      保存开单信息
 ****/
+ (void)saveBillingNewCarDic:(NSDictionary *)parts complete:(void(^)(NSInteger status,PResponseModel *responser))complete;//保存开单信息
/****
 *      车辆列表
 ****/
+ (void)carListNewCarComplete:(void(^)(NSMutableArray *array,PResponseModel *responser))complete;//车辆列表
+ (void)carListNewCarWithParam:(NSDictionary *)param complete:(void(^)(NSMutableArray *array,PResponseModel *responser))complete;
/****
 *      根据VIN获取车辆信息
 ****/
+ (void)carMessageWithVIN:(NSString *)vin carComplete:(void(^)(PResponseModel * _Nullable responser, NSError * _Nullable error))complete;//根据VIN获取车辆信息
/****
 *      辅助返回状态值，@1. 成功 @0失败
 ****/
/****
 *      单车开单信息
 ****/
+ (void)getSingleCarMessagecomplete:(void(^)(PorscheNewCarMessage *model,PResponseModel* responser))complete;//单车开单信息
/****
 *      取消开单原因
 ****/
+ (void)getCancelBillingReasonListComplate:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complate;//取消开单原因


+ (void)insuranceConfirmComplete:(void(^)(NSInteger status,PResponseModel *responser))complete;

#pragma mark  流程确认
/****
 *            流程确认 number 1.开单 2.技师 3.备件 4.服务 5.客户 
             //buttonid   0：让客户确认   1：让技师确认   2：让备件确认  3:让保修员审批
 ****/
+ (void)orderSureToNextOrder:(NSInteger )number buttonid:(NSInteger)buttonid Complete:(void(^)(NSInteger status,PResponseModel *responser))complete;

+ (void)orderSureToNextOrder:(NSInteger )number param:(NSDictionary *)param buttonid:(NSInteger)buttonid Complete:(void(^)(NSInteger status,PResponseModel *responser))complete;
//1:等待车间确认  2：等待备件确认 3：等待增项确认 4：等待保修确认
+ (void)waitConfirmWithStatus:(NSNumber *)status complete:(void(^)(NSInteger status,PResponseModel *responser))complete;
#pragma mark  人员指派
+ (void)bottomSaveChooseTechWithdic:(NSDictionary *)paramers complete:(void(^)(NSInteger status, PResponseModel * _Nonnull responser))complete;
#pragma mark  工单信息

/****
            工单列表
 ****/
+ (void)getWorkOrderListComplate:(void(^)(PorscheNewCarMessage *carMessage,PResponseModel* responser))complate;//
/****
//            工单方案库
// ****/
//+ (void)workOrderSchemeListRequestWith:(PorscheRequestSchemeListModel *)model complete:(void(^)(NSDictionary *paramers,PResponseModel* responser))complete;//
/****
            未完成 plateplace:车籍 carplate:车牌号
 ****/
+ (void)workOrderUnfinishedSchemeListRequestWithPlateplace:(NSString *)plateplace carpalte:(NSString *)carplate  complete:(void(^)(NSMutableArray *list,PResponseModel* responser))complete;

+ (void)workOrderUnfinishedSchemeListRequestWith:(NSDictionary *)paramers complete:(void(^)(NSMutableArray *list,PResponseModel* responser))complete;//
//添加未完成方案
+ (void)increaseUnfinishedItemWithModel:(PorscheNewScheme *)model isDelete:(BOOL)isDelete complete:(void(^)(NSInteger status,PResponseModel *model))complete;
/****
            添加条件方案
 ****/
+ (void)increaseItemWithModel:(PorscheSchemeModel *)model isDelete:(BOOL)isDelete complete:(void(^)(NSInteger status,PResponseModel *model))complete;
/****
            增删/删除 工单中的方案
 ****/
+ (void)increaseItemWithParamers:(ProscheAdditionCondition *)condition complete:(void(^)(NSInteger status,PResponseModel *model))complete;
/****
 *          添加全屏方案库至工单
 ****/
+ (void)increaseItemsWithParamers:(NSDictionary *)condition complete:(void(^)(NSInteger status,PResponseModel *model))complete;
/****
 *          添加/删除 备件工时至工单 addedType @1（kAddition）添加   @2（kDeletion）删除
 ****/
+ (void)inscreaseProjectSubObjectAddedType:(NSNumber *)addedType Condition:(ProscheAdditionCondition *)condition complete:(void(^)(NSInteger status,PResponseModel *model))complete;
/****
 *          自定义项目编辑 编辑名称
 ****/
+ (void)editCustomProjectName:(PorscheNewScheme *)scheme complete:(void(^)(NSInteger status,PResponseModel *model))complete;
/****
 *         工单方案编辑 备注编辑
 ****/
+ (void)editProjectRemark:(PorscheNewScheme *)scheme complete:(void(^)(NSInteger status,PResponseModel *model))complete;
/****
 *         工单方案编辑 工时/备件编辑
 ****/
+ (void)editProjectWorkHourOrMaterial:(PorscheNewSchemews *)schemews type:(NSNumber *)type complete:(void(^)(NSInteger status,PResponseModel *model))complete;
/****
 *         工单 工时/备件/方案选择
 ****/
+ (void)chooseBtWithid:(NSNumber *)projectid type:(NSNumber *)type isChoose:(NSNumber *)value success:(void(^)())success fail:(void(^)())fail;
+ (void)chooseProjectSchemews:(ProscheChooseSchemewsCondition *)condition complete:(void(^)(NSInteger status,PResponseModel *responser))complete;
//方案级别修改
+ (void)updateSchemeLevelWithSchemeId:(NSNumber *)schemeid levelid:(NSNumber *)levelid complete:(void(^)(NSInteger status,PResponseModel *responser))complete;
#pragma mark  工时/备件 匹配搜索
/****
 *          工时匹配 全匹配
 ****/
+ (void)searchWorkHour:(ProscheSchemewsSearchCondition *)condition complete:(void(^)(NSMutableArray *list,PResponseModel* responser))complete;
/****
 *          备件匹配 图号匹配
 ****/
+ (void)searchMaterialNumber:(ProscheSchemewsSearchCondition *)condition type:(NSNumber *)type complete:(void(^)(NSMutableArray *list,PResponseModel* responser))complete;
#pragma mark  结算方式
/****
 *          设置结算方式
 ****/
//+ (void)setSettlementNumber:(ProscheProjectSettlementCondition *)condition complete:(void(^)(NSInteger status,PResponseModel* responser))complete;
//model 备件工时或者方案 isset:设置结算/审核结算  type：区分1.备件工时 2.方案   settle：结算方式model
+ (void)setsettleWithModel:(id)model isset:(BOOL)isset addStatus:(NSNumber *)addStatus type:(NSNumber *)type settle:(PorscheConstantModel *)settle complete:(void(^)(NSInteger status, PResponseModel * _Nonnull responser))complete;
#pragma mark  折扣设置
+ (void)editDiscountWithSchemews:(PorscheNewSchemews *)schemews rate:(NSNumber *)rate rangeid:(NSNumber *)rangeId complete:(void(^)(NSInteger status,PResponseModel *responser))complete;
+ (void)editProjectDiscount:(PorscheDiscountCondition *)condition complete:(void(^)(NSInteger status,PResponseModel *responser))complete;
#pragma mark  客户签字上传
+ (void)updateCustomSignImages:(NSArray <ZLCamera *>*)images parameModel:(PorscheRequestUploadPictureVideoModel * _Nullable)requestModel completion:(void (^)(id _Nullable responser, NSError * _Nullable error))completion;
#pragma mark  获取工单方案信息
+ (void)getWorkOrderSchemeOrderid:(NSNumber *)orderid complete:(void(^)(PorscheSchemeModel *shcheme,PResponseModel *responser))complete;
#pragma mark   修改方案级别 常量版
+ (void)schemeUpdateLevelWithSchemeID:(NSNumber *)schemeid constant:(PorscheConstantModel *)constant completion:(void(^)(NSInteger status,PResponseModel *responser))completion;
#pragma mark 获取方案库列表
+ (void)schemeListWith:(NSDictionary *)model complete:(void(^)(NSArray *array, PResponseModel * _Nonnull responser))complete;
#pragma mark  保存工单中整个方案在方案详情中的修改
+ (void)saveWorkOrderScheme:(PorscheSchemeModel *)scheme complete:(void(^)(NSInteger status,PResponseModel *responser))complete;
#pragma mark  获取服务沟通 确认时 开关 1. 2. 3. 4. 5. 6.
+ (void)getServiceSwitchStatusComplete:(void(^)(NSInteger status,PResponseModel * _Nullable responser))complete;
#pragma mark  编辑开启/关闭
+ (void)sendMessageToEditWithStatus:(BOOL)isEdit complete:(void(^)(NSInteger status,PResponseModel * _Nullable responser))complete;
#pragma mark  服务顾问开关 1：让技师确认   2：让备件确认  3:让保修员审批
+ (void)serviceSwitchStatus:(NSNumber *)status complete:(void(^)(NSInteger status,PResponseModel * _Nullable responser))complete;

#pragma mark  获取工单实时状态
+ (void)getWorkOrderCurrentStatusComplete:(void(^)(NSInteger status,PResponseModel * _Nullable responser))complete;
#pragma mark  获取提醒数据个数 order：nil表示全部提醒 ，非nil表示单车提醒
+ (void)getNoticeWithOrderid:(NSNumber *)orderid complete:(void(^)(NSInteger status,PResponseModel * _Nullable responser))complete;









#pragma mark - Robin的接口 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

/**
 登录接口
 
 @param username 用户名
 @param password 用户密码
 @param complete 返回的block
 */
+ (void)loginRequestWith:(NSString *)username password:(NSString *)password complete:(PorscheRequestManagerBlock _Nullable)complete;

/**
 后台登录
 */
+ (void)loginRequestWithBackstagecomplete:(PorscheRequestManagerBlock)complete;
/**
 上传视频和图片

 @param images 图片数组
 @param videoUrl 视频本地url
 @param requestModel 请求的model
 */
+ (void)uploadCameraImages:(NSArray <ZLCamera *>*)images editImage:(BOOL)editImage video:(NSURL * _Nullable)videoUrl parameModel:(PorscheRequestUploadPictureVideoModel * _Nullable)requestModel completion:(void (^)(id _Nullable responser, NSError * _Nullable error))completion;

/**
 上传视频

 @param videoUrl 视频Url
 @param requestModel 请求参数
 */
+ (void)uploadVideoWithURL:(NSURL *)videoUrl parameModel:(PorscheRequestUploadPictureVideoModel * _Nullable)requestModel completion:(void (^)(id _Nullable responser, NSError * _Nullable error))completion;

/**
 删除图片

 @param cameraID 图片的aiid
 @param complete
 */
+ (void)deleteCameraImage:(NSInteger)cameraID complete:(void(^)(BOOL delete1, NSString *errorMsg))complete;

#pragma mark - 方案模块

/**
 获取方案库列表
 
 @param model 获取方案库列表的model --->PorscheSchemeModel
 @param complete 回调
 */
+ (void)schemeListRequestWith:(PorscheRequestSchemeListModel *)model complete:(PorscheRequestManagerBlock)complete;

+ (void)schemeListRequestAllListComplete:(PorscheRequestManagerBlock)complete;

/**
 获取方案详情

 @param schemeid 方案的id
 @param completion
 */
+ (void)schemeDetailWithSchemeID:(NSInteger)schemeid  completion:(void (^)(PorscheSchemeModel * _Nullable porschemeModel, NSError * _Nullable error))completion;

/**
 获取方案通知详情

 @param schemeid 方案id
 @param noticeid 通知id
 @param completion
 */
+ (void)notificationSchemeDetailWithSchemeID:(NSInteger)schemeid noticeID:(NSInteger)noticeid completion:(void (^)(PorscheSchemeModel * _Nullable porschemeModel, PResponseModel * _Nullable responser))completion;

/**
 修改方案

 @param schemeModel 方案model
 @param completion
 */
+ (void)schemeDetailSaveWithSchemeModel:(PorscheSchemeModel *)schemeModel completion:(PorscheRequestSuccessBlock)completion;

/**
 保存方案到我的方案

 @param schemeModel 方案model
 @param completion
 */
+ (void)schemeDetailAddToMeWithSchemeModel:(PorscheSchemeModel *)schemeModel schemeType:(NSInteger)schemeType completion:(PorscheRequestSuccessBlock)completion;

/**
 删除方案

 @param schemeid 方案删除
 @param complete
 */
+ (void)schemeListDeleteWithSchemeID:(NSString *)schemeid complete:(PorscheRequestSuccessBlock)complete;

/**
 修改方案级别

 @param schemeid 方案id
 @param levelid 级别id
 @param levename 级别名字
 @param completion
 */
+ (void)schemeUpdateLevelWithSchemeID:(NSInteger)schemeid levelID:(NSInteger)levelid levelName:(NSString *)levename completion:(PorscheRequestSuccessBlock)completion;

/**
 删除方案列表请求接口
 
 @param deteleMode 删除的类型
 @param schemeid 方案id
 @param uid 要删除的模块id
 @param complete
 */
//+ (void)schemeListDeteleRequestMode:(PorscheSchemeRequestDeteleMode)deteleMode SchemeID:(NSInteger)schemeid UID:(NSInteger)uid complete:(void(^)(BOOL delete, NSString *errorMsg))complete;

#pragma mark - 备件模块
/**
 获取备件详情

 @param speraid 备件id
 @param completion
 */
+ (void)speraDetailWithSperaID:(NSInteger)speraid completion:(void (^)(PorscheSperaModel * _Nullable speraModel, NSError * _Nullable error))completion;

/**
 获取备件列表

 @param requestModel 获取备件列表的请求model --> PorscheRequestSperaListhModel
 @param completion
 */
+ (void)speraListWith:(PorscheRequestSchemeListModel *)requestModel completion:(void (^)(NSArray <PorscheSchemeSpareModel *>* _Nullable speraArray, NSError * _Nullable error))completion;

/**
 保存备件详情接口
 
 @param speraModel 备件详情model
 @param completion
 */
+ (void)speraDetailSaveWithSperaModel:(PorscheSperaModel *)speraModel completion:(PorscheRequestSuccessBlock)completion;

/**
 新增备件
 
 @param speraModel 备件model
 @param speraType 备件类型（1：厂方 2：本地 3 : 我的）
 @param completion
 */
+ (void)speraDetailAddToMeWithSperaModel:(PorscheSperaModel *)speraModel speraType:(NSInteger)speraType completion:(PorscheRequestSuccessBlock)completion;

/**
 备件删除

 @param speraid 删除备件id
 @param completion
 */
+ (void)speraDeleteWithID:(NSInteger)speraid completion:(PorscheRequestSuccessBlock)completion;

#pragma mark - 工时模块
/**
 获取工时列表

 @param requestModel 获取工时列表的请求model --> PorscheRequestSchemeListModel
 @param completion
 */
+ (void)workHoursListWith:(PorscheRequestSchemeListModel *)requestModel completion:(void (^)(NSArray <PorscheSchemeWorkHourModel *>* _Nullable workHourArray, NSError * _Nullable error))completion;

/**
 获取工时详情
 
 @param workhourid 工时id
 @param completion
 */
+ (void)workHourDetailWithWorkHourID:(NSInteger)workhourid completion:(void (^)(PorscheWorkHoursModel * _Nullable workHourModel, NSError * _Nullable error))completion;

/**
 保存工时详情接口
 
 @param workHourModel 工时详情model
 @param completion
 */
+ (void)workHourDetailSaveWithWorkHourModel:(PorscheWorkHoursModel *)workHourModel completion:(PorscheRequestSuccessBlock)completion;

/**
 添加工时

 @param workHourModel 工时model
 @param workHourType 工时类型（0:厂方 1:本店 2:我的备件
 @param completion
 */
+ (void)workHourDetailAddToMeWithWorkHourModel:(PorscheWorkHoursModel *)workHourModel workHourType:(NSInteger)workHourType completion:(PorscheRequestSuccessBlock)completion;

/**
 删除工时

 @param workhourid 删除工时的id
 @param completion
 */
+ (void)workHourDeleteWithID:(NSInteger)workhourid completion:(PorscheRequestSuccessBlock)completion;








#pragma mark - Chengkai的接口 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
/**
 左侧任务提醒-任务列表
 */
+ (void)noticeLeftListWithParams:(NSDictionary *)param completion:(void (^)(NSMutableArray *noticeLeftArray,PResponseModel* responser))completion;

/**
 左侧本店提醒-下方方案列表
 */
+ (void)noticeLeftBottomFanganListWithCompletion:(void (^)(NSMutableArray *fanganListArray,PResponseModel* responser))completion;

/**
 左侧任务提醒-处理未读的信息
 */
+ (void)noticeLeftListHandleUnreadNoticeWithParams:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion;

/**
 我的收藏夹列表
 */
+ (void)myFavoriteslistWithParams:(NSDictionary *)param completion:(void (^)(NSMutableArray *favoritesList,PResponseModel* responser))completion;

/**
 删除收藏夹-方案
 */
+ (void)deteleSchemeDataForScreenPopFileWithParams:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion;

/**
 删除收藏夹
 */
+ (void)deteleFavoritesListWithParams:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion;

/**
 添加收藏夹
 */
+ (void)addFavoritesListWithParams:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion;

/**
 添加收藏夹-方案
 */
+ (void)addSchemeForFavoriteListWithParams:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion;

/**
 收藏夹名称更改
 */
+ (void)changeFavoriteNameWithParams:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion isNeedShowPopView:(BOOL)isNeed;

/**
 在厂车辆全屏右侧点击交车
 */
+ (void)jiaocheForFullScreenRightViewcompletion:(void (^)(PResponseModel* responser))completion;


/**
 在厂车辆本店工单信息
 */
+ (void)mainShopInformationcompletion:(void (^)(PResponseModel* responser))completion;

/**
 服务档案页面信息查询
 */
+ (void)serviceRecordsRightInformationWith:(NSDictionary *)param completion:(void (^)(HDServiceRecordsRightModel *serviceRecordsRightModel, PResponseModel* responser))completion;

/**
 用户修改密码
 */
+ (void)userChangePasswordWithParam:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion;

/**
 服务档案车辆添加标签
 */
+ (void)addCarflgForServiceRecordsRightWithParam:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion;

/**
 服务档案车辆标签删除
 */
+ (void)deleteCarflgForServiceRecordsRightWithParam:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion;

/**
 服务档案标签查找
 */
+ (void)searchCarflgListSearchForServiceRecordsRightWithParam:(NSDictionary *)param completion:(void (^)(NSArray *carflgTableViewArray, PResponseModel* responser))completion;

/**
 服务档案未完成方案删除（右侧未完成方案左划）
 */
+ (void)deleteUnfinishFanganForForServiceRecordsRightWithParam:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion;

/**
 服务档案右侧车辆标签列表
 */
+ (void)carflgListForServiceRecordsLeftCompletion:(void (^)(NSArray<PorscheConstantModel *> *carflgList, PResponseModel* responser))completion;

/**
 服务档案左侧车辆信息列表
 */
+ (void)serviceRecordsLeftCarListWithParam:(NSDictionary *)param completion:(void (^)(NSArray<PorscheNewCarMessage *> *carList, PResponseModel* responser))completion;

/**
 添加备忘录
 */
+ (void)addMemoTextWith:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion;

/**
 编辑备忘录
 */
+ (void)editMemoTextWith:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion;

/**
 备忘录列表
 */
+ (void)memoTextListCompletion:(void (^)(NSArray<RemarkListModel *> *memoList, PResponseModel* responser))completion;

/**
 客户取消确认
 */
+ (void)userCancelAffirmCompletion:(void (^)(PResponseModel* responser))completion;

/**
 公里数列表 
 */
+ (void)resviceRecordsKMList:(void (^)(PResponseModel* responser))completion;

/**
 *4.匹配车牌
 * @param plateall  车牌
 */
+ (void)carNumberInputListWithParam:(NSDictionary *)param completion:(void (^)(NSArray<PorscheConstantModel *> *carNumberList, PResponseModel* responser))completion;

/**
 * 获取预检单信息
 */
+ (void)preCheckGetDataWithOrderID:(NSNumber *)orderID completion:(void (^)(PResponseModel* responser))completion;

/**
 * 修改预检单信息
 */
+ (void)preCheckChangeDataWithParam:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion;





#pragma mark - 赵国庆的接口 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

/**
 全部车系列表
 */
+ (void)getAllCarSeriers:(void (^)(NSArray<PorscheCarSeriesModel *> *carseries, PResponseModel* responser))completion;

/**
 获取全部车系常量列表 +++
 */
+ (void)getAllCarSeriersConstant:(void (^)(NSArray<PorscheConstantModel *> * _Nullable, PResponseModel * _Nullable))completion;

/**
 获取车型
 */
+ (void)getAllCarTypeWithCarsPctid:(NSNumber *)pctid completion:(void (^)(NSArray<PorscheCarTypeModel *> * _Nullable, PResponseModel * _Nullable))completion;


/**
 获取车型常量数据 +++
 */

+ (void)getAllCarTypeConstantWithCarsPctid:(NSNumber *)pctid completion:(void (^)(NSArray<PorscheConstantModel *> * _Nullable, PResponseModel * _Nullable))completion;

/**
  获取年款
 */
+ (void)getAllCarYearWithCartypePctid:(NSNumber *)pctid completion:(void (^)(NSArray<PorscheCarYearModel *> * _Nullable, PResponseModel * _Nullable))completion;

/**
 获取年款常量数据 +++
 */
+ (void)getAllCarYearConstantWithCartypePctid:(NSNumber *)pctid completion:(void (^)(NSArray<PorscheConstantModel *> * _Nullable , PResponseModel * _Nullable))completion;

/**
  获取排量
 */
+ (void)getAllCarOutputWithCaryearPctid:(NSNumber *)pctid completion:(void (^)(NSArray<PorscheCarOutputModel *> * _Nullable, PResponseModel * _Nullable))completion;


/**
 获取排量常量数据 +++
 */

+ (void)getAllCarOutputConstantWithCaryearPctid:(NSNumber *)pctid completion:(void (^)(NSArray<PorscheConstantModel *> * _Nullable, PResponseModel * _Nullable))completion;
/**
 下载pdf
 */
+ (void)downloadPDFWithURLStr:(NSString *)URLStr params:(NSDictionary *)params orderid:(NSNumber *)orderid completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

/**
 * 获取pdf文件路径
 */
+ (void)getPDFFileWithType:(PDFType)type spareInfo:(NSArray *)spareInfo printCategory:(NSArray *)category completion:(void (^)(NSURL *fileURL))completion;

/*
*  获取工单微信分享ID
**/
+ (void)getWechatShareidCompletion:(void (^)(PResponseModel* responser))completion;


@end
NS_ASSUME_NONNULL_END
