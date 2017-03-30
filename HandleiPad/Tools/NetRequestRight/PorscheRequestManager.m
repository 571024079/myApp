//
//  PorscheRequestManager.m
//  HandleiPad
//
//  Created by Robin on 2016/11/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheRequestManager.h"
#import "HDLeftSingleton.h"
#import "AppDelegate.h"
@implementation PorscheRequestManager

//业务分类
+ (void)getMaterialBusinessList:(void(^)(NSMutableArray *classifyArray,NSMutableArray *titleArray,PResponseModel* responser))complete {
    [PHTTPRequestSender sendRequestWithURLStr:BUSINESS_CATEGORY_URL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            NSMutableArray *titlrarray = [NSMutableArray array];
            for (NSDictionary *dic in responser.list) {
                PorscheBusinessClassify *model = [PorscheBusinessClassify new];
                [model setValuesForKeysWithDictionary:dic];
                [array addObject:model];
                [titlrarray addObject:model.businesstypename];
            }
            complete(array,titlrarray,responser);
        }else {
            complete(nil,nil,responser);
        }
    }];
}
//工时主子组
+ (void)getItemTimeGroupList:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complete {
    [PHTTPRequestSender sendRequestWithURLStr:ITEM_TIME_MAIN_CHILDREN_GROUP_URL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in responser.list) {
                PorscheItemTimeChildrenGroup *model = [PorscheItemTimeChildrenGroup new];
                [model setValuesForKeysWithDictionary:dic];
                [array addObject:model];
            }
            complete(array,responser);
        }else {
            complete(nil,responser);
        }
    }];

}

//备件主组
+ (void)getMaterialMianList:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complete//备件主组
{
    [[PRequestManager sharePRequestManager] sendRequestWithURLStr:MATERIAL_MAIN_GROUP_URL parameters:@{} completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            if (responser.list.count) {
                for (NSDictionary *dic in responser.list) {
                    PorscheMaterialMainGroup *model = [[PorscheMaterialMainGroup alloc]initWithDic:dic];
                    [array addObject:model];
                }
            }
            complete(array,responser);
        }else {
            complete(nil,responser);
        }
    }];

}
//单车开单信息
+ (void)getSingleCarMessagecomplete:(void(^)(PorscheNewCarMessage *model,PResponseModel* responser))complete {
    [PHTTPRequestSender sendRequestWithURLStr:SINGLE_CAR_MESSAGE_URL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            NSLog(@"获取单车信息成功");
//            PorscheNewCarMessage *model = [PorscheNewCarMessage new];
           PorscheNewCarMessage *model = [PorscheNewCarMessage yy_modelWithDictionary:responser.object];
            [model parseVINCarseriesModelToPorscheCarSeriesModel];
//            [model setValuesForKeysWithDictionary:responser.object];
            complete(model,responser);
        }else {
            complete(nil,responser);
        }
    }];
}

//根据车牌获取车辆信息
+ (void)getCarMessage:(NSDictionary *)carNumberDic complete:(void(^)(PResponseModel * _Nullable responser, NSError * _Nullable error))complete {
    [PHTTPRequestSender sendRequestWithURLStr:CAR_NUMBER_CAR_MESSAGE_URL parameters:carNumberDic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser,error);
    }];
}
//新开单操作
+ (void)setupBillingNewCarComplete:(PorscheRequestManagerBlock)complete {
    [PHTTPRequestSender sendRequestWithURLStr:BILLING_URL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            PorscheNewCarMessage *billing = [PorscheNewCarMessage yy_modelWithDictionary:responser.object];
            billing.woid = [responser.object objectForKey:@"orderid"];
            
            complete(billing,error);
        }else {
            complete(@0,error);
        }
    }];
}
//取消开单
+ (void)cancelBillingNewCarReason:(NSString *)reasonStr complete:(void(^)(NSInteger status,PResponseModel *responser))complete {
    [PHTTPRequestSender sendRequestWithURLStr:CANCEL_BILLING_URL parameters:@{@"canceldes":reasonStr} completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
    }];
}

//保存开单信息 responser.status == 100  保存成功
+ (void)saveBillingNewCarDic:(NSDictionary *)parts complete:(void(^)(NSInteger status,PResponseModel *responser))complete {
    [PHTTPRequestSender sendRequestWithURLStr:SAVE_CAR_BILLING_MESSAGE_URL parameters:parts completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
        
    }];
}

//根据VIN获取车辆信息
+ (void)carMessageWithVIN:(NSString *)vin carComplete:(void(^)(PResponseModel * _Nullable responser, NSError * _Nullable error))complete {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic hs_setSafeValue:vin forKey:@"vin"];
    [PHTTPRequestSender sendRequestWithURLStr:VIN_FOR_CAR_MESSAGE_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser,error);
        
    }];
}

//车辆列表(返回的是数组list)
+ (void)carListNewCarComplete:(void(^)(NSMutableArray *array,PResponseModel *responser))complete {
    [self carListNewCarWithParam:[NSDictionary dictionary] complete:complete];
}
+ (void)carListNewCarWithParam:(NSDictionary *)param complete:(void(^)(NSMutableArray *array,PResponseModel *responser))complete {
    
    [PHTTPRequestSender sendRequestWithURLStr:CAR_LIST_URL parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            NSMutableArray *datasource = [NSMutableArray array];
            
            if (responser.list.count) {
                for (NSDictionary *dic in responser.list) {
                    PorscheNewCarMessage *model = [PorscheNewCarMessage yy_modelWithDictionary:dic];
                    [datasource addObject:model];
                }
            }
            complete(datasource,responser);
        }else {
            complete(nil,responser);
        }
    }];
}
//获取保险公司
+ (void)getSecureCompanyListComplate:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complate
{
    [PHTTPRequestSender sendRequestWithURLStr:SECURE_COMPANY_MESSAGE_URL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            
            NSMutableArray *datasource = [NSMutableArray array];
            
            if (responser.list.count) {
                for (NSDictionary *dic in responser.list) {
                    PorscheInsuranceCompany *model = [[PorscheInsuranceCompany alloc]initWithDic:dic];
                    [datasource addObject:model];
                }
            }
            complate(datasource,responser);
        }else {
            complate(nil,responser);
        }
    }];
    
}
//取消开单原因
+ (void)getCancelBillingReasonListComplate:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complate//取消开单原因
{
    [PHTTPRequestSender sendRequestWithURLStr:CANCEL_BILLING_REASON_LIST_URL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            
            NSMutableArray *datasource = [NSMutableArray array];
            
            if (responser.list.count) {
                for (NSDictionary *dic in responser.list) {
                    PorscheCancelBillingReason *model = [[PorscheCancelBillingReason alloc]initWithDic:dic];
                    [datasource addObject:model];
                }
            }
            complate(datasource,responser);
        }else {
            complate(nil,responser);
        }
    }];
}
//开单中获取员工列表
+ (void)getStaffListTestWithGroupId:(NSNumber *)groupId positionId:(NSNumber *)positionId complete:(void(^)(NSMutableArray * _Nonnull classifyArray, PResponseModel * _Nonnull responser))complete {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"groupid":groupId,@"positionid":positionId}];
    [PorscheRequestManager getBillingStaffListParameters:dic Complate:^(NSMutableArray * _Nonnull classifyArray, PResponseModel * _Nonnull responser) {
        complete(classifyArray,responser);
    }];
}


+ (void)getBillingStaffListParameters:(NSMutableDictionary *)parameters Complate:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complate {
    [PHTTPRequestSender sendRequestWithURLStr:BILLING_STAFF_LIST_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            
            NSMutableArray *datasource = [NSMutableArray array];
            
            if (responser.list.count) {
                for (NSDictionary *dic in responser.list) {
                    PorscheConstantModel *model = [PorscheConstantModel new];
                    model.cvsubid = dic[@"userid"];
                    model.cvvaluedesc = dic[@"nickname"];
                    [datasource addObject:model];
                }
            }
            complate(datasource,responser);
        }else {
            complate(nil,responser);
        }
    }];
}
//开单中获取组列表 （只包含组名数组）
+ (void)getBillingStaffGroupListComplate:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complate {
    [PHTTPRequestSender sendRequestWithURLStr:BILLING_STAFF_GROUP_LIST_URL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            
            NSMutableArray *datasource = [NSMutableArray array];
            
            if (responser.list.count) {
                for (NSDictionary *dic in responser.list) {
                    PorscheStaffGroup *model = [[PorscheStaffGroup alloc]initWithDic:dic];
                    [datasource addObject:model];
                }
            }
            complate(datasource,responser);
        }else {
            complate(nil,responser);
        }
    }];
}
//员工职位列表
+ (void)getBillingStaffPositionListComplate:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complate {
    [PHTTPRequestSender sendRequestWithURLStr:BILLING_STAFF_POSITION_LIST_URL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            
            NSMutableArray *datasource = [NSMutableArray array];
            
            if (responser.list.count) {
                for (NSDictionary *dic in responser.list) {
                    PorscheStaffPosition *model = [[PorscheStaffPosition alloc]initWithDic:dic];
                    [datasource addObject:model];
                }
            }
            complate(datasource,responser);
        }else {
            complate(nil,responser);
        }
    }];
}
//方案级别
+ (void)getPorscheSchemeLevelListComplete:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complete {
    [PHTTPRequestSender sendRequestWithURLStr:PORSCHE_PROJECT_LEVEL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            
            NSMutableArray *datasource = [NSMutableArray array];
            
            if (responser.list.count) {
                for (NSDictionary *dic in responser.list) {
                    PorscheStaffPosition *model = [[PorscheStaffPosition alloc]initWithDic:dic];
                    [datasource addObject:model];
                }
            }
            complete(datasource,responser);
        }else {
            complete(nil,responser);
        }
    }];
    
}
//结算方式
+ (void)getPorscheProjectSettltmentComplete:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complete {
    [PHTTPRequestSender sendRequestWithURLStr:PORSCHE_PROJECT_SETTLEMENT_URL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        NSLog(@"结算方式获取");
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            if (responser.list.count) {
                for (NSDictionary *dic in responser.list) {
                    ProscheProjectSettlement *settlement = [ProscheProjectSettlement yy_modelWithDictionary:dic];
                    [array addObject:settlement];
                }
                complete(array,responser);
            }
        }else {
            complete(nil,responser);
        }
    }];
}
//获取备件库存列表
+ (void)getMaterialCubListComplete:(void(^)(NSMutableArray *classifyArray,PResponseModel* responser))complete {
    [PHTTPRequestSender sendRequestWithURLStr:PORSCHE_PROJECT_MATERIAL_CUB_URL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        NSLog(@"备件库存获取");
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            if (responser.list.count) {
                for (NSDictionary *dic in responser.list) {
                    ProscheMaterialLocationList *location = [ProscheMaterialLocationList yy_modelWithDictionary:dic];
                    [array addObject:location];
                }
                complete(array,responser);
            }
        }else {
            complete(nil,responser);
        }
    }];
}
//添加/删除备件库存
+ (void)upDateMaterialCubListWithid:(NSNumber *)partid isDelete:(BOOL)isDelete complete:(void(^)(NSInteger status,PResponseModel *responser))complete {
    NSDictionary *dic = isDelete ? @{@"stockid":partid}: @{@"partid":partid};
    NSString *url = isDelete ? WORK_OEDER_DELETE_MATERIAL_CUB_URL : WORK_OEDER_ADD_MATERIAL_CUB_URL;
    [PHTTPRequestSender sendRequestWithURLStr:url parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        NSLog(@"添加备件库存");
        complete(responser.status,responser);
    }];

}
//添加备件库存
+ (void)editMaterialCubListWithDic:(NSDictionary *)dic complete:(void(^)(NSInteger status,PResponseModel *responser))complete {
    [PHTTPRequestSender sendRequestWithURLStr:WORK_OEDER_EDIT_MATERIAL_CUB_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        NSLog(@"编辑备件库存");
        complete(responser.status,responser);
    }];
}

#pragma mark  流程确认 1. 2. 3. 4. 5. 6.
+ (void)orderSureToNextOrder:(NSInteger )number buttonid:(NSInteger)buttonid Complete:(void(^)(NSInteger status,PResponseModel *responser))complete {
    [PorscheRequestManager orderSureToNextOrder:number param:nil buttonid:buttonid Complete:complete];
}

+ (void)orderSureToNextOrder:(NSInteger )number param:(NSDictionary *)param buttonid:(NSInteger)buttonid Complete:(void(^)(NSInteger status,PResponseModel *responser))complete
{
    NSString *url;
    switch (number) {
        case 1://开单确认
            url = SURE_BILLING_URL;
            break;
        case 2://技师确认
            url = WORK_ORDER_TECHICIAN_SURE_TO_NEXT_URL;
            
            break;
        case 3://备件确认
            url = WORK_ORDER_MATERIAL_SURE_TO_NEXT_URL;
            
            break;
        case 4://服务确认
            url = WORK_ORDER_SERVICE_SURE_TO_NEXT_URL;
            
            break;
        case 5://客户确认
            url = WORK_ORDER_CUSATOM_SURE_TO_NEXT_URL;
            
            break;
        case 6://车间确认
            url = WORK_ORDER_WORKSHOP_SURE_TO_NEXT_URL;
            break;
        default:
            break;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (param)
    {
        [dic setValuesForKeysWithDictionary:param];
    }
//    if (buttonid >= 0) {
//        [dic setObject:@(buttonid) forKey:@"buttomid"];// 备件
//    }else {
//        [dic removeObjectForKey:@"buttomid"];
//    }
    [PHTTPRequestSender sendRequestWithURLStr:url parameters:dic  completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
        [[HDLeftSingleton shareSingleton] reloadNoticeVCData];
    }];
}
+ (void)insuranceConfirmComplete:(void(^)(NSInteger status,PResponseModel *responser))complete
{
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_INSURANCE_CONFIRM parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
    }];
}

 //type:1:等待车间确认  2：等待备件确认 3：等待增项确认 4：等待保修确认 //processstatus:2:技师  4：服务顾问
+ (void)waitConfirmWithStatus:(NSNumber *)status complete:(void(^)(NSInteger status,PResponseModel *responser))complete {
    NSDictionary *dic;
    if (status) {
        dic = @{@"type":status,@"processstatus":@([HDLeftSingleton shareSingleton].stepStatus)};
        
    }else {
        return;
    }
    
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_USER_WAITCONFIRM parameters:dic  completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
        [[HDLeftSingleton shareSingleton] reloadNoticeVCData];
    }];
    
}

#pragma mark  人员指派 特意参数
+ (void)bottomSaveChooseTechWithdic:(NSDictionary *)paramers complete:(void(^)(NSInteger status, PResponseModel * _Nonnull responser))complete {
        [PorscheRequestManager saveBillingNewCarDic:paramers complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
            complete(status,responser);
            if (status == 100) {
                
            }else {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"save_already_billing.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
            }
        }];
}

#pragma mark  工单信息

/****
 *  工单列表
 ****/
+ (void)getWorkOrderListComplate:(void(^)(PorscheNewCarMessage *carMessage,PResponseModel* responser))complate
{
    
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_LIST_URL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {

            PorscheNewCarMessage *message = [PorscheNewCarMessage yy_modelWithDictionary:responser.object];
            [message setDefaultSchemeList];
            [[HDLeftSingleton shareSingleton] setRemark:message.statememo];//设置备注

            complate(message,responser);
            NSLog(@"获取工单信息成功！");
        }else {
            complate(nil,responser);

            NSLog(@"获取工单信息失败！");

        }
    }];
}
/*
+ (void)workOrderSchemeListRequestWith:(PorscheRequestSchemeListModel *)model complete:(void(^)(NSDictionary *paramers,PResponseModel* responser))complete {//工单方案库
    
    NSMutableDictionary *parameters = [model yy_modelToJSONObject];
    
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_SCHEME_LIST_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (responser.status == 100) {
            
            NSDictionary *dic = responser.object;
            NSMutableArray *safeArray = [NSMutableArray array];
            [dic[@"safe"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                PorscheSchemeModel *model = [PorscheSchemeModel yy_modelWithDictionary:obj];
                [safeArray addObject:model];
            }];
            
            NSMutableArray *lurkingArray = [NSMutableArray array];
            [dic[@"lurking"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                PorscheSchemeModel *model = [PorscheSchemeModel yy_modelWithDictionary:obj];
                [lurkingArray addObject:model];
            }];
            NSMutableArray *infoArray = [NSMutableArray array];
            [dic[@"info"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                PorscheSchemeModel *model = [PorscheSchemeModel yy_modelWithDictionary:obj];
                [infoArray addObject:model];
            }];
            NSDictionary *endDic = @{@"safe":safeArray,@"lurking":lurkingArray,@"info":infoArray};
            complete(endDic,responser);
        } else {
            complete(nil,responser);
        }
    }];
}
*/

+ (void)workOrderUnfinishedSchemeListRequestWithPlateplace:(NSString *)plateplace carpalte:(NSString *)carplate  complete:(void(^)(NSMutableArray *list,PResponseModel* responser))complete {

    PorscheNewCarMessage *model = [HDLeftSingleton shareSingleton].carModel;
    
    NSDictionary *paramers = @{@"wocarid":model.wocarid};
    
    [PorscheRequestManager workOrderUnfinishedSchemeListRequestWith:paramers complete:complete];
}

+ (void)workOrderUnfinishedSchemeListRequestWith:(NSDictionary *)paramers  complete:(void(^)(NSMutableArray *list,PResponseModel* responser))complete //未完成
{
    [PHTTPRequestSender sendRequestWithURLStr:SCHEME_LIST_URL parameters:paramers completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            [responser.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                PorscheSchemeModel *model = [PorscheSchemeModel  yy_modelWithDictionary:obj];
                model.schemetype = @4;
                [array addObject:model];
            }];
            
            complete(array,responser);
        }else {
            complete(nil,responser);
        }
    }];
    
}
//添加未完成
+ (void)increaseUnfinishedItemWithModel:(PorscheNewScheme *)model isDelete:(BOOL)isDelete complete:(void(^)(NSInteger status,PResponseModel *model))complete {
    ProscheAdditionCondition *tmp = [ProscheAdditionCondition new];
    tmp.processstatus = @([HDLeftSingleton shareSingleton].stepStatus);
    tmp.type = isDelete ? kDeletion:kAddition;//添加/删除
    tmp.schemeid = model.schemeid;//方案在工单中的id
    tmp.schemestockid = model.wosstockid;//方案id
    tmp.schemtype = model.schemetype;
    [PorscheRequestManager increaseItemWithParamers:tmp complete:complete];
}
//添加条件方案
+ (void)increaseItemWithModel:(PorscheSchemeModel *)model isDelete:(BOOL)isDelete complete:(void(^)(NSInteger status,PResponseModel *model))complete {
    ProscheAdditionCondition *tmp = [ProscheAdditionCondition new];
    tmp.processstatus = @([HDLeftSingleton shareSingleton].stepStatus);
    tmp.type = isDelete ? kDeletion:kAddition;//添加/删除
    if (isDelete) {
        tmp.schemeid = model.ordersolutionid;//方案在工单中的id
        tmp.schemestockid = model.schemeid;//方案id
    }else {
        tmp.schemeid = model.orderschemeid;//方案在工单中的id
        tmp.schemestockid = model.schemeid;//方案id
    }
    
    tmp.schemtype = model.schemetype;//方案类型1.厂方2.本店3.自定义方案 3.未完成
    
    
    [PorscheRequestManager increaseItemWithParamers:tmp complete:complete];
}

//添加方案至工单
+ (void)increaseItemWithParamers:(ProscheAdditionCondition *)condition complete:(void(^)(NSInteger status,PResponseModel *model))complete;//添加方案至工单
{
    NSDictionary *dic = [condition yy_modelToJSONObject];
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_INCREASE_SCHEME_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        complete(responser.status,responser);
    }];
}
//添加全屏方案库至工单
+ (void)increaseItemsWithParamers:(NSDictionary *)condition complete:(void(^)(NSInteger status,PResponseModel *model))complete;//添加全屏方案库至工单
{
//    NSDictionary *dic = [condition yy_modelToJSONObject];
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_INCREASE_SCHEMES_URL parameters:condition completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        complete(responser.status,responser);
    }];
}
//添加工时备件至工单 addedType @1（kAddition）添加     @2（kDeletion）删除
+ (void)inscreaseProjectSubObjectAddedType:(NSNumber *)addedType Condition:(ProscheAdditionCondition *)condition complete:(void(^)(NSInteger status,PResponseModel *model))complete {
    
    NSDictionary *dic = [condition yy_modelToJSONObject];
    NSString *paramer = [addedType isEqual:kAddition] ? WORK_ORDER_INCREASE_SUBOBJECT_URL : WORK_ORDER_DELETE_SUBOBJECT_URL;
    [PHTTPRequestSender sendRequestWithURLStr:paramer parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        complete(responser.status,responser);
    }];
}
/****编辑
 *         自定义项目编辑 编辑名称
 ****/
//
+ (void)editCustomProjectName:(PorscheNewScheme *)scheme complete:(void(^)(NSInteger status,PResponseModel *model))complete {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic hs_setSafeValue:scheme.wosstockid forKey:@"id"];
    [dic hs_setSafeValue:scheme.schemename forKey:@"solutionName"];
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_EDIT_CUSTOM_NAME_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
    }];
}
/****
 *         工单方案编辑 备注编辑
 ****/
+ (void)editProjectRemark:(PorscheNewScheme *)scheme complete:(void(^)(NSInteger status,PResponseModel *model))complete {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic hs_setSafeValue:scheme.schemeid forKey:@"schemeid"];
    [dic hs_setSafeValue:scheme.wosremark forKey:@"remark"];
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_EDIT_SCHEME_REMARK_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
    }];
}
/****
 *         工单方案编辑 工时/备件编辑 type:1.工时 2.备件
 ****/
+ (void)editProjectWorkHourOrMaterial:(PorscheNewSchemews *)schemews type:(NSNumber *)type complete:(void(^)(NSInteger status,PResponseModel *model))complete {
    NSString *partUrl;
    
    ProscheAdditionSchemewsCondition *condition = [ProscheAdditionSchemewsCondition new];
    condition.processstatus = @([HDLeftSingleton shareSingleton].stepStatus - 1);
    if ([type isEqualToNumber:kWorkType]) {//工时
        partUrl = WORK_ORDER_EDIT_SCHEME_WORK_HOUR_URL;
        condition.schemeid = schemews.wospwosid;
        condition.workhourid = schemews.schemewsid;
        condition.workhourcount = schemews.schemewscount;
        condition.workhourname = schemews.schemewsname;
        condition.workhourunitprice = schemews.schemewsunitprice;
        condition.workhourcode = schemews.schemewscode;
    }else if ([type isEqualToNumber:kMaterialType]){//备件
        partUrl = WORK_ORDER_EDIT_SCHEME_MATERIAL_URL;

        condition.schemeid = schemews.wospwosid;
        condition.spareid = schemews.schemewsid;
        condition.sparecount = schemews.schemewscount;
        condition.sparename = schemews.schemewsname;
        condition.spareunitprice = schemews.schemewsunitprice;
        condition.sparecode = schemews.schemewscode;
        condition.sparephotocode = schemews.schemewsphotocode;
    }
    
    NSDictionary *dic = [condition yy_modelToJSONObject];
    [PHTTPRequestSender sendRequestWithURLStr:partUrl parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
    }];
}
/****
 *         工单 工时/备件/方案选择
 ****/

#pragma mark  钩的点击事件------
/**
 @param schemetype  左侧方案层级
 @param isNeenSend  是否通知左侧刷新列表
 */
+ (void)chooseBtWithid:(NSNumber *)projectid type:(NSNumber *)type isChoose:(NSNumber *)value success:(void(^)())success fail:(void(^)())fail {
    ProscheChooseSchemewsCondition *choose = [ProscheChooseSchemewsCondition new];
    choose.projectid = projectid;
    choose.type = type;
    choose.value = value;
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    [PorscheRequestManager chooseProjectSchemews:choose complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
        [hud hideAnimated:YES];
        if (status == 100) {
            NSLog(@"勾选成功");
            success();
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
            fail();
        }
    }];
    
}
+ (void)chooseProjectSchemews:(ProscheChooseSchemewsCondition *)condition complete:(void(^)(NSInteger status,PResponseModel *responser))complete {
    NSDictionary *dic = [condition yy_modelToJSONObject];
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_CHOOSE_SCHEMEWS_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
    }];
}


#pragma mark  工时/备件 匹配搜索
/****
 *          工时匹配 全匹配/部分匹配
 ****/
+ (void)searchWorkHour:(ProscheSchemewsSearchCondition *)condition complete:(void(^)(NSMutableArray *list,PResponseModel* responser))complete {
    NSDictionary *dic = [condition yy_modelToJSONObject];
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_MATECH_WORKHOUR_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            [responser.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                PorscheSchemeWorkHourModel *model = [PorscheSchemeWorkHourModel yy_modelWithDictionary:obj];
                [array addObject:model];
            }];
            complete(array,responser);
        }else {
            complete(nil,responser);
        }
        
    }];
}
/****
 *          备件匹配 图号匹配 部分
 ****/
+ (void)searchMaterialNumber:(ProscheSchemewsSearchCondition *)condition type:(NSNumber *)type complete:(void(^)(NSMutableArray *list,PResponseModel* responser))complete {
    NSMutableDictionary *dic = [NSMutableDictionary  dictionaryWithDictionary:[condition yy_modelToJSONObject]];
//NSString *urlStr;
    NSNumber *findid = nil;
    switch ([type integerValue]) {
        case 1:
            findid = @2;
            break;
        case 2:
            findid = @1;
            break;
        default:
            break;
    }
    //int findflag;   //当前在编辑内容：1：编号，2：图号
    [dic hs_setSafeValue:findid forKey:@"findflag"];
    
    
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_MATECH_MATERIAL_PARTLIST_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            [responser.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                PorscheSchemeSpareModel *model = [PorscheSchemeSpareModel yy_modelWithDictionary:obj];
                [array addObject:model];
            }];
            complete(array,responser);
        }else {
            complete(nil,responser);
        }
        
    }];
}
/****
 *          设置结算方式
 ****/
+ (void)setSettlementNumber:(ProscheProjectSettlementCondition *)condition isset:(BOOL)isset  complete:(void(^)(NSInteger status,PResponseModel* responser))complete {
    NSDictionary *dic = [condition yy_modelToJSONObject];
    NSString *str = isset ? WORK_ORDER_SET_SETTLEMENT_URL : WORK_ORDER_CONFIRM_SETTLEMENT_URL;
    [PHTTPRequestSender sendRequestWithURLStr:str parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
        if (responser.status == 100 && [str isEqualToString:WORK_ORDER_CONFIRM_SETTLEMENT_URL])
        {
            // 刷新消息
            [[HDLeftSingleton shareSingleton] reloadNoticeVCData];
        }
    }];
}

//model 备件工时或者方案  type：区分1.备件工时 2.方案   settle：结算方式model addStatus:添加流程 1.技师 2.服务顾问
+ (void)setsettleWithModel:(id)model isset:(BOOL)isset  addStatus:(NSNumber *)addStatus type:(NSNumber *)type settle:(PorscheConstantModel *)settle complete:(void(^)(NSInteger status, PResponseModel * _Nonnull responser))complete {
    if ([type isEqualToNumber:@1]) {//工时备件修改结算方式
        [PorscheRequestManager setupSchemewsSettlementWithModel:model isset:isset addsattus:addStatus settlt:settle complete:complete];
    }else if ([type isEqualToNumber:@2]) {//修改方案结算方式
        [PorscheRequestManager setupSchemeSettlementWithModel:model isset:isset addsattus:addStatus settlt:settle complete:complete];
    }
}

//方案结算方式设置/确认
+ (void)setupSchemeSettlementWithModel:(PorscheNewScheme *)scheme isset:(BOOL)isset addsattus:(NSNumber *)addStatus settlt:(PorscheConstantModel *)settle complete:(void(^)(NSInteger status, PResponseModel * _Nonnull responser))complete{
    ProscheProjectSettlementCondition *condition = [ProscheProjectSettlementCondition new];
    condition.processstatus = addStatus;
    condition.schemeid = scheme.schemeid;
    condition.settlementflg = @3;
    condition.settlementid = settle.cvsubid;
    [PorscheRequestManager setSettlementNumber:condition isset:isset complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
        complete(status,responser);
    }];
}

//工时备件结算方式设置/确认
+ (void)setupSchemewsSettlementWithModel:(PorscheNewSchemews *)schemews isset:(BOOL)isset addsattus:(NSNumber *)addStatus settlt:(PorscheConstantModel *)settle complete:(void(^)(NSInteger status, PResponseModel * _Nonnull responser))complete{
    ProscheProjectSettlementCondition *condition = [ProscheProjectSettlementCondition new];
    condition.processstatus = addStatus;
    condition.schemeid = schemews.wospwosid;
    condition.settlementflg = schemews.schemesubtype;
    condition.settlementid = settle.cvsubid;
    condition.wsid = schemews.schemewsid;
    [PorscheRequestManager setSettlementNumber:condition isset:isset complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
        complete(status,responser);
    }];
}


#pragma mark  折扣设置
//工时备件折扣 工单折扣
+ (void)editDiscountWithSchemews:(PorscheNewSchemews *)schemews rate:(NSNumber *)rate rangeid:(NSNumber *)rangeId complete:(void(^)(NSInteger status,PResponseModel *responser))complete{
    PorscheDiscountCondition *condition = [PorscheDiscountCondition new];
    condition.wsid = schemews.schemewsid;
    condition.schemeid = schemews.wospwosid;
    condition.type = schemews.schemesubtype;
    condition.rate = rate;
    condition.scope = rangeId ? rangeId : @1;//未传则为 当前单一折扣
    [PorscheRequestManager editProjectDiscount:condition complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
        complete(status,responser);
    }];
}


+ (void)editProjectDiscount:(PorscheDiscountCondition *)condition complete:(void(^)(NSInteger status,PResponseModel *responser))complete {
    NSDictionary *dic = [condition yy_modelToJSONObject];
    [PHTTPRequestSender sendRequestWithURLStr:WORK_OEDER_DISCOUNT_SCHEMEWS_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
    }];
}
//方案级别修改
+ (void)updateSchemeLevelWithSchemeId:(NSNumber *)schemeid levelid:(NSNumber *)levelid complete:(void(^)(NSInteger status,PResponseModel *responser))complete {
    NSDictionary *dic = @{@"schemeid":schemeid,@"levelid":levelid};
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_UPDATE_SCHEME_LEVEL_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
    }];
}

#pragma mark  获取工单方案信息
+ (void)getWorkOrderSchemeOrderid:(NSNumber *)orderid complete:(void(^)(PorscheSchemeModel *shcheme,PResponseModel *responser))complete {
    NSDictionary *dic = @{@"schemeid":orderid};
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_LIST_SCHEME_DETIAL_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            PorscheSchemeModel *scheme = [PorscheSchemeModel yy_modelWithDictionary:responser.object];
            scheme.flag = @1;
            complete(scheme,responser);
        }else {
            complete(nil,responser);
        }
    }];
}

#pragma mark   修改方案级别 常量版
+ (void)schemeUpdateLevelWithSchemeID:(NSNumber *)schemeid constant:(PorscheConstantModel *)constant completion:(void(^)(NSInteger status,PResponseModel *responser))completion {
    
    NSDictionary *parameters = @{@"schemeid":schemeid,
                                 @"levelname":constant.cvvaluedesc,
                                 @"levelid":constant.cvsubid};

    [PHTTPRequestSender sendRequestWithURLStr:SCHEME_REVISE_LEVEL_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser.status,responser);
    }];
}
#pragma mark 获取方案库列表
+ (void)schemeListWith:(NSDictionary *)model complete:(void(^)(NSArray *array, PResponseModel * _Nonnull responser))complete {
    
    
    [PHTTPRequestSender sendRequestWithURLStr:SCHEME_LIST_URL parameters:model completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (!complete) return;
        if (responser.status == SUCCESS_STATUS) {
            NSLog(@"获取方案列表成功");
            NSMutableArray *models = [[NSMutableArray alloc] init];
            [responser.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                PorscheSchemeModel *model = [PorscheSchemeModel yy_modelWithDictionary:obj];
                [models addObject:model];
            }];
            
            complete(models, responser);
        } else {
            complete(nil, responser);
        }
    }];
}

#pragma mark  保存工单中整个方案在方案详情中的修改
+ (void)saveWorkOrderScheme:(PorscheSchemeModel *)scheme complete:(void(^)(NSInteger status,PResponseModel *responser))complete {
    NSDictionary *dic = [scheme yy_modelToJSONObject];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dic];
    [param hs_setSafeValue:@1 forKey:@"flag"];
    
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_LIST_SCHEME_DETIAL_SAVE_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
    }];
}

#pragma mark  获取服务沟通 确认时 返回值开关：1. 2. 3. 4. 5. 6.
+ (void)getServiceSwitchStatusComplete:(void(^)(NSInteger status,PResponseModel * _Nullable responser))complete {
   [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_LIST_SERVICE_SWITCH_URL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
       complete(responser.status,responser);
   }];
}

#pragma mark  编辑开启/关闭
+ (void)sendMessageToEditWithStatus:(BOOL)isEdit complete:(void(^)(NSInteger status,PResponseModel * _Nullable responser))complete {

    NSString *urlStr;
    if (isEdit) {
        if (![[HDStoreInfoManager shareManager]carorderid])
        {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未选择车辆" height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
            return;
        }
        urlStr = WORK_ORDER_LIST_EDIT_OPEN_URL;
    }else {
        urlStr = WORK_ORDER_LIST_EDIT_CLOSE_URL;
    }
    
    [PHTTPRequestSender sendRequestWithURLStr:urlStr parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
        // 刷新左侧车辆列表
        if (isEdit)
        {
            [[HDLeftSingleton shareSingleton] updateOnFactoryCarList];
        }
    }];
}




#pragma mark  服务顾问开关 1：让技师确认   2：让备件确认  3:让保修员审批
+ (void)serviceSwitchStatus:(NSNumber *)status complete:(void(^)(NSInteger status,PResponseModel * _Nullable responser))complete {
    NSDictionary *dic = @{@"redirecttype":status};
    
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_LIST_SERVICE_SWITCH_OUT_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
    }];
}



#pragma mark  获取工单实时状态
+ (void)getWorkOrderCurrentStatusComplete:(void(^)(NSInteger status,PResponseModel * _Nullable responser))complete {
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_CURRENT_STATUS_NOTIFINATION parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
    }];
}

#pragma mark  获取提醒数据个数 
+ (void)getNoticeWithOrderid:(NSNumber *)orderid complete:(void(^)(NSInteger status,PResponseModel * _Nullable responser))complete {
    NSDictionary *dic = @{@"orderid":orderid};
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_NOTICE_NOTIFINATION parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        complete(responser.status,responser);
    }];
}


#pragma mark - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ Robin的接口 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

+ (void)loginRequestWith:(NSString *)username password:(NSString *)password complete:(PorscheRequestManagerBlock _Nullable)complete {
    
    NSDictionary *parameters = @{@"username":username,@"password":password};
    
    [PHTTPRequestSender sendRequestWithURLStr:LOGIN_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"网络错误");
            
        }  else if (responser.status != SUCCESS_STATUS) {
            NSLog(@"登录失败:%@",responser.msg);
            
        } else {
            
            HDStoreInfoManager *storeModel = [HDStoreInfoManager shareManager];
            [storeModel yy_modelSetWithDictionary:responser.object];
            NSLog(@"用户 %@ 登录成功",storeModel.username);
            
            [[PorscheConstant shareConstant] requestVersionList];
            [storeModel setAlias];
        }
        if (complete) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_MESSAGE_AFTER_LOGINED_NOTIFINATION object:nil];
            complete(responser,error);
        }
    }];
}

+ (void)loginRequestWithBackstagecomplete:(PorscheRequestManagerBlock)complete  {
    
    PorscheSchemeModel *model;
    [model yy_modelToJSONData];
    NSDictionary *userinfo = [PorscheUserTool getUserInfo];
    NSString *username = [userinfo objectForKey:@"username"];
    NSString *password = [userinfo objectForKey:@"password"];
    [PorscheRequestManager loginRequestWith:username password:password complete:complete];
}

+ (void)schemeListRequestWith:(PorscheRequestSchemeListModel *)model complete:(PorscheRequestManagerBlock)complete {
    
    if (!model) {
        model = [[PorscheRequestSchemeListModel alloc] init];
    }

    NSDictionary *parameters = [model yy_modelToJSONObject];
    
    [PHTTPRequestSender sendRequestWithURLStr:SCHEME_LIST_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        [PorscheRequestSchemeListModel shareModel].isSetupCar = NO;
        if (!complete) return;
        
        if (error) {
            NSLog(@"网络错误");
            complete(nil, error);
            return;
        }
        if (responser.status == SUCCESS_STATUS) {
            NSLog(@"获取方案列表成功");
            NSMutableArray *models = [[NSMutableArray alloc] init];
            [responser.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                PorscheSchemeModel *model = [PorscheSchemeModel yy_modelWithDictionary:obj];
                [models addObject:model];
            }];

            complete(models, nil);
        } else {
            NSLog(@"获取方案列表失败 -- %@",responser.msg);
            complete(nil, nil);
        }
    }];
}

+ (void)schemeListRequestAllListComplete:(PorscheRequestManagerBlock)complete{
    
    PorscheRequestSchemeListModel *model = [[PorscheRequestSchemeListModel alloc] init];
    
    [PorscheRequestManager schemeListRequestWith:model complete:complete];
}

+ (void)schemeListDeleteWithSchemeID:(NSString *)schemeid complete:(PorscheRequestSuccessBlock)complete {
    
    [PorscheRequestManager schemeDeleteMoreItemRequestMode:PorscheSchemeRequestDeteleModeAll SchemeIDs:@[schemeid] complete:complete];
}

+ (void)schemeUpdateLevelWithSchemeID:(NSInteger)schemeid levelID:(NSInteger)levelid levelName:(NSString *)levename completion:(PorscheRequestSuccessBlock)completion {
    
    NSDictionary *parameters = @{@"schemeid":@(schemeid),
                                 @"levelname":levename,
                                 @"levelid":@(levelid)};
    [PorscheRequestManager porscheSenderURL:SCHEME_REVISE_LEVEL_URL parameters:parameters completion:completion];
}

+ (void)schemeDeleteMoreItemRequestMode:(PorscheSchemeRequestDeteleMode)deteleMode SchemeIDs:(NSArray <NSString *>*)schemeids complete:(PorscheRequestSuccessBlock)complete{
    
    PorscheRequestSchemeDeleteModel *model = [[PorscheRequestSchemeDeleteModel alloc] init];
    model.caozuotype = @(deteleMode);
    model.isdellall = @(schemeids.count > 1);
    model.schemeids = [schemeids componentsJoinedByString:@","];
    
    NSDictionary *parameters = [model yy_modelToJSONObject];
    [PHTTPRequestSender sendRequestWithURLStr:SCHEME_DELETE_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (error) {
            complete(NO,responser,@"网络异常");
            [MBProgressHUD showMessageText:@"网络异常,请重试" toView:KEY_WINDOW anutoHidden:YES];
            return ;
        }
        
        if (responser.status == SUCCESS_STATUS) {
            complete(YES,responser,responser.msg);
        } else {
            complete (NO,responser,responser.msg);
        }
    }];
}

+ (void)updateCustomSignImages:(NSArray <ZLCamera *>*)images parameModel:(PorscheRequestUploadPictureVideoModel * _Nullable)requestModel completion:(void (^)(id _Nullable responser, NSError * _Nullable error))completion {
    __block NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    [images enumerateObjectsUsingBlock:^(ZLCamera * _Nonnull camera, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [imageArray addObject:camera.photoImage];
        
    }];
    
    NSDictionary *parameters =  [requestModel yy_modelToJSONObject];
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
//    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
//    hud.label.text = @"正在上传签字图片...";
//    __weak typeof(hud)weakhud = hud;
    [PHTTPRequestSender uploadImage:imageArray videoUrl:[images.firstObject videoUrl] parameters:parameters progress:^(NSProgress * _Nonnull progress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            weakhud.progress = 1.0 * progress.completedUnitCount / progress.totalUnitCount;
        });
        
    } completion:^(id _Nullable responser, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            weakhud.mode = MBProgressHUDModeText;
//            weakhud.label.text = error ?@"上传失败!": @"上传成功!";
//            [weakhud hideAnimated:YES afterDelay:1.0];
            completion(responser, error);
        });
    }];
}

+ (void)uploadCameraImages:(NSArray <ZLCamera *>*)images editImage:(BOOL)editImage video:(NSURL *)videoUrl parameModel:(PorscheRequestUploadPictureVideoModel * _Nullable)requestModel completion:(void (^)(id _Nullable responser, NSError * _Nullable error))completion{
    
//    PorscheRequestUploadPictureVideoModel *request = [[PorscheRequestUploadPictureVideoModel alloc] init];
//    request.aieditdesc = @"这是一个测试的相片上传";
//    request.aifiletype = @(1);
//    request.aipictype = @(1);
//    request.keytype = @(1);
//    request.relativeid = @(12345);

   __block NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    [images enumerateObjectsUsingBlock:^(ZLCamera * _Nonnull camera, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (editImage) {
            [imageArray addObject:camera.editImage];
            requestModel.parentid = camera.cameraID;
            requestModel.edittype = @(2);
        } else {
            [imageArray addObject:camera.photoImage];
            requestModel.edittype = @(1);
        }
    }];
    
    NSDictionary *parameters =  [requestModel yy_modelToJSONObject];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = @"正在上传图片与视频...";
    __weak typeof(hud)weakhud = hud;
    [PHTTPRequestSender uploadImage:imageArray videoUrl:videoUrl parameters:parameters progress:^(NSProgress * _Nonnull progress) {

        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakhud.progress = 1.0 * progress.completedUnitCount / progress.totalUnitCount;
        });
        
    } completion:^(id _Nullable responser, NSError * _Nonnull error) {
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responser, error);
            weakhud.mode = MBProgressHUDModeText;
            weakhud.label.text = error ?@"上传失败!": @"上传成功!";
            [weakhud hideAnimated:YES afterDelay:1.0];
//        });
    }];
}

+ (void)uploadVideoWithURL:(NSURL *)videoUrl parameModel:(PorscheRequestUploadPictureVideoModel * _Nullable)requestModel completion:(void (^)(id _Nullable responser, NSError * _Nullable error))completion {
    
    [PorscheRequestManager uploadCameraImages:@[] editImage:YES video:videoUrl parameModel:requestModel completion:completion];
}

+ (void)deleteCameraImage:(NSInteger)cameraID complete:(void(^)(BOOL delete, NSString *errorMsg))complete {
    
    NSDictionary *parameters = @{@"aiid":@(cameraID)};
    [PHTTPRequestSender sendRequestWithURLStr:CAMERA_DETELE_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
       
        if (error) {
            NSLog(@"请求失败");
        }
        
        if (responser.status == SUCCESS_STATUS) {
            NSLog(@"删除图片成功 -- %@",responser.msg);
            complete(YES,nil);
        } else {
            NSLog(@"删除图片失败 -- %@",responser.msg);
            complete(NO,responser.msg);
        }
    }];
}

+ (void)schemeDetailWithSchemeID:(NSInteger)schemeid  completion:(void (^)(PorscheSchemeModel * _Nullable porschemeModel, NSError * _Nullable error))completion {
    
    NSDictionary *parameters = @{@"schemeid":@(schemeid)};
    
    [PHTTPRequestSender sendRequestWithURLStr:SCHEME_DETAIL_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
       
        if (!completion) return;
        
        if (error) {
            NSLog(@"网络错误");
            completion(nil, error);
            return;
        }
        if (responser.status == SUCCESS_STATUS) {
            
            NSLog(@"获取方案详情列表成功");
            PorscheSchemeModel *model = [PorscheSchemeModel yy_modelWithDictionary:responser.object];
            
            completion(model, nil);
        } else {
            NSLog(@"获取方案详情失败 -- %@",responser.msg);
            completion(nil, nil);
        }

    }];
}

+ (void)notificationSchemeDetailWithSchemeID:(NSInteger)schemeid noticeID:(NSInteger)noticeid completion:(void (^)(PorscheSchemeModel * _Nullable porschemeModel, PResponseModel * _Nullable responser))completion {
    
    NSDictionary *parameters = @{@"schemeid":@(schemeid),
                                 @"noticeid":@(noticeid)};
    
    [PHTTPRequestSender sendRequestWithURLStr:SCHEME_DETAIL_NOTICE_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (!completion) return;
        
//        if (error) {
//            NSLog(@"网络错误");
//            completion(nil, error);
//            return;
//        }
        if (responser.status == SUCCESS_STATUS) {
            
            NSLog(@"获取方案详情列表成功");
            PorscheSchemeModel *model = [PorscheSchemeModel yy_modelWithDictionary:responser.object];
            
            completion(model, responser);
        } else {
            NSLog(@"获取方案详情失败 -- %@",responser.msg);
            completion(nil, responser);
        }
        
    }];

}

//保存方案
+ (void)schemeDetailSaveWithSchemeModel:(PorscheSchemeModel *)schemeModel completion:(PorscheRequestSuccessBlock)completion {
    
    NSDictionary *parameters = [schemeModel yy_modelToJSONObject];
    
    [PorscheRequestManager porscheSenderURL:SCHEME_SAVE_DETAIL_URL parameters:parameters completion:completion];
}

//添加方案到我的方案
+ (void)schemeDetailAddToMeWithSchemeModel:(PorscheSchemeModel *)schemeModel schemeType:(NSInteger)schemeType completion:(PorscheRequestSuccessBlock)completion {
    
    NSInteger originalType = schemeModel.schemetype.integerValue;
    schemeModel.schemetype = @(schemeType);

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[schemeModel yy_modelToJSONObject]];
    
    schemeModel.schemetype = @(originalType);
    
    
    if ([schemeModel.saveType integerValue] == 0)
    {
        // flag=0 不替换    processstatus=0    ordersolutionid;   //工单方案id   schemerelationorderid;//工单来源id
        [parameters hs_setSafeValue:@0 forKey:@"flag"];
        [parameters hs_setSafeValue:@0 forKey:@"processstatus"];
        [parameters hs_setSafeValue:@0 forKey:@"ordersolutionid"];
        [parameters hs_setSafeValue:@0 forKey:@"schemerelationorderid"];
    }
    else
    {
        [parameters hs_setSafeValue:[[HDStoreInfoManager shareManager] carorderid] forKey:@"schemerelationorderid"];
        [parameters hs_setSafeValue:@([[HDLeftSingleton shareSingleton] stepStatus]) forKey:@"processstatus"];
        [parameters hs_setSafeValue:@1 forKey:@"flag"];
    }

    
    
    
    [PorscheRequestManager porscheSenderURL:SCHEME_ADDTOME_URL parameters:parameters completion:completion];
}

+ (void)porscheSenderURL:(NSString *)url parameters:(NSDictionary *)parameters completion:(PorscheRequestSuccessBlock)completion {
    
    [PHTTPRequestSender sendRequestWithURLStr:url parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (!completion) return;
        
        if (error) {
            NSLog(@"网络错误");
            completion(NO,responser, @"网络错误");
            return;
        }
        if (responser.status == SUCCESS_STATUS) {
            
            NSLog(@"请求成功");
            completion(YES, responser, responser.msg);
        } else {
            NSLog(@"请求失败 -- %@",responser.msg);
            completion(NO, responser, responser.msg);
        }
    }];
}

+ (void)speraDetailWithSperaID:(NSInteger)speraid completion:(void (^)(PorscheSperaModel * _Nullable speraModel, NSError * _Nullable error))completion {
    
    NSDictionary *parameters = @{@"parts_id":@(speraid)};
    
    [PHTTPRequestSender sendRequestWithURLStr:SPERA_DETAIL_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (!completion) return;
        
        if (error) {
            NSLog(@"网络错误");
            completion(nil, error);
            return;
        }
        if (responser.status == SUCCESS_STATUS) {
            
            NSLog(@"获取备件详情成功");
            PorscheSperaModel *model = [PorscheSperaModel yy_modelWithDictionary:responser.object];
            
            completion(model, nil);
        } else {
            NSLog(@"获取备件详情失败 -- %@",responser.msg);
            completion(nil, nil);
        }
        
    }];
}

+ (void)speraListWith:(PorscheRequestSchemeListModel *)requestModel completion:(void (^)(NSArray <PorscheSchemeSpareModel *>* _Nullable speraArray, NSError * _Nullable error))completion {
    
    NSDictionary *parameters = [requestModel yy_modelToJSONObject];
    
    [PHTTPRequestSender sendRequestWithURLStr:SPERA_LIST_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        [PorscheRequestSchemeListModel shareModel].isSetupCar = NO;
        if (!completion) return;
        
        if (error) {
            NSLog(@"网络错误");
            completion(nil, error);
            return;
        }
        if (responser.status == SUCCESS_STATUS) {
            
            NSLog(@"获取备件列表成功");
            NSMutableArray *modelArray = [[NSMutableArray alloc] init];
            [responser.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PorscheSchemeSpareModel *model = [PorscheSchemeSpareModel yy_modelWithDictionary:obj];
                [modelArray addObject:model];
            }];
            completion(modelArray, nil);
        } else {
            NSLog(@"获取备件列表失败 -- %@",responser.msg);
            completion(nil, [NSError new]);
        }
    }];
}

+ (void)speraDetailSaveWithSperaModel:(PorscheSperaModel *)speraModel completion:(PorscheRequestSuccessBlock)completion {
    
    speraModel.type = @"update";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[speraModel yy_modelToJSONObject]];

    [PHTTPRequestSender sendRequestWithURLStr:SPERA_SAVE_DETAIL_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (!completion) return;
        
        if (error) {
            NSLog(@"网络错误");
            completion(NO, responser, @"网络错误");
            return;
        }
        if (responser.status == SUCCESS_STATUS) {
            
            NSLog(@"更新保存备件成功");
            completion(YES, responser, responser.msg);
        } else {
            NSLog(@"更新保存备件失败 -- %@",responser.msg);
            completion(NO, responser, responser.msg);
        }
    }];
    
    
}

+ (void)speraDetailAddToMeWithSperaModel:(PorscheSperaModel *)speraModel speraType:(NSInteger)speraType completion:(PorscheRequestSuccessBlock)completion {
    
    speraModel.type = @"add";
    speraModel.parts.parts_stock_type = @(0);//保存到我的备件需要传0
    NSInteger originalType = speraModel.parts.parts_type.integerValue;
    speraModel.parts.parts_type = @(speraType);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[speraModel yy_modelToJSONObject]];
    speraModel.parts.parts_type = @(originalType);
    
    
    [PHTTPRequestSender sendRequestWithURLStr:SPERA_SAVE_DETAIL_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (!completion) return;

        if (error) {
            NSLog(@"网络错误");
            completion(NO, responser, @"网络错误");
            return;
        }
        if (responser.status == SUCCESS_STATUS) {
            
            NSLog(@"添加备件成功");
            completion(YES, responser, responser.msg);
        } else {
            NSLog(@"添加备件失败 -- %@",responser.msg);
            completion(NO, responser, responser.msg);
        }
    }];
}

+ (void)speraDeleteWithID:(NSInteger)speraid completion:(PorscheRequestSuccessBlock)completion {
    
    NSDictionary *parameters = @{@"parts_id":@(speraid)};
    
    [PorscheRequestManager porscheDeleteWithID:speraid parameters:parameters deleteURL:SPERA_DELETE_URL completion:completion];
}

+ (void)porscheDeleteWithID:(NSInteger)speraid parameters:(NSDictionary *)parameters deleteURL:(NSString *)url completion:(PorscheRequestSuccessBlock)completion {
    
    [PHTTPRequestSender sendRequestWithURLStr:url parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (!completion) return;
        
        if (error) {
            NSLog(@"网络错误");
            completion(NO, responser, @"网络错误");
            return;
        }
        if (responser.status == SUCCESS_STATUS) {
            
            NSLog(@"删除备件成功");
            completion(YES, responser, responser.msg);
        } else {
            NSLog(@"删除备件失败 -- %@",responser.msg);
            completion(NO, responser, responser.msg);
        }
        
    }];

}

+ (void)workHoursListWith:(PorscheRequestSchemeListModel *)requestModel completion:(void (^)(NSArray <PorscheSchemeWorkHourModel *>* _Nullable workHourArray, NSError * _Nullable error))completion {
    
    NSDictionary *parameters = [requestModel yy_modelToJSONObject];
    
    [PHTTPRequestSender sendRequestWithURLStr:WORKHOURS_LIST_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        [PorscheRequestSchemeListModel shareModel].isSetupCar = NO;
        if (!completion) return;
        
        if (error) {
            NSLog(@"网络错误");
            completion(nil, error);
            return;
        }
        if (responser.status == SUCCESS_STATUS) {
            
            NSLog(@"获取工时列表成功");
            NSMutableArray *modelArray = [[NSMutableArray alloc] init];
            [responser.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PorscheSchemeWorkHourModel *model = [PorscheSchemeWorkHourModel yy_modelWithDictionary:obj];
                [modelArray addObject:model];
            }];
            completion(modelArray, nil);
        } else {
            NSLog(@"获取工时列表失败 -- %@",responser.msg);
            completion(nil, nil);
        }
    }];

}


+ (void)workHourDetailWithWorkHourID:(NSInteger)workhourid completion:(void (^)(PorscheWorkHoursModel * _Nullable workHourModel, NSError * _Nullable error))completion {
    
    NSDictionary *parameters = @{@"workhourid":@(workhourid)};
    
    [PHTTPRequestSender sendRequestWithURLStr:WORKHOURS_DETAIL_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (!completion) return;
        
        if (error) {
            NSLog(@"网络错误");
            completion(nil, error);
            return;
        }
        if (responser.status == SUCCESS_STATUS) {
            
            NSLog(@"获取工时详情成功");
            PorscheWorkHoursModel *model = [PorscheWorkHoursModel yy_modelWithDictionary:responser.object];
            
            completion(model, nil);
        } else {
            NSLog(@"获取工时详情失败 -- %@",responser.msg);
            completion(nil, nil);
        }
        
    }];
}

+ (void)workHourDetailSaveWithWorkHourModel:(PorscheWorkHoursModel *)workHourModel completion:(PorscheRequestSuccessBlock)completion {
    
    workHourModel.type = @"update";
    
    NSDictionary *parameters = [workHourModel yy_modelToJSONObject];
    
    [PHTTPRequestSender sendRequestWithURLStr:WORKHOURS_SAVE_DETAIL_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (!completion) return;
        
        if (error) {
            NSLog(@"网络错误");
            completion(NO, responser, @"网络错误");
            return;
        }
        if (responser.status == SUCCESS_STATUS) {
            
            NSLog(@"保存工时成功");
            completion(YES, responser, responser.msg);
        } else {
            NSLog(@"保存工时失败 -- %@",responser.msg);
            completion(NO, responser, responser.msg);
        }
    }];
}

+ (void)workHourDetailAddToMeWithWorkHourModel:(PorscheWorkHoursModel *)workHourModel workHourType:(NSInteger)workHourType completion:(PorscheRequestSuccessBlock)completion {
    
    workHourModel.type = @"add";
    NSInteger originalType = workHourModel.workhour.workhourtype.integerValue;
    workHourModel.workhour.workhourtype = @(workHourType);
    NSDictionary *parameters = [workHourModel yy_modelToJSONObject];
    workHourModel.workhour.workhourtype = @(originalType);
    
    [PHTTPRequestSender sendRequestWithURLStr:WORKHOURS_SAVE_DETAIL_URL parameters:parameters completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (!completion) return;
        
        if (error) {
            NSLog(@"网络错误");
            completion(NO, responser, @"网络错误");
            return;
        }
        if (responser.status == SUCCESS_STATUS) {
            
            NSLog(@"添加工时成功");
            completion(YES, responser, responser.msg);
        } else {
            NSLog(@"添加工时失败 -- %@",responser.msg);
            completion(NO, responser, responser.msg);
        }
    }];
}

+ (void)workHourDeleteWithID:(NSInteger)workhourid completion:(PorscheRequestSuccessBlock)completion {
    
    NSDictionary *parameters = @{@"workhourid":@(workhourid)};
    
    [PorscheRequestManager porscheDeleteWithID:workhourid parameters:parameters deleteURL:WORKHOURS_DELETE_URL completion:completion];
}










#pragma mark - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ Chengkai的接口 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
/**
 左侧任务提醒-任务列表
 */
+ (void)noticeLeftListWithParams:(NSDictionary *)param completion:(void (^)(NSMutableArray *noticeLeftArray,PResponseModel* responser))completion {
    
    [PHTTPRequestSender sendRequestWithURLStr:NOTICE_LEFT_LIST parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            [responser.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HDLeftNoticeListModel *data = [HDLeftNoticeListModel dataFormDic:obj];
                [array addObject:data];
            }];
            completion(array, responser);
        }else {
            completion(nil,responser);
        }
    }];
}
/**
 左侧本店提醒-下方方案列表
 */
+ (void)noticeLeftBottomFanganListWithCompletion:(void (^)(NSMutableArray *fanganListArray,PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:NOTICE_LEFT_FANGAN_LIST parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            [responser.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HDLeftNoticeFanganModel *data = [HDLeftNoticeFanganModel dataFormDic:obj];
                [array addObject:data];
            }];
            completion(array, responser);
        }else {
            completion(nil,responser);
        }
    }];
}
/**
 左侧任务提醒-处理未读的信息
 */
+ (void)noticeLeftListHandleUnreadNoticeWithParams:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:NOTICE_LEFT_HANDLEUNREADNOTICE parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}
/**
 我的收藏夹列表
 */
+ (void)myFavoriteslistWithParams:(NSDictionary *)param completion:(void (^)(NSMutableArray *favoritesList,PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:FAVORITE_LIST_URL parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            [responser.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PorscheSchemeFavoriteModel *data = [PorscheSchemeFavoriteModel yy_modelWithDictionary:obj];
                [array addObject:data];
            }];
            completion(array, responser);
        }else {
            completion(nil,responser);
        }
    }];
}
/**
 删除收藏夹-方案
 */
+ (void)deteleSchemeDataForScreenPopFileWithParams:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:FAVORITE_LIST_DETAIL_SCHEME_DETALE parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
            completion(responser);
    }];
}
/**
 删除收藏夹
 */
+ (void)deteleFavoritesListWithParams:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:FAVORITE_DETELE parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}
/**
 添加收藏夹
 */
+ (void)addFavoritesListWithParams:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:FAVORITE_INSERT_URL parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}
/**
 添加收藏夹-方案
 */
+ (void)addSchemeForFavoriteListWithParams:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:FAVORITE_INSERTSCHEME_URL parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}
/**
 收藏夹名称更改
 */
+ (void)changeFavoriteNameWithParams:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion isNeedShowPopView:(BOOL)isNeed {
    [PHTTPRequestSender sendRequestWithURLStr:FAVORITE_CHANGE_NAME parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    } isNeedShowPopView:isNeed];
}
/**
 在厂车辆全屏右侧点击交车
 */
+ (void)jiaocheForFullScreenRightViewcompletion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:FULLSCREEN_RIGHTVIEW_JIAOCHE parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}
/**
 在厂车辆本店工单信息
 */
+ (void)mainShopInformationcompletion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:MAINSHOPINFORMATION parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}
/**
 服务档案页面信息查询
 */
+ (void)serviceRecordsRightInformationWith:(NSDictionary *)param completion:(void (^)(HDServiceRecordsRightModel *serviceRecordsRightModel, PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:SERVICERECORDS_RIGHT_INFORMATION parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            HDServiceRecordsRightModel *model = [HDServiceRecordsRightModel yy_modelWithDictionary:responser.object];
            completion(model, responser);
        }else {
            completion(nil,responser);
        }
    }];
}
/**
 用户修改密码
 */
+ (void)userChangePasswordWithParam:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:USER_CHANGE_PASSWOED parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}
/**
 服务档案车辆添加标签
 */
+ (void)addCarflgForServiceRecordsRightWithParam:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:SERVICERECORDS_RIGHT_ADDCARFLG parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}
/**
 服务档案车辆标签删除
 */
+ (void)deleteCarflgForServiceRecordsRightWithParam:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:SERVICERECORDS_RIGHT_DELETECARFLG parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}
/**
 服务档案标签查找
 */
+ (void)searchCarflgListSearchForServiceRecordsRightWithParam:(NSDictionary *)param completion:(void (^)(NSArray *carflgTableViewArray, PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:SERVICERECORdS_RIGHT_CARFLG_SEARCH parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in responser.list) {
                HDServiceRecordsCarflgTableViewModel *model = [HDServiceRecordsCarflgTableViewModel yy_modelWithDictionary:dic];
                [array addObject:model];
            }
            completion(array, responser);
        }else {
            completion(nil, responser);
        }
    }];
}
/**
 服务档案未完成方案删除（右侧未完成方案左划）
 */
+ (void)deleteUnfinishFanganForForServiceRecordsRightWithParam:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:SERVICERECORDS_RIGHT_CELL_UNFINISH_DELETE parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}
/**
 服务档案右侧车辆标签列表
 */
+ (void)carflgListForServiceRecordsLeftCompletion:(void (^)(NSArray<PorscheConstantModel *> *carflgList, PResponseModel* responser))completion; {
    [PHTTPRequestSender sendRequestWithURLStr:SERVICERECORDS_LEFT_CARFLGLIST parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in responser.list) {
                PorscheConstantModel *data = [[PorscheConstantModel alloc] init];
                data.cvvaluedesc = dic[@"targetname"];
                data.cvsubid = dic[@"targetid"];
                [array addObject:data];
            }
            completion(array, responser);
        }else {
            completion(nil, responser);
        }
    }];
}
/**
 服务档案左侧车辆信息列表
 */
+ (void)serviceRecordsLeftCarListWithParam:(NSDictionary *)param completion:(void (^)(NSArray<PorscheNewCarMessage *> *carList, PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:SERVICERECORDS_LEFT_CARLIST parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in responser.list) {
                PorscheNewCarMessage *model = [PorscheNewCarMessage yy_modelWithDictionary:dic];
                [array addObject:model];
            }
            completion(array, responser);
        }else {
            completion(nil, responser);
        }
    }];
}

/**
 添加备忘录
 */
+ (void)addMemoTextWith:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:TOP_MEMO_ADD parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}

/**
 编辑备忘录
 */
+ (void)editMemoTextWith:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:TOP_MEMO_EDIT parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}

/**
 备忘录列表
 */
+ (void)memoTextListCompletion:(void (^)(NSArray<RemarkListModel *> *memoList, PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:TOP_MEMO_LIST parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in responser.list) {
                RemarkListModel *data = [RemarkListModel yy_modelWithDictionary:dic];
                [array addObject:data];
            }
            completion(array, responser);
        }else {
            completion(nil, responser);
        }
    }];
}

/**
 客户取消确认
 */
+ (void)userCancelAffirmCompletion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_USER_CANCELAFFIRM parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}

/**
 公里数列表
 */
+ (void)resviceRecordsKMList:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:SERVICERECORDS_RIGHT_KILOMETERELIST parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}

/**
 *4.匹配车牌
 * @param plateall  车牌
 */
+ (void)carNumberInputListWithParam:(NSDictionary *)param completion:(void (^)(NSArray<PorscheConstantModel *> *carNumberList, PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:CARNUMBER_LIST_URL parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in responser.list) {
                PorscheConstantModel *data = [[PorscheConstantModel alloc] init];
                data.cvvaluedesc = dic[@"plateall"];
                data.cvsubidstr = dic[@"plateplace"];
                data.extrainfo = dic[@"ccarplate"];
                [array addObject:data];
            }
            completion(array, responser);
        }else {
            completion(nil, responser);
        }
    }];
}


/**
 * 获取预检单信息
 */
+ (void)preCheckGetDataWithOrderID:(NSNumber *)orderID completion:(void (^)(PResponseModel* responser))completion {
    
    if (orderID != nil) {
        [PHTTPRequestSender sendRequestWithURLStr:PreCheck_GetData parameters:nil orderid:orderID completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
            completion(responser);
        } isNeedShowPopView:NO];
    }else {
        [PHTTPRequestSender sendRequestWithURLStr:PreCheck_GetData parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
            completion(responser);
        }];
    }
    
}


/**
 * 修改预检单信息
 */
+ (void)preCheckChangeDataWithParam:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion {
    [PHTTPRequestSender sendRequestWithURLStr:PreCheck_ChangeData parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        completion(responser);
    }];
}




#pragma mark - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 赵国庆的接口 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

//转换成车系常量
+ (void)getAllCarSeriers:(void (^)(NSArray<PorscheCarSeriesModel *> * _Nullable, PResponseModel * _Nullable))completion
{
    [PHTTPRequestSender sendRequestWithURLStr:PORSCHE_CARSERIES parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100)
        {
            NSMutableArray *carseries = [NSMutableArray array];
            for (NSDictionary *dict in responser.list)
            {
                PorscheCarSeriesModel *model = [PorscheCarSeriesModel yy_modelWithDictionary:dict];
                if (model) {
                    [carseries addObject:model];
                }
            }
            if (completion)
            {
                completion(carseries, responser);
            }
        } else {
            if (completion)
            {
                completion(nil, responser);
            }
        }
        
    }];
}
+ (void)getAllCarSeriersConstant:(void (^)(NSArray<PorscheConstantModel *> * _Nullable, PResponseModel * _Nullable))completion
{
    [PorscheRequestManager getAllCarSeriers:^(NSArray<PorscheCarSeriesModel *> * _Nullable carseries, PResponseModel * _Nullable responser) {
        
        NSMutableArray *carSeriesArray = [[NSMutableArray alloc] init];
  
        for (PorscheCarSeriesModel *carSerie in carseries) {
            
            PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
            model.cvvaluedesc = carSerie.cars;
            model.extrainfo = carSerie.carscode;
            model.cvsubid = carSerie.pctid;
            [carSeriesArray addObject:model];
        }
        
        if (completion) {
            completion(carSeriesArray,responser);
        }
    }];

}


+ (void)getAllCarTypeWithCarseries:(NSString *)carseries ccarseriesCode:(NSString *)carseriesCode completion:(void (^)(NSArray<PorscheCarTypeModel *> * _Nullable, PResponseModel * _Nullable))completion
{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:carseries forKey:@"cars"];
    [param hs_setSafeValue:carseriesCode forKey:@"carscode"];

    [PHTTPRequestSender sendRequestWithURLStr:PORSCHE_CARTYPE parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100)
        {
            NSMutableArray *cartypes = [NSMutableArray array];
            for (NSDictionary *dict in responser.list)
            {
                PorscheCarTypeModel *model = [PorscheCarTypeModel yy_modelWithDictionary:dict];
                if (model) {
                    [cartypes addObject:model];
                }
            }
            if (completion)
            {
                completion(cartypes, responser);
            }
        } else {
            if (completion)
            {
                completion(nil, responser);
            }
        }

    }];
}


+ (void)getAllCarTypeWithCarsPctid:(NSNumber *)pctid completion:(void (^)(NSArray<PorscheCarTypeModel *> * _Nullable, PResponseModel * _Nullable))completion
{
    /*
     cars	    车系          string	@mock=Cayman
     carscode	车系CODE      string	@mock=987
     */
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:pctid forKey:@"pctid"];
    
    [PHTTPRequestSender sendRequestWithURLStr:PORSCHE_CARTYPE parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100)
        {
            NSMutableArray *cartypes = [NSMutableArray array];
            for (NSDictionary *dict in responser.list)
            {
                PorscheCarTypeModel *model = [PorscheCarTypeModel yy_modelWithDictionary:dict];
                if (model) {
                    [cartypes addObject:model];
                }
            }
            if (completion)
            {
                completion(cartypes, responser);
            }
        } else {
            if (completion)
            {
                completion(nil, responser);
            }
        }
        
    }];

}

//把车系转出常量格式

+ (void)getAllCarTypeConstantWithCarseries:(NSString *)carseries ccarseriesCode:(NSString *)carseriesCode completion:(void (^)(NSArray<PorscheConstantModel *> * _Nullable, PResponseModel * _Nullable))completion {
    
    [PorscheRequestManager getAllCarTypeWithCarseries:carseries ccarseriesCode:carseriesCode completion:^(NSArray<PorscheCarTypeModel *> * _Nonnull carTypes, PResponseModel * _Nonnull responser) {
       
        NSMutableArray *carTypeArray = [[NSMutableArray alloc] init];
        
        for (PorscheCarTypeModel *carType in carTypes) {
            
            PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
            model.cvvaluedesc = [NSString stringWithFormat:@"%@ %@",carType.cars,carType.cartype];
            model.extrainfo = carType.cartypecode;
            model.configure = carType.pctconfigure1;
            model.descr = carType.cartype;
            [carTypeArray addObject:model];
        }
        if (completion) {
            completion(carTypeArray,responser);
        }
    }];
}

+ (void)getAllCarTypeConstantWithCarsPctid:(NSNumber *)pctid completion:(void (^)(NSArray<PorscheConstantModel *> * _Nullable, PResponseModel * _Nullable))completion
{
    [PorscheRequestManager getAllCarTypeWithCarsPctid:pctid completion:^(NSArray<PorscheCarTypeModel *> * _Nonnull carTypes, PResponseModel * _Nonnull responser) {
        
        NSMutableArray *carTypeArray = [[NSMutableArray alloc] init];
        
        for (PorscheCarTypeModel *carType in carTypes) {
            
            PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
            model.cvvaluedesc = [NSString stringWithFormat:@"%@ %@",carType.cars,carType.cartype];
            model.extrainfo = carType.cartypecode;
            model.configure = carType.pctconfigure1;
            model.descr = carType.cartype;
            model.cvsubid = carType.pctid;
            [carTypeArray addObject:model];
        }
        if (completion) {
            completion(carTypeArray,responser);
        }
    }];
}

+ (void)getAllCarYearWithCarseries:(NSString *)carseries ccarseriesCode:(NSString *)carseriesCode cartype:(NSString *)cartype cartypecode:(NSString *)cartypecode configure:(NSString *)configure completion:(void (^)(NSArray<PorscheCarYearModel *> * _Nullable, PResponseModel * _Nullable))completion
{
    /*
     cars           车系名称	string	@mock=Cayman
     carscode       车系code	string	@mock=987
     cartype        车型名称	string	@mock=S
     cartypecode	车型code	string	@mock=12
     pctconfigure1      车型配置	string	@mock=
     */
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:carseries forKey:@"cars"];
    [param hs_setSafeValue:carseriesCode forKey:@"carscode"];
    [param hs_setSafeValue:cartype forKey:@"cartype"];
    [param hs_setSafeValue:cartypecode forKey:@"cartypecode"];
    [param hs_setSafeValue:configure forKey:@"pctconfigure1"];

    [PHTTPRequestSender sendRequestWithURLStr:PORSCHE_CARYEAR parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100)
        {
            NSMutableArray *years = [NSMutableArray array];
            for (NSDictionary *dict in responser.list)
            {
                PorscheCarYearModel *model = [PorscheCarYearModel yy_modelWithDictionary:dict];
                if (model) {
                    [years addObject:model];
                }
            }
            if (completion)
            {
                completion(years, responser);
            }
        } else {
            if (completion)
            {
                completion(nil, responser);
            }
        }

    }];
}


+ (void)getAllCarYearWithCartypePctid:(NSNumber *)pctid completion:(void (^)(NSArray<PorscheCarYearModel *> * _Nullable, PResponseModel * _Nullable))completion
{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:pctid forKey:@"pctid"];
    
    [PHTTPRequestSender sendRequestWithURLStr:PORSCHE_CARYEAR parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100)
        {
            NSMutableArray *years = [NSMutableArray array];
            for (NSDictionary *dict in responser.list)
            {
                PorscheCarYearModel *model = [PorscheCarYearModel yy_modelWithDictionary:dict];
                if (model) {
                    [years addObject:model];
                }
            }
            if (completion)
            {
                completion(years, responser);
            }
        } else {
            if (completion)
            {
                completion(nil, responser);
            }
        }
        
    }];
}

+ (void)getAllCarYearConstantWithCarseries:(NSString *)carseries ccarseriesCode:(NSString *)carseriesCode cartype:(NSString *)cartype cartypecode:(NSString *)cartypecode configure:(NSString *)configure completion:(void (^)(NSArray<PorscheConstantModel *> * _Nullable , PResponseModel * _Nullable))completion {
    
    [PorscheRequestManager getAllCarYearWithCarseries:carseries ccarseriesCode:carseriesCode cartype:cartype cartypecode:cartypecode configure:configure completion:^(NSArray<PorscheCarYearModel *> * _Nullable carYears, PResponseModel * _Nullable responser) {
        
        NSMutableArray *carYearArray = [[NSMutableArray alloc] init];
        
        for (PorscheCarYearModel *caryear in carYears) {
            
            PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
            model.cvvaluedesc = caryear.year;
            model.extrainfo = caryear.year;
            
            // 年款 新增车系 车系code 车型  车型code
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
            
            [carYearArray addObject:model];
        }
        if (completion) {
            completion(carYearArray,responser);
        }

    }];
}

+ (void)getAllCarYearConstantWithCartypePctid:(NSNumber *)pctid completion:(void (^)(NSArray<PorscheConstantModel *> * _Nullable , PResponseModel * _Nullable))completion
{
    [PorscheRequestManager getAllCarYearWithCartypePctid:pctid completion:^(NSArray<PorscheCarYearModel *> * _Nullable carYears, PResponseModel * _Nullable response) {
        
        NSMutableArray *carYearArray = [[NSMutableArray alloc] init];
        
        for (PorscheCarYearModel *caryear in carYears) {
            
            PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
            model.cvvaluedesc = caryear.year;
            model.extrainfo = caryear.year;
            model.cartype = caryear.cartype;
            model.pctcartypeno = caryear.pctcartypeno;
            model.pctconfigure1 = caryear.pctconfigure1;
            model.pctcarsno = caryear.pctcarsno;
            model.cars = caryear.cars;
            model.cvsubid = caryear.pctid;
            
            [carYearArray addObject:model];
        }
        if (completion) {
            completion(carYearArray,response);
        }
    }];
}

+ (void)getAllCarOutputWithCarseries:(NSString *)carseries ccarseriesCode:(NSString *)carseriesCode cartype:(NSString *)cartype cartypecode:(NSString *)cartypecode configure:(NSString *)configure year:(NSString *)year completion:(void (^)(NSArray<PorscheCarOutputModel *> * _Nullable, PResponseModel * _Nullable))completion
{
    /*
     cars           车系	string	@mock=Cayman
     carscode       车系code	string	@mock=987
     cartype        车型	string	@mock=S
     cartypecode	车型code	string	@mock=12
     configure      车辆配置	string	@mock=
     year           年款	string	@mock=2010
     */
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:carseries forKey:@"cars"];
    [param hs_setSafeValue:carseriesCode forKey:@"carscode"];
    [param hs_setSafeValue:cartype forKey:@"cartype"];
    [param hs_setSafeValue:cartypecode forKey:@"cartypecode"];
    [param hs_setSafeValue:configure forKey:@"configure"];
    [param hs_setSafeValue:year forKey:@"year"];

    [PHTTPRequestSender sendRequestWithURLStr:PORSCHE_CAROUTPUT     parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100)
        {
            NSMutableArray *outputs = [NSMutableArray array];
            for (NSDictionary *dict in responser.list)
            {
                PorscheCarOutputModel *model = [PorscheCarOutputModel yy_modelWithDictionary:dict];
                if (model) {
                    [outputs addObject:model];
                }
            }
            if (completion)
            {
                completion(outputs, responser);
            }
        } else {
            if (completion)
            {
                completion(nil, responser);
            }
        }

    }];
}

+ (void)getAllCarOutputWithCaryearPctid:(NSNumber *)pctid completion:(void (^)(NSArray<PorscheCarOutputModel *> * _Nullable, PResponseModel * _Nullable))completion
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:pctid forKey:@"pctid"];
    [PHTTPRequestSender sendRequestWithURLStr:PORSCHE_CAROUTPUT parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100)
        {
            NSMutableArray *outputs = [NSMutableArray array];
            for (NSDictionary *dict in responser.list)
            {
                PorscheCarOutputModel *model = [PorscheCarOutputModel yy_modelWithDictionary:dict];
                if (model) {
                    [outputs addObject:model];
                }
            }
            if (completion)
            {
                completion(outputs, responser);
            }
        } else {
            if (completion)
            {
                completion(nil, responser);
            }
        }
        
    }];
}

+ (void)getAllCarOutputConstantWithCarseries:(NSString *)carseries ccarseriesCode:(NSString *)carseriesCode cartype:(NSString *)cartype cartypecode:(NSString *)cartypecode configure:(NSString *)configure year:(NSString *)year completion:(void (^)(NSArray<PorscheConstantModel *> * _Nullable, PResponseModel * _Nullable))completion {
    
    [PorscheRequestManager getAllCarOutputWithCarseries:carseries ccarseriesCode:carseriesCode cartype:cartype cartypecode:cartypecode configure:configure year:year completion:^(NSArray<PorscheCarOutputModel *> * _Nullable carOutputs, PResponseModel * _Nullable responser) {
        
        NSMutableArray *carOutputArray = [[NSMutableArray alloc] init];
        for (PorscheCarOutputModel *caroutput in carOutputs) {
            
            PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
            model.cvvaluedesc = caroutput.displacement;
            model.extrainfo = caroutput.displacement;
            [carOutputArray addObject:model];
        }
        if (completion) {
            completion(carOutputArray,responser);
        }
    }];
}

+ (void)getAllCarOutputConstantWithCaryearPctid:(NSNumber *)pctid completion:(void (^)(NSArray<PorscheConstantModel *> * _Nullable, PResponseModel * _Nullable))completion
{
    [PorscheRequestManager getAllCarOutputWithCaryearPctid:pctid completion:^(NSArray<PorscheCarOutputModel *> * _Nullable carOutputs, PResponseModel * _Nullable responser) {
        NSMutableArray *carOutputArray = [[NSMutableArray alloc] init];
        for (PorscheCarOutputModel *caroutput in carOutputs) {
            
            PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
            model.cvvaluedesc = caroutput.displacement;
            model.extrainfo = caroutput.displacement;
            model.cvsubid = caroutput.pctid;
            [carOutputArray addObject:model];
        }
        if (completion) {
            completion(carOutputArray,responser);
        }
    }];
}



+ (void)downloadPDFWithURLStr:(NSString *)URLStr params:(NSDictionary *)params orderid:(NSNumber *)orderid completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
    [PHTTPRequestSender sendDownloadRequestWithURLStr:URLStr parameters:params orderid:orderid completionHandler:completionHandler];
}

+ (void)getPDFFileWithType:(PDFType)type spareInfo:(NSArray *)spareInfo printCategory:(NSArray *)category completion:(void (^)(NSURL *fileURL))completion {
    
    if (![[[HDStoreInfoManager shareManager] carorderid] integerValue])
    {
        // 未选择工单
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未选择工单" height:60 center:HD_FULLView.center superView:HD_FULLView];
        return;
    }
    NSMutableDictionary *param = nil;
    NSString *URLStr = PRINT_SPAREPDF;
    if (type == PDF_Quotation)
    {
        NSString *typeStr = @"";
        if(category.count)
        {
            typeStr = [category componentsJoinedByString:@","];
        }
        param = [NSMutableDictionary dictionaryWithDictionary:@{@"type":typeStr}];
        
        //        [param hs_setSafeValue:spareInfo forKey:@"pdfPartsInfoDtos"];
        
        URLStr = PRINT_QUOTATIONPDF;
    }
    else
    {
        param = [NSMutableDictionary dictionary];
        [param hs_setSafeValue:spareInfo forKey:@"pdfPartsInfoDtos"];
    }
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    [PorscheRequestManager downloadPDFWithURLStr:URLStr params:param orderid:[[HDStoreInfoManager shareManager] carorderid] completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        if (!error)
        {
            if ([filePath absoluteString].length)
            {
                if (completion)
                {
                    completion(filePath);
                }
            }
        }
    }];
}

+ (void)getWechatShareidCompletion:(void (^)(PResponseModel* responser))completion
{
    [PHTTPRequestSender sendRequestWithURLStr:WechatShareID parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100)
        {
            if (completion)
            {
                completion(responser);
            }
        }
        else
        {
            if (completion)
            {
                completion(nil);
            }
        }
    }];
}

@end
