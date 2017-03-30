//
//  HDRightMaterialDealViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDRightMaterialDealViewController.h"

//顶部视图
#import "HDMaterialHeaderView.h"

//底部视图
#import "TeachicianAdditionItemBottomView.h"

//分区区头
#import "HDWorkListTVHFViewNormal.h"
//工时cell
#import "HDRIghtMaterialTableViewCell.h"
//可修改配件cell
#import "HDRightMaterialTableViewCellOne.h"
//添加配件cell
#import "HDRightMaterialTableViewCellAdd.h"
//添加新配件cell
#import "HDRightNewMaterialTableViewCell.h"
//备注cell
#import "HDRightMaterialRemarkTableViewCell.h"

//弹窗内容视图
#import "HDWorkListTableViews.h"
#import "AlertViewHelpers.h"

//保存弹窗，进入服务沟通
//保存弹窗
#import "HDNewSaveView.h"

#import "HDLeftSingleton.h"
//价格试用全店
#import "HDPoperDeleteView.h"
//照片库
#import "PorschePhotoGallery.h"
//备件库
#import "TechcianNumberTFInputView.h"
//
#import "HDWorkListNextView.h"
//人员
#import "HDSelectStaffView.h"
#import "PorschePhotoModelController.h"

#import "MaterialTaskTimeDetailsView.h"
#import "HDServiceDealView.h"

@interface HDRightMaterialDealViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate>
;
// 媒体处理类
@property (nonatomic, strong) PorschePhotoModelController *modelController;

//工单model
@property (nonatomic, strong) PorscheNewCarMessage *carMessage;

@property (nonatomic, strong) UIPopoverController *pop;
//滑动
@property (strong, nonatomic) UIView *containerView;

//底层滑动视图
@property (strong, nonatomic)  UIScrollView *baseView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSNumber *currentIdx;//进入备件工时库时的位置
//备件确认数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

////顶部视图
//@property (nonatomic, strong) HDMaterialHeaderView *headerView;
//底部视图
@property (nonatomic, strong) TeachicianAdditionItemBottomView *bottomView;
//空白占位图
@property (nonatomic, strong) UIButton *emptyView;

@property (nonatomic, strong) NSMutableArray *customDataArray;

//自定义添加的项目，区头分类标志，图片数组
@property (nonatomic, strong) NSArray *customImgArray;


//移动分区
//起始index
@property (nonatomic, strong) NSIndexPath *pointIndexpath;
//终点index
@property (nonatomic, strong) NSIndexPath *endPointIndexPath;
//分区渲染图
@property (nonatomic, strong) UIImageView *imageView;
//经过的section
@property (nonatomic, assign) NSInteger tmpSection;
@property (nonatomic, assign) NSInteger oldSection;
//添加Model
@property (nonatomic, strong) id itemModel;

@property (nonatomic, strong) NSNumber *saveStatus;
@end

@implementation HDRightMaterialDealViewController


- (void)dealloc {
    NSLog(@"HDRightMaterialDealViewController.dealloc");
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    
    self.baseView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64 - 49);
    self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.baseView.frame));
    
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.baseView.frame));
    
    _baseView.contentSize = CGSizeMake(CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 49 - 64, CGRectGetWidth(self.baseView.frame), 49);
    
    self.emptyView.frame = self.containerView.frame;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _tmpSection = -1;
    _oldSection = -2;
    self.saveStatus = @1;
    [HDLeftSingleton shareSingleton].stepStatus = 3;

    
    [self setupBaseScrollView];
    
    [self setUpTableView];
    
    [self setheaderViewAndBottomView];
    
    [self addEmptyView];
    
    
//    [self addNotifination];
    
//    [self addLongPress];
    
    [self getOrderList];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self.bottomView.saveLb.text isEqualToString:@"保存"]) {
        [PorscheRequestManager sendMessageToEditWithStatus:NO complete:^(NSInteger status, PResponseModel * _Nullable responser) {
        }];
    }
}

- (void)setupBaseScrollView {
    //滑动
    _baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- 64 - 49)];
    
    
    _baseView.contentSize = CGSizeMake(CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    
    _baseView.bounces = NO;
    
    _baseView.maximumZoomScale = 2;
    
    _baseView.minimumZoomScale = 1;
    
    [self.view addSubview:_baseView];
    
    _baseView.backgroundColor = [UIColor whiteColor];
    
    [_baseView addSubview:self.containerView];
    
    self.baseView.delegate = self;
}

#pragma mark  ------scroll------

- (UIView *)containerView {
    if (!_containerView) {
        
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.baseView.frame))];
    }
    return _containerView;
}

//设置缩放内容

#pragma mark - 缩放

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.containerView;
}



- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidZoom");
    
    
    //捏合或者移动时，确定正确的center
    CGFloat centerX = scrollView.center.x;
    
    CGFloat centerY = scrollView.center.y;
    
    //随时获取center位置
    centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : centerX;
    
    centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height / 2 : centerY;
    
    if (scrollView.contentSize.height > scrollView.frame.size.height) {
        _tableView.scrollEnabled = NO;
    }else {
        _tableView.scrollEnabled = YES;
    }
    
    self.containerView.center = CGPointMake(centerX, centerY);
}

- (PorschePhotoModelController *)modelController
{
    if (!_modelController)
    {
        _modelController = [[PorschePhotoModelController alloc] init];
        _modelController.supporterViewController = self;
    }
    return _modelController;
}

- (void)getOrderList {
    
//    if ([HDLeftSingleton shareSingleton].maxStatus >= [HDLeftSingleton shareSingleton].stepStatus) {
        [self getWorkOrderListTest];
        self.customDataArray = [[[CoreDataManager shareManager] getModelsWithTableName:CoreDataStoreType] mutableCopy];

//    }else {
//        self.carMessage = [PorscheNewCarMessage new];
//        self.dataArray = nil;
//        [self reloadSelfView];
//    }
}

- (void)baseReloadData
{
    [self getOrderList];
}

- (void)reloadSelfView {
//    [self afterConfirmIncrease];
    [self addEmptyView];
    [self setupBottomViewStaff];
    [self setSelectCountLabelContent];
    [self.tableView reloadData];
}

//获取确认后增项
- (void)afterConfirmIncrease {
    if ([self.carMessage.wostatus isEqual:@7]) {//客户已确认
        if([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_FuWuGouTong_Add_AfterClientAffirm]){
            self.saveStatus = @1;
        }
    }
}


- (void)failToEditWithModel:(PResponseModel *)responser {
    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
    [self.tableView reloadData];
}

#pragma mark  测试库存数据
//编辑库位数据 stockid （库存id type：库存类型  1本店   2PCN  3PAG   4无库存  5常备件） amount:（  库存数量 ）     备件id  （ partid ）     modifyType    （  1 临时修改  2 永久保存 ）
- (void)editCubWithDic:(NSDictionary *)dic {
    WeakObject(self);

    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    [PorscheRequestManager editMaterialCubListWithDic:dic complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
        [hud hideAnimated:YES];
        if (status == 100) {
            [selfWeak getWorkOrderListTest];
        }else {
            [selfWeak failToEditWithModel:responser];
        }
    }];
}

//添加/删除备件库位
- (void)addMaterialCubDataWithId:(NSNumber *)partid isDelete:(BOOL)isDelete {
    WeakObject(self);

    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    [PorscheRequestManager upDateMaterialCubListWithid:partid isDelete:isDelete complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
        [hud hideAnimated:YES];
        if (status == 100) {
            [selfWeak getWorkOrderListTest];
        }else {
            [selfWeak failToEditWithModel:responser];

        }
    }];
}

//工单列表
- (void)getWorkOrderListTest {
    WeakObject(self);
    if ([HDStoreInfoManager shareManager].carorderid) {
        MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
        
        [PorscheRequestManager getWorkOrderListComplate:^(PorscheNewCarMessage * _Nonnull carMessage, PResponseModel * _Nonnull responser) {
            [hud hideAnimated:YES];
            if (![PorscheNewCarMessage isOnFactoryHintWithWostatus:carMessage.orderstatus.wostatus])
            {
                [HDStoreInfoManager shareManager].carorderid = nil;
                selfWeak.carMessage = nil;
                selfWeak.dataArray = nil;
                [selfWeak reloadSelfView];
                return;
            }

            
            if (carMessage.solutionList) {
                NSLog(@"获取工单方案信息成功！");
                [HDLeftSingleton shareSingleton].maxStatus = [carMessage.wostatus integerValue];
                if([[HDLeftSingleton shareSingleton] showStepAlertViewShowStatus:nil]) {
                    return ;
                }
                selfWeak.carMessage = carMessage;
                selfWeak.dataArray = carMessage.solutionList;
                
                [[HDLeftSingleton shareSingleton] setCarModel:carMessage];
                
                [selfWeak reloadSelfView];
                
                [[HDLeftSingleton shareSingleton] setupSingleNoticeWithNumber:carMessage.msgcount.allnum];
            }else {
                
                [selfWeak failToEditWithModel:responser];

            }
        }];
    }else {
        NSLog(@"未选择车辆,获取不到工单信息");
    }
    
}
- (void)setupBottomViewStaff {

    self.bottomView.carMessage = self.carMessage;
    [_bottomView setSaveLbTittleAndImgBool:[_saveStatus integerValue]];

}

//编辑工时/备件 
- (void)editWorkHourOrMaretialWithSchemews:(PorscheNewSchemews *)schemews type:(NSNumber *)type{
//    if ([HDPermissionManager isNotThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeMaterial]) {
//        return ;
//    }
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    WeakObject(self);
    [PorscheRequestManager editProjectWorkHourOrMaterial:schemews type:type complete:^(NSInteger status, PResponseModel * _Nonnull model) {
        [hud hideAnimated:YES];
        if (status == 100) {
            NSLog(@"方案工时修改成功！");
            [selfWeak getWorkOrderListTest];
        }else {
            [selfWeak failToEditWithModel:model];
            NSLog(@"方案工时修改失败！");
        }
    }];
    
}


//添加工时备件 type:1.工时  2.备件  source:1.库 2.自定义 stocked添加自定义不需要，添加库多工时配件，存id数组  删除时，将单一的配件或者工时id存入数组。
- (void)upDateProjectMaterialTestWithAddedType:(NSNumber *)addedType schemeid:(NSNumber *)schemeid type:(NSNumber *)type source:(NSNumber *)source stockid:(NSArray *)stockList {
//    if ([HDPermissionManager isNotThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeMaterial]) {
//        return ;
//    }
    NSString *stockid = stockList.count ? [stockList componentsJoinedByString:@","] :@"";
    ProscheAdditionCondition *tmp = [ProscheAdditionCondition new];
    if ([addedType isEqual:kAddition]) {
        tmp.processstatus = @([HDLeftSingleton shareSingleton].stepStatus - 1);
        tmp.schemeid = schemeid;
        tmp.source = source;
        tmp.type = type;
        tmp.stockidbatch = stockid;
    }else if ([addedType isEqual:kDeletion]) {
        tmp.schemeid = schemeid;
        tmp.type = type;
        tmp.wsid = stockList.firstObject;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    WeakObject(self);
    [PorscheRequestManager inscreaseProjectSubObjectAddedType:addedType Condition:tmp complete:^(NSInteger status, PResponseModel * _Nonnull model) {
        [hud hideAnimated:YES];
        if (status == 100) {
            NSLog(@"工时/备件添加/删除至方案成功");
            [selfWeak getWorkOrderListTest];
        }else {
            [selfWeak failToEditWithModel:model];

            NSLog(@"工时/备件添加/删除至方案失败");
        }
        
    }];
}


#pragma mark  显示方案详情之后 需确认：备件员不能添加方案
- (void)showSchemeDetialWithScheme:(PorscheNewScheme *)scheme {
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    
    [PorscheRequestManager getWorkOrderSchemeOrderid:scheme.schemeid complete:^(PorscheSchemeModel * _Nonnull schemeModel, PResponseModel * _Nonnull responser) {
        [hud hideAnimated:YES];
        if (schemeModel) {
            [MaterialTaskTimeDetailsView showOrderSchemeWithScheme:schemeModel clickAction:^(DetailViewBackType style, PorscheSchemeModel *model) {
                [PorscheRequestManager saveWorkOrderScheme:schemeModel complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
                    if (status == 100) {
                        
                    }else {
                        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
                        
                    }
                }];
            }];
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
        }
    }];
}
/*
- (void)addNotifination {
    //从备件库工时库返回
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(materialBackToTechnianVC:) name:BACK_FROM_MATERIAL_AND_ITEM_TIME_NOTIFINATION object:nil];
    //点击在场车辆切换车辆信息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCarMessage:) name:BILLING_CAR_MESSAGE_NOTIFINATION object:nil];
}

- (void)showCarMessage:(NSNotification *)noti {
    self.saveStatus = @0;
    [self getOrderList];
}
*/
- (void)addLongPress {
    //长按移动分区
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(move:)];
    longPress.minimumPressDuration = 0.3;
    [_tableView addGestureRecognizer:longPress];
}

- (void)addEmptyView {
    if (self.dataArray.count == 0) {
        
        [self.view addSubview:self.emptyView];
        
    }else {
        [self.emptyView removeFromSuperview];
    }
}


- (void)setUpTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 49) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 分区区头
    [_tableView registerNib:[UINib nibWithNibName:@"HDWorkListTVHFViewNormal" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HDWorkListTVHFViewNormal"];
    
    //工时cell
    [_tableView registerNib:[UINib nibWithNibName:@"HDRIghtMaterialTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDRIghtMaterialTableViewCell"];
    //可修改配件cell
    [_tableView registerNib:[UINib nibWithNibName:@"HDRightMaterialTableViewCellOne" bundle:nil] forCellReuseIdentifier:@"HDRightMaterialTableViewCellOne"];
    //添加配件cell
    [_tableView registerNib:[UINib nibWithNibName:@"HDRightMaterialTableViewCellAdd" bundle:nil] forCellReuseIdentifier:@"HDRightMaterialTableViewCellAdd"];
    //添加新配件cell
    [_tableView registerNib:[UINib nibWithNibName:@"HDRightNewMaterialTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDRightNewMaterialTableViewCell"];
    //备注行cell
    [_tableView registerNib:[UINib nibWithNibName:@"HDRightMaterialRemarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDRightMaterialRemarkTableViewCell"];
    
    [self.containerView addSubview:self.tableView];

}
#pragma mark  备件库工时库  选择返回
- (void)materialBackToTechnianVC:(NSDictionary *)sender {//@{@"ids":list,@"type":@1}//返回数据
    //工时库 备件库返回
    if ([sender[@"type"] integerValue] != 3) {
        if ([sender[@"ids"] count] == 0) {
            return;
        }
        NSNumber *type = [sender[@"type"] integerValue] == 1 ? kMaterialType : kWorkType;
        PorscheNewScheme *scheme = self.dataArray[[self.currentIdx integerValue]];
        [self upDateProjectMaterialTestWithAddedType:kAddition schemeid:scheme.schemeid type:type source:kScheme stockid:sender[@"ids"]];
        //方案库返回
    }else {
        //[self addedFullSchemeCubSchemeWithidArray:dic[@"ids"]];
    }
}

#pragma mark  ------底部进入服务确认------


#pragma mark  判断 服务顾问是否有选择
- (BOOL)isStepToShowNext {
    NSString *string = nil;
    

    
    
//    if (self.bottomView.techicianTF.text.length == 0) {
//        string = @"未指定技师";
//    }
//
    if ([self isHasEmptyMaterialCub]) {
        string = @"备件信息不完整";
    }
    
    if (string) {
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:string height:60 center:self.tableView.center superView:self.view];
        return NO;
    }else {
        return YES;
    }
    
    
}
#pragma mark  备件库存/名称/编号/价格/数量判断
- (BOOL)isHasEmptyMaterialCub {
    NSArray *schemeArr = self.carMessage.solutionList;
    if (schemeArr.count) {
        for (PorscheNewScheme *scheme in schemeArr) {
            NSArray *schemewsArr = scheme.projectList;
            if (schemewsArr.count) {
                for (PorscheNewSchemews *schemews in schemewsArr) {
                    if ([schemews.schemesubtype isEqualToNumber:@2]) {//备件
                       //备件名称 编号 价格 数量
                        if ([schemews.iscancel integerValue] > 0)
                        {
                            if (schemews.schemewsname.length < 1 || schemews.schemewscode.length < 1 || [schemews.schemewscount isEqualToNumber:@0]) {
                                return YES;
                            }
                        }
                        
                        //库存
                        NSArray *schemewsCubArr = schemews.partsstocklist;
                        if (schemewsCubArr.count) {
                            for (ProscheMaterialLocationModel *location in schemewsCubArr) {
                                // 勾选中 ，库存为空 , 非长备件
                            
                                if ([schemews.iscancel integerValue] > 0 &&  location.pbstockname.length == 0 && [schemews.partsstocktype integerValue] == 0) {
                                    return YES;
                                }
                            }
                        }else {
                            if ([schemews.iscancel integerValue] > 0)
                            {
                                return YES;
                            }
                        }
                    }
                }
            }
        }
    }
    return NO;
}

- (void)sureTechicianAction {
    
    if (![self isStepToShowNext]) {
        return;
    }
    WeakObject(self);
    
   NSArray *titleArray =  @[@"进入服务流程",@"先让技师确认"];
    
    [HDServiceDealView showMakeSureViewAroundView:self.bottomView.techicianSurebt viewType:HDServiceDealViewToSeviceAndTech direction:UIPopoverArrowDirectionUp titleArr:titleArray first:^{
        
    } second:^{
        
        if (self.bottomView.serviceHelperTF.text.length == 0) {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定服务顾问" height:60 center:KEY_WINDOW.center superView:HD_FULLView];
            return ;
        }
        [selfWeak sureToServiceWithParam:@{@"ordergoto":@4}];
    } three:^{
        
        if (self.bottomView.techicianTF.text.length == 0) {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定技师" height:60 center:KEY_WINDOW.center superView:HD_FULLView];
            return ;
        }
        
        [selfWeak sureToServiceWithParam:@{@"ordergoto":@2}];
    }];
}

- (void)sureToServiceWithParam:(NSDictionary *)param {
    WeakObject(self);
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    [PorscheRequestManager orderSureToNextOrder:3 param:param buttonid:-1 Complete:^(NSInteger status,PResponseModel *responser) {
        [hud hideAnimated:YES];
        if (status == 100) {//开单成功
            //发信号进入技师增项
            //进入技师增项
//            [selfWeak hasNotPermission];
            
            selfWeak.carMessage.orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
            [HDLeftSingleton shareSingleton].carModel = selfWeak.carMessage;

            NSInteger number = [selfWeak.carMessage.orderstatus.skipstep integerValue];
            if (number > 0  && number != 3 && number < 6) {//跳转
                HDLeftStatusStyle style;
                if (number == 2 || number == 4) {
                    style =HDLeftStatusStyleSchemeLeft;
                }else {
                    style = HDLeftStatusStyleBilling;
                }
                [HDStatusChangeManager changeStatusLeft:style right:number - 1];
            }else {
                [selfWeak saveAction];
            }
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:HD_FULLView];
        }
    }];
}

//根据权限  停留或者跳转  本界面 刷新
- (void)hasNotPermission {
    [self sendNotifinationToLeftToReloadDataType:@1];

    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_Fuwugoutong]) {
        self.saveStatus = @1;
        [self.bottomView setSaveLbTittleAndImgBool:[_saveStatus boolValue]];
        [self reloadSelfView];
        return ;
    }else {
//        [HDLeftSingleton shareSingleton].maxStatus = 4;
    }
}

#pragma mark  底部保存-编辑
- (void)bottomSaveAction {
    WeakObject(self);
    
    BOOL isShowAlert = [[HDLeftSingleton shareSingleton] showStepAlertViewShowStatus:nil];
    if (isShowAlert) {
        return;
    }
    
    if ([selfWeak.bottomView.saveLb.text isEqualToString:@"保存"]) {
        [PorscheRequestManager sendMessageToEditWithStatus:NO complete:^(NSInteger status, PResponseModel * _Nullable responser) {
            if (status == 100) {
                 OrderOptStatusDto *orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
                if (![PorscheNewCarMessage isOnFactoryHintWithWostatus:orderstatus.wostatus])
                {
                    [HDStoreInfoManager shareManager].carorderid = nil;
                    selfWeak.carMessage = nil;
                    selfWeak.dataArray = nil;
                    [selfWeak reloadSelfView];
                    return;
                }
                
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"save_already_billing.png"] message:@"已保存" height:60 center:self.tableView.center superView:self.view];
                [selfWeak saveAction];
                [selfWeak getOrderList];
            }else {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:self.tableView.center superView:self.view];
            }
        }];
    }else {
        if ([HDPermissionManager isNotThisPermission:HDOrder_BeiJianQueRen_Edit]) {
            return;
        }
        [PorscheRequestManager sendMessageToEditWithStatus:YES complete:^(NSInteger status, PResponseModel * _Nullable responser) {
            OrderOptStatusDto *orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
            if (![PorscheNewCarMessage isOnFactoryHintWithWostatus:orderstatus.wostatus])
            {
                [HDStoreInfoManager shareManager].carorderid = nil;
                selfWeak.carMessage = nil;
                selfWeak.dataArray = nil;
                [selfWeak reloadSelfView];
                return;
            }
            [selfWeak actionWithStatus:status responser:responser];
            [selfWeak getOrderList];
        }];
    }
}

//可否编辑状态 问题
- (void)actionWithStatus:(NSInteger)status responser:(PResponseModel *)responser {
    if (status == 100) {
        self.carMessage.orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
        if ([self.carMessage.orderstatus.editable isEqual: @1]) {
            self.bottomView.carMessage.orderstatus = self.carMessage.orderstatus;

            [self editAction];
        }else {
            [self showAlertWithMessage:responser.msg];
        }
    }else {
        [self showAlertWithMessage:responser.msg];
    }
}

- (void)showAlertWithMessage:(NSString *)message  {
    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:message height:60 center:self.tableView.center superView:self.view];
}

- (void)saveAction {
    [self.bottomView setSaveLbTittleAndImgBool:YES];
    self.saveStatus = @1;
    [self.tableView reloadData];
    
}

- (void)editAction {
    [self.bottomView setSaveLbTittleAndImgBool:NO];
    self.saveStatus = @0;
    [self.tableView reloadData];
}


#pragma mark  底部视图加载和事件

- (void)setheaderViewAndBottomView {
    
    self.bottomView = [TeachicianAdditionItemBottomView getCustomFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49 - 64, CGRectGetWidth(self.view.frame), 49) style:BottomConstantSaveStylematerial];
    //
    [self.bottomView setSaveLbTittleAndImgBool:[_saveStatus integerValue]];

    WeakObject(self);
    self.bottomView.teachicianAdditionItemBottomViewBlock = ^(TeachicianAdditionItemBottomViewStyle style,UIButton *sender) {
        if (style == TeachicianAdditionItemBottomViewStyleSavebt) {
            //保存按钮
            [selfWeak bottomSaveAction];
        }
        else if (style == TeachicianAdditionItemBottomViewStyleTechicianHelperBt) {
                //选择技师
            [selfWeak bottomTechBtAction];
            
        }else if (style == TeachicianAdditionItemBottomViewStyleTechcianSureBt) {
            //备件确认
            [selfWeak sureTechicianAction];

        }else if (style == TeachicianAdditionItemBottomViewStyleServiceHelperBt) {
            //选择服务顾问
            [selfWeak showSelectStaffViewWithTF:selfWeak.bottomView.serviceHelperTF];
        }
    };
    [self.view addSubview:self.bottomView];

}

#pragma mark  选择技师
- (void)bottomServiceBtAction {
    [self showSelectStaffViewWithTF:self.bottomView.techicianTF];
}

#pragma mark  选择技师
- (void)bottomTechBtAction {
    [self showSelectTechStaffViewWithTF:self.bottomView.techicianTF];
}

- (void)showSelectTechStaffViewWithTF:(UITextField *)TF
{
    WeakObject(self);
    WeakObject(TF);
    // 获取组中员工数组
    [HDLeftSingleton shareSingleton].selectedPosid = @1;
    [PorscheRequestManager getStaffListTestWithGroupId:[HDStoreInfoManager shareManager].groupid positionId:[HDLeftSingleton shareSingleton].selectedPosid complete:^(NSMutableArray * _Nonnull classifyArray, PResponseModel * _Nonnull responser) {
        [selfWeak showChooseTechBottomNameWithTF:TFWeak infoArray:classifyArray];
    }];
    
    
}
- (void)showChooseTechBottomNameWithTF:(UITextField *)tf infoArray:(NSMutableArray *)infoArr {
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
        [selfWeak bottomSaveChooseTechWithdic:@{@"technicianid":staffid}];
        
    }];
}

#pragma mark  底部 人员
- (void)showSelectStaffViewWithTF:(UITextField *)TF
{
    WeakObject(self);
    WeakObject(TF);
    // 获取组中员工数组
    [HDLeftSingleton shareSingleton].selectedPosid = @3;

    [PorscheRequestManager getStaffListTestWithGroupId:[HDStoreInfoManager shareManager].groupid positionId:@3 complete:^(NSMutableArray * _Nonnull classifyArray, PResponseModel * _Nonnull responser) {
        [selfWeak showChooseBottomNameWithTF:TFWeak infoArray:classifyArray];
    }];
}
//组列表
- (void)getStaffGroupTest {
    if (![HDLeftSingleton shareSingleton].groupArray) {
        [HDLeftSingleton shareSingleton].groupArray = [NSMutableArray arrayWithArray:[[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataGroup]];
    }
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
        [selfWeak bottomSaveChooseTechWithdic:@{@"serviceadvisorid":staffid}];
        
    }];
}

- (void)bottomSaveChooseTechWithdic:(NSDictionary *)paramers {
    if ([HDStoreInfoManager shareManager].carorderid) {
        [PorscheRequestManager bottomSaveChooseTechWithdic:paramers complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
            
        }];
    }
}
#pragma mark  ------deleagte------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray.count) {
        PorscheNewScheme *cubScheme = self.dataArray[section];
        //判断方案是否显示下拉。默认显示
        if ([cubScheme.shadowStatus isEqualToNumber:@1]) {
            //保存状态下
            if ([_saveStatus integerValue] == 1) {
                return cubScheme.projectList.count + 1;
                //正常编辑状态下
            }else {
                //编辑备件的权限
                if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeMaterial]) {
                    return cubScheme.projectList.count + 1;
                }
                
                if ([cubScheme.wosisconfirm integerValue] == 2) {
                    return cubScheme.projectList.count + 1;
                }
                
                return cubScheme.projectList.count + 2;
                
            }
        }else {
            return 0;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PorscheNewScheme *cubScheme = self.dataArray[indexPath.section];
    if (cubScheme.projectList.count > indexPath.row) {
        PorscheNewSchemews *schemews = cubScheme.projectList[indexPath.row];

        if (schemews.partsstocklist.count == 0) {
            return 40;
        }
        
        if (schemews.partsstocklist.count > 4)
        {
            return 160;
        }
        return schemews.partsstocklist.count * 40;
        
    }
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat normal = 51;
    
    PorscheNewScheme *scheme = self.dataArray[section];
    
    //方案是否需要显示 增项头
    if ([scheme.isshow isEqualToNumber:@0]) {
        normal = 51;
        //工单被确认
    }else {
        normal = 71;
    }
    
    if (section == _tmpSection) {
        return self.imageView.frame.size.height + normal;
    }
    return normal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
   return [self getHeaderViewWithTableView:tableView section:section];
}

#pragma mark  ------项目区头------
- (UIView *)getHeaderViewWithTableView:(UITableView *)tableView section:(NSInteger)section {
    HDWorkListTVHFViewNormal *singleItemHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HDWorkListTVHFViewNormal"];
    
    if (!singleItemHeaderView) {
        singleItemHeaderView = [[HDWorkListTVHFViewNormal alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 51)];
    }
    
    PorscheNewScheme *cubScheme = self.dataArray[section];
    singleItemHeaderView.saveStatus = @1;
    singleItemHeaderView.tmpModel = cubScheme;
    
    if ([_saveStatus integerValue] == 1) {//控制长按显示详情
        singleItemHeaderView.isMaterial = NO;
    }else {
        singleItemHeaderView.isMaterial = YES;
    }
    WeakObject(self);
    //是否显示或者隐藏 所属分类的工时和备件
    singleItemHeaderView.shadowBlock = ^(UIButton *button,PorscheNewScheme *tmpModel) {
        [selfWeak setTableViewHeaderGiddenStatus:tmpModel];
    };
    
    singleItemHeaderView.deleteBt.hidden = YES;
    
    /*
    singleItemHeaderView.longPressBlock = ^() {
        [selfWeak showSchemeDetialWithScheme:cubScheme];
    };
    */
    
    return singleItemHeaderView;
}

#pragma mark  客户确认后，点击显示隐藏确认标签------
- (void)setupDataArrayWithTapHeaderScheme:(PorscheNewScheme *)scheme {
    
    for (PorscheNewScheme *model in self.dataArray) {
        if ([model.processflag integerValue] == [scheme.processflag integerValue]) {
            model.shadowStatus = scheme.shadowStatus;
        }
    }
}

//同一添加人或者客户确认项目 设置标签
- (void)setTableViewHeaderGiddenStatus:(PorscheNewScheme *)scheme {
    [self setupDataArrayWithTapHeaderScheme:scheme];
     [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

//项目从技师增项确定，工时最少一个，配件可以没有，工时相关数据在前边，配件在后面，最后一行是添加配件行，每个配件最多有四种库寸状态，自定义添加的配件可以修改编号和图号，方案库中项目配件只能修改图号，
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PorscheNewScheme *cubScheme = self.dataArray[indexPath.section];

#pragma mark  ------一般项目相关cell------
 if (cubScheme.projectList.count > indexPath.row) {
    
        PorscheNewSchemews *indexModel = [cubScheme.projectList objectAtIndex:indexPath.row];

            if ([indexModel.schemesubtype isEqualToNumber:@1]) {
            //工时cell
            UITableViewCell *cell = [self getitemTimeCellWith:tableView indexPath:indexPath model:indexModel];
            return cell;
        }else {
            //新增配件行
            if ([indexModel.schemewstype integerValue] != 1) {
                
                if ([HDLeftSingleton isUserAdded:indexModel.projectaddid]) {// 备件自己加的
                    UITableViewCell *cell = [self getAddMaterialCellWith:tableView indexPath:indexPath];
//                    UITableViewCell *cell = [self getMaterialCellWith:tableView indexPath:indexPath model:indexModel];
                    return cell;
                }
                /*else {
                    //一般配件行
                    UITableViewCell *cell = [self getMaterialCellWith:tableView indexPath:indexPath model:indexModel];
                    return cell;
                }
            */
            }
            /*else {*/
                //一般配件行
                UITableViewCell *cell = [self getMaterialCellWith:tableView indexPath:indexPath model:indexModel];
                return cell;
//            }
            
        }
     
    }else if (cubScheme.projectList.count == indexPath.row) {
        
        if ([_saveStatus integerValue] == 1) {
            //备注行
            UITableViewCell *cell = [self getRemarkCellWith:tableView indexPath:indexPath];
            return cell;
        }else {
            //编辑备件的权限
            if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeMaterial]) {
                //备注行
                UITableViewCell *cell = [self getRemarkCellWith:tableView indexPath:indexPath];
                return cell;
            }
            if ([cubScheme.wosisconfirm integerValue] == 2) {
                //备注行
                UITableViewCell *cell = [self getRemarkCellWith:tableView indexPath:indexPath];
                return cell;
            }
            //添加配件行
            UITableViewCell *cell = [self getAddMaterialCellWith:tableView indexPath:indexPath];
            return cell;
        }

        
    }else if (cubScheme.projectList.count < indexPath.row) {
        //备注行cell
        UITableViewCell *cell = [self getRemarkCellWith:tableView indexPath:indexPath];
        return cell;
    }
    return nil;
}

#pragma mark  ------工时行cell------
- (UITableViewCell *)getitemTimeCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(PorscheNewSchemews *)model{
    HDRIghtMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDRIghtMaterialTableViewCell" forIndexPath:indexPath];
    //给配件赋值 所属方案的自费状态，内结或者保修
    PorscheNewScheme *cubScheme = self.dataArray[indexPath.section];
    model.superschemesettlementway = cubScheme.wossettlement;
    
    cell.saveStatus = _saveStatus;
    if ([cubScheme.wosisconfirm integerValue] == 2) {
        cell.saveStatus = @1;
    }
    cell.tmpModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell layoutIfNeeded];
    WeakObject(self);
    cell.chooseBlock = ^(PorscheNewSchemews *schemews,UIView *view){
        [selfWeak chooseActionWithSchemws:schemews scheme:cubScheme view:view type:@1];
    };
    
    return cell;
}

#pragma mark  ------配件行cell------
- (UITableViewCell *)getMaterialCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(PorscheNewSchemews *)model {
    //配件cell
    HDRightMaterialTableViewCellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"HDRightMaterialTableViewCellOne" forIndexPath:indexPath];
    WeakObject(cell);
    WeakObject(self);
    //给配件赋值 所属方案的自费状态，内结或者保修
    PorscheNewScheme *cubScheme = self.dataArray[indexPath.section];
    model.superschemesettlementway = cubScheme.wossettlement;
    cell.saveStatus = _saveStatus;
    //编辑备件权限
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeMaterial]) {
        cell.saveStatus = @1;
    }

    if ([cubScheme.wosisconfirm integerValue] == 2) {
        cell.saveStatus = @1;
    }
    cell.tmpModel = model;
    //添加库存
    cell.addedCubBlock = ^(BOOL isdelete,PorscheNewSchemews *schemews,NSNumber *psbid) {
        NSNumber *needid = schemews.schemewsid;
        if (isdelete) {
            needid = psbid;
        }
        [selfWeak addMaterialCubDataWithId:needid isDelete:isdelete];
    };
    //库存数量编辑
    cell.editMaterialCubBlock = ^(NSDictionary *dic) {
        [selfWeak editCubWithDic:dic];
    };
    cell.hDRightMaterialTableViewCellOneStyleBlock = ^(HDRightMaterialTableViewCellOneStyle style,UIButton *sender,NSString *str) {
        
        if (style == HDRightMaterialTableViewCellOneStyleDown) {
            //选择库存及数量
            WeakObject(sender)
            [selfWeak cubViewActionWithView:senderWeak cell:cellWeak model:model];
        }else if (style == HDRightMaterialTableViewCellOneStylePriceTF) {
            //价格试用全店
            
//            [selfWeak priceUseForAllShopWithModel:model cell:cellWeak tableView:tableView text:str];
        }else if (style == HDRightMaterialTableViewCellOneStyleOtherTF) {
            
        }
    };
    
    
    //备件勾选
    cell.confirmActionBlock = ^(UIButton *button){
        [selfWeak chooseActionWithSchemws:model scheme:cubScheme view:button type:@2];//type 备件
    };
    //备件
    cell.addedReturnBlock = ^(PorscheNewSchemews *schemews) {
        [selfWeak editWorkHourOrMaretialWithSchemews:schemews type:kMaterialType];
    };
    //编辑工时显示弹窗
    cell.editMaterialAllBlock = ^(PorscheNewSchemews *schemews) {
        [HDSchemewsView showHDSchemewsStyle:HDSchemewsViewStyleMaterial model:schemews withSupperVC:selfWeak needMatch:NO addedBlock:^(HDSchemewsViewBlockStyle style) {
            if (style == HDSchemewsViewBlockStyleRefresh) {
                [selfWeak getOrderList];
            }
        }];
    };
    [cell layoutIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark  备件库位选择------
- (void)cubViewActionWithView:(UIButton *)button cell:(UITableViewCell *)cell model:(PorscheNewSchemews *)schemews{
    NSMutableArray *titArray = [NSMutableArray array];
    for (PorscheConstantModel *tmp in self.customDataArray) {
        [titArray addObject:tmp];
    }
    if ([schemews.partsstocktype integerValue] == 1) {
        PorscheConstantModel *data = [[PorscheConstantModel alloc] init];
        data.cvvaluedesc = @"常备件";
        data.cvsubid = @5;
        [titArray addObject:data];
    }
    
    WeakObject(self);
    [PorscheMultipleListhView showSingleListViewFrom:button dataSource:titArray selected:nil showArrow:NO direction:ListViewDirectionDown complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
        
        [selfWeak selectedCubWithSchemews:schemews idx:idx view:button withCustomArray:titArray];

    }];
    
}

- (void)selectedCubWithSchemews:(PorscheNewSchemews *)schemews idx:(NSInteger)idx view:(UIView *)view withCustomArray:(NSArray *)customArray {
    
//    WeakObject(self)
    ProscheMaterialLocationModel *psbModel;
    if (schemews.partsstocklist.count) {
        psbModel = schemews.partsstocklist[view.tag];
    }
    
    PorscheConstantModel *tmp = customArray[idx];
    
    BOOL isContain = NO;
    BOOL isShow = NO;
    for (ProscheMaterialLocationModel *tmpLo in schemews.partsstocklist) {
        if ([tmp.cvsubid isEqual:tmpLo.pbstockid]) {
            isContain = YES;
            isShow = YES;
        }
    }
    
    if ([psbModel.pbstockid isEqual:tmp.cvsubid]) {//对比 是否和当前选择的库存类型 相同
        isShow = NO;
    }
    
    if (isContain) {
        //提示
        if (isShow) {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"该库存类型已存在" height:60 center:KEY_WINDOW.center superView:HD_FULLView];
        }
    }else {
        //请求
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param hs_setSafeValue:tmp.cvsubid forKey:@"type"];
        // 约定,当列表没有数据的时候,是常备件,更改成其他的库存的时候按照原来的方式,库存 id 传0.当列表没有数据,也不是常备件,也传0当时常备件的其他判断界面不显示,相当于变相的添加操作    (后来对数据进行了改造,常备件的时候添加了一条数据,在第一位)
        [param hs_setSafeValue:psbModel.pbsid forKey:@"stockid"];
        [param hs_setSafeValue:@0 forKey:@"amount"];
        [param hs_setSafeValue:schemews.schemewsid forKey:@"partid"];
        if ([schemews.partsstocktype integerValue] == 1 && [psbModel.pbstockid integerValue] == 5) {
            [HDPoperDeleteView showAlertViewAroundView:view titleArr:@[@"是否修改常备件属性",@"临时修改",@"永久修改"] direction:UIPopoverArrowDirectionRight sure:^{
                [param hs_setSafeValue:@1 forKey:@"modifyType"];
                [self editCubWithDic:param];
            } refuse:^{
            } cancel:^{
                [param hs_setSafeValue:@2 forKey:@"modifyType"];
                [self editCubWithDic:param];
            }];
        }else {
            [param hs_setSafeValue:@0 forKey:@"modifyType"];
            [self editCubWithDic:param];
        }
        
        
//        NSDictionary *dic = @{@"type":tmp.stockid,@"stockid":psbModel.pbsid,@"amount":@0};
        
    }
}

- (void)editCubWithPbsModel:(ProscheMaterialLocationModel *)pbsmodel {
    NSDictionary *dic = @{@"type":pbsmodel.pbstockid,@"stockid":pbsmodel.pbsid,@"amount":pbsmodel.pbsamount};
    [self editCubWithDic:dic];
}
#pragma mark  ------价格试用全店------

- (void)priceUseForAllShopWithModel:(PorscheNewSchemews *)model cell:(HDRightMaterialTableViewCellOne *)cell tableView:(UITableView *)tableView text:(NSString *)text {
//    WeakObject(self);
    [HD_FULLView endEditing:YES]; //关闭键盘
//    WeakObject(cell);
    [self editWorkHourOrMaretialWithSchemews:model type:kMaterialType];
/*
   self.pop = [HDPoperDeleteView showAlertViewAroundView:cell.materialPriceTF titleArr:@[@"此价格适用于全店?",@"确定",@"取消"] direction:UIPopoverArrowDirectionAny sure:^{
        
    } refuse:^{
        
    } cancel:^{
        
    }];
    
    _pop.delegate = self;
 */
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    /*
    if ([popoverController isEqual:_pop]) {
       
        [self.tableView reloadData];
    }
    */
    return YES;
}

#pragma mark  ------添加配件行cell------
- (UITableViewCell *)getAddMaterialCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    HDRightNewMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDRightNewMaterialTableViewCell" forIndexPath:indexPath];
    cell.headerImageView.image = [UIImage imageNamed:@"hd_custom_item_time_material.png"];
    [cell layoutIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PorscheNewScheme *cubscheme = self.dataArray[indexPath.section];
    //默认设置
    cell.saveStatus = _saveStatus;
    
    //编辑备件权限
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeMaterial]) {
        cell.saveStatus = @1;
    }

    if ([cubscheme.wosisconfirm integerValue] == 2) {
        cell.saveStatus = @1;
    }
    PorscheNewSchemews *model;
    //添加配件行的choose相关也要hidden
    if (indexPath.row >= cubscheme.projectList.count) {
        model = nil;
        cell.tmpModel = model;
        
    }else {
        model = [cubscheme.projectList objectAtIndex:indexPath.row];
        model.superschemesettlementway = cubscheme.wossettlement;
        cell.tmpModel  = model;
    }
    
    WeakObject(self);
    WeakObject(cell);
    //刷新数据，添加库存
    cell.addedCubBlock = ^(BOOL isdelete,PorscheNewSchemews *schemews,NSNumber *psbid) {
        NSNumber *needid = schemews.schemewsid;
        if (isdelete) {
            needid = psbid;
        }
        [selfWeak addMaterialCubDataWithId:needid isDelete:isdelete];
        
        
    };
    //添加行完成键  事件 编辑备件
    cell.addedReturnBlock = ^(PorscheNewSchemews *schemews) {
        if (!model) {//添加行
            schemews.wospwosid = cubscheme.schemeid;
        }
        [selfWeak editWorkHourOrMaretialWithSchemews:schemews type:kMaterialType];
    };
    //修改库位数量
    cell.editCubCount = ^(ProscheMaterialLocationModel *pbsModel) {
        [selfWeak editCubWithPbsModel:pbsModel];
    };
    
    cell.hDRightNewMaterialTableViewCellBlock = ^(HDRightNewMaterialTableViewCellStyle style,UIButton *sender) {
        
        //添加备件
        if (style == HDRightNewMaterialTableViewCellStyleAdd) {
            
            [selfWeak upDateProjectMaterialTestWithAddedType:kAddition schemeid:cubscheme.schemeid type:kMaterialType source:kCustomScheme stockid:nil];

            //选择按钮
        }else if (style == HDRightNewMaterialTableViewCellStyleChoose) {
            
            //是新增加的配件行可以删除
            if (indexPath.row < cubscheme.projectList.count) {
                
                [HDPoperDeleteView showAlertViewAroundView:sender titleArr:@[@"确定删除",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
                    [selfWeak upDateProjectMaterialTestWithAddedType:kDeletion schemeid:cubscheme.schemeid type:kMaterialType source:kCustomScheme stockid:@[model.schemewsid]];
                    
                } refuse:^{
                    
                } cancel:^{
                    
                }];
            }
            //选择输入框
        }else if (style == HDRightNewMaterialTableViewCellStyleTF) {
            if ([HDPermissionManager isNotThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeMaterial]) {
                return ;
            }
#pragma mark  备件弹窗
            NSIndexPath *indexPath = [tableView indexPathForCell:cellWeak];
            selfWeak.currentIdx = @(indexPath.section);
            PorscheNewScheme *scheme = selfWeak.dataArray[indexPath.section];
            PorscheNewSchemews *schemews;
            BOOL needMatch = YES;
            if (scheme.projectList.count) {//
                if (indexPath.row > scheme.projectList.count - 1) {
                    schemews = [PorscheNewSchemews new];
                    
                    schemews.schemewsid = @0;
                }else {
                    schemews = scheme.projectList[indexPath.row];
                    needMatch = NO;
                }
            }else {
                schemews = [PorscheNewSchemews new];
                schemews.schemewsid = @0;
            }
            schemews.wospwosid = scheme.schemeid;
            
            [HDSchemewsView showHDSchemewsStyle:HDSchemewsViewStyleMaterial model:schemews withSupperVC:selfWeak needMatch:needMatch addedBlock:^(HDSchemewsViewBlockStyle style) {
                if (style == HDSchemewsViewBlockStyleRefresh) {
                    [selfWeak getWorkOrderListTest];
                }
            }];
        }else if (style == HDRightNewMaterialTableViewCellStyleNormalTF) {
            //添加删除/库位
        }else if (style == HDRightNewMaterialTableViewCellStyleAddCub) {
            
            NSIndexPath *idx = [tableView indexPathForCell:cellWeak];
            PorscheNewSchemews *model = [cubscheme.projectList objectAtIndex:idx.row];
            WeakObject(sender)
            [selfWeak cubViewActionWithView:senderWeak cell:cellWeak model:model];

        }else if (style == HDRightNewMaterialTableViewCellStyleReturn) {
        }
    };

    return cell;
}


#pragma mark  钩的点击事件------
//权限相关：如果可以编辑 就可以打钩操作
- (void)chooseActionWithSchemws:(id)model scheme:(PorscheNewScheme *)schemeModel view:(UIView *)aroundView type:(NSNumber *)type {
    WeakObject(self);
    if ([model isKindOfClass:[PorscheNewSchemews class]]) {
        PorscheNewSchemews *schemews = model;
        if ([schemews.iscancel isEqualToNumber:@0]) {//未勾选
            [self chooseBtWithid:schemews.schemewsid type:type isChoose:@1];;
            
        }else {
            
            [HDPoperDeleteView showAlertViewAroundView:aroundView titleArr:@[@"确定取消",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
                if ([selfWeak isLastSchemewsHasChoosenWithScheme:schemeModel]) {
                    [selfWeak chooseBtWithid:schemeModel.schemeid type:@3 isChoose:@0];
                    
                }else {
                    [selfWeak chooseBtWithid:schemews.schemewsid type:type isChoose:@0];
                }

            } refuse:^{
                
            } cancel:^{
                
            }];
        }
    }else {
        PorscheNewScheme *scheme = model;
        if ([scheme.wosisconfirm isEqualToNumber:@0]) {//未勾选
            [self chooseBtWithid:scheme.schemeid type:type isChoose:@1];;
            
        }else {
            
            [HDPoperDeleteView showAlertViewAroundView:aroundView titleArr:@[@"确定取消",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
                [selfWeak chooseBtWithid:scheme.schemeid type:type isChoose:@0];
                
            } refuse:^{
                
            } cancel:^{
                
            }];
        }
    }
    
    
}

- (void)chooseBtWithid:(NSNumber *)projectid type:(NSNumber *)type isChoose:(NSNumber *)value {
    WeakObject(self);
    [PorscheRequestManager chooseBtWithid:projectid type:type isChoose:value success:^{
        [selfWeak getWorkOrderListTest];
        
    } fail:^{
        
    }];
    
}
- (BOOL)isLastSchemewsHasChoosenWithScheme:(PorscheNewScheme *)scheme {
    NSInteger integer = 0;
    if (scheme.projectList.count) {
        for (PorscheNewSchemews *schemews in scheme.projectList) {
            if (![schemews.iscancel isEqual:@0]) {
                integer ++;
            }
        }
        if (integer == 1) {
            return YES;
        }else {
            return NO;
        }
    }
    return NO;
}

#pragma mark  ------备注行cell------
- (UITableViewCell *)getRemarkCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    HDRightMaterialRemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDRightMaterialRemarkTableViewCell" forIndexPath:indexPath];
    PorscheNewScheme *cubScheme = self.dataArray[indexPath.section];
    
    cell.remarkLb.text = cubScheme.wosremark;
    [cell setImageRemarkNumber:cubScheme.statememo];
    
    cell.saveStatus = _saveStatus;
    //编辑备件的权限
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeMaterial]) {
        //备注行
        cell.saveStatus = @1;
    }
    
    if ([cubScheme.wosisconfirm integerValue] == 2) {
        cell.saveStatus = @1;
    }
    WeakObject(self);
    
    cell.hDRightMaterialRemarkTableViewCellBlock = ^(HDRightMaterialRemarkTableViewCellStyle style, UIButton *button){
        if (style == HDRightMaterialRemarkTableViewCellStyleCamera) {
            selfWeak.modelController.shootType = PorschePhotoCarImage;
            selfWeak.modelController.fileType = PorschePhotoGalleryFileTypeImage;
            selfWeak.modelController.keyType = PorschePhotoGalleryKeyTypeScheme;
            selfWeak.modelController.relativeid = cubScheme.schemeid;
            [selfWeak.modelController cycleTakePhoto:nil video:nil];
        }else if (style == HDRightMaterialRemarkTableViewCellStylePhoto) {
            [PorschePhotoModelController getPhotoListCompletion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
                if (responser.status == 100)
                {
                    PorscheGalleryModel *model = [PorscheGalleryModel yy_modelWithDictionary:responser.object];
                    model.currentSchemeid = cubScheme.schemeid;
                    [selfWeak.modelController showPhotoGalleryWithModel:model viewType:PorschePhotoGalleryPreviewAndShoot];
                }
            }];
        }
        
    };
    
    [cell layoutIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


//更新顶部  总价的值
- (void)setSelectCountLabelContent
{
    PorscheNewCarMessage *newCarMessage;
    if (self.carMessage) {
        newCarMessage = self.carMessage;
    }else {
        newCarMessage = [PorscheNewCarMessage new];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:TECHICIANADDITION_SELECTED_NOTIFINATION object:@{@"carmessage":newCarMessage}];
    [[HDLeftSingleton shareSingleton] reloadRightViewVCHeaderContent:@{@"carmessage":newCarMessage}];

}

/****
 *  type:1. 刷新网络数据 2.刷新tableView
 ****/
- (void)sendNotifinationToLeftToReloadDataType:(NSNumber *)type {
    [[HDLeftSingleton shareSingleton] reloadLeftBillingList:type];
}
- (void)setSaveStatus:(NSNumber *)saveStatus {
    _saveStatus = saveStatus;
    [HDLeftSingleton shareSingleton].saveStatus = saveStatus;
    [[HDLeftSingleton shareSingleton].HDRightViewController setheaderUserEnabled:@{@"issave":saveStatus}];
}

#pragma mark  ------lazy------
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableArray *)customDataArray {
    if (!_customDataArray) {
        _customDataArray = [NSMutableArray array];
    }
    return _customDataArray;
}

//空白占位图
- (UIButton *)emptyView {
    if (!_emptyView) {
        _emptyView = [UIButton buttonWithType:UIButtonTypeCustom];
        _emptyView.frame = self.tableView.frame;
        [_emptyView setTitle:@"暂无信息" forState:UIControlStateNormal];
        [_emptyView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _emptyView.titleLabel.font =  [UIFont systemFontOfSize:26 weight:UIFontWeightThin];
    }
    return _emptyView;
}

#pragma mark  ------移动项目相关------
- (void)move:(UILongPressGestureRecognizer *)sender {
    //获取坐标点
    CGPoint point =[sender locationInView:self.tableView];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        //获取坐标点在tableView上的位置
        _pointIndexpath = [_tableView indexPathForRowAtPoint:point];
        
        
        
        if (!_pointIndexpath) {
            CGPoint point1 = point;
            point1.y += 51;
            _pointIndexpath = [_tableView indexPathForRowAtPoint:point1];
            if (!_pointIndexpath) {
                return;
            }
        }
        
        //通过indexPath 借助数据数组，获取当前分区的所有cell和headerView
        
        __weak typeof(self) selfWeak = self;
        
        
        self.imageView = [self creatTotalViewWith:_pointIndexpath.section];
//        NSLog(@"_fromeIndexPath.section.section %d",_pointIndexpath.section);
        //更改imageView的中心点为手指点击位置
        __block CGPoint center = self.imageView.center;
        
        //获取点击位置model
        _itemModel = self.dataArray[_pointIndexpath.section];
        //删除model，
        [self.dataArray removeObject:_itemModel];
        // 删除分区的效果
        [selfWeak.tableView deleteSections:[NSIndexSet indexSetWithIndex:_pointIndexpath.section] withRowAnimation:UITableViewRowAnimationFade];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [selfWeak.tableView reloadData];
        });
        
        [UIView animateWithDuration:0.25 animations:^{
            center.y = point.y;
            center.x = self.view.frame.size.width /2;
            selfWeak.imageView.center = center;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        if (point.y < 50) {
            UITableViewCell *cell = [self.tableView.visibleCells firstObject];
            NSIndexPath *firstIndexPath = [self.tableView indexPathForCell:cell];
            NSLog(@"firstCellSection~~~~~~~~~~~%ld",(long)firstIndexPath.section);
            if (firstIndexPath.section > 0) {
                NSLog(@"下移~~~~~~~~~~~");
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:firstIndexPath.section - 1] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }
        }
        
        if (point.y > self.tableView.bounds.size.height - 50) {
            UITableViewCell *cell = [self.tableView.visibleCells lastObject];
            NSIndexPath *firstIndexPath = [self.tableView indexPathForCell:cell];
            NSLog(@"lastCellSection~~~~~~~~~~~%ld",(long)firstIndexPath.section);
            
            if (firstIndexPath.section < self.dataArray.count - 1) {
                NSLog(@"上移~~~~~~~~~~~");
                PorscheNewScheme *model = self.dataArray[firstIndexPath.section + 1];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:model.projectList.count + 1 inSection:firstIndexPath.section + 1] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }
        }
        
        //移动中的位置
        _endPointIndexPath = [_tableView indexPathForRowAtPoint:point];
        
        //更改imageView的中心点为手指点击位置
        CGPoint center = self.imageView.center;
        center.y = point.y;
        self.imageView.center = center;
        if (_endPointIndexPath) {
            _tmpSection = _endPointIndexPath.section;
            if (_oldSection != _tmpSection) {
                _oldSection = _tmpSection;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:_tmpSection] withRowAnimation:UITableViewRowAnimationFade];
                
            }
        }
        NSLog(@"point.y:%f  heeight/2:%f",point.y,self.imageView.frame.size.height / 2);
#pragma mark  ------移动中的位置，做定时滑动，触发定时器------
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        _tmpSection = -1;
        
        if (!_endPointIndexPath) {
            CGPoint point1 = point;
            point1.y += 51 + self.imageView.frame.size.height;
            //移动中的位置
            _endPointIndexPath = [_tableView indexPathForRowAtPoint:point1];
            if (!_endPointIndexPath) {
                
                [self.dataArray addObject:_itemModel];
                [self.tableView reloadData];
                
                [self.imageView removeFromSuperview];
                
                
                
                return;
            }
        }
        
        /*
         若当前手指所在indexPath不是要移动cell的indexPath，
         且是插入模式，则执行cell的插入操作
         每次移动手指都要执行该判断，实时插入
         */
        
        
        NSLog(@"_endPointIndexPath:%ld",(long)_endPointIndexPath.section);
        
        [self.dataArray insertObject:_itemModel atIndex:_endPointIndexPath.section];
//        
//        [self saveItemDataSource];

        [self.tableView reloadData];
        
        [self.imageView removeFromSuperview];
        
    }
}

//生成分区图片
- (UIImageView *)creatTotalViewWith:(NSInteger )section {
    
    UIView *headerView = [_tableView headerViewForSection:section];
    
    NSMutableArray *cellImageArray = [NSMutableArray array];
    
    PorscheNewScheme *cubScheme = self.dataArray[section];
    
    UIImage *headerViewImage = [self createCellImageView:headerView];
    
    CGFloat height = headerViewImage.size.height;
    
    for (int i = 0; i <= cubScheme.projectList.count + 1; i ++) {
        UIView *cellView = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
        UIImage *image = [self createCellImageView:cellView];
        
        if (image) {
            height += image.size.height;
            [cellImageArray addObject:image];
            
        }
    }
    
    CGSize size = CGSizeMake(headerViewImage.size.width, height);
    
    UIGraphicsBeginImageContext(size);
    
    [headerViewImage drawInRect:CGRectMake(0, 0, headerViewImage.size.width, headerViewImage.size.height)];
    
    CGFloat heightone = headerViewImage.size.height;
    
    for (UIImage *image in cellImageArray) {
        
        [image drawInRect:CGRectMake(0, heightone, image.size.width, image.size.height)];
        heightone += image.size.height;
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    imageView.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    
    imageView.layer.shadowRadius = 5.0;
    
    imageView.alpha = 1;
    
    imageView.center =  [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].center;
    
    [self.tableView addSubview:imageView];
    
    return imageView;
}

- (UIImage *)createCellImageView:(UIView *)cell {
    //打开图形上下文，并将cell的根层渲染到上下文中，生成图片
    
    //    UIGraphicsBeginImageContext(cell.bounds.size);
    
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, [UIScreen mainScreen].scale);
    
    
    
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
