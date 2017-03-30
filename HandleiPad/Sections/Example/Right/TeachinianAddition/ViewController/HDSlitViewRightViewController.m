//
//  HDSlitViewRightViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/8/30.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDSlitViewRightViewController.h"
#import "HDWorkListTVHFView.h"
#import "HDWorkListRightTableViewCell.h"
#import "CustomBarItemView.h"
#import "HDWorkListHeaderView.h"
#import "HDWorkListRightTableViewCellOne.h"
#import "HDWorkListRightTableViewCellTwo.h"
#import "AlertViewHelpers.h"

#import "HDWorkListTVHFViewNormal.h"
#import "KandanRightViewController.h"
#import "TeachicianAdditionItemBottomView.h"
#import "TeachnicianAdditionItemHeaderView.h"
#import "HDTechcianSingleItemTableViewCell.h"
#import "HDWorkListTVHFViewOne.h"
#import "HDWorkListTVHFViewOneNormal.h"
//弹出选择列表
#import "HDWorkListNextView.h"
//数据单例
#import "HDLeftSingleton.h"
//图号编号辅助视图
#import "TechcianNumberTFInputView.h"
//工时辅助视图
#import "TechcianItemTimeTFInputView.h"
//相机+视频
#import "ZLCameraViewController.h"

//删除弹窗
#import "HDPoperDeleteView.h"
//保存弹窗
#import "HDNewSaveView.h"
// 备注行cell
#import "HDTechicianRemarkTableViewCell.h"

//相册库
#import "PorschePhotoGallery.h"
//修改适用范围弹窗
#import "HDProjectChangeRangeView.h"
//选择技师弹窗
#import "HDSelectStaffView.h"
//
#import "HDLeftCustomItemView.h"
//
#import "MaterialTaskTimeDetailsView.h"

#import "PorschePhotoModelController.h"
#import "HDServiceDealView.h"
typedef enum {
    AutoScrollUp,
    AutoScrollDown
} AutoScroll;



@interface HDSlitViewRightViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,HDWorkListTVHFViewOneNormalDelegate,HDWorkListTVHFViewNormalDelegate,UIPopoverControllerDelegate>

//保修弹窗
@property (nonatomic, strong) HDPoperDeleteView *guaranteeView;
//工单model
@property (nonatomic, strong) PorscheNewCarMessage *carMessage;

//滑动
@property (strong, nonatomic) UIView *containerView;

//底层滑动视图
@property (strong, nonatomic)  UIScrollView *baseView;

//界面View
@property (strong, nonatomic) UITableView *tableView;

//底部栏
@property (nonatomic, strong) TeachicianAdditionItemBottomView *bottomView;

//数据源数组
@property (nonatomic, strong) NSMutableArray *dataArray;
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

//自定义添加的项目，区头分类标志，图片数组
@property (nonatomic, strong) NSArray *customImgArray;


//空白占位图
@property (nonatomic, strong) UIButton *emptyView;

//定位 点击工时库的位置
@property (nonatomic, strong) NSNumber *currentIdx;

//相机model数组
@property (nonatomic, strong) NSMutableArray *cameraDataSource;

//保存参数0.不保存，1.保存
@property (nonatomic, strong) NSNumber *saveStatus;
// 媒体处理类
@property (nonatomic, strong) PorschePhotoModelController *modelController;
@end

@implementation HDSlitViewRightViewController

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"HDSlitViewRightViewController-dealloc");
}

- (void)viewDidLayoutSubviews {
    
    
    self.baseView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64 - 49);
    self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.baseView.frame));
    
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.baseView.frame));

    _baseView.contentSize = CGSizeMake(CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 49 - 64, CGRectGetWidth(self.baseView.frame), 49);
    
    self.emptyView.frame = self.containerView.frame;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [HDLeftSingleton shareSingleton].isTechicianAdditionVC = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [HDLeftSingleton shareSingleton].isTechicianAdditionVC = NO;
    if ([self.bottomView.saveLb.text isEqualToString:@"保存"]) {
        [PorscheRequestManager sendMessageToEditWithStatus:NO complete:^(NSInteger status, PResponseModel * _Nullable responser) {
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _tmpSection = -1;
    _oldSection = -2;
    self.saveStatus = @1;
    
    [HDLeftSingleton shareSingleton].stepStatus = 2;
    
//    [self setupSaveSattus];

    [self setupBaseScrollView];
    
    [self setupBottomView];

    [self setupTableView];
    
    [self configNavitem];
    
//    [self addLongPress];
    
    [self addemptyView];
    
//    [self addNotifinationForCub];
    
    [self getOrderList];

}

- (void)getOrderList {
    
//    if ([HDLeftSingleton shareSingleton].maxStatus >= [HDLeftSingleton shareSingleton].stepStatus) {
        [self getWorkOrderListTestNeedSendNoti:YES schemeType:kAllScheme];
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
    [self afterConfirmIncrease];
    [self addemptyView];
    [self setupBottomViewStaff];
    [self setSelectCountLabelContent];
    [self.tableView reloadData];
}

//获取确认后增项
- (void)afterConfirmIncrease {
    if ([self.carMessage.wostatus isEqual:@7]) {//客户已确认
        if([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_JiShiZengXiang_AfterConfirmAdded]){
            self.saveStatus = @1;
        }
    }
}


/*
- (void)setupSaveSattus {
    if ([HDLeftSingleton shareSingleton].maxStatus != [HDLeftSingleton shareSingleton].stepStatus) {
        self.saveStatus = @1;
    }
    
    if ([self.carMessage.wostatus isEqual:@7]) {
        if([HDPermissionManager isNotThisPermission:HDOrder_JiShiZengXiang_AfterConfirmAdded]){
            self.saveStatus = @1;
        }
    }

    //预计交车隐藏状态
    [[NSNotificationCenter defaultCenter] postNotificationName:RIGHT_SAVE_LIST_NOTIFINATION object:@{@"issave":_saveStatus}];

//    if ([HDLeftSingleton shareSingleton].maxStatus == 2) {
//        _saveStatus = @0;
//    }
}
*/
- (void)setSaveStatus:(NSNumber *)saveStatus {
    _saveStatus = saveStatus;
    [HDLeftSingleton shareSingleton].saveStatus = saveStatus;
    [[HDLeftSingleton shareSingleton].HDRightViewController setheaderUserEnabled:@{@"issave":saveStatus}];
}


#pragma mark  技师增项 接口测试 未通


#pragma mark  技师增项 接口测试 已通

//编辑工时/备件
- (void)editWorkHourOrMaretialWithSchemews:(PorscheNewSchemews *)schemews type:(NSNumber *)type{
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    WeakObject(self);
    [PorscheRequestManager editProjectWorkHourOrMaterial:schemews type:type complete:^(NSInteger status, PResponseModel * _Nonnull model) {
        [hud hideAnimated:YES];
        if (status == 100) {
            NSLog(@"方案工时修改成功！");
            [selfWeak getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
        }else {
            NSLog(@"方案工时修改失败！");
            [selfWeak failToEditWithModel:model];

        }
    }];
}

//修改方案备注
- (void)editSchemeRemarkWithScheme:(PorscheNewScheme *)scheme {
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    WeakObject(self);
    [PorscheRequestManager editProjectRemark:scheme complete:^(NSInteger status, PResponseModel * _Nonnull model) {
        [hud hideAnimated:YES];
        if (status == 100) {
            NSLog(@"方案备注修改成功！");
            [selfWeak getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
        }else {
            NSLog(@"方案备注修改失败！");
            [selfWeak failToEditWithModel:model];
        }
    }];
}

//修改自定义项目名称
- (void)editCustomProjectnameScheme:(PorscheNewScheme *)scheme {
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    WeakObject(self);
    [PorscheRequestManager editCustomProjectName:scheme complete:^(NSInteger status, PResponseModel * _Nonnull model) {
        [hud hideAnimated:YES];
        if (status == 100) {
            NSLog(@"自定义项目名称修改成功！");
            [selfWeak getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
        }else {
            NSLog(@"自定义项目名称修改失败！");
            [selfWeak failToEditWithModel:model];
        }
    }];
}
//添加全屏方案库方案
- (void)addedFullSchemeCubSchemeWithidArray:(NSArray *)idArray {
    if (idArray.count == 0) {
        return;
    }
    WeakObject(self);

    NSMutableArray *schemes = [NSMutableArray array];
    for (PorscheSchemeModel *scheme in idArray) {
        
        [schemes addObject:@{@"schemeid":scheme.orderschemeid, @"schemtype": scheme.schemetype,@"schemestockid":scheme.schemeid}];
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param hs_setSafeValue:schemes forKey:@"stockidbatch"];
    [param hs_setSafeValue:@([HDLeftSingleton shareSingleton].stepStatus) forKey:@"processstatus"];
    
    [PorscheRequestManager increaseItemsWithParamers:param complete:^(NSInteger status, PResponseModel * _Nonnull model) {
        if (status == 100) {
            NSLog(@"添加方案库全屏方案至工单成功");
            [selfWeak getWorkOrderListTestNeedSendNoti:YES schemeType:kAllScheme];
        }else {
            NSLog(@"添加方案库全屏方案至工单失败");
            [selfWeak failToEditWithModel:model];

        }
    }];
}

- (void)failToEditWithModel:(PResponseModel *)responser {
    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
    [self.tableView reloadData];
}

//工单列表
- (void)getWorkOrderListTestNeedSendNoti:(BOOL)need schemeType:(NSNumber *)type{
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
                //工单状态
                [HDLeftSingleton shareSingleton].maxStatus = [carMessage.wostatus integerValue];
                if([[HDLeftSingleton shareSingleton] showStepAlertViewShowStatus:nil]) {
                    return ;
                }
                selfWeak.carMessage = carMessage;
                selfWeak.dataArray = carMessage.solutionList;
//                [selfWeak setupSaveSattus];
                [selfWeak reloadSelfView];
                [[HDLeftSingleton shareSingleton] setupSingleNoticeWithNumber:carMessage.msgcount.allnum];
                [[HDLeftSingleton shareSingleton] setCarModel:carMessage];
                if (need) {
                    [selfWeak sendNotiToleftReloadWithType:type idArray:carMessage.solutionList];
                }
            }else {
                
                [selfWeak failToEditWithModel:responser];
            }
        }];
    }else {
        NSLog(@"未选择车辆,获取不到工单信息");
        selfWeak.bottomView.carMessage = nil;
    }
    
}

- (void)sendMessageToBottomView {

}

- (void)sendNotiToleftReloadWithType:(NSNumber *)number idArray:(NSArray *)listArray {
//    NSMutableArray *idArray = [NSMutableArray array];
//    for (PorscheNewScheme *scheme in listArray) {
//        [idArray addObject:scheme.wosstockid];
//    }
    if (!number) {
        number = [NSNumber new];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:WORK_ORDER_REFRESH_LEFT_ITEM_NOTIFINATION object:@{@"type":number,@"idArray":listArray}];
    [[HDLeftSingleton shareSingleton]reloadSchemeLeftLocalData:@{@"type":number,@"idArray":listArray}];

}
//删除工单中方案
- (void)deleteProject:(PorscheNewScheme *)model {
    ProscheAdditionCondition *tmp = [ProscheAdditionCondition new];
    tmp.processstatus = @([HDLeftSingleton shareSingleton].stepStatus);
    tmp.type = kDeletion;//添加/删除
    tmp.schemeid = model.schemeid;//方案在工单中的id
    tmp.schemestockid = model.schemeid;//方案id
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    WeakObject(model);
    WeakObject(self);
    [PorscheRequestManager increaseItemWithParamers:tmp complete:^(NSInteger status, PResponseModel * _Nonnull model) {
        [hud hideAnimated:YES];
        if (status == 100) {
            NSNumber *object = modelWeak.schemetype;
           //
            [selfWeak getWorkOrderListTestNeedSendNoti:YES schemeType:object];

        }else {
            NSLog(@"删除工单中方案失败！");
            [selfWeak failToEditWithModel:model];

        }
    }];
}

//添加工时备件 type:1.工时  2.备件  source:1.库 2.自定义 stocked添加自定义不需要，添加库多工时配件，存id数组  删除时，将单一的配件或者工时id存入数组。
- (void)upDateProjectMaterialTestWithAddedType:(NSNumber *)addedType schemeid:(NSNumber *)schemeid type:(NSNumber *)type source:(NSNumber *)source stockid:(NSArray *)stockList {
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
            [selfWeak getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
        }else {
            NSLog(@"工时/备件添加/删除至方案失败");
            [selfWeak failToEditWithModel:model];

        }
        
    }];
}

//左侧刷新
#pragma mark 刷新方案列表
- (void)sendMessageToleftReloadData {
//    [[NSNotificationCenter defaultCenter] postNotificationName:WORK_ORDER_LEFT_REFRESH_MORE_NOTIFINATION object:nil];
    [[HDLeftSingleton shareSingleton] reloadSchemeLeftData:nil];
}

- (void)showSchemeDetialWithScheme:(PorscheNewScheme *)scheme {
    WeakObject(self);
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    [PorscheRequestManager getWorkOrderSchemeOrderid:scheme.schemeid complete:^(PorscheSchemeModel * _Nonnull schemeModel, PResponseModel * _Nonnull responser) {
        [hud hideAnimated:YES];
        if (schemeModel) {
            [MaterialTaskTimeDetailsView showOrderSchemeWithScheme:schemeModel clickAction:^(DetailViewBackType style, PorscheSchemeModel *model) {
                
                [selfWeak sendMessageToleftReloadData];
                
                if (style == DetailViewBackTypeSaveToMyScheme || style == DetailViewBackTypeSaveToMySchemeAndAddToOrder || style == DetailViewBackTypeDelete) {
                    [selfWeak getOrderList];
                    
                    [[HDLeftSingleton shareSingleton] reloadSchemeLefMyData];
                    }else {
//                    [PorscheRequestManager saveWorkOrderScheme:schemeModel complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
//                        if (status == 100) {
                            [selfWeak getOrderList];
//                        }else {
//                            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
//                        }
//                    }];
                }
                
            }];
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
        }
    }];
}

#pragma mark  ⤴️⤴️⤴️⤴️⤴️⤴️⤴️⤴️⤴️⤴️⤴️⤴️--网络请求-分割线

- (void)setupBottomView {
    _bottomView = [TeachicianAdditionItemBottomView getCustomFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 64 - 49, CGRectGetWidth(self.view.frame), 49) style:BottomConstantSaveStyleTechician];
    [self.bottomView setSaveLbTittleAndImgBool:[_saveStatus integerValue]];

    [self.view addSubview:self.bottomView];
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

- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.containerView.frame style:UITableViewStyleGrouped];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"HDWorkListRightTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDWorkListRightTableViewCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"HDWorkListRightTableViewCellOne" bundle:nil] forCellReuseIdentifier:@"HDWorkListRightTableViewCellOne"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"HDWorkListRightTableViewCellTwo" bundle:nil] forCellReuseIdentifier:@"HDWorkListRightTableViewCellTwo"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"HDTechcianSingleItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDTechcianSingleItemTableViewCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"HDWorkListTVHFViewNormal" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HDWorkListTVHFViewNormal"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"HDWorkListTVHFViewOneNormal" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HDWorkListTVHFViewOneNormal"];
    //备注cell --注册
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HDTechicianRemarkTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HDTechicianRemarkTableViewCell class])];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.showsVerticalScrollIndicator = NO;
    
    [self.containerView addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
/*
- (void)addNotifinationForCub {
    //从备件库工时库返回
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(materialBackToTechnianVC:) name:BACK_FROM_MATERIAL_AND_ITEM_TIME_NOTIFINATION object:nil];
    //添加删除方案项目，自定义项目
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addModel:) name:TECHICIANADDITION_ADD_ITEM_NOTIFINATION object:nil];
    //点击在场车辆切换车辆信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCarMessage:) name:BILLING_CAR_MESSAGE_NOTIFINATION object:nil];

}

- (void)showCarMessage:(NSNotification *)noti {
    self.saveStatus = @0;
    [self getOrderList];
}
*/
//添加空白页面提示
- (void)addemptyView {
    if (self.dataArray.count == 0) {
        [self.containerView addSubview:self.emptyView];
    }else {
        if ([self.containerView.subviews containsObject:self.emptyView]) {
            [self.emptyView removeFromSuperview];
        }
    }
}

- (void)addLongPress {
    //长按移动分区
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(move:)];
    longPress.minimumPressDuration = 0.3;
    [_tableView addGestureRecognizer:longPress];
}

#pragma mark 刷新方案列表

- (void)addModel:(NSDictionary *)sender {
    if (self.dataArray.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    [self getWorkOrderListTestNeedSendNoti:YES schemeType:kAllScheme];
}

//工时库返回数据
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
        [self addedFullSchemeCubSchemeWithidArray:sender[@"ids"]];
    }
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

- (void)setupBottomViewStaff {
    
    self.bottomView.carMessage = self.carMessage;
    
    [_bottomView setSaveLbTittleAndImgBool:[_saveStatus integerValue]];
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
        
//        [self saveItemDataSource];
        
        [self.tableView reloadData];
        
        [self.imageView removeFromSuperview];

    }
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

#pragma mark  判断 备件员是否有选择，自定义方案是未设置名字的
- (BOOL)isStepToShowNext {
    NSString *string = nil;
    
    
    if (self.carMessage.solutionList.count) {
        for (PorscheNewScheme *scheme in self.carMessage.solutionList) {
            if ([scheme.schemetype isEqual:@3]) {
                if ([scheme.schemename isEqualToString:@""]) {
                    string = @"未填写方案名称";
                }
            }
        }
    }
    
    if (string) {
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:string height:60 center:self.tableView.center superView:self.view];
        return NO;
    }
    return YES;
}





#pragma mark  底部进入备件确认------

- (void)sureTechicianAction {
    WeakObject(self);
    //方案修改适用范围 弹窗
//    [HDProjectChangeRangeView showRangeViewWithProjectArray:nil block:^(UIButton *button) {
//       
//    }];
    
    //过滤：自定义方案名称未填写提示
    if (![self isStepToShowNext]) {
        return;
    }
    
    BOOL isNeedToWorkShopSure = NO;
    BOOL isWorkShopSure = NO;
    NSArray *titleArr;
    
    if ([self.carMessage.orderstatus.statusworkshop isEqual:@1]) {//需要车间确认
        isNeedToWorkShopSure = YES;
        titleArr = @[@"确认进入车间流程?",@"确定",@"取消"];
    }
    else
    {
        titleArr =   @[@"进入备件流程",@"进入服务流程"];
    }
    
    if (![self.carMessage.orderstatus.statusworkshop isEqual:@1])
    {
        [HDServiceDealView showMakeSureViewAroundView:self.bottomView.techicianSurebt viewType:HDServiceDealViewTechinian direction:UIPopoverArrowDirectionUp titleArr:titleArr first:^{
            // 进入备件确认
            if (self.bottomView.materialHelperTF.text.length == 0) {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定备件员" height:60 center:self.tableView.center superView:self.view];
                return ;
            }
            WeakObject(self);
            MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
            NSNumber *ordergoto = @3;
            NSInteger nextOrder;
            if ([self.carMessage.orderstatus.statuswaitworkshop integerValue] == 1)
            {
                nextOrder = 6;
            }
            else
            {
                nextOrder = 2;
            }
            [PorscheRequestManager orderSureToNextOrder:nextOrder param:@{@"ordergoto":ordergoto} buttonid:-1 Complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
                [hud hideAnimated:YES];
                if (status == 100) {
                    NSLog(@"确认进入下个流程成功！");
                    [selfWeak sendNotifinationToLeftToReloadDataType:@1];
                    [selfWeak hasNotPermission];
                    
                    selfWeak.carMessage.orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
                    [HDLeftSingleton shareSingleton].carModel = selfWeak.carMessage;
                    
                    NSInteger number = [self.carMessage.orderstatus.skipstep integerValue];
                    if (number > 0  && number != 2 && number < 6) {//跳转
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
                    NSLog(@"确认进入下个流程失败！");
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:HD_FULLView];
                }
            }];
        } second:^{
            

            
            if (self.bottomView.serviceHelperTF.text.length == 0) {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定服务顾问" height:60 center:self.tableView.center superView:self.view];
                return ;
            }
            // 进入服务确认
            WeakObject(self);
            MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
            NSNumber *ordergoto = @4;
            NSInteger nextOrder;
            if ([self.carMessage.orderstatus.statuswaitworkshop integerValue] == 1)
            {
                nextOrder = 6;
            }
            else
            {
                nextOrder = 2;
            }
            [PorscheRequestManager orderSureToNextOrder:nextOrder param:@{@"ordergoto":ordergoto} buttonid:-1 Complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
                [hud hideAnimated:YES];
                if (status == 100) {
                    NSLog(@"确认进入下个流程成功！");
                    [selfWeak sendNotifinationToLeftToReloadDataType:@1];
                    [selfWeak hasNotPermission];
                    
                    selfWeak.carMessage.orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
                    [HDLeftSingleton shareSingleton].carModel = selfWeak.carMessage;
                    
                    NSInteger number = [self.carMessage.orderstatus.skipstep integerValue];
                    if (number > 0  && number != 2 && number < 6) {//跳转
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
                    NSLog(@"确认进入下个流程失败！");
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:HD_FULLView];
                }
            }];
        } three:nil];

    }
    else
    {
        //车间确认权限
        [HDNewSaveView showMakeSureViewAroundView:self.bottomView.techicianSurebt tittleArray:titleArr direction:UIPopoverArrowDirectionUp makeSure:^{
            //进入备件--进入车间
            [selfWeak sureToNextWith:isNeedToWorkShopSure isWorkShopSure:isWorkShopSure];
        } cancel:^{
            
        }];
    }

}




- (void)sureToNextWith:(BOOL)isNeedWorkShopSure isWorkShopSure:(BOOL)isWorkShopSure{
    
    if (isWorkShopSure) {
        [self sureToWorkShop];
    }else {
        isNeedWorkShopSure ? [self sureToWaitWorkShop] : [self sureTomaterial];

    }
}

//车间等待
#pragma mark --- 车间等待接口
- (void)sureToWaitWorkShop {
    self.saveStatus = @1;
    [self reloadSelfView];
    [self workShopbottomView];
    
    [PorscheRequestManager waitConfirmWithStatus:@1 complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
        if (status == 100) {
            /* [selfWeak sendNotifinationToLeftToReloadDataType:@1];
             [selfWeak hasNotPermission];
             */
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:HD_FULLView];
            
        }
    }];
}

- (void)sureTomaterial {
    if ([self.bottomView.techicianSurebt.titleLabel.text isEqualToString:@"车间确认"]) {//车间权限
        if ([HDPermissionManager isNotThisPermission:HDOrder_JiShiZengXiang_WorkshopAffirm]) {
            return;
        }
    }else {
        if ([HDLeftSingleton isUserOrder]) {//自己的单子
            if ([HDPermissionManager isNotThisPermission:HDOrder_JiShiZengXiang_Edit]) {
                return;
            }
        }else {//不是自己的单子
            if ([HDPermissionManager isNotThisPermission:HDOrder_JiShiZengXiang_EditOtherPersonOrder]) {
                return;
            }
        }

    }
    
    [self sureTomaterialAction];
}

#pragma mark -- 确认
//进入备件---进入服务
- (void)sureTomaterialAction {
    WeakObject(self);
    NSNumber *ordergoto = @2;
    if (([self.carMessage.orderstatus.stateserice isEqualToNumber:@1] && [self.carMessage.orderstatus.statepart isEqualToNumber:@0]))
    {
        ordergoto = @4;
        if (self.bottomView.serviceHelperTF.text.length == 0) {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定服务顾问" height:60 center:self.tableView.center superView:self.view];
            return ;
        }
    }
    else if ([self.carMessage.orderstatus.stateserice isEqualToNumber:@1] && [self.carMessage.orderstatus.statepart isEqualToNumber:@0])
    {
        ordergoto = @3;
        if (self.bottomView.materialHelperTF.text.length == 0) {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定备件员" height:60 center:self.tableView.center superView:self.view];
            return ;
        }
    }
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    [PorscheRequestManager orderSureToNextOrder:2 param:@{@"ordergoto":ordergoto} buttonid:-1 Complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
        [hud hideAnimated:YES];
        if (status == 100) {
            NSLog(@"确认进入下个流程成功！");
            [selfWeak sendNotifinationToLeftToReloadDataType:@1];
            [selfWeak hasNotPermission];
            
            selfWeak.carMessage.orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
            [HDLeftSingleton shareSingleton].carModel = selfWeak.carMessage;

            NSInteger number = [self.carMessage.orderstatus.skipstep integerValue];
            if (number > 0  && number != 2 && number < 6) {//跳转
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
            NSLog(@"确认进入下个流程失败！");
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:HD_FULLView];
        }
    }];
}

//车间确认
- (void)sureToWorkShop {
    if ([HDPermissionManager isNotThisPermission:HDOrder_JiShiZengXiang_WorkshopAffirm]) {
        return;
    }
    
    NSNumber *ordergoto = @2;
    if (([self.carMessage.orderstatus.stateserice isEqualToNumber:@1] && [self.carMessage.orderstatus.statepart isEqualToNumber:@0]))
    {
        ordergoto = @4;
    }
    else if ([self.carMessage.orderstatus.stateserice isEqualToNumber:@1] && [self.carMessage.orderstatus.statepart isEqualToNumber:@0])
    {
        ordergoto = @3;
    }
    
    WeakObject(self);
    [PorscheRequestManager orderSureToNextOrder:6 param:@{@"ordergoto":ordergoto} buttonid:-1 Complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
        if (status == 100) {
            [selfWeak sendNotifinationToLeftToReloadDataType:@1];
            
//            [selfWeak hasNotPermission];
            
            selfWeak.carMessage.orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
            [HDLeftSingleton shareSingleton].carModel = selfWeak.carMessage;

            NSInteger number = [self.carMessage.orderstatus.skipstep integerValue];
            if (number > 0  && number != 2 && number < 6) {//跳转
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
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_Beijianqueren]) {
        self.saveStatus = @1;
        self.bottomView.saveStatus = @1;
        [self.bottomView setSaveLbTittleAndImgBool:[_saveStatus boolValue]];

        [self reloadSelfView];
        return ;
    }else {
        [HDLeftSingleton shareSingleton].maxStatus = 3;

    }
}



- (void)workShopbottomView {
    [self.bottomView.techicianSurebt setTitle:@"车间确认" forState:UIControlStateNormal];
}

/****
 *  type:1. 刷新网络数据 2.刷新tableView
 ****/
- (void)sendNotifinationToLeftToReloadDataType:(NSNumber *)type {
    [[HDLeftSingleton shareSingleton] reloadLeftBillingList:type];
}

#pragma mark  底部保存------

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
        if ([self.carMessage.wostatus isEqual:@7]) {
            
        }else {
            if ([HDLeftSingleton isUserOrder]) {//自己的单子
                if ([HDPermissionManager isNotThisPermission:HDOrder_JiShiZengXiang_Edit]) {
                    return;
                }
            }else {//不是自己的单子
                if ([HDPermissionManager isNotThisPermission:HDOrder_JiShiZengXiang_EditOtherPersonOrder]) {
                    return;
                }
            }
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
            //
//            [selfWeak getOrderList];
            
            // 切换到左侧方案
            [[HDLeftSingleton shareSingleton].leftTabBarVC changeBtAction:@{@"left":@2,@"right":@0}];
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


#pragma mark 底部按钮事件------

- (void)configNavitem {
    __weak typeof(self) selfWeak = self;
    //底部视图
    self.bottomView.teachicianAdditionItemBottomViewBlock = ^(TeachicianAdditionItemBottomViewStyle style,UIButton *sender) {
      
        switch (style) {//选择服务顾问
            case TeachicianAdditionItemBottomViewStyleServiceHelperBt:
            {
                [selfWeak bottomServiceBtAction];
            }
                

                break;//选择备件员
            case TeachicianAdditionItemBottomViewStyleMaterialHelperBt:
            {
                [selfWeak bottomMaterialBtAction];
            }
                
                
                break;
                //保存
            case TeachicianAdditionItemBottomViewStyleSavebt:
            {
                [selfWeak bottomSaveAction];
                
            }
                break;
                //技师确认
            case TeachicianAdditionItemBottomViewStyleTechcianSureBt:
            {
                [selfWeak sureTechicianAction];
            }
                break;
            default:
                break;
        }
    };
    
    
}
#pragma mark  选择备件员
- (void)bottomMaterialBtAction {//组别id 0.全部  职位id:2备件
    WeakObject(self);
    [PorscheRequestManager getStaffListTestWithGroupId:@0 positionId:@2 complete:^(NSMutableArray * _Nonnull classifyArray, PResponseModel * _Nonnull responser) {
        if (classifyArray.count) {
            PorscheConstantModel *tmp = [PorscheConstantModel new];
            tmp.cvvaluedesc = @"全部";
            tmp.cvsubid = @(-1);
            [classifyArray insertObject:tmp atIndex:0];
            
            [PorscheMultipleListhView showSingleListViewFrom:selfWeak.bottomView.materialHelperTF dataSource:classifyArray selected:nil showArrow:NO direction:ListViewDirectionUp complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
                selfWeak.bottomView.materialHelperTF.text = constantModel.cvvaluedesc;
                    [selfWeak saveMaterialSelectedWithModel:constantModel];
            }];
        }
    }];
 }

- (void)saveMaterialSelectedWithModel:(PorscheConstantModel *)model {
    self.carMessage.wopartsmanname = model.cvvaluedesc;
    self.carMessage.wopartsmanid = model.cvsubid;
    [self bottomSaveChooseTechWithdic:@{@"wopartsmanid":model.cvsubid}];
}

#pragma mark  选择服务顾问
- (void)bottomServiceBtAction {
    [self showSelectStaffViewWithTF:self.bottomView.serviceHelperTF];
}

- (void)showSelectStaffViewWithTF:(UITextField *)TF
{
    WeakObject(self);
    WeakObject(TF);
    // 获取组中员工数组
    [HDLeftSingleton shareSingleton].selectedPosid = @3;
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
        selfWeak.carMessage.serviceadvisorname = staffname;
        [selfWeak bottomSaveChooseTechWithdic:@{@"serviceadvisorid":staffid}];
        
    }];
}

- (void)bottomSaveChooseTechWithdic:(NSDictionary *)paramers {
    if ([HDStoreInfoManager shareManager].carorderid) {
        MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
        [PorscheRequestManager bottomSaveChooseTechWithdic:paramers complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
            [hud hideAnimated:YES];
        }];
    }
}

//组列表
- (void)getStaffGroupTest {
    if (![HDLeftSingleton shareSingleton].groupArray) {
        [HDLeftSingleton shareSingleton].groupArray = [NSMutableArray arrayWithArray:[[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataGroup]];
    }
}



#pragma mark  delegate------

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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}


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
                
                if ([cubScheme.wosisconfirm integerValue] == 2) {
                    return cubScheme.projectList.count + 1;
                }
                if ([cubScheme.schemeaddstatus integerValue] == 4) {//服务顾问添加的
                    if (![HDPermissionManager isHasHDOrder_JiShiZengXiang_EditServiceAdviser]) {
                        return cubScheme.projectList.count + 1;
                    }
                }
                return cubScheme.projectList.count + 3;//[cubScheme.schemetype isEqualToNumber:@3] ? cubScheme.projectList.count + 3: cubScheme.projectList.count + 2;

            }
        }else {
            return 0;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //根据数据类型，判断得到要显示的headerView
    PorscheNewScheme *cubModel = self.dataArray[section];
    WeakObject(tableView)
    WeakObject(cubModel);
    //自定义项目区头
    if ([cubModel.schemetype isEqualToNumber:@3]) {
        
        UIView *view = [self getCustomHeaderViewWith:tableViewWeak section:section model:cubModelWeak];
        
        return view;
    //一般项目区头
    }else {
        UIView *view = [self getNormalHeaderViewWith:tableViewWeak section:section model:cubModelWeak];
        
        return view;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    #pragma mark  发送信号 更改已选方案显示------
    //方案
    PorscheNewScheme *cubScheme = self.dataArray[indexPath.section];
    
    WeakObject(tableView);
    #pragma mark  自定义项目相关cell------
    if ([cubScheme.schemetype isEqualToNumber:@3] ) {
        
        if (cubScheme.projectList.count >indexPath.row) {
            
            
            PorscheNewSchemews *model = [cubScheme.projectList objectAtIndex:indexPath.row];
            //自定义项目中。设置工时添加行为方案自带，和新增工时区别开
            if ([model.schemesubtype integerValue] == 1) {//工时
                //工时cel
                UITableViewCell *cell = [self getCustomItemTimeCell:tableViewWeak model:model indexpath:indexPath];
                return cell;
            }else {
                UITableViewCell *cell = [self getNewPeijianCellWith:tableViewWeak model:model indexPath:indexPath];
                return cell;
            }
            
        }else if(cubScheme.projectList.count == indexPath.row)//自定义项目 增
        {
            if ([_saveStatus integerValue] == 1) {
                //备注行
                UITableViewCell *cell = [self getRemarkCellWith:tableViewWeak indexPath:indexPath];
                return cell;
            }else {
                if ([cubScheme.wosisconfirm integerValue] == 2) {
                    //备注行
                    UITableViewCell *cell = [self getRemarkCellWith:tableViewWeak indexPath:indexPath];
                    return cell;
                }
                if ([cubScheme.schemeaddstatus integerValue] == 4) {//服务顾问添加的
                    if (![HDPermissionManager isHasHDOrder_JiShiZengXiang_EditServiceAdviser]) {
                        //备注行
                        UITableViewCell *cell = [self getRemarkCellWith:tableViewWeak indexPath:indexPath];
                        return cell;
                    }
                }
                //工时cel
                UITableViewCell *cell = [self getCustomItemTimeCell:tableViewWeak model:nil indexpath:indexPath];
                return cell;
            }
            
        }else if(cubScheme.projectList.count + 1 == indexPath.row) {//自定义项目添加配件行
            
            UITableViewCell *cell = [self getNewPeijianCellWith:tableViewWeak model:nil indexPath:indexPath];

            
            return cell;
        }else {
            UITableViewCell *cell = [self getRemarkCellWith:tableViewWeak indexPath:indexPath];
            return cell;
        }
#pragma mark  一般项目相关cell------

    }else if (cubScheme.projectList.count > indexPath.row) {
        
        
        PorscheNewSchemews *model = [cubScheme.projectList objectAtIndex:indexPath.row];
        
        //工时cell
        WeakObject(model);
        if ([model.schemesubtype integerValue] == 1) {
#pragma mark 工时可以修改名称
//            if ([model.schemewstype integerValue] == 2)
//            {
                //工时cel
                UITableViewCell *cell = [self getCustomItemTimeCell:tableViewWeak model:modelWeak indexpath:indexPath];
                return cell;
//            }
//            else
//            {
//                UITableViewCell *cell = [self getItemCubItemTimeCell:tableViewWeak model:modelWeak indexPath:indexPath];
//                return cell;
//            }

        }
        
        //新增配件cell
        if ([model.schemewstype integerValue] != 1) {//不是自带的
                UITableViewCell *cell = [self getNewPeijianCellWith:tableViewWeak model:modelWeak indexPath:indexPath];
            return cell;
        }
#pragma mark -- 备件可以修改名称
        //配件cell
//        UITableViewCell *cell = [self getItemCubPeijianCellWith:tableViewWeak model:modelWeak indexPath:indexPath];
//        return cell;
        UITableViewCell *cell = [self getNewPeijianCellWith:tableViewWeak model:modelWeak indexPath:indexPath];
        return cell;
    // 添加工时行
    }else if (cubScheme.projectList.count == indexPath.row) {
        
        if ([_saveStatus integerValue] == 1) {
            //备注行
            UITableViewCell *cell = [self getRemarkCellWith:tableViewWeak indexPath:indexPath];
            return cell;
        }
        //工时cel
        UITableViewCell *cell = [self getCustomItemTimeCell:tableViewWeak model:nil indexpath:indexPath];
        return cell;
    }
         //添加配件Cell
    else if ((cubScheme.projectList.count + 1) == indexPath.row)
    {
        if ([_saveStatus integerValue] == 1) {
            //备注行
            UITableViewCell *cell = [self getRemarkCellWith:tableViewWeak indexPath:indexPath];
            return cell;
        }else {
            if ([cubScheme.wosisconfirm integerValue] == 2) {
                //备注行
                UITableViewCell *cell = [self getRemarkCellWith:tableViewWeak indexPath:indexPath];
                return cell;
            }
            if ([cubScheme.schemeaddstatus integerValue] == 4) {//服务顾问添加的
                if (![HDPermissionManager isHasHDOrder_JiShiZengXiang_EditServiceAdviser]) {
                    //备注行
                    UITableViewCell *cell = [self getRemarkCellWith:tableViewWeak indexPath:indexPath];
                    return cell;
                }
            }
            //添加配件行
            UITableViewCell *cell = [self getNewPeijianCellWith:tableViewWeak model:nil indexPath:indexPath];
            
            return cell;
        }
    }
    else if (cubScheme.projectList.count < indexPath.row) {
        UITableViewCell *cell = [self getRemarkCellWith:tableViewWeak indexPath:indexPath];
        return cell;
    }
    
    return nil;
    
}

#pragma mark  s
- (UIView *)getCustomHeaderViewWith:(UITableView *)tableView section:(NSInteger)section model:(PorscheNewScheme *)model{
    
    HDWorkListTVHFViewOneNormal *singleItemHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HDWorkListTVHFViewOneNormal"];
    singleItemHeaderView.contentView.backgroundColor = [UIColor clearColor];

    if (!singleItemHeaderView) {
        
        singleItemHeaderView = [[HDWorkListTVHFViewOneNormal alloc]initWithCustomFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 51)];
    }
    
    singleItemHeaderView.saveStatus = _saveStatus;
    
    //编辑服务顾问添加方案的权限
    if ([model.schemeaddstatus integerValue] == 4) {//服务顾问添加的
        if (![HDPermissionManager isHasHDOrder_JiShiZengXiang_EditServiceAdviser]) {
            singleItemHeaderView.saveStatus = @1;
        }
    }
    
    if ([model.wosisconfirm integerValue] == 2) {
        singleItemHeaderView.saveStatus = @1;
    }
    singleItemHeaderView.tmpModel = model;
    singleItemHeaderView.delegate = self;
    if (![HDLeftSingleton isUserAdded:model.schemeaddperson]) {//不是自己添加的
        singleItemHeaderView.deleteBt.hidden = YES;
        singleItemHeaderView.deleteSuperBt.hidden = YES;
        singleItemHeaderView.chooseBgView.hidden = NO;
        singleItemHeaderView.chooseBt.hidden = NO;
    }else {//自己添加的
        if ([singleItemHeaderView.saveStatus integerValue]) {//保存状态
            singleItemHeaderView.deleteSuperBt.hidden = YES;
            singleItemHeaderView.deleteBt.hidden = YES;
            singleItemHeaderView.chooseBgView.hidden = NO;
            singleItemHeaderView.chooseBt.hidden = NO;


        }else {//可编辑状态
            if ([model.wosisconfirm integerValue] == 0) {
                singleItemHeaderView.deleteSuperBt.hidden = YES;
                singleItemHeaderView.deleteBt.hidden = YES;
                singleItemHeaderView.chooseBgView.hidden = NO;
                singleItemHeaderView.chooseBt.hidden = NO;
            }else {
                singleItemHeaderView.deleteSuperBt.hidden = NO;
                singleItemHeaderView.deleteBt.hidden = NO;
                singleItemHeaderView.chooseBgView.hidden = YES;
                singleItemHeaderView.chooseBt.hidden = YES;
            }
            
            //取消服务顾问添加方案的权限
            if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_JiShiZengXiang_CancelScheme]) {
                singleItemHeaderView.deleteSuperBt.hidden = YES;
                singleItemHeaderView.deleteBt.hidden = YES;
                singleItemHeaderView.chooseBgView.hidden = NO;
                singleItemHeaderView.chooseBt.hidden = YES;
                singleItemHeaderView.chooseBgView.backgroundColor = [UIColor whiteColor];
            }
        }
    }
    WeakObject(self);
    
    
    //选择
    singleItemHeaderView.chooseBtBlock = ^(UIButton *sender) {
        [selfWeak chooseActionWithSchemws:model scheme:model view:sender type:@3];
    };
    
    
    //保修
    singleItemHeaderView.guaranteeViewblock = ^(UIButton *guarantee) {
        [selfWeak guaranteeViewActionWithTableView:tableView cell:nil Model:model button:guarantee];

    };
    //编辑方案名称
    singleItemHeaderView.editBlock = ^(NSString *text) {
        PorscheNewScheme *scheme = [PorscheNewScheme new];
        scheme.wosstockid = model.wosstockid;
        scheme.schemename = text;
        [selfWeak editCustomProjectnameScheme:scheme];
    };
    //是否显示或者隐藏 所属分类的工时和备件
    singleItemHeaderView.shadowBlock = ^(UIButton *button,PorscheNewScheme *tmpModel) {
        [selfWeak setTableViewHeaderGiddenStatus:tmpModel];
    };
    
    singleItemHeaderView.updateLevelBlock = ^(UIButton *button) {
        NSArray *array = [selfWeak getNeededLevelWithScheme:model];
        [HDLeftCustomItemView showCustomViewWithModelArray:array aroundView:button direction:UIPopoverArrowDirectionDown complete:^(PorscheConstantModel *tmp) {
            [selfWeak updateSchemeLevel:model.schemeid levelid:tmp.cvsubid];
        }];
    };
    //长按
    singleItemHeaderView.longPressBlock = ^() {
        [selfWeak showSchemeDetialWithScheme:model];
    };
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

- (void)setTableViewHeaderGiddenStatus:(PorscheNewScheme *)scheme {
    
    [self setupDataArrayWithTapHeaderScheme:scheme];
    
    [self.tableView reloadData];
}


#pragma mark  一般方案库区头------
- (UIView *)getNormalHeaderViewWith:(UITableView *)tableView section:(NSInteger)section model:(PorscheNewScheme *)model {
    
    HDWorkListTVHFViewNormal *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HDWorkListTVHFViewNormal"];
    view.contentView.backgroundColor = [UIColor clearColor];
    
    view.isGuarantee = YES;
    view.saveStatus = _saveStatus;
    //编辑服务顾问添加方案的权限
    if ([model.schemeaddstatus integerValue] == 4) {//服务顾问添加的
        if (![HDPermissionManager isHasHDOrder_JiShiZengXiang_EditServiceAdviser]) {
            view.saveStatus = @1;
        }
    }
    if ([model.wosisconfirm integerValue] == 2) {
        view.saveStatus = @1;
    }
    view.tmpModel = model;

    //设置项目名
    if (![HDLeftSingleton isUserAdded:model.schemeaddperson]) {
        view.deleteBt.hidden = YES;
        view.deleteSuperBt.hidden = YES;
        view.chooseSuperView.hidden = NO;
    }else {
        if ([view.saveStatus integerValue]) {
            
            view.deleteBt.hidden = YES;
            view.deleteSuperBt.hidden = YES;
            view.chooseSuperView.hidden = NO;
            
        }else {
            
            if ([model.wosisconfirm integerValue] == 0) {
                view.deleteBt.hidden = YES;
                view.deleteSuperBt.hidden = YES;
                view.chooseSuperView.hidden = NO;
            }else {
                view.deleteSuperBt.hidden = NO;
                view.deleteBt.hidden = NO;
                view.chooseSuperView.hidden = YES;
            }
            
            //取消服务顾问添加方案的权限
            if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_JiShiZengXiang_CancelScheme]) {
                view.deleteSuperBt.hidden = YES;
                view.deleteBt.hidden = YES;
                view.chooseSuperView.hidden = NO;
                view.chooseSuperView.backgroundColor = [UIColor whiteColor];
            }
        }
    }
    
    view.delegate = self;
    WeakObject(self);
    //勾选
    view.confirmActionBlock = ^(UIButton *sender){
        [selfWeak chooseActionWithSchemws:model scheme:model view:sender type:@3];
    };
    
    
    //保修弹窗
    WeakObject(view);
    view.guaranteeblock = ^(UIButton *button,PorscheNewScheme *tmpModel) {
      
        [selfWeak guaranteeViewActionWithTableView:tableView cell:nil Model:model button:viewWeak.guatanteeBt];
    };
    //是否显示或者隐藏 所属分类的工时和备件
    view.shadowBlock = ^(UIButton *button,PorscheNewScheme *tmpModel) {
        [selfWeak setTableViewHeaderGiddenStatus:tmpModel];
    };
    view.updateLevelBlock = ^(UIButton *button) {
        NSArray *array = [selfWeak getNeededLevelWithScheme:model];
        [HDLeftCustomItemView showCustomViewWithModelArray:array aroundView:button direction:UIPopoverArrowDirectionDown complete:^(PorscheConstantModel *tmp) {
            [selfWeak updateSchemeLevel:model.schemeid levelid:tmp.cvsubid];
        }];
    };
    view.longPressBlock = ^() {
        [selfWeak showSchemeDetialWithScheme:model];
    };
    
    return view;
}
#pragma mark  修改方案级别
- (void)updateSchemeLevel:(NSNumber *)schemeid levelid:(NSNumber *)levelid {
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    [PorscheRequestManager updateSchemeLevelWithSchemeId:schemeid levelid:levelid complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
        [hud hideAnimated:YES];
        if (status == 100) {
            [self getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"save_already_billing.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
        }
    }];
}

- (NSArray *)getNeededLevelWithScheme:(PorscheNewScheme *)scheme {
    PorscheConstantModel *model;
    NSArray *array =  [[CoreDataManager shareManager] getModelsWithTableName:CoreDataSchemeLevel];
    for (PorscheConstantModel *tmp in array) {
        if ([tmp.cvsubid integerValue] == [scheme.schemelevelid integerValue]) {
            model = tmp;
        }
    }
    
    NSMutableArray *endArr = [NSMutableArray array];
    [endArr addObjectsFromArray:array];
    [endArr removeObject:model];
    
    return endArr;
    
}


//- (void)

#pragma mark  自定义区头代理--删除------

- (void)didSelectedView:(HDWorkListTVHFViewOneNormal *)view ofButton:(UIButton *)deleteBt model:(PorscheNewScheme *)tmpModel {
    WeakObject(self);
    
//    [HDPoperDeleteView showAlertViewAroundView:deleteBt titleArr:@[@"确定删除",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
//        [selfWeak deleteProject:tmpModel];
//
//    } refuse:^{
//        
//    } cancel:^{
//        
//    }];
    [HDPoperDeleteView showAlertTableViewWithAroundView:deleteBt withDataSource:@[@"误操作, 移除方案", @"暂不做, 下次提醒"] direction:UIPopoverArrowDirectionRight selectBlock:^(NSInteger index) {
        switch (index) {
            case 0:
                [selfWeak deleteProject:tmpModel];
                break;
            case 1:
                [selfWeak chooseBtWithid:tmpModel.schemeid type:@3 isChoose:@0 withSchemetype:tmpModel.schemetype isNeedSendNoti:YES];
                break;
            default:
                break;
        }
    }];
    
}

#pragma mark  其他项目区头代理方法--删除----
- (void)didSelectedView:(HDWorkListTVHFViewNormal *)view ofBt:(UIButton *)deleteBt model:(PorscheNewScheme *)tmpModel{
    
    WeakObject(self);
//    [HDPoperDeleteView showAlertViewAroundView:deleteBt titleArr:@[@"确定删除",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
//        [selfWeak deleteProject:tmpModel];
//        
//    } refuse:^{
//        
//    } cancel:^{
//        
//    }];
    [HDPoperDeleteView showAlertTableViewWithAroundView:deleteBt withDataSource:@[@"误操作, 移除方案", @"暂不做, 下次提醒"] direction:UIPopoverArrowDirectionRight selectBlock:^(NSInteger index) {
        switch (index) {
            case 0:
                [selfWeak deleteProject:tmpModel];
                break;
            case 1:
                [selfWeak chooseBtWithid:tmpModel.schemeid type:@3 isChoose:@0 withSchemetype:tmpModel.schemetype isNeedSendNoti:YES];
                break;
            default:
                break;
        }
    }];
    
}



#pragma mark  自定义项目工时行cell------
- (UITableViewCell *)getCustomItemTimeCell:(UITableView *)tableView model:(PorscheNewSchemews *)model indexpath:(NSIndexPath *)indexPath {
    WeakObject(self);
    // 工时
    HDTechcianSingleItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDTechcianSingleItemTableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[HDTechcianSingleItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HDTechcianSingleItemTableViewCell"];
    }
    PorscheNewScheme *scheme = self.dataArray[indexPath.section];
    model.superschemesettlementway = scheme.wossettlement;
    //保存/编辑状态
    cell.saveStatus = _saveStatus;
    //编辑服务顾问添加的权限
    if ([scheme.schemeaddstatus integerValue] == 4) {//服务顾问添加的
        if (![HDPermissionManager isHasHDOrder_JiShiZengXiang_EditServiceAdviser]) {
            cell.saveStatus = @1;
        }
    }
    //编辑工时的权限
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeTime]) {
        cell.saveStatus = @1;
    }
    if ([scheme.wosisconfirm integerValue] == 2) {
        cell.saveStatus = @1;
    }
    cell.tmpModel = model;
    //编辑服务顾问添加工时的权限
    if ([cell.saveStatus integerValue] == 0) {
        if ([scheme.schemeaddstatus integerValue] == 4) {//服务顾问添加的
            if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_JiShiZengXiang_CancelSchemeTime]) {
                cell.chooseImageViewSuperView.backgroundColor = Color(255, 255, 255);
                cell.chooseBt.hidden = YES;
            }
        }
    }
    
    [cell layoutIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //cell点击 回调
    WeakObject(cell)
    //保修弹窗
    cell.guaranteeViewBlock = ^(UIButton *guaranteeBt) {
        [selfWeak guaranteeViewActionWithTableView:tableView cell:cellWeak Model:model button:guaranteeBt];
    };
    //选择打钩
    cell.chooseBlock = ^(PorscheNewSchemews *schemews,UIButton *sender) {
        [selfWeak chooseActionWithSchemws:schemews scheme:scheme view:sender type:@1];
    };
    
    //工时行 1.输
    
    cell.addedreturnBlock = ^(PorscheNewSchemews *schemews) {
        if (!model) {//空白添加时，获取坐在方案id
            if (!schemews) {
                schemews = [PorscheNewSchemews new];
            }
            schemews.wospwosid = scheme.schemeid;
        }
        [selfWeak editWorkHourOrMaretialWithSchemews:schemews type:kWorkType];
    };
    
    //工时行 1.添加工时按钮 2.修改工时内容 3.进入工时库添加工时 4.删除新增工时
    cell.hDTechcianSingleItemTableViewCellBlock = ^(HDTechcianSingleItemTableViewCellStyle style,UIButton *sender) {
        //维修按钮--添加工时
        if (style == HDTechcianSingleItemTableViewCellStyleRepair) {
            
            [selfWeak upDateProjectMaterialTestWithAddedType:kAddition schemeid:scheme.schemeid type:kWorkType source:kCustomScheme stockid:nil];
        }
            //删除按钮
        else if (style == HDTechcianSingleItemTableViewCellStyleChoose) {
            
            [HDPoperDeleteView showAlertViewAroundView:cellWeak.chooseBt titleArr:@[@"确定删除",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
                [selfWeak upDateProjectMaterialTestWithAddedType:kDeletion schemeid:scheme.schemeid type:kWorkType source:kCustomScheme stockid:@[model.schemewsid]];
                
            } refuse:^{
                
            } cancel:^{
                
            }];
            //工时弹窗
        }else if (style == HDTechcianSingleItemTableViewCellStyleItemTimeTF) {
#pragma mark  工时弹窗
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
                    schemews.wospwosid = scheme.schemeid;
                    needMatch = NO;
                }
            }else {
                schemews = [PorscheNewSchemews new];
                schemews.schemewsid = @0;

            }
            
            schemews.wospwosid = scheme.schemeid;
            [HDSchemewsView showHDSchemewsStyle:HDSchemewsViewStyleWorkHour model:schemews withSupperVC:selfWeak needMatch:needMatch  addedBlock:^(HDSchemewsViewBlockStyle style) {
                if (style == HDSchemewsViewBlockStyleRefresh) {
                    [selfWeak getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
                }
            }];
        }
    };
    
    return cell;

}

#pragma mark  新增配件行cell------
- (UITableViewCell *)getNewPeijianCellWith:(UITableView *)tableView model:(PorscheNewSchemews *)model indexPath:(NSIndexPath *)indexPath {
    
    HDWorkListRightTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"HDWorkListRightTableViewCellTwo" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[HDWorkListRightTableViewCellTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HDWorkListRightTableViewCellTwo"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    PorscheNewScheme *scheme = self.dataArray[indexPath.section];
    if (model) {
        model.superschemesettlementway = scheme.wossettlement;
    }
    
    NSNumber *saveStatus = _saveStatus;
    //编辑服务顾问添加的权限
    if ([scheme.schemeaddstatus integerValue] == 4) {//服务顾问添加的
        if (![HDPermissionManager isHasHDOrder_JiShiZengXiang_EditServiceAdviser]) {
            saveStatus = @1;
        }
    }
    //编辑备件权限
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeMaterial]) {
        saveStatus = @1;
    }
    if ([scheme.wosisconfirm integerValue] == 2) {
        saveStatus = @1;
    }
    cell.saveStatus = saveStatus;

    cell.tmpModel = model;
    
    //编辑服务顾问添加备件的权限
    if ([cell.saveStatus integerValue] == 0) {
        if ([scheme.schemeaddstatus integerValue] == 4) {//服务顾问添加的
            if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_JiShiZengXiang_CancelSchemeSpacePart]) {
                cell.superChooseImageView.backgroundColor = Color(255, 255, 255);
                cell.chooseBt.hidden = YES;
                
            }
        }
    }

    __weak typeof(self) selfWeak = self;
    WeakObject(cell);
    
    //
    cell.addedReturnBlock = ^(PorscheNewSchemews *schemews) {
        if (!model) {//空白添加时，获取所在方案id
            if (!schemews) {
                schemews = [PorscheNewSchemews  new];
            }
            
            schemews.wospwosid = scheme.schemeid;
        }
        [selfWeak editWorkHourOrMaretialWithSchemews:schemews type:kMaterialType];
    };
    //保修弹窗
    cell.guaranteeBlock = ^(UIButton *guaranteeBt) {
        [selfWeak guaranteeViewActionWithTableView:tableView cell:cellWeak Model:model button:guaranteeBt];
    };
    
    cell.hDWorkListRightTableViewCellTwoBlock = ^(HDWorkListRightTableViewCellTwoStyle style,UIView *sender) {
        //删除按钮事件
        if (style == HDWorkListRightTableViewCellTwoStyleDelete) {

            [HDPoperDeleteView showAlertViewAroundView:cellWeak.chooseBt titleArr:@[@"确定删除",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
                [selfWeak upDateProjectMaterialTestWithAddedType:kDeletion schemeid:scheme.schemeid type:kMaterialType source:kCustomScheme stockid:@[model.schemewsid]];
                
            } refuse:^{
                
            } cancel:^{
                
            }];
            
        //选择按钮事件
        }else if (style == HDWorkListRightTableViewCellTwoStyleChoose) {
            
            [selfWeak chooseActionWithSchemws:model scheme:scheme view:cellWeak.chooseBt type:@2];

        //添加事件
        }else if (style == HDWorkListRightTableViewCellTwoStyleAdd) {
            
            [selfWeak upDateProjectMaterialTestWithAddedType:kAddition schemeid:scheme.schemeid type:kMaterialType source:kCustomScheme stockid:nil];

            //输入框事件//图号编号
        }else if (style == HDWorkListRightTableViewCellTwoStyleTF) {
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
            /*
            __block PorscheNewSchemews *schemews = [PorscheNewSchemews new];
            schemews.schemeid = scheme.schemeid;
            schemews.schemewsid = @0;
            schemews.schemewstype = scheme.wossource;
            */
            
            [HDSchemewsView showHDSchemewsStyle:HDSchemewsViewStyleMaterial model:schemews withSupperVC:selfWeak needMatch:needMatch addedBlock:^(HDSchemewsViewBlockStyle style) {
                if (style == HDSchemewsViewBlockStyleRefresh) {
                    [selfWeak getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
                }
            }];
            
            //其他输入框
        }else if (style == HDWorkListRightTableViewCellTwoStyleNormalTF) {
            
        }else if (style == HDWorkListRightTableViewCellTwoStyleReturn) {
            
        }
        
    };
    [cell layoutIfNeeded];
    return cell;
}

#pragma mark  保修弹窗------
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    self.guaranteeView = nil;
    return YES;
}

- (NSInteger)getSettleIdxWithSchemeModel:(id)model modelArr:(NSArray *)array {
    __block NSInteger idex = 0;
    if ([model isKindOfClass:[PorscheNewSchemews class]]) {
        PorscheNewSchemews *schemws = model;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PorscheConstantModel *tmp = obj;
            if ([tmp.cvsubid integerValue] == [schemws.schemesettlementway integerValue]) {
                idex = idx;
                *stop = YES;
            }
        }];
        
        return idex;
    }else if ([model isKindOfClass:[PorscheNewScheme class]]) {
        PorscheNewScheme *scheme = model;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PorscheConstantModel *tmp = obj;
            if ([tmp.cvsubid integerValue] == [scheme.wossettlement integerValue]) {
                idex = idx;
                *stop = YES;
            }
        }];
        return idex;
    }
    return idex;
    
}

- (void)guaranteeViewActionWithTableView:(UITableView *)tableView  cell:(UITableViewCell *)cell Model:(id)model button:(UIButton *)button{
//    if ([HDPermissionManager isNotThisPermission:HDOrder_JiShiZengXiang_JiesuanFangshi]) {
//        return;
//    }
    NSArray *settleArr = [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataPayWay];
    if (!self.guaranteeView) {
        NSInteger idx = [self getSettleIdxWithSchemeModel:model modelArr:settleArr];
        
        self.guaranteeView = [[HDPoperDeleteView alloc]initWithGuaranteeChooseViewFrame:CGRectMake(0, 0, 240, 203) dataSource:settleArr idx:idx];
        self.guaranteeView.poperVC.delegate = self;
    }
    [HD_FULLView endEditing:YES];
    WeakObject(self);
    self.guaranteeView.guaranteeChooseView.guaranteeChooseViewBlock = ^(UIButton *button,NSInteger interger) {
        
        //工时，配件保修
        if ([model isKindOfClass:[PorscheNewSchemews class]]) {
            
            if (button.tag == 1) {
                PorscheConstantModel *settlement = settleArr[interger];
                if ([settlement.cvvaluedesc isEqualToString:@"内结"]) {
                    if ([HDPermissionManager isNotThisPermission:HDOrder_JiShiZengXiang_XuanzeNeijie]) {
                        return;
                    }
                } else if ([settlement.cvvaluedesc isEqualToString:@"保修"]) {
                    if ([HDPermissionManager isNotThisPermission:HDOrder_JiShiZengXiang_BaoXiuShenQing]) {
                        return;
                    }
                }
                MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
                [PorscheRequestManager setsettleWithModel:model isset:YES addStatus:@1 type:@1 settle:settlement complete:^(NSInteger status, PResponseModel * _Nonnull responser){
                    [hud hideAnimated:YES];
                    if (status == 100) {
                        [selfWeak getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
                    }
                }];
            }
            //项目保修
        }else {
            //0.自费  1.保修  2.内结
            if (button.tag == 1) {
                PorscheConstantModel *settlement = settleArr[interger];
                if ([settlement.cvvaluedesc isEqualToString:@"内结"]) {
                    if ([HDPermissionManager isNotThisPermission:HDOrder_JiShiZengXiang_XuanzeNeijie]) {
                        return;
                    }
                } else if ([settlement.cvvaluedesc isEqualToString:@"保修"]) {
                    if ([HDPermissionManager isNotThisPermission:HDOrder_JiShiZengXiang_BaoXiuShenQing]) {
                        return;
                    }
                }
                MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
                [PorscheRequestManager setsettleWithModel:model isset:YES addStatus:@1 type:@2 settle:settlement complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
                    [hud hideAnimated:YES];
                    if (status == 100) {
                        [selfWeak getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
                    }
                }];
            }
        }
        
        [selfWeak.guaranteeView.poperVC dismissPopoverAnimated:YES];
        
        selfWeak.guaranteeView = nil;
        };
        [selfWeak.guaranteeView.poperVC presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}

#pragma mark  方案库工时行cell------

- (UITableViewCell *)getItemCubItemTimeCell:(UITableView *)tableView model:(PorscheNewSchemews *)model indexPath:(NSIndexPath *)indexPath {
    HDWorkListRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDWorkListRightTableViewCell" forIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //给配件赋值 所属方案的自费状态，内结或者保修
    PorscheNewScheme *cubScheme = self.dataArray[indexPath.section];
    model.superschemesettlementway = cubScheme.wossettlement;
    cell.saveStatus = _saveStatus;
    
    //编辑服务顾问添加的权限
    if ([cubScheme.schemeaddstatus integerValue] == 4) {//服务顾问添加的
        if (![HDPermissionManager isHasHDOrder_JiShiZengXiang_EditServiceAdviser]) {
            cell.saveStatus = @1;
        }
    }
    //编辑工时的权限
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeTime]) {
        cell.saveStatus = @1;
    }
    if ([cubScheme.wosisconfirm integerValue] == 2) {
        cell.saveStatus = @1;
    }
    
    cell.tmpModel = model;
    
    //编辑服务顾问添加工时的权限
    if ([cell.saveStatus integerValue] == 0) {
        if ([cubScheme.schemeaddstatus integerValue] == 4) {//服务顾问添加的
            if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_JiShiZengXiang_CancelSchemeTime]) {
                cell.chooseBgView.backgroundColor = Color(255, 255, 255);
                cell.chooseBt.hidden = YES;
                
            }
        }
    }
    [cell layoutIfNeeded];
    WeakObject(self);
    WeakObject(cell);
    WeakObject(model);
    
    //工时行 1.输入内容编辑工时
    cell.addedReturnBlock = ^(PorscheNewSchemews *schemews) {
        
        [selfWeak editWorkHourOrMaretialWithSchemews:schemews type:kWorkType];
    };
    //修改 保修 弹窗
    cell.guaranteeActionBlock = ^(UIButton *buttom) {
        [selfWeak guaranteeViewActionWithTableView:tableView cell:cellWeak Model:modelWeak button:buttom];
    };
    
    cell.block = ^ (CameraAndPicStyle style,UIView *sender){
        switch (style) {
            case CameraAndPicStyleCamera://拍照
            {
                
            }
                break;
            case CameraAndPicStylePic://相片
                break;
            case LongPressStyle:
            {
                //长按
            }
                break;
            case chooseBtStyle:
            {
                [selfWeak chooseActionWithSchemws:model scheme:cubScheme view:sender type:@1];
            }
                break;
            // 工时数量完成弹窗
            case TextFIeldStyleEndEditting:
            {

            }
                break;
            default:
                break;
        }
        
    };
    return cell;
}

#pragma mark  方案库配件行cell------
- (UITableViewCell *)getItemCubPeijianCellWith:(UITableView *)tableView model:(PorscheNewSchemews *)model indexPath:(NSIndexPath *)indexPath {
    HDWorkListRightTableViewCellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"HDWorkListRightTableViewCellOne" forIndexPath:indexPath];
    if (!cell) {
        cell = [[HDWorkListRightTableViewCellOne alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HDWorkListRightTableViewCellOne"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //给配件赋值 所属方案的自费状态，内结或者保修
    PorscheNewScheme *cubScheme = self.dataArray[indexPath.section];
    model.superschemesettlementway = cubScheme.wossettlement;
    cell.saveStatus = _saveStatus;
    //编辑服务顾问添加的权限
    if ([cubScheme.schemeaddstatus integerValue] == 4) {//服务顾问添加的
        if (![HDPermissionManager isHasHDOrder_JiShiZengXiang_EditServiceAdviser]) {
            cell.saveStatus = @1;
        }
    }
    //编辑备件的权限
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeMaterial]) {
        cell.saveStatus = @1;
    }
    if ([cubScheme.wosisconfirm integerValue] == 2) {
        cell.saveStatus = @1;
    }
    
    cell.tmpModel = model;
    
    //编辑服务顾问添加工时的权限
    if ([cell.saveStatus integerValue] == 0) {
        if ([cubScheme.schemeaddstatus integerValue] == 4) {//服务顾问添加的
            if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_JiShiZengXiang_CancelSchemeSpacePart]) {
                cell.chooseSuperView.backgroundColor = Color(255, 255, 255);
                cell.chooseBt.hidden = YES;
            }
        }
    }
    WeakObject(self);
    WeakObject(cell);
    //配件行 1.输入内容编辑工时
    cell.returnBlock = ^(PorscheNewSchemews *schemews) {
        [selfWeak editWorkHourOrMaretialWithSchemews:schemews type:kMaterialType];
    };
    //修改 保修 弹窗
    cell.guaranteeBtBlock = ^(UIButton *button) {
        [selfWeak guaranteeViewActionWithTableView:tableView cell:cellWeak Model:model button:button];
    };
    
    cell.hDWorkListRightTableViewCellOneBlock = ^ (HDWorkListRightTableViewCellOneStyle style,UIButton *sender){
        if (style == HDWorkListRightTableViewCellOneStyleChoose) {
            //选择按钮
            [selfWeak chooseActionWithSchemws:model scheme:cubScheme view:cellWeak.chooseBt type:@2];
            //输入框
        }else if (style == HDWorkListRightTableViewCellOneStyleTF) {
            
        }
    };
    
    [cell layoutIfNeeded];
    return cell;
}
#pragma mark  钩的点击事件------

- (void)chooseActionWithSchemws:(id)model scheme:(PorscheNewScheme *)schemeModel view:(UIView *)aroundView type:(NSNumber *)type{
    WeakObject(self);
    if ([model isKindOfClass:[PorscheNewSchemews class]]) {
        PorscheNewSchemews *schemews = model;
        
        if ([schemews.iscancel isEqualToNumber:@0]) {//未勾选HDOrder_JiShiZengXiang_CancelSchemeTime
            
            NSInteger per = HDOrder_JiShiZengXiang_CancelSchemeTime;//工时
            
            if ([schemews.schemesubtype integerValue] == 2) {//备件
                per = HDOrder_JiShiZengXiang_CancelSchemeSpacePart;
            }
            if ([HDPermissionManager isNotWithNOAlertViewThisPermission:per]) {
                return;
            }
            [self chooseBtWithid:schemews.schemewsid type:type isChoose:@1 withSchemetype:nil isNeedSendNoti:NO];
            
        }else {
            
            [HDPoperDeleteView showAlertViewAroundView:aroundView titleArr:@[@"确定取消",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
                if ([selfWeak isLastSchemewsHasChoosenWithScheme:schemeModel]) {
                    [selfWeak chooseBtWithid:schemeModel.schemeid type:@3 isChoose:@0 withSchemetype:schemeModel.schemetype isNeedSendNoti:NO];

                }else {
                    [selfWeak chooseBtWithid:schemews.schemewsid type:type isChoose:@0 withSchemetype:schemeModel.schemetype isNeedSendNoti:NO];
                }

            } refuse:^{
                
            } cancel:^{
                
            }];
        }
    }else {
        PorscheNewScheme *scheme = model;
        if ([scheme.wosisconfirm isEqualToNumber:@0]) {//未勾选
            [self chooseBtWithid:scheme.schemeid type:type isChoose:@1 withSchemetype:scheme.schemetype isNeedSendNoti:YES];
            
        }else {
            if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_JiShiZengXiang_CancelScheme]) {
                return;
            }
            
            
            [HDPoperDeleteView showAlertViewAroundView:aroundView titleArr:@[@"确定取消",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
                [selfWeak chooseBtWithid:scheme.schemeid type:type isChoose:@0 withSchemetype:scheme.schemetype isNeedSendNoti:YES];
                
            } refuse:^{
                
            } cancel:^{
                
            }];
        }
    }
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


/**
 @param schemetype  左侧方案层级
 @param isNeenSend  是否通知左侧刷新列表
 */
- (void)chooseBtWithid:(NSNumber *)projectid type:(NSNumber *)type isChoose:(NSNumber *)value withSchemetype:(NSNumber *)schemetype isNeedSendNoti:(BOOL)isNeenSend {
    WeakObject(self);
    [PorscheRequestManager chooseBtWithid:projectid type:type isChoose:value success:^{
        [selfWeak getWorkOrderListTestNeedSendNoti:isNeenSend schemeType:schemetype];

    } fail:^{
#warning 勾选操作失败！
        [selfWeak.tableView reloadData];
    }];

}

#pragma mark  备注行cell------
- (UITableViewCell *)getRemarkCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    HDTechicianRemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HDTechicianRemarkTableViewCell class]) forIndexPath:indexPath];
    
    PorscheNewScheme *cubScheme = self.dataArray[indexPath.section];
    cell.saveStatus = _saveStatus;
    if ([cubScheme.schemeaddstatus integerValue] == 4) {//服务顾问添加的
        if (![HDPermissionManager isHasHDOrder_JiShiZengXiang_EditServiceAdviser]) {
            cell.saveStatus = @1;
        }
    }
    if ([cubScheme.wosisconfirm integerValue] == 2) {
        cell.saveStatus = @1;
    }
    cell.tmpModel = cubScheme;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WeakObject(self);
    cell.HDTechicianRemarkTableViewCellBlock = ^(HDTechicianRemarkTableViewCellStyle style,NSString *text) {
        //相机
        if (style == HDTechicianRemarkTableViewCellStyleCamera) {
            
//            ZLCameraViewController *camera = [[ZLCameraViewController a lloc] initWithUsageType:ControllerUsageTypeCamera];
//            camera.cameraType = ZLCameraContinuous;
//            [KEY_WINDOW.rootViewController.presentedViewController presentViewController:camera animated:YES completion:^{
//                
//            }];
            selfWeak.modelController.shootType = PorschePhotoCarImage;
            selfWeak.modelController.fileType = PorschePhotoGalleryFileTypeImage;
            selfWeak.modelController.keyType = PorschePhotoGalleryKeyTypeScheme;
            selfWeak.modelController.relativeid = cubScheme.schemeid;
            [selfWeak.modelController cycleTakePhoto:nil video:nil];
        //相册
        }else if (style == HDTechicianRemarkTableViewCellStylePhoto){
//            [selfWeak showPhotoGallery];
            [PorschePhotoModelController getPhotoListCompletion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
                if (responser.status == 100)
                {
                    PorscheGalleryModel *model = [PorscheGalleryModel yy_modelWithDictionary:responser.object];
                    model.currentSchemeid = cubScheme.schemeid;
                    [selfWeak.modelController showPhotoGalleryWithModel:model viewType:PorschePhotoGalleryPreviewAndShoot];
                }
            }];
        //输入框完成键
        }else if (style == HDTechicianRemarkTableViewCellStyleTFReturn) {
            PorscheNewScheme *scheme = [PorscheNewScheme new];
            scheme.schemeid = cubScheme.schemeid;
            scheme.wosremark = text;
            [selfWeak editSchemeRemarkWithScheme:scheme];
        }
    };
    
    return cell;
}

- (NSMutableArray *)cameraDataSource {
    
    if (!_cameraDataSource) {
        _cameraDataSource = [[NSMutableArray alloc] init];
    }
    return _cameraDataSource;
}

- (void)showPhotoGallery {
    
//    PorschePhotoGallery *photoView = [PorschePhotoGallery viewWithCarVideo:nil carPics:[NSMutableArray arrayWithArray:@[]] schemePics:[NSMutableArray arrayWithArray:@[]] viewType:PorschePhotoGalleryPreviewAndShoot];
//    
//    [HD_FULLView addSubview:photoView];
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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

//空白占位图
- (UIButton *)emptyView {
    if (!_emptyView) {
        _emptyView = [UIButton buttonWithType:UIButtonTypeCustom];
        _emptyView.frame = self.containerView.frame;
        [_emptyView setTitle:@"暂无信息" forState:UIControlStateNormal];
        [_emptyView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _emptyView.titleLabel.font =  [UIFont systemFontOfSize:26 weight:UIFontWeightThin];
    }
    return _emptyView;
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
