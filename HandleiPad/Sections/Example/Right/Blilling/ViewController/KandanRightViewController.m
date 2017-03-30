	//
//  KandanRightViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/7.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "KandanRightViewController.h"
#import "BlillingMessageBottomView.h"
#import "BlillingMessageHeaderView.h"
#import "HWDateHelper.h"
#import "AlertViewHelpers.h"
//单例
#import "HDLeftSingleton.h"

//车系、车型弹窗，年款排量
#import "HDWorkListTableViews.h"

//VIN辅助
#import "PHTTPManager.h"
#import "PCarTypeModel.h"
//视频，相机，扫描
#import "ZLCameraViewController.h"
//预览窗口
#import "HDDriverLisencePreView.h"

#import <MediaPlayer/MediaPlayer.h>
//图片查看
#import "HZPhotoBrowser.h"
//图片编辑
#import "DrawViewController.h"
//保存弹窗 确认窗口
//#import "HDdeleteView.h"
#import "HDNewSaveView.h"
//车辆临时model
#import "PorscheCarModel.h"
//已保存
#import "HDBillingSaveAlertView.h"
#import "HDLeftListModel.h"
//保时捷Vin码识别model
#import "PorscheVinCarModel.h"
//选择技师
#import "HDWorkListNextView.h"

#import "PorscheVideoPlayer.h"
//取消开单原因弹窗
#import "HDCancelBillingView.h"
//本地照片库
#import "PorschePhotoGallery.h"

// 员工选择
#import "HDSelectStaffView.h"
#import "AppDelegate.h"

#import "VinCameraViewController.h"
#import "HDPoperDeleteView.h"
#import "HDPreCheckViewController.h"

@interface KandanRightViewController ()<UIScrollViewDelegate,UIPopoverControllerDelegate,HZPhotoBrowserDelegate,CameraViewControllerDelegete,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BlillingMessageCenterViewDelegate>

@property (nonatomic, strong) ZLCameraViewController *cameraVC ;

//底部保存弹窗 技师确认
//@property (nonatomic, strong) HDNewSaveView *saveView;
//行驶证预览视图
@property (nonatomic, strong) HDDriverLisencePreView *preDriverLisenceView;
//底层滑动视图
@property (strong, nonatomic)  UIScrollView *baseView;
//底部视图
@property (nonatomic, strong) BlillingMessageBottomView *bottomView;
//遮罩 显示服务顾问列表
@property (nonatomic, strong) UIView *clearView;
//保修：无保修，新车保修，延长保修，
@property (nonatomic, strong) UIPopoverController *guaranteePoperController;
@property (nonatomic, strong) NSMutableArray *guranteeArray;
////车牌弹出框
@property (nonatomic, strong) UIPopoverController *carCardastralPoperController;
@property (nonatomic, strong) NSMutableArray *insuranceArray;//保险公司数组
@property (nonatomic, strong) PorscheNewCarMessage *info;
@property (nonatomic, strong) PorscheNewCarMessage *carInfo;
@property (nonatomic) BOOL isEditing;
@property (nonatomic, strong) HZPhotoBrowser *browser;
@end

@implementation KandanRightViewController


- (void)dealloc {
    
    [self.billingView removeFromSuperview];
    [self.bottomView removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {

    self.baseView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 49);
    self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.baseView.frame), CGRectGetHeight(self.baseView.frame));
    self.billingView.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame) );
    _baseView.contentSize = CGSizeMake(CGRectGetWidth(self.containerView.frame),CGRectGetHeight(self.containerView.frame));
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.containerView.frame), CGRectGetWidth(self.view.frame), 49);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.view = scrollView;

    [HDLeftSingleton shareSingleton].stepStatus = 1;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bottomNewBillingAction) name:NEW_BILLING_CAR_NOTIFINAITON object:nil];
    
    [self setupBaseScrollView];
    [self setupView];
    
    if (![[HDStoreInfoManager shareManager] carorderid])
    {
        self.isEditing = NO;
        [self setEditStatus:NO];
    }
    else
    {
        self.isEditing = NO;
        // 编辑状态
        [self.billingView setViewEdit:NO];
        [self.bottomView setBottomViewEditAction:NO];
        
    }
    [self sendCarInfoRequest:NULL];
}

#pragma mark 初始bilingView
- (void)setupView {
    self.billingView = [BlillingMessageCenterView initWithCustomFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 49)];
    self.billingView.delegate = self;
    [self.containerView addSubview:self.billingView];
    self.bottomView = [[BlillingMessageBottomView alloc] initWithCustomFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49)];
    [self.view addSubview:self.bottomView];
    [self bottomViewEventHandle];
    [self billingViewEvntHandle];
}

- (void)billingViewEvntHandle
{
    WeakObject(self);
#pragma mark  中心程序Block
    //dms 车牌号 VIN 公里数
    self.billingView.BillingTFToReloadBlock = ^(UITextField *tf) {
    };
    
    self.billingView.blillingMessageCenterViewBlock  = ^(BlillingMessageCenterViewStyle style,UIButton *sender,NSInteger idx,UIView *view) {
        
        switch (style) {
#pragma mark  行驶证
            case BlillingMessageCenterViewStyleCameraUp: {
                [selfWeak recognizeDrivingLicense];
                
            }
                break;
#pragma mark  环车
            case BlillingMessageCenterViewStyleCycle: {
                [selfWeak chooseTotakephotoupdata];
                
            }
                break;
#pragma mark  更多图片
                
            case BlillingMessageCenterViewStylePreView: {
                
                [selfWeak stepToPhotoAssert:idx button:sender view:view];
            }
                
                break;
#pragma mark  播放视频
            case BlillingMessageCenterViewStyleVideo: {
                
                [selfWeak playVideoAction];
            }
                break;
                
#pragma mark -- Vin 图片识别界面
            case BlillingMessageCenterViewStyleVinPhotoRecognize:
            {
                [selfWeak recognizeVINInfo];
            }
                break;
#pragma mark -- 预检单打印
                case BlillingMessageCenterViewStylePrecheckOrder:
            {
                [selfWeak showPrecheckViewController];
            }
                break;
            default:
                break;
        }
    };
    
    self.billingView.morePicBlock = ^ (NSInteger idx,CGRect rect) {
        
        HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
        selfWeak.browser = browser;
        browser.isScanModel = !selfWeak.isEditing;
        browser.sourceImagesContainerView = selfWeak.billingView.picCollectionView;
        
        browser.imageCount = selfWeak.carInfo.picArray.count;
        
        browser.customRectFromWindow = rect;
        browser.currentImageIndex = (int)idx;
        browser.delegate = selfWeak;
        [browser show];
    };
}


#pragma mark  行驶证识别
- (void)recognizeDrivingLicense {
    WeakObject(self);
    // 没有行驶证照片的时候，去拍照
    ZLCameraViewController *scan = [[ZLCameraViewController alloc] initWithUsageType:ControllerUsageTypeScan];
    // 拍照最多个数
    scan.maxCount = 10;
    // 多张拍摄
    scan.cameraType = ZLCameraContinuous;
    
    scan.scanBlock = ^(ScanInfoModel *model){
        
        NSString *oldCars = selfWeak.billingView.carCategoryTF.text;
        NSString *oldVIN = selfWeak.billingView.VINnumberTF.text;
        NSString *newVIN = model.vin;
        BOOL ret = [selfWeak isNeedSetVINInfoWithOldCars:oldCars oldVIN:oldVIN newVIN:newVIN];
        
        // 保存车牌
        if (model.carCardArea.length && model.carCardNum.length)
        {
            selfWeak.billingView.carNumberTF.text = model.carCardNum;
            selfWeak.billingView.carLocationLb.text = model.carCardArea;
            selfWeak.carInfo.plateplace = model.carCardArea;
            selfWeak.carInfo.ccarplate = model.carCardNum;
            
            // 通过车牌获取车辆信息
            [selfWeak getcarMessage:^{
                if (ret)
                {
                    [selfWeak getVinInfoWithVIN:newVIN completion:^{
                        [selfWeak saveOrder:NULL];
                    }];
                }
            }];
            
          }
        else
        {
            if (ret)
            {
                [selfWeak getVinInfoWithVIN:newVIN completion:^{
                    [selfWeak saveOrder:NULL];
                }];
            }
        }
        
        // ------识别车牌信息赋值------
        selfWeak.billingView.driverLicenseUpImgv.image = model.image;
        //            selfWeak.billingView.carNumberTF.text = model.carCardNum;
        //            selfWeak.billingView.carLocationLb.text = model.carCardArea;
        
    };
    //模态推出相机页面（可自行用Push方法代替）
    [scan showPickerVc:selfWeak];
}

#pragma mark -- 是否需要在VIN识别后，设置车系，车型，年款，排量
- (BOOL)isNeedSetVINInfoWithOldCars:(NSString *)oldCars oldVIN:(NSString *)oldVin newVIN:(NSString *)newVin
{
    /*
     vin车型：
     1，需要识别
     如果原先 没有车型，那么需要识别
     如果原先  有车型，没有vin，需要识别
     如果原先  有车型， 也有vin，那么需要判断， 原来的 vin 是否 和 新输入的 vin 一致，
     如果一致，那么不需要识别， 如果新输入的vin和，原先的vin不一致，那么需要识别
     */
    if(newVin.length)
    {
        return YES;
    }
    
    if (!oldCars.length)
    {
        return YES;
    }
    
    if (oldCars.length && !oldVin.length)
    {
        return YES;
    }
    
    if (oldCars.length && oldVin.length)
    {
        if ([newVin isEqualToString:oldVin])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return NO;
}


#pragma mark -- Vin识别
- (void)recognizeVINInfo
{
    
    VinCameraViewController *Vin = [[VinCameraViewController alloc] init];
    WeakObject(self);
    Vin.Finished = ^(NSString *carpalte, NSString *place, NSString *vin){
        NSString *oldCars = selfWeak.billingView.carCategoryTF.text;
        NSString *oldVIN = selfWeak.billingView.VINnumberTF.text;
        NSString *newVIN = vin;

        BOOL ret = [selfWeak isNeedSetVINInfoWithOldCars:oldCars  oldVIN:oldVIN newVIN:vin];

        // 保存车牌
        if (carpalte.length && place.length)
        {
            
            selfWeak.billingView.carNumberTF.text = carpalte;
            selfWeak.billingView.carLocationLb.text = place;
            selfWeak.carInfo.plateplace = place;
            selfWeak.carInfo.ccarplate = carpalte;
            
            // 通过车牌获取车辆信息
            [selfWeak getcarMessage:^{
                if (ret)
                {
                    [selfWeak getVinInfoWithVIN:newVIN completion:^{
                        [selfWeak saveOrder:NULL];
                    }];
                }
            }];
            
        }
        else
        {
            if (ret)
            {
                [selfWeak getVinInfoWithVIN:newVIN completion:^{
                    [selfWeak saveOrder:NULL];
                }];
            }
        }
    };
    [self presentViewController:Vin animated:YES completion:NULL];
}


#pragma mark  环车拍照

- (void)chooseTotakephotoupdata {
    
    // 如果车牌不存在
    if (!self.carInfo.ccarplate.length || !self.carInfo.plateplace.length)
    {
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"请输入完整车牌" height:60 center:HD_FULLView.center superView:HD_FULLView];
        return;

    }

    WeakObject(self);
    [HDPoperDeleteView showUpDatePhotoViewAroundView:self.billingView.cycleCarimgv direction:UIPopoverArrowDirectionRight Camera:^{
        [selfWeak cycleTakePhoto];
    } location:^{
        [selfWeak showPhotoGallery];
    }];
}
- (void)cycleTakePhoto {
    WeakObject(self);
    
    ZLCameraViewController *cameraVC =  [[ZLCameraViewController alloc] initWithUsageType:ControllerUsageTypeCamera];
    
    // 拍照最多个数
    cameraVC.maxCount = 10;
    // 多张拍摄
    cameraVC.cameraType = ZLCameraContinuous;
    
    cameraVC.images = selfWeak.carInfo.picArray;
    
    cameraVC.videoModel = selfWeak.carInfo.videoModel;
    cameraVC.delegete = self;
    
    //模态推出相机页面（可自行用present方法代替）
    [cameraVC showPickerVc:selfWeak];
}
#pragma mark  更多图片 +点击图片进图片库
- (void)stepToPhotoAssert:(NSInteger)clickIdx button:(UIButton *)sender view:(UIView *)view {
    //    WeakObject(self);
    
    if (clickIdx < 0) {
        [AlertViewHelpers setAlertViewWithMessage:@"暂无图片" viewController:self button:sender];
        return;
    }
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    self.browser = browser;
    browser.sourceImagesContainerView = self.billingView.picCollectionView;
    
    browser.imageCount = self.carInfo.picArray.count;
    browser.isScanModel = !self.isEditing;
    browser.collectionCell = (UICollectionViewCell *)view;
    
    browser.currentImageIndex = (int)clickIdx;
    browser.delegate = self;
    [browser show];
    
}

#pragma mark  视频播放按钮
- (void)playVideoAction {
    WeakObject(self);
    if (selfWeak.carInfo.videoModel &&selfWeak.carInfo.videoModel.videoUrl) {
        PorscheVideoPlayer *videoVC = [[PorscheVideoPlayer alloc] initWithURL:self.carInfo.videoModel.videoUrl videoId:selfWeak.carInfo.videoModel.cameraID];
        videoVC.isScanModel = !self.isEditing;
        __weak typeof(self)weakself = self;
        videoVC.deleteBlock = ^ (NSNumber *videoId) {
            
            [weakself deleteVideoWithVideoId:videoId];
        };
        
        [selfWeak presentViewController:videoVC animated:YES completion:nil];
        
    }else {
        [AlertViewHelpers setAlertViewWithMessage:@"暂无可播放视频" viewController:selfWeak button:selfWeak.billingView.videoPlayBt];
    }
}

#pragma mark  视频播放删除
- (void)deleteVideoWithVideoId:(NSNumber *)videoId {
    
    [self.cameraVC deleteDataSourceVideo:YES orImage:0];
    
    self.billingView.videoImageView.image = nil;
    ZLCamera *camera = [[ZLCamera alloc] init];
    camera.cameraID = videoId;
    [self cameraViewController:self.cameraVC deleteDidCamera:camera];
    
}


#pragma mark  scroll
- (void)setupBaseScrollView {
    //滑动
    _baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 49)];
    _baseView.contentSize = CGSizeMake(CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    _baseView.bounces = NO;
    _baseView.delegate = self;
    _baseView.maximumZoomScale = 2;
    _baseView.minimumZoomScale = 1;
    [self.view addSubview:_baseView];
    
    _baseView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_baseView addSubview:self.containerView];
    
}

#pragma mark -- containerView --
- (UIView *)containerView {
    if (!_containerView) {
        
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.baseView.frame))];
        _containerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return _containerView;
}

- (void)baseReloadData {
    [self sendCarInfoRequest:NULL];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isEditing) {
        [PorscheRequestManager sendMessageToEditWithStatus:NO complete:^(NSInteger status, PResponseModel * _Nullable responser) {
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self sendCarInfoRequest:NULL];
//    self.carInfo = [[PorscheNewCarMessage alloc] init];
//    [self.billingView setViewContentData:self.carInfo];
    
}

- (void)setEditStatus:(BOOL)isEdit
{
    self.isEditing = isEdit;
    [self.billingView setViewEdit:isEdit];
    [self.bottomView setBottomViewEditAction:isEdit];
}


#pragma mark -- 获取开单信息 --
- (void)sendCarInfoRequest:(void(^)())complection
{
    if (![[HDStoreInfoManager shareManager] carorderid])
    {
        return;
    }
    
    WeakObject(self);
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_KEYWINDOW];
    [PHTTPRequestSender sendRequestWithURLStr:SINGLE_CAR_MESSAGE_URL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        
        if (responser.status == 100)
        {
            PorscheNewCarMessage *carInfo = [PorscheNewCarMessage yy_modelWithDictionary:responser.object];
            
            if (![PorscheNewCarMessage isOnFactoryHintWithWostatus:carInfo.orderstatus.wostatus])
            {
                [HDStoreInfoManager shareManager].carorderid = nil;
                carInfo = nil;
            }
            
            
            [carInfo parseVINCarseriesModelToPorscheCarSeriesModel];
            selfWeak.carInfo = carInfo;
            [selfWeak setBillingViewContentData:selfWeak.carInfo];
            [selfWeak.bottomView setViewContentData:selfWeak.carInfo];
            [HDLeftSingleton shareSingleton].carModel = carInfo;
            [[HDLeftSingleton shareSingleton] setupSingleNoticeWithNumber:carInfo.msgcount.allnum];
            [[HDLeftSingleton shareSingleton] setRemark:carInfo.statememo];
            
            [hud hideAnimated:YES afterDelay:0.5f];
            if (complection)
            {
                complection();
            }
        }
        HD_KEYWINDOW.userInteractionEnabled = YES;
    }];
}

#pragma mark -- 设置开单信息页面数据 -----
- (void)setBillingViewContentData:(PorscheNewCarMessage *)carinfo
{
    [self.billingView setViewContentData:carinfo];
    [self.billingView setViewEdit:self.isEditing];
}




#pragma mark --- 底部视图按钮 ---
- (void)bottomViewEventHandle
{
    WeakObject(self);
//底部视图
self.bottomView.blillingMessageBottomViewBlock = ^(BlillingMessageBottomViewStyle style,UIButton *sender) {
    //新建
    if (style == BlillingMessageBottomViewStyleCreate) {
        
        [selfWeak bottomNewBillingAction];
        // 取消
    }else if (style == BlillingMessageBottomViewStyleDelete) {
        
        [selfWeak bottomDeleteAction];
        
        //编辑
    }else if (style == BlillingMessageBottomViewStyleEdit) {
        
        [selfWeak bottoEditAction];
        //选择选择技师
    }else if (style == BlillingMessageBottomViewStyleTechicain) {
        [selfWeak chooseTachicianActionWithButton:selfWeak.bottomView.nameTF];
        //开单确认
    }else if (style == BlillingMessageBottomViewStyleBillingSure) {
        
        [selfWeak sureBillingAction];
        //职位选择
    }else if (style == BlillingMessageBottomViewStylePosition) {
        [selfWeak choosePositionActionWithButton:selfWeak.bottomView.positionTF];
        
    }
};
}

#pragma mark --- 新建 ---
- (void)bottomNewBillingAction {
    if ([HDPermissionManager isNotThisPermission:HDOrder_Kaidan]) {//开单权限
        return;
    } ;
    if ([HDPermissionManager isNotThisPermission:HDOrder_KaiDan_BuiltNewOrder]) {
        return;
    } ;
    
    //新键 新开单号
    [self getNewCarModel];
    
}

#pragma mark  ---- 编辑保存 ---
- (void)bottoEditAction {
    if ([HDPermissionManager isNotThisPermission:HDOrder_Kaidan]) {//开单权限
        return;
    } ;
    WeakObject(self);
    
    if (!self.isEditing) {
        
        if ([HDLeftSingleton isUserOrder]) {//自己的单子
            if ([HDPermissionManager isNotThisPermission:HDOrder_KaiDan_EditOrder]) {
                return;
            }
        }else {//不是自己的单子
            if ([HDPermissionManager isNotThisPermission:HDOrder_KaiDan_EditOtherPersonOrder]) {
                return;
            }
        }
        
        [PorscheRequestManager sendMessageToEditWithStatus:YES complete:^(NSInteger status, PResponseModel * _Nullable responser) {
            if (status == 100) {

                OrderOptStatusDto *orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
                if (![PorscheNewCarMessage isOnFactoryHintWithWostatus:orderstatus.wostatus])
                {
                    [HDStoreInfoManager shareManager].carorderid = nil;
                    selfWeak.carInfo = nil;
                    [selfWeak setBillingViewContentData:nil];
                    [selfWeak.bottomView setViewContentData:nil];
                    [HDLeftSingleton shareSingleton].carModel = nil;
                    [[HDLeftSingleton shareSingleton] setupSingleNoticeWithNumber:nil];
                    [[HDLeftSingleton shareSingleton] setRemark:nil];
                    return;
                }
//                selfWeak.carInfo.orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
//                selfWeak.bottomView.carMessage = selfWeak.carInfo;
                NSNumber *statestart = [responser.object objectForKey:@"statestart"];
                [selfWeak saveChangeToEdit];
                [selfWeak.bottomView setBillButtonEnabel:[statestart integerValue]];
                
            }else {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:selfWeak.billingView.center superView:selfWeak.view];
            }
        }];
    }else {
        [PorscheRequestManager sendMessageToEditWithStatus:NO complete:^(NSInteger status, PResponseModel * _Nullable responser) {
            if (status == 100) {
                OrderOptStatusDto *orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
                if (![PorscheNewCarMessage isOnFactoryHintWithWostatus:orderstatus.wostatus])
                {
                    [HDStoreInfoManager shareManager].carorderid = nil;
                    selfWeak.carInfo = nil;
                    [selfWeak setBillingViewContentData:nil];
                    [selfWeak.bottomView setViewContentData:nil];
                    [HDLeftSingleton shareSingleton].carModel = nil;
                    [[HDLeftSingleton shareSingleton] setupSingleNoticeWithNumber:nil];
                    [[HDLeftSingleton shareSingleton] setRemark:nil];
                    return;
                }
                [selfWeak saveBeforeTest];
            }else {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:selfWeak.billingView.center superView:selfWeak.view];
            }
        }];
    }
    
}

//保存变编辑
- (void)saveChangeToEdit {
    [self setEditStatus:YES];
}

//保存按钮事件
- (void)saveBeforeTest {
    //有车牌和车籍，
    NSString *message;
    
    if (self.billingView.carLocationLb.text.length > 0 && self.billingView.carNumberTF.text.length > 0)
    {
//        if (self.billingView.VINnumberTF.text.length < 17) {
//            message = @"VIN长度不足17位";
//            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:message height:60 center:self.billingView.center superView:self.view];
//        }
//        else
//        {
//            [self saveForBillingViewChange];
//        }
        [self saveForBillingViewChange];
    }
    else
    {
        message = @"请输入完整车牌信息";
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:message height:60 center:self.billingView.center superView:self.view];
    }
}


//保存状态下，View不可编辑
- (void)saveForBillingViewChange {
    [self setEditStatus:NO];
}

#pragma mark  底部选择技师
- (void)chooseTachicianActionWithButton:(UITextField *)sender {
    if ([HDPermissionManager isNotThisPermission:HDOrder_Kaidan]) {//开单权限
        return;
    } ;
    if (self.bottomView.positionTF.text.length && [HDLeftSingleton shareSingleton].selectedPosid) {
        [self showSelectStaffViewWithTF:sender];
    }else {
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"]  message:@"请选择技师或者服务顾问" height:60 center:HD_FULLView.center superView:HD_FULLView];
    }
}


#pragma mark  开单确认和取消------输入权限
- (void)sureBillingAction {
    if ([HDPermissionManager isNotThisPermission:HDOrder_Kaidan]) {//开单权限
        return;
    } ;
    
    if (!(self.bottomView.nameTF.text.length && [HDLeftSingleton shareSingleton].selectedPosid))
    {
        {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"]  message:@"请选择技师或者服务顾问" height:60 center:HD_FULLView.center superView:HD_FULLView];
        }
        return;
    }
    
    WeakObject(self);
    //输入权限
    if (!self.billingView.carNumberTF.text.length || !self.billingView.carLocationLb.text.length || !self.billingView.VINnumberTF.text.length) {
        
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"*为必填内容" height:60 center:self.billingView.center superView:self.view];
        return;
    }
    
    NSArray *titlrArr;
    if ([[HDLeftSingleton shareSingleton].selectedPosid isEqualToNumber:@1]) {
        titlrArr = @[@"确认进入技师流程?",@"确定",@"取消"];
    }else {
        titlrArr = @[@"确认进入服务流程?",@"确定",@"取消"];
    }
    
    [HDNewSaveView showMakeSureViewAroundView:self.bottomView.billingSure tittleArray:titlrArr direction:UIPopoverArrowDirectionUp makeSure:^{
        //发信号进入技师增项
        //进入技师增项
//        [HDLeftSingleton shareSingleton].maxStatus = 2;
        //            [selfWeak saveCarMessage];
        //开单 提交开单状态
        [selfWeak setupBillingNewCar];
        //开单之后，删除保存的工单id
        
    } cancel:^{
        
    }];
}
//确认开单
- (void)setupBillingNewCar {
    MBProgressHUD *mbView = [MBProgressHUD showProgressMessage:@"" toView:self.billingView];
    WeakObject(self);
    [PorscheRequestManager orderSureToNextOrder:1 buttonid:-1 Complete:^(NSInteger status,PResponseModel *responser) {
        [mbView hideAnimated:YES];
        if (status == 100) {//开单成功
            self.carInfo.orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
            NSInteger number = [self.carInfo.orderstatus.skipstep integerValue];
            if (number > 1 && number < 6) {
                HDLeftStatusStyle style;
                if (number == 2 || number == 4) {
                    style =HDLeftStatusStyleSchemeLeft;
                }else {
                    style = HDLeftStatusStyleBilling;
                }
                [HDStatusChangeManager changeStatusLeft:style right:number - 1];
                return ;
            }
            [selfWeak successToBilling];
            [selfWeak sendCarInfoRequest:^{
                if ([HDPermissionManager isNotThisPermission:HDOrder_Jishizengxiang])
                {
                    return ;
                }
                else
                {
//                    [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleSchemeLeft right:HDRightStatusStyleTechician];
                }
            }];
        }
        else
        {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:self.billingView.center superView:self.billingView];
        }
        
    }];
}

//开单成功，看是否需要保存 变编辑
- (void)saveSuccessVhangeBottomView {
    if ([self.bottomView.editTextBt.titleLabel.text isEqualToString:@"编辑"]) {
        [self saveChangeToEdit];
    }
}

//开单成功
- (void)successToBilling {
    
    [self saveSuccessVhangeBottomView];
    //左边刷新
    [self reloadLeftView];
}

#pragma mark  人员指派
- (void)showSelectStaffViewWithTF:(UITextField *)TF
{
    WeakObject(self);
    WeakObject(TF);
    // 获取组中员工数组
    [PorscheRequestManager getStaffListTestWithGroupId:[HDStoreInfoManager shareManager].groupid positionId:[HDLeftSingleton shareSingleton].selectedPosid complete:^(NSMutableArray * _Nonnull classifyArray, PResponseModel * _Nonnull responser) {
        
        [selfWeak showChooseBottomNameWithTF:TFWeak infoArray:classifyArray];
    }];
}


- (void)showChooseBottomNameWithTF:(UITextField *)tf infoArray:(NSMutableArray *)infoArr {
    WeakObject(tf)
    
    [self getStaffGroupTest];
    
    __block BOOL isMore = NO;
    __block PorscheConstantModel *tmpModel;
    if ([HDLeftSingleton shareSingleton].groupArray.count) {
        for (PorscheConstantModel *tmp in [HDLeftSingleton shareSingleton].groupArray) {
            if ([tmp.cvsubid integerValue] != [[HDStoreInfoManager shareManager].groupid integerValue]) {
                isMore = YES;
            }else {
                tmpModel = tmp;
            }
            
        }
    }
    
    PorscheConstantModel *more;
    if (isMore) {
        more = [PorscheConstantModel new];
        more.cvsubid = @0;
        more.cvvaluedesc = @"其他";
        [infoArr insertObject:more atIndex:0];
    }
    
    NSMutableArray *groupArray = [[HDLeftSingleton shareSingleton].groupArray mutableCopy];
    if (tmpModel) {
        [groupArray removeObject:tmpModel];
    }
    WeakObject(self);
    
    [HDSelectStaffView selectStaffViewWithView:tf CurrentGroupStaffs:infoArr otherGroups:groupArray selectCompletion:^(NSNumber *groupid, NSNumber *staffid, NSString *staffname) {
        tfWeak.text = staffname;
        [HDLeftSingleton shareSingleton].selectedId = staffid;//4
        [selfWeak bottomSaveChooseTechWithUserid:staffid];
    }];
}

- (void)bottomSaveChooseTechWithUserid:(NSNumber *)userid {
    if ([HDStoreInfoManager shareManager].carorderid) {
        NSDictionary *dic;
        if ([[HDLeftSingleton shareSingleton].selectedPosid integerValue] == 1) {//技师
            self.carInfo.technicianid = userid;
            self.carInfo.serviceadvisorid = nil;
            self.carInfo.technicianname = nil;
            self.carInfo.serviceadvisorname = nil;
            dic = @{@"technicianid":userid};
        }else if ([[HDLeftSingleton shareSingleton].selectedPosid integerValue] == 3){//服务顾问
            dic = @{@"serviceadvisorid":userid};
            self.carInfo.technicianid = nil;
            self.carInfo.technicianname = nil;
            self.carInfo.serviceadvisorname = nil;
            self.carInfo.serviceadvisorid = userid;
        }
//        if (dic) {
//            [PorscheRequestManager bottomSaveChooseTechWithdic:dic complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
//                
//            }];
//        }
        WeakObject(self);
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_CHANGE_POSITION_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
            if (responser.status == 100)
            {
                [selfWeak sendCarInfoRequest:NULL];
            }
        }];
//        [self saveOrder:NULL];
    }
}

#pragma mark  底部职位
- (void)choosePositionActionWithButton:(UITextField *)sender {
    if ([HDPermissionManager isNotThisPermission:HDOrder_Kaidan]) {//开单权限
        return;
    } ;
    WeakObject(self);
    NSMutableArray *dataArr = [NSMutableArray array];
    PorscheConstantModel *model1 = [PorscheConstantModel new];
    model1.cvvaluedesc = @"技师";
    model1.cvsubid = @1;
    [dataArr addObject:model1];
    
    PorscheConstantModel *model2 = [PorscheConstantModel new];
    model2.cvvaluedesc = @"服务顾问";
    model2.cvsubid = @3;
    [dataArr addObject:model2];
    
    [PorscheMultipleListhView showSingleListViewFrom:sender dataSource:dataArr selected:nil showArrow:NO direction:ListViewDirectionUp complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
        // 保存选择职位
        [selfWeak saveSelectPositionWithTF:sender model:constantModel];
    }];
    
}


- (void)saveSelectPositionWithTF:(UITextField *)tf model:(PorscheConstantModel *)constant
{
    
    if (![HDStoreInfoManager shareManager].carorderid) {
        return;
    }
        [HDLeftSingleton shareSingleton].selectedPosid = constant.cvsubid;
    
    
//    NSInteger positionid = [[HDLeftSingleton shareSingleton].selectedPosid integerValue];
    
    NSNumber *userid = nil;

    if ([[HDLeftSingleton shareSingleton].selectedPosid integerValue] == 1) {//技师
        userid = self.carInfo.technicianid;
    }else if ([[HDLeftSingleton shareSingleton].selectedPosid integerValue] == 3){//服务顾问
        userid = self.carInfo.serviceadvisorid;
    }
    
    [self.bottomView selectViewContentData:self.carInfo];
    
    if ([userid integerValue] > 0)
    {
        [self bottomSaveChooseTechWithUserid:userid];
    }
    
}
#pragma mark  底部员工指派 逻辑<根据职位id，组id，确定>
//组列表
- (void)getStaffGroupTest {
    if (![HDLeftSingleton shareSingleton].groupArray) {
        [HDLeftSingleton shareSingleton].groupArray = [NSMutableArray arrayWithArray:[[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataGroup]];
    }
}
#pragma mark --- 取消开单 ---
- (void)bottomDeleteAction {
    if ([HDPermissionManager isNotThisPermission:HDOrder_Kaidan]) {//开单权限
        return;
    } ;
    WeakObject(self);
    if ([HDPermissionManager isNotThisPermission:HDOrder_KaiDan_CancelOrder]) {
        return;
    } ;
    //取消开单原因
    [HDCancelBillingView showCancelViewBlock:^(NSString *reasonString) {
        
        [selfWeak cancelBillingNewCarReason:reasonString];
        
    }];
}

//取消开单
- (void)cancelBillingNewCarReason:(NSString *)reason {
    WeakObject(self);
    MBProgressHUD *mbView = [MBProgressHUD showProgressMessage:@"" toView:self.billingView];
    
    [PorscheRequestManager cancelBillingNewCarReason:reason complete:^(NSInteger status,PResponseModel *responser) {
        [mbView hideAnimated:YES];
        if (status == 100) {//取消开单成功
            [HDStoreInfoManager shareManager].carorderid = nil;
            //本界面清空
            [selfWeak bottomNewBillingAction];
            //左侧需要刷新
//            [self sendNotifinationToLeftToReloadDataType:@1];
            [selfWeak reloadLeftView];
            
        }else {//取消开单失败
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:self.billingView.center superView:self.billingView];
        }
        
    }];
}

- (void)reloadLeftView
{
    [[[HDLeftSingleton shareSingleton] leftVC] baseReloadData];
}


#pragma mark  新建工单
- (void)getNewCarModel;
{
    MBProgressHUD *mbView = [self getMBView];
    WeakObject(self);
    
    [PorscheRequestManager setupBillingNewCarComplete:^(id model, NSError *error) {
        if ([model isKindOfClass:[PorscheNewCarMessage class]]) {
            [HDLeftSingleton shareSingleton].maxStatus = 1;
            
            [HDLeftSingleton shareSingleton].carModel = nil;
            [[HDLeftSingleton shareSingleton].HDRightViewController changeItemColor:nil];

            
            selfWeak.carInfo = (PorscheNewCarMessage *)model;
            [HDStoreInfoManager shareManager].carorderid = selfWeak.carInfo.woid;
            [HDLeftSingleton shareSingleton].carModel = selfWeak.carInfo;
            [selfWeak.bottomView setViewContentWithData:selfWeak.carInfo isNew:YES];
//            [selfWeak.bottomView setCarMessage:selfWeak.carInfo];
            [selfWeak setBillingViewContentData:selfWeak.carInfo];
            [selfWeak setEditStatus:YES];
            //新建的时候刷新提醒数量和备注数量
            [[HDLeftSingleton shareSingleton] setupSingleNoticeWithNumber:selfWeak.carInfo.msgcount.allnum];
            [[HDLeftSingleton shareSingleton] setRemark:@1];
        }else {//新开单未成功
            
        }
        [mbView hideAnimated:YES];
    }];
}

- (MBProgressHUD *)getMBView {
    return [MBProgressHUD showProgressMessage:@"" toView:self.billingView];
}


#pragma mark --- billingViewDelegate ---  保存各种信息
- (void)billingViewSaveCarInfo:(PorscheNewCarMessage *)carinfo blillingMessageCenterViewStyle:(BlillingMessageCenterViewStyle)style
{
    
    void(^completion)();
    WeakObject(self);
    if (style == BlillingMessageCenterViewStyleCarNumber || style == BlillingMessageCenterViewStyleVIN || style == BlillingMessageCenterViewStyleCarCategory)
    {
        completion = ^{
            [selfWeak reloadLeftView];
        };
    }
    
//    // 判断车牌，车籍是否存在
//    if ([carinfo.plateplace isEqualToString:@"未上牌"])
//    {
//
//        // 保存数据
//        [self saveOrder:complection];
//    }
    if (style == BlillingMessageCenterViewStyleVIN)
    {
        [self getVinInfoWithVIN:self.carInfo.cvincode completion:^{
            //
            [self saveOrder:completion];
        }];
    }
    else if (carinfo.plateplace.length && carinfo.ccarplate.length)
    {
        if (style == BlillingMessageCenterViewStyleCarNumber)
        {
            [self getcarMessage:^{
                [selfWeak saveOrder:completion];
            }];
        }
        else
        {
            [self saveOrder:completion];
        }
    }

}

//vin获取车辆信息
- (void)getVinInfoWithVIN:(NSString *)VIN completion:(void(^)())completion {
    if(VIN.length < 17){
        
        NSString *message = @"VIN长度不足17位";
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:message height:60 center:self.billingView.center superView:self.view];
        
        [self saveOrder:NULL];
        return;
    }
    self.carInfo.cvincode = VIN;
    self.billingView.VINnumberTF.text = VIN;
    
    WeakObject(self);
    MBProgressHUD *hub = [MBProgressHUD showProgressMessage:nil toView:self.view];
    [PorscheRequestManager carMessageWithVIN:VIN carComplete:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        [hub hideAnimated:YES];
        if (responser.status == 100 || responser.status == 301)
        {
            
            NSNumber *woid = [responser.object objectForKey:@"woid"];
            if([woid integerValue])
            {
                if (![woid isEqualToNumber:[HDStoreInfoManager shareManager].carorderid])
                {
                    [selfWeak handleCarAlreadyInfactoryWithCarInfo:responser.object];
                    return ;
                }
                
                [HDStoreInfoManager shareManager].carorderid = woid;
            }
            
            PorscheNewCarMessage *carInfo = [PorscheNewCarMessage yy_modelWithDictionary:responser.object];
            [carInfo parseVINCarseriesModelToPorscheCarSeriesModel];
            [PorscheNewCarMessage compareMergeCurrenCarinfo:selfWeak.carInfo oldCarinfoInfo:carInfo];
            
            // 把VIN对应的车型信息重新赋值
            [selfWeak setCarinfoCartypeWithVINCarInfo:carInfo];
            [selfWeak saveVINInfoWithVINCarInfo:carInfo];
            
            
//            if([carInfo.woid integerValue])
//            {
//                [HDStoreInfoManager shareManager].carorderid = carInfo.woid;
//            }
//            
      
            if (carInfo.plateplace.length && carInfo.ccarplate.length)
            {
                selfWeak.carInfo.plateplace = carInfo.plateplace;
                selfWeak.carInfo.ccarplate = carInfo.ccarplate;
            }
            
            if (completion)
            {
                completion();
            }
        }
//        else if (responser.status == 301) {
////            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"此车辆已在厂" height:60 center:HD_FULLView.center superView:HD_FULLView];
//            [selfWeak handleCarAlreadyInfactoryWithCarInfo:responser.object];
//        }
        }];
}

- (void)setCarinfoCartypeWithVINCarInfo:(PorscheNewCarMessage *)VINCarInfo
{
    self.carInfo.carsid = VINCarInfo.carsid;
    self.carInfo.cartypeid = VINCarInfo.cartypeid;
    self.carInfo.caryearid = VINCarInfo.caryearid;
    self.carInfo.cardisplacementid = VINCarInfo.cardisplacementid;
    self.carInfo.savecartypeid = VINCarInfo.ccartypeid;
    self.carInfo.wocarcatena = VINCarInfo.wocarcatena;
    self.carInfo.wocarmodel = VINCarInfo.wocarmodel;
    self.carInfo.woyearstyle = VINCarInfo.woyearstyle;
    self.carInfo.wooutputvolume = VINCarInfo.wooutputvolume;
    self.carInfo.savecartypeid = VINCarInfo.ccartypeid;
    
}


// 判断是否存在车型信息
- (void)saveVINInfoWithVINCarInfo:(PorscheNewCarMessage *)VINCarInfo
{
    // 如果 未选择车型信息 那么直接选择第一个，进行赋值 这里会有bug
    if ( ![self.carInfo.carsid integerValue] || ![self.carInfo.cartypeid integerValue] ||  ![self.carInfo.caryearid integerValue] || ![self.carInfo.cardisplacementid integerValue])
    {
        PorscheConstantModel *carseries = [[VINCarInfo getCarseries] firstObject];
        PorscheConstantModel *cartype = [[VINCarInfo getCartypeWithCarspctid:carseries.cvsubid] firstObject];
        PorscheConstantModel *caryear = [[VINCarInfo getCaryearWithCarspctid:carseries.cvsubid cartypepctid:cartype.cvsubid] firstObject];
        PorscheConstantModel *output = [[VINCarInfo getCaroutputWithCarspctid:carseries.cvsubid cartypepctid:cartype.cvsubid caryearpctid:caryear.cvsubid] firstObject];

        /*
         // 车系
         NSString *cars = carInfo.ccarcatena;
         self.carCategoryLb.text = cars;
         self.carCategoryTF.text = cars;
         
         // 车型
         NSString *cartype = carInfo.wocarmodel;
         self.carStyleTF.text = cartype;
         self.carStyleLb.text = cartype;
         
         // 年款
         NSString *caryear = carInfo.woyearstyle;
         self.carYearLb.text = caryear;
         self.carMadeYearTF.text = caryear;
         
         // 排量
         NSString *caroutput = carInfo.wooutputvolume;
         */
        self.carInfo.carsid = carseries.cvsubid;
        self.carInfo.wocarcatena = carseries.cvvaluedesc;
        
        self.carInfo.cartypeid = cartype.cvsubid;
        self.carInfo.wocarmodel = cartype.descr;

        self.carInfo.caryearid = caryear.cvsubid;
        self.carInfo.woyearstyle = caryear.cvvaluedesc;

        
        self.carInfo.cardisplacementid = output.cvsubid;
        self.carInfo.wooutputvolume = output.cvvaluedesc;

        if ([carseries.cvsubid integerValue] > 0) {
            self.carInfo.savecartypeid = carseries.cvsubid;
        }
        
        if ([cartype.cvsubid integerValue] > 0) {
            self.carInfo.savecartypeid = cartype.cvsubid;
            
        }
        if ([caryear.cvsubid integerValue] > 0) {
            self.carInfo.savecartypeid = caryear.cvsubid;
            
        }
        
        if ([output.cvsubid integerValue] > 0)
        {
            self.carInfo.savecartypeid = output.cvsubid;
        }
        
//        [self reloadLeftView];
    }
    [self setBillingViewContentData:self.carInfo];
}

#pragma mark --- 通过车牌获取车辆信息 ---
//车牌号获取车辆信息
- (void)getcarMessage:(void(^)())completion
{
    WeakObject(self);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:self.carInfo.ccarplate forKey:@"ccarplate"];
    [param hs_setSafeValue:self.carInfo.plateplace forKey:@"plateplace"];

    [PorscheRequestManager getCarMessage:param complete:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100 || responser.status == 301)
        {
            
            // 如果存在工单id，那么当前工单id就是返回的
            NSNumber *woid = [responser.object objectForKey:@"woid"];
            if([woid integerValue])
            {
                if (![woid isEqualToNumber:[HDStoreInfoManager shareManager].carorderid])
                {
                    [selfWeak handleCarAlreadyInfactoryWithCarInfo:responser.object];
                    return ;
                }
                
                [HDStoreInfoManager shareManager].carorderid = woid;
            }
            
            PorscheNewCarMessage *carInfo = [PorscheNewCarMessage yy_modelWithDictionary:responser.object];
            [carInfo parseVINCarseriesModelToPorscheCarSeriesModel];
            [PorscheNewCarMessage compareMergeCurrenCarinfo:selfWeak.carInfo oldCarinfoInfo:carInfo];
            
            
  
            if (completion) {
                completion();
            }
        }
//        else if (responser.status == 301)
//        {
////            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"此车辆已在厂" height:60 center:HD_FULLView.center superView:HD_FULLView];
//            [selfWeak handleCarAlreadyInfactoryWithCarInfo:responser.object];
//        }
    }];
}

#pragma mark 车辆已在厂处理
- (void)handleCarAlreadyInfactoryWithCarInfo:(NSDictionary *)info
{
    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"此车辆已在厂" height:60 center:HD_FULLView.center superView:HD_FULLView];

    PorscheNewCarMessage *carinfo = [PorscheNewCarMessage yy_modelWithDictionary:info];
    NSNumber *orderid = carinfo.woid;
    // 如果车辆在场刷新左边界面
    [HDStoreInfoManager shareManager].carorderid = orderid;
    [self sendCarInfoRequest:NULL];
    
    BaseLeftViewController *vc = [[HDLeftSingleton shareSingleton] leftVC];
    if ([vc isKindOfClass:NSClassFromString(@"KandanLeftViewController")])
    {
        [vc baseReloadDataWithObject:carinfo];
    }

}

#pragma mark -- 保存开单信息 --
- (void)saveOrder:(void(^)())complection
{
    if (self.carInfo.ccarplate.length && self.carInfo.plateplace.length)
    {
        NSDictionary *info = [self.carInfo yy_modelToJSONObject];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:info];
        //    attachments
        //    solutionList
        //    cartypes
        //    carSeries
        [param removeObjectForKey:@"attachments"];
        [param removeObjectForKey:@"solutionList"];
        [param removeObjectForKey:@"cartypes"];
        [param removeObjectForKey:@"carSeries"];
        [param removeObjectForKey:@"picArray"];
        [param removeObjectForKey:@"savecartypeid"];

        [param hs_setSafeValue:self.carInfo.savecartypeid forKey:@"ccartypeid"];
        
        WeakObject(self);
        MBProgressHUD *hub = [MBProgressHUD showProgressMessage:nil toView:self.view];
        [PorscheRequestManager saveBillingNewCarDic:param complete:^(NSInteger status,PResponseModel *responser) {
            [hub hideAnimated:YES];
            if (status == 100) {
                if (complection)
                {
                    complection();
                }
                else
                {
                    [selfWeak reloadLeftView];
                }
                
                [selfWeak sendCarInfoRequest:NULL];
            }
            else
            {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
                [HDStoreInfoManager shareManager].carorderid = nil;
                selfWeak.carInfo = nil;
                [selfWeak setBillingViewContentData:nil];
                [selfWeak.bottomView setViewContentData:nil];
                [HDLeftSingleton shareSingleton].carModel = nil;
                [[HDLeftSingleton shareSingleton] setupSingleNoticeWithNumber:nil];
                [[HDLeftSingleton shareSingleton] setRemark:nil];
                
                
            }
        }];

    }
}

#pragma mark 进入图片库
- (void)showPhotoGallery {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        
        ipc.delegate = self;
        [self intoPhotoLibrarySetting];
        [self presentViewController:ipc animated:YES completion:NULL];
    }
}

// 进入图片库
- (void)intoPhotoLibrarySetting
{
    [[NSNotificationCenter defaultCenter] postNotificationName:INTO_PHOTOLIBRARY_NOTIFICATION object:nil];
}

// 退出图片库
- (void)exitPhotoLibrarySetting
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EXIT_PHOTOLIBRARY_NOTIFICATION object:nil];
}


#pragma mark  访问相册选择照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self exitPhotoLibrarySetting];
    UIImage *selectImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    ZLCamera *camera = [[ZLCamera alloc] init];
    camera.photoImage = selectImage;
    [self cameraViewController:nil createDidNewOriginalPhoto:camera];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self exitPhotoLibrarySetting];
    [picker dismissViewControllerAnimated:YES completion:NULL];

}



#pragma mark 图片上传delegate

/**
 新建了一个原图图片
 */
- (void)cameraViewController:(ZLCameraViewController *)cameraController createDidNewOriginalPhoto:(ZLCamera *)photo;
{
    WeakObject(self);
    PorscheRequestUploadPictureVideoModel *request = [[PorscheRequestUploadPictureVideoModel alloc] init];
    request.aieditdesc = photo.markString;
    request.aifiletype = @(1);
    request.aipictype = @(1);
    request.keytype = @(1);
    request.relativeid = [HDStoreInfoManager shareManager].carorderid;
    request.edittype = @1;
    request.aiid = nil;  // 新建时为空，编辑时才有
    request.parentid = nil;
    request.patharray = nil;
    request.iscovers = photo.isCovers ? @1 : @0;
    // 新建工单图片
    HD_KEYWINDOW.userInteractionEnabled = NO;
    [PorscheRequestManager uploadCameraImages:@[photo] editImage:NO video:nil parameModel:request completion:^(id  _Nullable responser, NSError * _Nullable error) {
        if (!error)
        {
            NSDictionary *responserObjectInfo = [responser objectForKey:@"object"];
            PorscheResponserPictureVideoModel *picModel = [PorscheResponserPictureVideoModel yy_modelWithDictionary:responserObjectInfo];
            [photo convertPhotoWithPhoto:picModel];
            [cameraController addPhoto:photo];
            
            [selfWeak sendCarInfoRequest:NULL];
        }
        else
        {
            HD_KEYWINDOW.userInteractionEnabled = YES;
        }
    }];
    
}


- (void)uploadMv:(ZLCamera *)photo isVideo:(BOOL)isVideo isEditImage:(BOOL)isEdit
{
    PorscheRequestUploadPictureVideoModel *request = [[PorscheRequestUploadPictureVideoModel alloc] init];
    request.aieditdesc = photo.markString;
    request.aifiletype = isVideo ? @2 : @1;
    request.aipictype = @(1);
    request.keytype = @(1);
    request.relativeid = [HDStoreInfoManager shareManager].carorderid;
    request.edittype = isEdit? @2:@1;
//    request.aiid = nil;  // 新建时为空，编辑时才有
    request.parentid = isEdit ? photo.cameraID : nil;
    request.patharray = nil;
    
    request.iscovers = photo.isCovers ? @1 : @0;
    // 将第一张拍摄的照片设置为封面
    [PorscheRequestManager uploadCameraImages:@[photo] editImage:isEdit video:photo.videoUrl parameModel:request completion:^(id  _Nullable responser, NSError * _Nullable error) {
        if (!error)
        {
            NSDictionary *responserObjectInfo = [responser objectForKey:@"object"];
            PorscheResponserPictureVideoModel *picModel = [PorscheResponserPictureVideoModel yy_modelWithDictionary:responserObjectInfo];
            if (!isEdit)
            {
                photo.cameraID = picModel.aiid;
            }
        }
    }];
}


/**
 新建了一个编辑图片
 */
- (void)cameraViewController:(ZLCameraViewController *)cameraController createDidNewEditPhoto:(ZLCamera *)photo;
{
    WeakObject(self);
    
    PorscheRequestUploadPictureVideoModel *request = [[PorscheRequestUploadPictureVideoModel alloc] init];
    request.aieditdesc = photo.markString;
    request.aifiletype = @(1);
    request.aipictype = @(1);
    request.keytype = @(1);
    request.relativeid = [HDStoreInfoManager shareManager].carorderid;
    request.edittype = @2;
    request.aiid = photo.cameraID;  // 新建时为空，编辑时才有
    request.iscovers = photo.isCovers ? @1 : @0;
    request.parentid = photo.cameraID;
    request.patharray = [photo convertPathArrayToString];//[[photo.pathArray yy_modelToJSONString] stringByReplacingOccurrencesOfString:@"\"" withString:@"\'"];
    HD_KEYWINDOW.userInteractionEnabled = NO;
    [PorscheRequestManager uploadCameraImages:@[photo] editImage:YES video:nil parameModel:request completion:^(id  _Nullable responser, NSError * _Nullable error) {
        if (!error)
        {
            NSDictionary *responserObjectInfo = [responser objectForKey:@"object"];
            PorscheResponserPictureVideoModel *picModel = [PorscheResponserPictureVideoModel yy_modelWithDictionary:responserObjectInfo];
            [photo convertPhotoWithPhoto:picModel];
            [selfWeak sendCarInfoRequest:NULL];
            [selfWeak.browser reloadCurrentPhoto];
            [cameraController reloadData];
        }
        else
        {
            HD_KEYWINDOW.userInteractionEnabled = YES;
        }
    }];
}

- (void)cameraViewController:(ZLCameraViewController *)cameraController createDidNewVideo:(ZLCamera *)video
{
    WeakObject(self);
    
    PorscheRequestUploadPictureVideoModel *request = [[PorscheRequestUploadPictureVideoModel alloc] init];
    request.aieditdesc = @"视频上传";
    request.aifiletype = @(2);
    request.aipictype = @(1);
    request.keytype = @(1);
    request.relativeid = [HDStoreInfoManager shareManager].carorderid;
    request.edittype = @1;
    request.aiid = nil;  // 新建时为空，编辑时才有
    request.parentid = nil;
    request.patharray = nil;
    request.iscovers = video.isCovers ? @1 : @0;
    [PorscheRequestManager uploadCameraImages:@[] editImage:NO video:video.videoUrl parameModel:request completion:^(id  _Nullable responser, NSError * _Nullable error) {
        if (!error)
        {
            NSDictionary *responserObjectInfo = [responser objectForKey:@"object"];
            PorscheResponserPictureVideoModel *picModel = [PorscheResponserPictureVideoModel yy_modelWithDictionary:responserObjectInfo];
            video.cameraID = picModel.aiid;
            [video convertVideoWithVideo:picModel];
            [selfWeak sendCarInfoRequest:NULL];
            [cameraController reloadData];
        }
    }];
}

/**
 删除了一个图片
 */
- (void)cameraViewController:(ZLCameraViewController *)cameraController deleteDidCamera:(ZLCamera *)photo{
    if ([photo.cameraID integerValue] == 0)
    {
        return;
    }
    WeakObject(self);
    [PorscheRequestManager deleteCameraImage:photo.cameraID.integerValue complete:^(BOOL delete, NSString * _Nonnull errorMsg) {
        if (delete)
        {
            NSLog(@"删除成功");
            [selfWeak sendCarInfoRequest:NULL];
            [cameraController reloadData];
        }
    }];
}

#pragma mark - 图片浏览器代理
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    //    if (self.picArray && self.picArray.count > index) {
    //        ZLCamera *camera = [self.picArray objectAtIndex:index];
    //        return camera.editImage;
    //    }
    return [UIImage imageNamed:PlaceHolderImageNormalName];
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    if (self.carInfo.picArray && self.carInfo.picArray.count > index) {
        ZLCamera *camera = [self.carInfo.picArray objectAtIndex:index];
        return camera.editImageUrl;
    }
    return nil;
}

- (NSString *)photoBrowser:(HZPhotoBrowser *)browser markContentForIndex:(NSInteger)index {
    if (self.carInfo.picArray && self.carInfo.picArray.count > 0) {
        ZLCamera *camera = [self.carInfo.picArray objectAtIndex:index];
        return camera.markString;
    }
    return nil;
}

- (void)photoBrowser:(HZPhotoBrowser *)browser EditImageForIndex:(NSInteger)index {
    
    [self reDrawImageControllerWithIndex:index photoBrowser:browser array:self.carInfo.picArray];
}



- (void)reDrawImageControllerWithIndex:(NSInteger)index photoBrowser:(HZPhotoBrowser *)photoBrowser array:(NSMutableArray <ZLCamera *>*)array{
    WeakObject(self);
    ZLCamera *camera = [array objectAtIndex:index];
    DrawViewController *drawVC = [[DrawViewController alloc] initWithNibName:@"DrawViewController" bundle:nil];
    drawVC.image = camera.photoImage;
    drawVC.imageUrl = camera.photoImageUrl;
    drawVC.pathArray = camera.pathArray;
    drawVC.markString = camera.markString;
    drawVC.isCovers = camera.isCovers;
    drawVC.doneBlock = ^(UIImage *image, NSString *markString,BOOL isCovers, NSMutableArray *pathArray) {
        
        //        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        camera.editImage = image;
        
        
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        camera.editImage = image;
        camera.markString = markString;
        camera.thumbImage = [UIImage imageWithData:data];
        camera.isCovers = isCovers;
        camera.pathArray = pathArray;
        
        [selfWeak cameraViewController:nil createDidNewEditPhoto:camera];
        
    };
    
    WeakObject(drawVC);
    drawVC.deleteBlock = ^ () {
        ZLCamera *camera = [selfWeak.carInfo.picArray objectAtIndex:index];
        [selfWeak.carInfo.picArray removeObjectAtIndex:index];
        
        if (selfWeak.carInfo.picArray.count ==0) {
            
            [photoBrowser closePhotoBrowser];
            
            [drawVCWeak dismissViewControllerAnimated:YES completion:nil];
            
        }else {
            
            [photoBrowser deletePhotoWithIndex:index];
            
        }
        
        [selfWeak.cameraVC deleteDataSourceVideo:NO orImage:index];
        [selfWeak cameraViewController:nil deleteDidCamera:camera];
        
    };
    
    [self presentViewController:drawVC animated:NO completion:nil];
}

- (void)showPrecheckViewController
{
    HDPreCheckViewController *precheckViewController = [[HDPreCheckViewController alloc] init];
    CGRect frame = precheckViewController.view.frame;
    ViewController *vc = [HDLeftSingleton shareSingleton].VC;
    frame = vc.view.frame;
    frame.size.width -= 100;
    frame.size.height -= 100;

    frame.origin.x = 30;
    frame.origin.y = 30;
    
    precheckViewController.view.frame = frame;
//    [vc addChildViewController:precheckViewController];
//    [vc.view addSubview:precheckViewController.view];
//    [vc.navigationController pushViewController:precheckViewController animated:YES];
    [vc presentViewController:precheckViewController animated:YES completion:NULL];
}

#pragma mark - 缩放

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    //捏合或者移动时，确定正确的center
    CGFloat centerX = scrollView.center.x;
    
    CGFloat centerY = scrollView.center.y;
    
    //随时获取center位置
    centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : centerX;
    
    centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height / 2 : centerY;
    
    self.containerView.center = CGPointMake(centerX, centerY);
}

@end
