//
//  HDLeftSingleton.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/5.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDLeftSingleton.h"
#import "HDSlitViewRightViewController.h"
#import "HDServiceViewController.h"
#import "KandanLeftViewController.h"
#import "KandanRightViewController.h"
#import "HDSlitViewLeftViewController.h"
#import "FullScreenLeftListForRightVC.h"
#import "HDLeftNoticeViewController.h"
#import "HDServiceRecordsRightVC.h"
#import "HDServiceRecordsLeftVC.h"

static HDLeftSingleton *manager = nil;

@implementation HDLeftSingleton

+ (HDLeftSingleton *)shareSingleton {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
        [manager setupClearView];
        
    });
    
    return manager;
}

+ (BOOL)isUserOrder {
    if ([[HDStoreInfoManager shareManager].userid integerValue] == [[HDLeftSingleton shareSingleton].carModel.createuserid integerValue]) {
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL)isUserAdded:(NSNumber *)addedid {
    if ([[HDStoreInfoManager shareManager].userid isEqual:addedid]) {
        return YES;
    }
    return NO;
}


- (void)cleanData {
    _tableViewY = 0;
    _leftCollectionView = nil;
    _entryStyle = nil;
    _carModel = nil;
    _leftCollectionView = nil;
    _collectionViewArray = nil;
    _allCollectionArray = nil;
    _pointArray = nil;
    _dragCubScheme = nil;
    _fromIndex = -1;
    _fromIndexpath = nil;
    _endIndexPath = nil;
    _endIndex = -1;
    _isDrag = NO;
    _isItemVC = NO;
    _isTechicianAdditionVC = NO;
    _isHiddenTF = NO;
    _stepStatus = 0;
    _maxStatus = 0;
    [_statusArray removeAllObjects];
    _isBack = NO;
    _saveStatus = @1;
    _leftVC = nil;
    _VC = nil;
    //工单
    _HDRightViewController = nil;
    _leftTabBarVC = nil;
    _rightBaseView = nil;
    _isSelectedPreDate = NO;

    //人员
    _groupArray = nil;
    _positionArray = nil;
    _infoArray = nil;
    _selectedId = nil;
    _selectedPosid = nil;
    _selectedGroupid = nil;
}


- (NSMutableArray *)collectionViewArray {
    
    if (!_collectionViewArray) {
        _collectionViewArray = [NSMutableArray array];
    }
    return _collectionViewArray;
}

- (NSMutableArray *)pointArray {
    if (!_pointArray) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}


- (void)setupClearView {
    _clearView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _clearView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    _clearView.userInteractionEnabled = NO;

}

- (NSMutableArray *)statusArray {
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    return _statusArray;
}

- (void)getMaxStatus {
    _maxStatus = _maxStatus > _stepStatus ? _maxStatus : _stepStatus;
}

- (void)setSaveStatus:(NSNumber *)saveStatus {
    _saveStatus = saveStatus;
//    [[NSNotificationCenter defaultCenter] postNotificationName:WORK_ORDER_SAVE_AND_EDIT_NOTIFINATION object:nil];
    [self reloadSchemeLeftBottomView];
}



//车辆是否在厂
- (BOOL)isInFactoryWithCarMessage:(PorscheNewCarMessage *)message {
    if ([message.orderstatus.wostatus isEqualToNumber:@8]) {
        [HDStoreInfoManager shareManager].carorderid = nil;
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"当前车辆已交车" height:60 center:HD_FULLView.center superView:HD_FULLView];
        [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleBilling right:HDRightStatusStyleBilling];
        return NO;
    }else {
        return YES;
    }
}

//获取当前车辆流程
- (BOOL)showStepAlertViewShowStatus:(NSString *)message {
    WeakObject(self);
    if (!message) {
        message = @"车辆还未进入此流程";
    }
    if (![HDStoreInfoManager shareManager].carorderid) {
        message = @"未选择车辆";
    }
    
    // 是否能够进入客户确认页面
    if([HDLeftSingleton shareSingleton].maxStatus == 5 || [[HDLeftSingleton shareSingleton].carModel.wocancelperson integerValue] > 0)
    {
        if ([HDLeftSingleton shareSingleton].stepStatus == 5)
        {
//            [selfWeak showAlert:message view:self.rightBaseView];
            return NO;
        }
    }
    
    if ([HDLeftSingleton shareSingleton].maxStatus < [HDLeftSingleton shareSingleton].stepStatus) {
        [selfWeak showAlert:message view:self.rightBaseView];
        return YES;
    }else {
        return NO;
    }
}


- (BOOL)isHasAddToOrderPermissionShowMessage:(BOOL)isShowMessage
{
    // 方案库方案加入工单权限
    BOOL isHasAddToOrder = [HDPermissionManager isHasThisPermission:HDOrder_GoSchemeLibrary_SaveToOrder isNeedShowMessage:isShowMessage];
    
    if (!isHasAddToOrder)
    {
        return isHasAddToOrder;
    }

    // 客户确认后  技师增项 加入工单权限
    if ([HDStoreInfoManager shareManager].carorderid && [HDLeftSingleton shareSingleton].stepStatus == 2 && [HDLeftSingleton shareSingleton].carModel.wostatus.integerValue == 7)
    {
        isHasAddToOrder =  [HDPermissionManager isHasThisPermission:HDOrder_JiShiZengXiang_AfterConfirmAdded isNeedShowMessage:isShowMessage];
        
    }
    
    // 客户确认后 服务增项 加入工单权限
    if ([HDStoreInfoManager shareManager].carorderid && [HDLeftSingleton shareSingleton].stepStatus == 4 &&[HDLeftSingleton shareSingleton].carModel.wostatus.integerValue == 7)
    {
        isHasAddToOrder = [HDPermissionManager isHasThisPermission:HDOrder_FuWuGouTong_Add_AfterClientAffirm isNeedShowMessage:isShowMessage];
    }
    
    return isHasAddToOrder;
}

- (BOOL)isHasNoticeAddToOrderPermission
{
    BOOL isHasAddToOrder = [HDPermissionManager isHasThisPermission:HDTaskNotice_MyShopNotice_NoticeOrderAddToOrder isNeedShowMessage:NO];
    
    if (!isHasAddToOrder)
    {
        return isHasAddToOrder;
    }

    // 客户确认后  技师增项 加入工单权限
    if ([HDStoreInfoManager shareManager].carorderid && [HDLeftSingleton shareSingleton].stepStatus == 2 && [HDLeftSingleton shareSingleton].carModel.wostatus.integerValue == 7)
    {
        isHasAddToOrder =  [HDPermissionManager isHasThisPermission:HDOrder_JiShiZengXiang_AfterConfirmAdded isNeedShowMessage:NO];
        
    }
    
    // 客户确认后 服务增项 加入工单权限
    if ([HDStoreInfoManager shareManager].carorderid && [HDLeftSingleton shareSingleton].stepStatus == 4 &&[HDLeftSingleton shareSingleton].carModel.wostatus.integerValue == 7)
    {
        isHasAddToOrder = [HDPermissionManager isHasThisPermission:HDOrder_FuWuGouTong_Add_AfterClientAffirm isNeedShowMessage:NO];
    }
    
    return isHasAddToOrder;
}


- (void)showAlert:(NSString *)message view:(UIView *)view{
    
    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:message height:60 center:view.center superView:view];
}

- (void)changeHeaderTextColor {
    [_HDRightViewController changeBottomText];
}

- (void)showAddedSchemeAlertView {
    [_HDRightViewController alertViewForAddedItem];
}

- (void)changeWorkFlowWithInfo:(NSDictionary *)dict
{
    [self.HDRightViewController changeBtAction:dict];
    [self.leftTabBarVC changeBtAction:dict];
}


- (void)reloadOrderList {
    if ([self.rightVC isKindOfClass:[HDSlitViewRightViewController class]]) {
        HDSlitViewRightViewController *slitVC = (HDSlitViewRightViewController *)self.rightVC;
        [slitVC addModel:nil];
    }else if ([self.rightVC isKindOfClass:[HDServiceViewController class]]) {
        HDServiceViewController *serviceVC = (HDServiceViewController *)self.rightVC;
        [serviceVC addModel:nil];
    }
}

- (void)reloadLeftBillingList:(NSNumber *)type {
    if ([_leftVC isKindOfClass:[KandanLeftViewController class]]) {
        KandanLeftViewController *kandanLeft = (KandanLeftViewController *)_leftVC;
        [kandanLeft getCarInFactionListAction:type];
    }
}

- (void)createNewCarMessage {
    if ([_rightVC isKindOfClass:[KandanRightViewController class]]) {
        KandanRightViewController *rightVC = (KandanRightViewController *)_rightVC;
        [rightVC bottomNewBillingAction];
    }
}

- (void)reloadViewAfterFullScreenBack {
//    if ([_leftVC isKindOfClass:[KandanLeftViewController class]]) {
    
        for(UINavigationController *vc in self.leftTabBarVC.viewControllers)
        {
            UINavigationController *nav = vc;
            
            if ([nav.viewControllers.firstObject isKindOfClass:[KandanLeftViewController class]])
            {
                KandanLeftViewController *kandanLeft = (KandanLeftViewController *)nav.viewControllers.firstObject;
                [kandanLeft helpActionWithRightView:nil];
                return;
            }
        }
//    }
}

- (void)reloadRightViewVCHeaderContent:(NSDictionary *)dic {
    [_HDRightViewController setSelectItemCount:dic];
}

- (void)reloadSchemeLeftBottomView {
    if ([_leftVC isKindOfClass:[HDSlitViewLeftViewController class]]) {
        HDSlitViewLeftViewController *slitLeft = (HDSlitViewLeftViewController *)_leftVC;
        [slitLeft changeBottomView];
    }
}

- (void)reloadSchemeLeftData:(NSString *)type {
    if ([_leftVC isKindOfClass:[HDSlitViewLeftViewController class]]) {
        HDSlitViewLeftViewController *slitVC = (HDSlitViewLeftViewController *)_leftVC;
        [slitVC refreshSchemeCub:type];
    }
}

- (void)reloadSchemeLefMyData
{
    if ([_leftVC isKindOfClass:[HDSlitViewLeftViewController class]]) {
        HDSlitViewLeftViewController *slitVC = (HDSlitViewLeftViewController *)_leftVC;
        [slitVC refreshMySchemeTabData];
    }
}

- (void)reloadSchemeLeftLocalData:(NSDictionary *)dic {
    if ([_leftVC isKindOfClass:[HDSlitViewLeftViewController class]]) {
        HDSlitViewLeftViewController *slitVC = (HDSlitViewLeftViewController *)_leftVC;
        [slitVC reloadLoadTableView:dic];
    }
}

- (void)updateSchemeFavouriteData:(NSDictionary *)dic {
    if ([_leftVC isKindOfClass:[HDSlitViewLeftViewController class]]) {
        HDSlitViewLeftViewController *slitVC = (HDSlitViewLeftViewController *)_leftVC;
        [slitVC addleftmodel:dic];
    }
}

- (void)scrollSchemeLeftToTop:(NSDictionary *)dic {
    if ([_leftVC isKindOfClass:[HDSlitViewLeftViewController class]]) {
        HDSlitViewLeftViewController *slitVC = (HDSlitViewLeftViewController *)_leftVC;
        [slitVC scrollTableView:dic];
    }
}

- (void)changeSchemeLeftLevel:(NSDictionary *)dic {
    if ([_leftVC isKindOfClass:[HDSlitViewLeftViewController class]]) {
        HDSlitViewLeftViewController *slitVC = (HDSlitViewLeftViewController *)_leftVC;
        [slitVC changeCellModelCategory:dic];
    }
}

- (void)scrollSchemeLeftAndRight:(NSDictionary *)dic {
    if ([_leftVC isKindOfClass:[HDSlitViewLeftViewController class]]) {
        HDSlitViewLeftViewController *slitVC = (HDSlitViewLeftViewController *)_leftVC;
        [slitVC scrollCollectionCell:dic];
    }
}

- (void)scrollAtTheSameTimeFromRightToLeft:(NSNumber *)number {
    if ([_leftVC isKindOfClass:[KandanLeftViewController class]]) {
        KandanLeftViewController *kandanLeft = (KandanLeftViewController *)_leftVC;
        [kandanLeft setTableViewContentOffSize:number];
    }
}

- (void)scrollAtTheSameTImeFromLeftToRight:(NSNumber *)number {
    if ([_rightVC isKindOfClass:[FullScreenLeftListForRightVC class]]) {
        FullScreenLeftListForRightVC *kandanLeft = (FullScreenLeftListForRightVC *)_rightVC;
        [kandanLeft setTableViewContentOffSize:number];
    }
}

- (void)reloadDataFromRightFull:(NSMutableDictionary *)dic {
    if ([_leftVC isKindOfClass:[KandanLeftViewController class]]) {
        KandanLeftViewController *kandanLeft = (KandanLeftViewController *)_leftVC;
        [kandanLeft reloadtableViewData:dic];
    }
}

- (void)reloadFullRightViewFromLeftData:(NSMutableArray *)array {
    if ([_rightVC isKindOfClass:[FullScreenLeftListForRightVC class]]) {
        FullScreenLeftListForRightVC *kandanLeft = (FullScreenLeftListForRightVC *)_rightVC;
        [kandanLeft loadDataForLeftListViewWithArray:array];
    }
}

- (void)singleCarNotice:(NSDictionary *)dic {
    
    NSInteger index = self.leftTabBarVC.selectedIndex;
    if (index < self.leftTabBarVC.viewControllers.count) {
        UINavigationController *baseNav = [self.leftTabBarVC.viewControllers objectAtIndex:index];
        if ([baseNav isKindOfClass:NSClassFromString(@"BaseNavigationViewController")])
        {
            for (UIViewController *vc in baseNav.viewControllers)
            {
                if ([vc isKindOfClass:[HDLeftNoticeViewController class]])
                {
                    HDLeftNoticeViewController *noticeVC = (HDLeftNoticeViewController *)vc;
                    [noticeVC singleCarNotifination:dic];
                    return;
                }
            }
        }
    }
}

- (void)showPreView:(NSDictionary *)dic {
    [_VC showPreView:dic];
}

- (void)reloadServiceHistoryViewFromLeft:(NSDictionary *)dic {
    if ([_rightVC isKindOfClass:[HDServiceRecordsRightVC class]]) {
        HDServiceRecordsRightVC *kandanLeft = (HDServiceRecordsRightVC *)_rightVC;
        [kandanLeft serviceRightVCAction:dic];
    }
}

- (void)reloadServiceHistoryViewFromRight:(NSNumber *)dic {
    if ([_leftVC isKindOfClass:[HDServiceRecordsLeftVC class]]) {
        HDServiceRecordsLeftVC *kandanLeft = (HDServiceRecordsLeftVC *)_leftVC;
        [kandanLeft setViewForm:dic];
    }
}

- (void)setupSingleNoticeWithNumber:(NSNumber *)number {
    [_HDRightViewController setSingleCarNotice:number];
}

- (void)setupNoticeWithNumber:(NSNumber *)number {
//    self.noticeCount = number;
    [_leftTabBarVC setNotice:number];
}

- (void)setNoticeCount:(NSNumber *)noticeCount
{
    _noticeCount = noticeCount;
    // 提醒tab上的数字更新
    [_leftTabBarVC setNotice:noticeCount];
    // 首页 提醒数字更新
    [_firstVC setNoticeCountWithNumber:noticeCount];
}

- (void)setRemark:(NSNumber *)number {
    [_HDRightViewController setRemark:number];
}


- (void)reloadNoticeVCData
{
        NSInteger index = self.leftTabBarVC.selectedIndex;
        if (index < self.leftTabBarVC.viewControllers.count) {
            UINavigationController *baseNav = [self.leftTabBarVC.viewControllers objectAtIndex:index];
            if ([baseNav isKindOfClass:NSClassFromString(@"BaseNavigationViewController")])
            {
                for (UIViewController *vc in baseNav.viewControllers)
                {
                    if ([vc isKindOfClass:[HDLeftNoticeViewController class]])
                    {
                        HDLeftNoticeViewController *noticeVC = (HDLeftNoticeViewController *)vc;
                        [noticeVC reloadNoticeData];
                        return;
                    }
                }
            }
        }
}

- (void)updateRedTip
{
    NSInteger index = self.leftTabBarVC.selectedIndex;
    if (index < self.leftTabBarVC.viewControllers.count) {
        UINavigationController *baseNav = [self.leftTabBarVC.viewControllers objectAtIndex:index];
        if ([baseNav isKindOfClass:NSClassFromString(@"BaseNavigationViewController")])
        {
            for (UIViewController *vc in baseNav.viewControllers)
            {
                if ([vc isKindOfClass:[HDLeftNoticeViewController class]])
                {
                    HDLeftNoticeViewController *noticeVC = (HDLeftNoticeViewController *)vc;
                    [noticeVC upadeRedTip];
                    return;
                }
            }
        }
    }
}

- (void)setRemindModel:(RemindModel *)remindModel
{
    _remindModel = remindModel;
    [self updateRedTip];
}

- (void)updateOnFactoryCarList
{
    NSInteger index = self.leftTabBarVC.selectedIndex;
    if (index < self.leftTabBarVC.viewControllers.count) {
        UINavigationController *baseNav = [self.leftTabBarVC.viewControllers objectAtIndex:index];
        if ([baseNav isKindOfClass:NSClassFromString(@"BaseNavigationViewController")])
        {
            for (UIViewController *vc in baseNav.viewControllers)
            {
                if ([vc isKindOfClass:[KandanLeftViewController class]])
                {
                    KandanLeftViewController *kandanLeft = (KandanLeftViewController *)vc;
                    [kandanLeft getCarInFactionListAction:@1];
                    return;
                }
            }
        }
    }
}


@end
