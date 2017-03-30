//
//  HDLeftSingleton.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/5.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PorscheItemModel.h"
#import "PorscheCarModel.h"
#import "BaseLeftViewController.h"
#import "ViewController.h"
#import "HDRightViewController.h"
#import "HDLeftTabBarViewController.h"
#import "HDLeftBillingDateChooseView.h"
#import "HDWorkListDateChooseView.h"
#import "HDFirstViewController.h"

@class BaseViewController,BaseLeftViewController;
@interface HDLeftSingleton : NSObject

//入口参数 1.开单接车 2.在场车辆 3.任务提醒 4. 服务档案 5.方案库 6.设置
@property (nonatomic, strong) NSNumber *entryStyle;

@property (nonatomic, strong)  UICollectionView *leftCollectionView;
//方案库tableView偏移量
@property (nonatomic, assign) CGFloat tableViewY;
//新开单车辆信息
@property (nonatomic, strong) PorscheNewCarMessage *carModel;

//非收藏夹数组
@property (nonatomic, strong) NSMutableArray *collectionViewArray;
//全部collectionView
@property (nonatomic, strong) NSMutableArray *allCollectionArray;

//cell的左右划按钮相对window的位置集合数组
@property (nonatomic, strong) NSMutableArray *pointArray;

//方案库拖动至技师增项的项目数据
@property (nonatomic, strong) id dragCubScheme;


//touch开始时的cell所在collection的index
@property (nonatomic, strong) NSIndexPath *fromIndexpath;

//collectionArray中所在位置
@property (nonatomic, assign) NSInteger fromIndex;

//touch结束时，所在位置，indexpath，所在collection idx
@property (nonatomic, strong) NSIndexPath *endIndexPath;
//collectionArray中所在位置
@property (nonatomic, assign) NSInteger endIndex;

//是否是拖动，拖动时，cell才会响应更换类别时间
@property (nonatomic, assign) BOOL isDrag;


// 是否是 左侧方案库界面
@property (nonatomic, assign) BOOL isItemVC;

//是否是技师增项界面
@property (nonatomic, assign) BOOL isTechicianAdditionVC;
////全局蒙版view
@property (nonatomic, strong) UIView *clearView;
//开单信息页面的是否隐藏TF
@property (nonatomic, assign) BOOL isHiddenTF;
//流程 状态 1. 开单  2.技师 3.备件 4.服务 5.客户
@property (nonatomic, assign) NSInteger stepStatus;
//走过的最靠近客户确认的流程
@property (nonatomic, assign) NSInteger maxStatus;
//右侧状态数组
@property (nonatomic, strong) NSMutableArray *statusArray;
//返回按钮点击状态 yes：点击  No：未点击 （点击事件已完成）
@property (nonatomic, assign) BOOL isBack;

@property (nonatomic, strong) NSNumber *saveStatus;

@property (nonatomic, weak) BaseViewController *rightVC;
@property (nonatomic, weak) BaseLeftViewController *leftVC;
@property (nonatomic, weak) ViewController *VC;

// 工单VC
@property (nonatomic, weak) HDRightViewController *HDRightViewController;

@property (nonatomic, weak) HDLeftTabBarViewController *leftTabBarVC;

//右侧父控制器的View
@property (nonatomic, strong) UIView *rightBaseView;

@property (nonatomic, assign) BOOL isSelectedPreDate;//是否选择过预计交车时间（主要用于服务确认 判断）
#pragma mark  人员相关
@property (nonatomic, strong) NSMutableArray *groupArray;//组名数据
@property (nonatomic, strong) NSMutableArray *positionArray;//职位数据
@property (nonatomic, strong) NSMutableArray *infoArray;//组成员数据
@property (nonatomic, strong) NSNumber *selectedPosid;//选择的职位id
@property (nonatomic, strong) NSNumber *selectedGroupid;//选择的组id
@property (nonatomic, strong) NSNumber *selectedId;//最终选择出的id
#pragma mark  任务提醒个数
@property (nonatomic, strong) NSNumber *noticeCount;
// 任务提醒信息
@property (nonatomic, strong) RemindModel *remindModel;

@property (nonatomic, strong) HDLeftBillingDateChooseView *keidanListLeftDatePopView;//在厂车辆左侧时间选择界面   保存在单例中,不用每次都创建,减少创建的时间
@property (nonatomic, strong) HDWorkListDateChooseView *yujiJiaocheTimeDatePopView;//预计交车时间选择界面   保存在单例中,不用每次都创建,减少创建的时间
@property (nonatomic, strong) HDFirstViewController *firstVC;



+ (HDLeftSingleton *)shareSingleton;

+ (BOOL)isUserOrder;

+ (BOOL)isUserAdded:(NSNumber *)addedid;//是否和用户id一致
- (void)cleanData;//清空数据
- (void)getMaxStatus;//获取最大流程 /*已废弃 */

#pragma mark 方案库方案加入工单权限  
- (BOOL)isHasAddToOrderPermissionShowMessage:(BOOL)isShowMessage;
// 提醒方案加入工单权限
- (BOOL)isHasNoticeAddToOrderPermission;
#pragma mark  左右侧 信息交换
- (void)changeHeaderTextColor;//修改流程文字颜色
- (void)showAddedSchemeAlertView;//显示已添加项目提示
- (BOOL)showStepAlertViewShowStatus:(NSString *)message;//获取当前车辆流程
- (BOOL)isInFactoryWithCarMessage:(PorscheNewCarMessage *)message;//车辆是否在场
- (void)changeWorkFlowWithInfo:(NSDictionary *)dict;// 流程转变
- (void)reloadOrderList;//增加项目之后  刷新
- (void)reloadLeftBillingList:(NSNumber *)type;//刷新在厂车辆数据
- (void)createNewCarMessage;//新建工单
- (void)reloadViewAfterFullScreenBack;//在厂车辆全屏返回
- (void)reloadRightViewVCHeaderContent:(NSDictionary *)dic;//刷新HDRightViewController中工单信息的显示
- (void)reloadSchemeLeftData:(NSString *)type;//刷新方案库左侧数据
- (void)reloadSchemeLeftLocalData:(NSDictionary *)dic;//刷新方案库本地数据
- (void)updateSchemeFavouriteData:(NSDictionary *)dic;//添加至收藏夹
- (void)scrollSchemeLeftToTop:(NSDictionary *)dic;//滑动左侧方案库至（0.0）位置
- (void)changeSchemeLeftLevel:(NSDictionary *)dic;//修改左侧方案库方案级别；
- (void)scrollSchemeLeftAndRight:(NSDictionary *)dic;//左侧方案库 拖动之后滑动事件
- (void)scrollAtTheSameTimeFromRightToLeft:(NSNumber *)number;//在场车辆右侧发通知给左侧全屏
- (void)scrollAtTheSameTImeFromLeftToRight:(NSNumber *)number;//在场车辆左侧发通知给右侧全屏
- (void)reloadDataFromRightFull:(NSMutableDictionary *)dic;//在场车辆全屏右侧触发 左侧刷新
- (void)reloadFullRightViewFromLeftData:(NSMutableArray *)array;//在场车辆右侧接收左侧数据
- (void)singleCarNotice:(NSDictionary *)dic;//单车提醒

- (void)showPreView:(NSDictionary *)dic;//显示打印页面

- (void)reloadServiceHistoryViewFromLeft:(NSDictionary *)dic;//服务档案左侧发送数据至左侧;
- (void)reloadServiceHistoryViewFromRight:(NSNumber *)dic;//服务档案右侧发送数据至左侧;
- (void)setupSingleNoticeWithNumber:(NSNumber *)number;//设置单车提醒数量
- (void)setupNoticeWithNumber:(NSNumber *)number;//设置所有提醒
- (void)setRemark:(NSNumber *)number;//备注标签的显示/隐藏

// 刷新左侧我的方案
- (void)reloadSchemeLefMyData;

// 刷新提醒
- (void)reloadNoticeVCData;

// 刷新红点
- (void)updateRedTip;

// 刷新在场车辆
- (void)updateOnFactoryCarList;

@end
