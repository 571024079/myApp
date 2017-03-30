//
//  HDPermissionDefine.h
//  HandleiPad
//
//  Created by handlecar on 16/12/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#ifndef HDPermissionDefine_h
#define HDPermissionDefine_h




// ************************ 功能模块--（工单） **************************

//20161226 sandy 大权限(外加+(车间确认权限，保修审批，方案工时打折，方案备件打折，取消确认))
#define HDOrder_Kaidan                                                          103         //开单信息（103）
#define HDOrder_Jishizengxiang                                                  104         // 技师增项（104）
#define HDOrder_Beijianqueren                                                   105         //备件确认（105）
#define HDOrder_Fuwugoutong                                                     106         //服务沟通（106）
#define HDOrder_Kehuqueren                                                      107         //客户确认（107）



//子模块
#define HDOrder_Remark                                                          102         //工单备注
#define HDOrder_Remark_Edit                                                     10201       //添加和修改自己备注



//  ------- 开单信息
#define HDOrder_KaiDan_BuiltNewOrder                                            10301       //新建工单(开单信息)
#define HDOrder_KaiDan_CancelOrder                                              10302       //取消工单(开单信息)
#define HDOrder_KaiDan_EditOrder                                                10303       //编辑工单(开单信息)
#define HDOrder_KaiDan_EditOtherPersonOrder                                     10304       //编辑他人工单(开单信息)

//  ------- 技师增项
#define HDOrder_JiShiZengXiang_Edit                                             10401       //编辑工单(技师增项)
#define HDOrder_JiShiZengXiang_EditOtherPersonOrder                             10402       //编辑他人工单(技师增项)
#define HDOrder_JiShiZengXiang_WorkshopAffirm                                   10403       //车间确认权限
#define HDOrder_JiShiZengXiang_EditServiceAdviser                               10404       //服务顾问的增项(编辑)
#define HDOrder_JiShiZengXiang_CancelScheme                                     10404001    //服务顾问的增项(取消方案)
#define HDOrder_JiShiZengXiang_CancelSchemeTime                                 10404002    //服务顾问的增项(取消方案工时)
#define HDOrder_JiShiZengXiang_CancelSchemeSpacePart                            10404003    //服务顾问的增项(取消方案备件)
// 结算方式查看权限，由于PC无法设置暂时注释
//#define HDOrder_JiShiZengXiang_JiesuanFangshi                                   10405       //结算方式
#define HDOrder_JiShiZengXiang_BaoXiuShenQing                                   10405001    //保修申请
#define HDOrder_JiShiZengXiang_XuanzeNeijie                                     10405002    //选择内结
#define HDOrder_JiShiZengXiang_AfterConfirmAdded                                10406       // 技师增项-客户确认后增项


//  ------- 备件确认
#define HDOrder_BeiJianQueRen_Edit                                              10501       //编辑工单(备件确认)
#define HDOrder_BeiJianQueRen_CubStatus                                         10502       //库存状态修改
#define HDOrder_BeiJianQueRen_NormalMatarial_change_temporary                   10503       //常备件临时修改
#define HDOrder_BeiJianQueRen_NormalMatarial_change_permanent                   10504       //常备件永久修改

//  ------- 服务沟通
#define HDOrder_FuWuGouTong_Edit                                                10601        //编辑工单(服务沟通)

// 结算方式查看权限，由于PC无法设置暂时注释
//#define HDOrder_FuWuGouTong_JiesuanFangshi                                      10602        //结算方式选择

#define HDOrder_FuWuGouTong_BaoXiuShenPi                                        10602003     //保修审批
#define HDOrder_FuWuGouTong_BaoXiuShenQing                                      10602001     //保修申请
#define HDOrder_FuWuGouTong_XuanzeNeijie                                        10602002     //选择内结
#define HDOrder_FuWuGouTong_SchemeTimeDiscount_Rate                             10603        //方案工时打折
#define HDOrder_FuWuGouTong_SchemeSpacePartDiscount_Rate                        10604        //方案备件打折
#define HDOrder_FuWuGouTong_Add_AfterClientAffirm                               10605        //服务增项—客户确认后增项
#define HDOrder_FuWuGouTong_OtherAdd_CanChange                                  10606        //服务增项—他人已增项工单，可进行修改（修改的内容是名称、单价、数量、编号、图号）


//  ------- 客户确认
#define HDOrder_ClientAffirm_Affirm                                             10701        //客户确认（含电子签字）
#define HDOrder_ClientAffirm_CanCelAffirm                                       10702        //取消确认
//#define HDOrder_ClientAffirm_Share                                              10703        //分享
#define HDOrder_ClientAffirm_Share_WeChat                                       10703001     //微信分享
#define HDOrder_ClientAffirm_Share_Mail                                         10703002     //邮件分享
//#define HDOrder_ClientAffirm_Share_PrePrint                                     10704        //预览和打印
#define HDOrder_ClientAffirm_Share_Price                                        10704001     //报价单
#define HDOrder_ClientAffirm_Share_Goods                                        10704002     //备货单

//增项权限
#define HDOrder_AddedScheme                                                     108          //增项权限（本店方案库、我的方案库、我的收藏夹、未完成）

//  ------- 工单主流程(在工单中修改已选方案)
#define HDOrder_InOrder_ChangeSelectScheme                                      109          //在工单中修改已选方案
#define HDOrder_InOrder_ChangeSelectScheme_EditSchemeTime                       10901        //编辑已选方案库方案的工时信息
#define HDOrder_InOrder_ChangeSelectScheme_EditSchemeMaterial                   10902        //编辑已选方案库方案的备件信息
#define HDOrder_GoSchemeLibrary_AddCustomScheme                                 10903        //新增自定义方案

//  ------- 工单主流程(进入方案库)
#define HDOrder_GoSchemeLibrary                                                 110          //方案库
//#define HDOrder_GoSchemeLibrary_Edit                                            11001        //编辑
#define HDOrder_GoSchemeLibrary_EditContent                                     11001        //编辑内容（名称、单价、数量、编号、图号）
#define HDOrder_GoSchemeLibrary_EditProperty                                    11002        //编辑属性（车型、公里数、时间、业务、组别、级别、收藏夹）
#define HDOrder_GoSchemeLibrary_ReplaceOldSchemeAfterChangeMyShop               11003        //修改本店方案后替换原方案
#define HDOrder_GoSchemeLibrary_SaveToOrder                                     11004        //加方案入工单

//  ------- 工单主流程(进入备件库) 技师
#define HDOrder_GoSpacePartLibrary                                              111          //进入备件库
#define HDOrder_GoSpacePartLibrary_Add                                          11101        //新增备件
#define HDOrder_GoSpacePartLibrary_Edit                                         11102        //编辑
#define HDOrder_GoSpacePartLibrary_EditContent                                  11103        //编辑（名称、单价、数量、编号）
#define HDOrder_GoSpacePartLibrary_EditProperty                                 11104        //编辑（车型、公里数、时间、业务、组别）
#define HDOrder_GoSpacePartLibrary_ReplaceOldSpacePartAfterChangeMyShop         11105        //修改本店备件后替换原备件

//  ------- 工单主流程(进入工时库)
#define HDOrder_GoTimeLibrary                                                   112          //进入工时库
#define HDOrder_GoTimeLibrary_Add                                               11201        //新增工时
#define HDOrder_GoTimeLibrary_Edit                                              11202        //编辑
#define HDOrder_GoTimeLibrary_ReplaceOldTimeAfterChangeMyShop                   11205        //修改本店工时后替换原工时
#define HDOrder_GoTimeLibrary_EditContent                                       11203        //编辑（名称、单价、数量、编号）
#define HDOrder_GoTimeLibrary_EditProperty                                      11204        //编辑（车型、公里数、时间、业务、组别）
//  ------- 工单主流程(预计交车时间)
#define HDOrder_PredictJiaoCheTime                                              113          //预计交车时间
#define HDOrder_PredictJiaoCheTime_ChangeOther                                  11301        //修改他人填写的预计交车时间
#define HDOrder_PredictJiaoCheTime_CanChangeAfterClientAffirm                   11302        //客户确认后，可修改预计交车时间



// ************************ 功能模块--（在厂车辆） **************************
//
#define HDStayFactoryList_Scan                                                  201
#define HDStayFactoryList_JiaoChe                                               20101         //交车（20101）


// ************************ 功能模块--（任务提醒） **************************

#define HDTaskNotice_MyShopNotice                                               301          //本店提醒
#define HDTaskNotice_MyShopNotice_Read                                          30101        //查看
#define HDTaskNotice_MyShopNotice_Edit                                          30102        //编辑
#define HDTaskNotice_MyShopNotice_SaveBecomeMyScheme                            30103        //存为我的方案
#define HDTaskNotice_MyShopNotice_NoticeOrderAddToOrder                         30104        //提醒方案加入工单



// ************************ 功能模块--（我的设置） **************************

#define HDOrder_User_Code                                                       501         //密码（501）
#define HDMySet_ChangePassWord                                                  50101        //修改密码



// ************************ 功能模块--（服务档案） **************************

#define HDOrder_Unfinished_Scheme                                               601         //未完成项目（601）
#define HDServiceRecords_IgnoreUnfinishProject                                  60101        //忽略未完成项目

#define HDOrder_Car_Remark                                                      602         //车辆标签（602）
#define HDServiceRecords_EditCarflg                                             60201        //标签编辑





//#define HDOrder_Edit_schemeInOrder                                              109         //在工单中修改已选方案（109）
//#define HDOrder_Scheme_In                                                       110         //进入方案库（110）
//#define HDOrder_Material_In                                                     111         //进入备件库（111）
//#define HDOrder_Workhour_In                                                     112         //进入工时库（112）
//#define HDOrder_Pre_Delivery_Date                                               113         //预计交车时间（113）
//
//#define HDTaskNotice_MyShopNotice                                               301         //本店提醒（301）


#endif /* HDPermissionDefine_h */
