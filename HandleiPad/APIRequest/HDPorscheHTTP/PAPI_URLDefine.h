//
//  PAPI_URLDefine.h
//  HandleiPad
//
//  Created by Handlecar on 16/11/15.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//  接口定义头文件


#ifndef PAPI_URLDefine_h
#define PAPI_URLDefine_h

#define SUCCESS_STATUS  100

#define  DevelopmentEnvironment       1       // 0 测试环境  1 开发环境

#if 1 // 1 开发测试服务器

#define BASE_URL        [HDUtils readCustomClassConfig:@"servivAddress"]

//#define  BASE_URL      @"http://106.14.38.215:8688"             // 开发用服务器 重构ip

//#define  BASE_URL      @"http://106.14.38.215:8600"             // 8600 演示

//#define  BASE_URL       @"http://106.14.16.216:8989"                       // 演示用

//#define  BASE_URL       @"http://106.14.16.216:9090"                       // 长沙正式ip 正式发布去掉首页端口号显示


//#define  BASE_URL      @"http://106.14.38.215:8689"             // 测试用服务器  #else

/*
 #define  BASE_URL      @"http://porsche1.handlecar-oms.com"             // 开发用服务器 重构ip
 
 //#define  BASE_URL      @"http://porsche2.handlecar-oms.com"             // 8600 演示
 
 //#define  BASE_URL       @"http://porsche3.handlecar-oms.com"                       // 演示用
 
 //#define  BASE_URL       @"http://porsche4.handlecar-oms.com"                       // 长沙正式ip 正式发布去掉首页端口号显示
 
 //#define  BASE_URL      @"http://106.14.38.215:8689"             // 测试用服务器  #else
 */

#endif

// 所有接口定义
// 常量版本列表
#define CONSTANTDATA_VERSION_URL                    @"/constant/versionlist"
// 常量请求接口
#define CONSTANTDATA_LIST_URL                       @"/constant/downloadbyname"
// 登录模块
#define LOGIN_URL                                   @"/user/login"   // 登录接口
//开单模块

#define BILLING_URL                                 @"/carorder/getnewcarorderid"//开单(新建)车辆
#define CANCEL_BILLING_URL                          @"/carorder/cancelbill"//取消开单
#define CAR_NUMBER_CAR_MESSAGE_URL                  @"/carorder/getcarinfobyplate"//根据车牌获取车辆信息
#define SAVE_CAR_BILLING_MESSAGE_URL                @"/carorder/updatecarbystep"//开单保存车辆信息
#define VIN_FOR_CAR_MESSAGE_URL                     @"/carorder/getcarinfobyvin"//vin获取车辆信息
#define CAR_LIST_URL                                @"/carorder/getcarorderlist"//车辆列表
#define SINGLE_CAR_MESSAGE_URL                      @"/carorder/getcarorder"//单车工单基本信息
//#define BILLINGINFO_URL                             @"ordernew/orderinfo"  // 新单车信息
#define SECURE_COMPANY_MESSAGE_URL                  @"/basicset/insurancecompanylist"//保险公司列表
#define CANCEL_BILLING_REASON_LIST_URL              @"/basicset/cancelreasonlist"//取消原因
#define BILLING_STAFF_LIST_URL                      @"/user/userlistfororder"//开单过程中员工列表
#define BILLING_STAFF_GROUP_LIST_URL                @"/user/grouplist"//开单中 组列表
#define BILLING_STAFF_POSITION_LIST_URL             @"/user/positionlist"//职位列表
#define PORSCHE_PROJECT_LEVEL                       @"/increaseitem/getschemelevel"//方案级别列表
#define PORSCHE_PROJECT_SETTLEMENT_URL              @"/increaseitem/getsettlement"//结算方式列表
#define PORSCHE_PROJECT_MATERIAL_CUB_URL            @"/orderprocess/getstocktype"//备件库存列表
#define FULLSCREEN_RIGHTVIEW_JIAOCHE                @"/carorder/subcar"//在场车辆全屏右侧交车
#define MAINSHOPINFORMATION                         @"/carorder/storeorderinfo"//在厂车辆本店工单信息
#define WORK_ORDER_CHANGE_POSITION_URL              @"/carorder/selectpositionfororder"  // 修改开单 技师或者服务顾问 人员
#define CARNUMBER_LIST_URL                          @"/carorder/searchplate"        //车牌输入匹配



//流程确认
#define SURE_BILLING_URL                            @"/carorder/confirmbill"//开单确认
#define WORK_ORDER_TECHICIAN_SURE_TO_NEXT_URL       @"/increaseitem/increaseitemconfirm"//技师确认
#define WORK_ORDER_WORKSHOP_SURE_TO_NEXT_URL        @"/orderprocess/workshopconfirm"//车间确认
#define WORK_ORDER_MATERIAL_SURE_TO_NEXT_URL        @"/orderprocess/sparepartsconfirm"//备件确认
#define WORK_ORDER_SERVICE_SURE_TO_NEXT_URL         @"/orderprocess/servicecommunicateconfirm"//服务确认
#define WORK_ORDER_CUSATOM_SURE_TO_NEXT_URL         @"/orderprocess/customerconfirm"//客户确认
#define WORK_ORDER_USER_CANCELAFFIRM                @"/increaseitem/cancelcustomerconfirm"//取消确认
#define WORK_ORDER_USER_WAITCONFIRM                 @"/increaseitem/orderwaitprocess"////1:等待车间确认  2：等待备件确认 3：等待增项确认 4：等待保修确认
#define WORK_ORDER_INSURANCE_CONFIRM                @"/increaseitem/confirmguarantee"     // 整单保修确认

//工单模块
#define WORK_ORDER_LIST_SERVICE_SWITCH_OUT_URL      @"/orderprocess/processdirect"//服务顾问 开关1.技师确认 2.备件确认3.保修审批
#define WORK_ORDER_LIST_EDIT_OPEN_URL               @"/increaseitem/starteditmode"//开启编辑
#define WORK_ORDER_LIST_EDIT_CLOSE_URL              @"/increaseitem/closeeditmode"//关闭编辑
#define WORK_ORDER_LIST_SERVICE_SWITCH_URL          @"/orderprocess/getserviceswitch"//服务顾问跳转接口
#define WORK_ORDER_LIST_SCHEME_DETIAL_SAVE_URL      @"/increaseitem/renewschemetoorder"//保存编辑过的方案至工单
#define WORK_ORDER_LIST_SCHEME_DETIAL_URL           @"/increaseitem/getSchemeDetail"//工单中方案详情
#define WORK_ORDER_LIST_URL                         @"/increaseitem/getincreaseitemInfo"//工单列表
#define WORK_ORDER_SCHEME_LIST_URL                  @"/orderprocess/getschemestocklist"//工单方案库
//#define WORK_ORDER_UNFINISHED_SCHEME_LIST_URL       @"/orderprocess/getunfinishedschemelist"//未完成方案 改为与 方案库方案列表同一个接口
#define WORK_ORDER_INCREASE_SCHEME_URL              @"/increaseitem/addordelscheme"//增加/删除 方案至工单
#define WORK_ORDER_INCREASE_SCHEMES_URL             @"/increaseitem/batchaddschemefromorder"//添加全屏方案库方案
#define WORK_ORDER_INCREASE_SUBOBJECT_URL           @"/increaseitem/addtempproject"//添加工时备件至工单
#define WORK_ORDER_DELETE_SUBOBJECT_URL             @"/increaseitem/delTempProject"//删除工单中工时/备件
//工单方案编辑
#define WORK_ORDER_EDIT_CUSTOM_NAME_URL             @"/increaseitem/selfsolutionedit"//修改自定义方案名称
#define WORK_ORDER_EDIT_SCHEME_REMARK_URL           @"/increaseitem/saveschemeremark"//修改方案备注
#define WORK_ORDER_EDIT_SCHEME_WORK_HOUR_URL        @"/increaseitem/schemehouredit"//修改工时
#define WORK_ORDER_EDIT_SCHEME_MATERIAL_URL         @"/increaseitem/schemepartedit"//修改备件
//工时/备件的图号/编号匹配
#define WORK_ORDER_MATECH_WORKHOUR_URL              @"/workhour/selectworkhourbyno"//工时匹配
#define WORK_ORDER_MATECH_MATERIAL_PARTLIST_URL     @"/parts/selectpartsbyno"//备件编号部分匹配
#define WORK_ORDER_MATECH_MATERIAL_PARTIMG_URL      @"/parts/selectpartsbyimageno"//备件图号部分匹配
#define WORK_ORDER_SET_SETTLEMENT_URL               @"/increaseitem/setprojectsettlement"//设置结算方式
#define WORK_ORDER_CONFIRM_SETTLEMENT_URL           @"/increaseitem/confirmschemesettlement"//审核结算方式
#define WORK_OEDER_ADD_MATERIAL_CUB_URL             @"/orderprocess/addstocktype"//添加库存位
#define WORK_OEDER_EDIT_MATERIAL_CUB_URL            @"/orderprocess/editstocktype"//编辑库存位
#define WORK_OEDER_DELETE_MATERIAL_CUB_URL          @"/orderprocess/delsocktype"//编辑库存位
#define WORK_OEDER_DISCOUNT_SCHEMEWS_URL            @"/orderprocess/givediscount"//折扣
#define WORK_ORDER_CHOOSE_SCHEMEWS_URL              @"/increaseitem/confirmorcancelproject"//选择/不选 方案中的工时和备件
#define WORK_ORDER_UPDATE_SCHEME_LEVEL_URL              @"/increaseitem/editschemelevel"//方案级别修改
#define WORK_ORDER_PHOTOLIST                        @"/attachment/getordersolutionatta"   // 工单图片列表

//方案库模块
#define SCHEME_LIST_URL             @"/scheme/list"  //获取方案库列表
#define SCHEME_DETAIL_URL           @"/scheme/info" //方案详情
#define SCHEME_SAVE_DETAIL_URL      @"/scheme/update" //修改方案
#define SCHEME_ADDTOME_URL          @"/scheme/insert" //添加为我的方案
#define SCHEME_DELETE_URL           @"/scheme/delete"  //方案删除
#define SCHEME_DETAIL_NOTICE_URL    @"/notice/read" //通知方案
#define SCHEME_REVISE_LEVEL_URL           @"/scheme/updatelevel" //修改方案级别
//图片上传 测试
#define UP_DATA_IMAGE_URL           @"/attachment/fileupload"
#define CAMERA_DETELE_URL           @"/attachment/delattachmentinfo"//删除照片
//备件
#define SPERA_LIST_URL              @"/parts/list"//备件列表
#define SPERA_DETAIL_URL            @"/parts/detail" //备件详情
#define SPERA_SAVE_DETAIL_URL       @"/parts/addorupdate" //备件保存
#define SPERA_DELETE_URL            @"/parts/del" //删除备件
//工时
#define WORKHOURS_LIST_URL          @"/workhour/list" //工时列表
#define WORKHOURS_DETAIL_URL        @"/workhour/detail" //工时详情
#define WORKHOURS_SAVE_DETAIL_URL   @"/workhour/addorupdate" //保存工时详情
#define WORKHOURS_DELETE_URL        @"/workhour/del" //删除工时
//收藏夹
#define FAVORITE_LIST_URL           @"/favorite/list" //收藏夹列表
#define FAVORITE_INSERT_URL         @"/favorite/insert" //新建收藏夹
#define FAVORITE_INSERTSCHEME_URL   @"/favoriteralation/insert" //给收藏夹添加新的方案
#define FAVORITE_LIST_DETAIL_SCHEME_DETALE      @"/favoriteralation/deleteone"   //方案夹详情方案删除
#define FAVORITE_DETELE             @"/favorite/delete"  //方案夹删除
#define FAVORITE_CHANGE_NAME        @"/favorite/rename"  //修改收藏夹名称

//服务档案
#define SERVICERECORDS_RIGHT_INFORMATION             @"/orderprocess/getservicearchiveinfo" //服务档案页面信息查询
#define SERVICERECORDS_RIGHT_ADDCARFLG               @"/orderprocess/addtargettocar" //服务档案右侧添加标签
#define SERVICERECORDS_RIGHT_DELETECARFLG            @"/orderprocess/deletecartarget" //服务档案右侧删除标签
#define SERVICERECORdS_RIGHT_CARFLG_SEARCH           @"/orderprocess/findtargetstock" //服务档案右侧标签查找
#define SERVICERECORDS_RIGHT_CELL_UNFINISH_DELETE    @"/orderprocess/ingorescheme" //服务档案未完成方案删除（右侧未完成方案左划）
#define SERVICERECORDS_LEFT_CARFLGLIST               @"/orderprocess/gettargetstocklist" //服务档案左侧车辆标签列表
#define SERVICERECORDS_LEFT_CARLIST                  @"/orderprocess/getarchivecarlist" //服务档案左侧车辆列表
#define SERVICERECORDS_RIGHT_KILOMETERELIST          @"/constant/getcarkmlevel" //服务档案右侧公里数列表


//业务分类
#define BUSINESS_CATEGORY_URL       @"/basicset/businesstypelist"
//备件主组
#define MATERIAL_MAIN_GROUP_URL     @"/parts/partsgroup"
//工时主子组
#define ITEM_TIME_MAIN_CHILDREN_GROUP_URL @"/workhour/group"//志勤


//提醒接口
#define NOTICE_LEFT_LIST              @"/remindtask/tasklist"//提醒界面左侧列表
#define NOTICE_LEFT_FANGAN_LIST       @"/notice/list"        //提醒左侧界面下面的方案列表
#define NOTICE_LEFT_HANDLEUNREADNOTICE      @"/remindtask/confirmtask" //处理未读的消息

//用户设置
#define USER_CHANGE_PASSWOED          @"/user/updatepassword"//用户修改密码


// 店铺信息
#define PORSCHE_STOREINFO           @"/basicset/storeinfo"    // 店铺信息

// 车系接口
#define PORSCHE_CARSERIES           @"/cartype/carslist"        // 车系
#define PORSCHE_CARTYPE             @"/cartype/cartypelist"     // 车型
#define PORSCHE_CARYEAR             @"/cartype/caryearlist"     // 年款
#define PORSCHE_CAROUTPUT           @"/cartype/caroutputlist"   // 排量

// 右上角工单备注
#define TOP_MEMO_ADD                @"/orderprocess/orderaddmeno"       //添加备忘录
#define TOP_MEMO_EDIT               @"/orderprocess/ordereditmeno"      //编辑备忘录
#define TOP_MEMO_LIST               @"/orderprocess/getordermenolist"   //备忘录列表

// 打印备货单 pdf
#define PRINT_SPAREPDF                      @"/increaseitem/printpdfparts"
// 报价单
#define PRINT_QUOTATIONPDF                   @"/increaseitem/printpdforder"

// 备件列表
#define PRINT_SPARE_LIST                    @"/increaseitem/getprintpdfparts"
#define SAVE_SPARE_LIST                     @"/increaseitem/setwospordertype"

// 微信分享id
#define WechatShareID                       @"/storesearch/getshareid"

//预检单
#define PreCheck_GetData                    @"/precheck/checkorderinfo" //获取预检单信息
#define PreCheck_ChangeData                 @"/precheck/updatepreorderbystep" //修改预检单信息
#define PreCheck_Print                      @"/precheck/printpdfpreorder"//打印预检单



#pragma mark  参数宏
#define kTechician          @1//技师增项
#define kService            @2//服务增项

#define kLeftSchemeZero     @0//添加方案至工单方案列表 左侧不刷新
#define kScheme             @1//方案库方案
#define kCustomScheme       @2//自定义方案
#define kUnfinishedScheme   @3//未完成
#define kAllScheme          @4//全部方案

//#define k

#define kWorkType           @1//工时
#define kMaterialType       @2//备件

#define kAddition           @1//增加
#define kDeletion           @2//删除

#define kMaterialImgPart    @1//图号部分匹配
#define kMaterialPart       @2//编号部分匹配
#define kMaterialAll        @3//编号全部匹配


#endif /* PAPI_URLDefine_h */
