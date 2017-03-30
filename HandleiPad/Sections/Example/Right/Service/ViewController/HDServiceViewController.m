//
//  HDServiceViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceViewController.h"

#import "HDLeftSingleton.h"

//保存弹窗，进入服务沟通
#import "HDServiceDealView.h"
//#import "HDNewSaveView.h"
//底部视图
#import "TeachicianAdditionItemBottomView.h"

//分区区头
#import "HDWorkListTVHFViewNormal.h"
//自定义分区区头
#import "HDWorkListTVHFViewOneNormal.h"
//工时
#import "HDServiceItemTimeTableViewCell.h"
//备件
#import "HDServiceMaterialTableViewCell.h"
//添加备件
#import "HDServiceAddMaterailTableViewCell.h"
//备注
#import "HDServiceRemarkTableViewCell.h"
//自定义项目工时
#import "HDServiceSingleItemTableViewCell.h"
//自定义备注行cell
#import "HDTechicianRemarkTableViewCell.h"



//保修弹窗
#import "HDPoperDeleteView.h"
//折扣弹窗
#import "HDDiscountView.h"
#import "HDPoperDeleteView.h"
//照片库
#import "PorschePhotoGallery.h"
// 小提示框
#import "HDBillingSaveAlertView.h"
//备件弹窗
#import "TechcianNumberTFInputView.h"
//工时弹窗
#import "TechcianItemTimeTFInputView.h"
//方案库弹窗
#import "MaterialTaskTimeDetailsView.h"

#import "HDLeftCustomItemView.h"

#import "PrintPreviewViewController.h"

#import "PorschePhotoModelController.h"
#import "HDNewSaveView.h"
//打印提示弹窗
#import "PorschePrintAffirmView.h"
#import "SpareSettingViewController.h"

// 打印类
#import "Printer.h"
//取消原因
#import "HDCancelBillingView.h"
#import "HDRightViewController.h"
//选择技师
#import "HDSelectStaffView.h"
@interface HDServiceViewController ()<UITableViewDelegate,UITableViewDataSource,HDWorkListTVHFViewNormalDelegate,HDWorkListTVHFViewOneNormalDelegate,UIPopoverControllerDelegate>

//工单model
@property (nonatomic, strong) PorscheNewCarMessage *carMessage;

//删除 窗口
@property (nonatomic, strong) UIPopoverController *popVC;

//保修弹窗
@property (nonatomic, strong) HDPoperDeleteView *guaranteeView;

//滑动
@property (strong, nonatomic) UIView *containerView;

//底层滑动视图
@property (strong, nonatomic)  UIScrollView *baseView;

//空白占位图
@property (nonatomic, strong) UIButton *emptyView;

//@property (nonatomic, strong) HDNewSaveView *saveView;

//底部视图
@property (nonatomic, strong) TeachicianAdditionItemBottomView *bottomView;

//服务数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *tmpBt;

//定位 点击工时库的位置
@property (nonatomic, strong) NSNumber *currentIdx;

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
//保存1/编辑0
@property (nonatomic, strong) NSNumber *saveStatus;
// 媒体处理类
@property (nonatomic, strong) PorschePhotoModelController *modelController;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@property (nonatomic, strong) Printer *printer;

@end

@implementation HDServiceViewController

- (void)viewDidLayoutSubviews {
    
    self.baseView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64 - 49);
    self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.baseView.frame));
    
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.baseView.frame));
    
    _baseView.contentSize = CGSizeMake(CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 49 - 64, CGRectGetWidth(self.baseView.frame), 49);
    
    self.emptyView.frame = self.containerView.frame;
}

- (void)dealloc {
    NSLog(@"HDServiceViewController.dealloc");
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)baseReloadData
{
    [self getOrderList];
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
    _tmpSection = -1;
    _oldSection = -2;
    self.saveStatus = @1;
    [HDLeftSingleton shareSingleton].stepStatus = 4;

//    [self setupSaveSattus];
    [self setupBaseScrollView];
    
    [self setUpTableView];
    
    [self setheaderViewAndBottomView];
    
    [self addEmptyView];
    
//    [self addNotifination];
    
    [self.view addSubview:self.bottomView];
    
//    [self addLongPress];
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
/*
- (void)setupSaveSattus {
    if ([HDLeftSingleton shareSingleton].maxStatus != [HDLeftSingleton shareSingleton].stepStatus) {
        self.saveStatus = @1;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:RIGHT_SAVE_LIST_NOTIFINATION object:@{@"issave":_saveStatus}];

}
*/
- (void)setSaveStatus:(NSNumber *)saveStatus {
    _saveStatus = saveStatus;
    [HDLeftSingleton shareSingleton].saveStatus = saveStatus;
    [[HDLeftSingleton shareSingleton].HDRightViewController setheaderUserEnabled:@{@"issave":saveStatus}];
}

/*
- (void)addGesWithSaveStatus:(NSNumber *)saveStatus {
    
    if ([saveStatus integerValue] == 1) {
        [self.tableView addGestureRecognizer:self.longPress];
    }else {
        [self.tableView removeGestureRecognizer:self.longPress];
    }
}
*/

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
            [selfWeak failToEditWithModel:model];
            NSLog(@"方案工时修改失败！");
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
            [selfWeak failToEditWithModel:model];

            NSLog(@"方案备注修改失败！");
            
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
            [selfWeak failToEditWithModel:model];

            NSLog(@"自定义项目名称修改失败！");
            
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
            [selfWeak failToEditWithModel:model];

            NSLog(@"添加方案库全屏方案至工单失败");
        }
    }];
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
                NSLog(@"获取工单方案信息成功！");
                [HDLeftSingleton shareSingleton].maxStatus = [carMessage.wostatus integerValue];
                if([[HDLeftSingleton shareSingleton] showStepAlertViewShowStatus:nil]) {
                    return ;
                }
                selfWeak.carMessage = carMessage;
                [HDLeftSingleton shareSingleton].carModel = carMessage;
                selfWeak.dataArray = carMessage.solutionList;
                [selfWeak reloadSelfView];
                [[HDLeftSingleton shareSingleton] setupSingleNoticeWithNumber:carMessage.msgcount.allnum];

                if (need) {
                    [selfWeak sendNotiToleftReloadWithType:type idArray:carMessage.solutionList];
                }
                
            }else {
                [selfWeak failToEditWithModel:responser];

            }
        }];
    }else {
        NSLog(@"未选择车辆,获取不到工单信息");
    }
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

- (void)sendNotiToleftReloadWithType:(NSNumber *)number idArray:(NSArray *)listArray {
    if (self.carMessage) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:WORK_ORDER_REFRESH_LEFT_ITEM_NOTIFINATION object:@{@"type":number,@"idArray":listArray}];
        [[HDLeftSingleton shareSingleton]reloadSchemeLeftLocalData:@{@"type":number,@"idArray":listArray}];
    }
}
- (void)failToEditWithModel:(PResponseModel *)responser {
    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
    [self.tableView reloadData];
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
            NSNumber *object = modelWeak.schemetype;//根据级别，刷新左侧方案库
            
             if ([modelWeak.schemetype integerValue] != 2) {//自定义方案 不刷新左边
             object = kLeftSchemeZero;
             }
             
            
            [selfWeak getWorkOrderListTestNeedSendNoti:YES schemeType:object];
            
        }else {
            [selfWeak failToEditWithModel:model];

            NSLog(@"删除工单中方案失败！");
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
            [selfWeak failToEditWithModel:model];

            NSLog(@"工时/备件添加/删除至方案失败");
        }
        
    }];
}

#pragma mark 刷新方案列表
- (void)sendMessageToleftReloadData {
    //    [[NSNotificationCenter defaultCenter] postNotificationName:WORK_ORDER_LEFT_REFRESH_MORE_NOTIFINATION object:nil];
    [[HDLeftSingleton shareSingleton] reloadSchemeLeftData:nil];
}
#pragma mark  显示方案详情之后
- (void)showSchemeDetialWithScheme:(PorscheNewScheme *)scheme {
    WeakObject(self);
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    [PorscheRequestManager getWorkOrderSchemeOrderid:scheme.schemeid complete:^(PorscheSchemeModel * _Nonnull schemeModel, PResponseModel * _Nonnull responser) {
        [hud hideAnimated:YES];
        if (responser.status == 100)
        {
            if (schemeModel) {
                [MaterialTaskTimeDetailsView showOrderSchemeWithScheme:schemeModel clickAction:^(DetailViewBackType style, PorscheSchemeModel *model) {
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
            }
        }
        else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
        }
    }];
}

//----------------------------------------------分割线--------------------------------------

- (UILongPressGestureRecognizer *)longPress {
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(move:)];
        _longPress.minimumPressDuration = 0.3;
    }
    return _longPress;
}
#pragma mark  方案库/备件库/工时库 返回
- (void)materialBackToTechnianVC:(NSDictionary *)sender {;//@{@"ids":list,@"type":@1}//返回数据
    //工时库 备件库返回
    if ([sender[@"type"] integerValue] != 3) {
        NSNumber *type = [sender[@"type"] integerValue] == 1 ? kMaterialType : kWorkType;
        if ([sender[@"ids"] count] == 0) {
            return;
        }
        PorscheNewScheme *scheme = self.dataArray[[self.currentIdx integerValue]];
        [self upDateProjectMaterialTestWithAddedType:kAddition schemeid:scheme.schemeid type:type source:kScheme stockid:sender[@"ids"]];
        //方案库返回
    }else {
        [self addedFullSchemeCubSchemeWithidArray:sender[@"ids"]];
    }
}


- (void)addEmptyView {
    if (self.dataArray.count == 0) {
        
        [self.view addSubview:self.emptyView];

    }else {
        [self.emptyView removeFromSuperview];
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


- (void)setUpTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 49) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 分区区头
    [_tableView registerNib:[UINib nibWithNibName:@"HDWorkListTVHFViewNormal" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HDWorkListTVHFViewNormal"];
    [_tableView registerNib:[UINib nibWithNibName:@"HDWorkListTVHFViewOneNormal" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HDWorkListTVHFViewOneNormal"];
    //工时cell
    [_tableView registerNib:[UINib nibWithNibName:@"HDServiceItemTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDServiceItemTimeTableViewCell"];
    //配件cell
    [_tableView registerNib:[UINib nibWithNibName:@"HDServiceMaterialTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDServiceMaterialTableViewCell"];
    //添加配件cell
    [_tableView registerNib:[UINib nibWithNibName:@"HDServiceAddMaterailTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDServiceAddMaterailTableViewCell"];
    //备注行cell
    [_tableView registerNib:[UINib nibWithNibName:@"HDTechicianRemarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDTechicianRemarkTableViewCell"];
    //自定义项目工时注册
    [_tableView registerNib:[UINib nibWithNibName:@"HDServiceSingleItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDServiceSingleItemTableViewCell"];
    
    
    [self.containerView addSubview:_tableView];
    
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

/*
- (void)addNotifination {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addModel:) name:TECHICIANADDITION_ADD_ITEM_NOTIFINATION object:nil];
    //从备件库工时库返回
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(materialBackToTechnianVC:) name:BACK_FROM_MATERIAL_AND_ITEM_TIME_NOTIFINATION object:nil];
    //切换在场车辆，切换显示的信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCarMessage:) name:BILLING_CAR_MESSAGE_NOTIFINATION object:nil];
}

- (void)showCarMessage:(NSNotification *)noti {
    self.saveStatus = @0;
//    [self setupSaveSattus];
    
    [self getOrderList];
}
*/
#pragma mark  ------获取通知------

- (void)addModel:(NSDictionary *)sender {
    if (self.dataArray.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    [self getWorkOrderListTestNeedSendNoti:YES schemeType:kAllScheme];

}

#pragma mark  底部视图及响应事件

- (void)setheaderViewAndBottomView {
    
    self.bottomView = [TeachicianAdditionItemBottomView getCustomFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49 - 64, CGRectGetWidth(self.view.frame), 49) style:BottomConstantSaveStyleService];
    [self.bottomView setSaveLbTittleAndImgBool:[_saveStatus integerValue]];
    
    WeakObject(self);
    self.bottomView.teachicianAdditionItemBottomViewBlock = ^(TeachicianAdditionItemBottomViewStyle style,UIButton *sender) {
        if (style == TeachicianAdditionItemBottomViewStyleSavebt) {
            //保存，编辑
            [selfWeak bottomSaveAction];
            
        }
        else if (style == TeachicianAdditionItemBottomViewStyleTechicianHelperBt) {
            //选择技师
            [selfWeak bottomServiceBtAction];
            
        }
        else if (style == TeachicianAdditionItemBottomViewStyleMaterialHelperBt) {
            //选择备件
            [selfWeak bottomMaterialBtAction];
            
        }
        else if (style == TeachicianAdditionItemBottomViewStyleTechcianSureBt) {
            //进入下个流程
            [selfWeak sureTechicianAction];
            
        }
        else if (style == TeachicianAdditionItemBottomViewStylePrintHelperBt)
        {
            BOOL isShowAlert = [[HDLeftSingleton shareSingleton] showStepAlertViewShowStatus:nil];
            if (isShowAlert) {
                return;
            }
            
            if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share_Price]) {
                return;
            };
            // 预览报价单
            [selfWeak loadPrintCategorysSelectViewWithPrintType:SparePrintTypePreView];
//         [PorscheRequestManager getPDFFileWithType:PDF_Quotation spareInfo:@[] printCategory:@[] completion:^(NSURL * _Nonnull fileURL) {
//             
//         }];
//           HDNewSaveView *saveView = [HDNewSaveView showMakeSureViewAroundView:selfWeak.bottomView.printBt tittleArray:@[@"打印类型",@"报价单",@"备货单"] direction:UIPopoverArrowDirectionUp makeSure:^{
//                // 进入打印页面
//                NSDictionary *info = nil;
//                info = @{@"confim":@1};
//                [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_PREVIEW_NOTIFICATION object:info];
//            } cancel:^{
//                
//            }];
//            [saveView setCancelButtonTitleColorNormal];

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
    [self bottomSaveChooseTechWithdic:@{@"wopartsmanid":model.cvsubid}];
}

#pragma mark  选择技师
- (void)bottomServiceBtAction {
    [self showSelectStaffViewWithTF:self.bottomView.techicianTF];
}

- (void)showSelectStaffViewWithTF:(UITextField *)TF
{
    WeakObject(self);
    WeakObject(TF);
    // 获取组中员工数组
    [HDLeftSingleton shareSingleton].selectedPosid = @1;
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
        [selfWeak bottomSaveChooseTechWithdic:@{@"technicianid":staffid}];
        
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
#pragma mark -- 选择打印分类

// 加载打印分类视图
- (void)loadPrintCategorysSelectViewWithPrintType
{
//    WeakObject(self);
    //    // 高度210
    //    HDSingleSelectView *selectCategoryView = [HDSingleSelectView loadSingleSelectViewWithOrigin:CGPointMake(326, self.view.bounds.size.height - self.bottomView.bounds.size.height - 210)];
    //    selectCategoryView.tag = SelectCategoryViewTag;
    //    selectCategoryView.dataSource = [self configPrintTypeModel];
    //    selectCategoryView.selectFinishedBlock = ^(NSInteger index){
    //        [selfWeak maskViewDidSelectView:nil];
    //    };
    //    self.maskView.hidden = NO;
    //    [self.view addSubview:selectCategoryView];
    
    
    PorschePrintAffirmView *printView = [PorschePrintAffirmView showPrinAffirmViewAndComplete:^(NSArray *pays, NSInteger count) {
        
//            [PorscheRequestManager getPDFFileWithType:PDF_Quotation spareInfo:@[] printCategory:pays completion:^(NSURL * _Nonnull fileURL) {
//            
//                [self beginPrintWithCopies:count];
//            }];
        
        //type 打印类型
        //count 打印份数
        // 进入打印页面
        // 获取打印pdf数据
        [self getPDFFileWithType:PDF_Quotation spareInfo:nil printType:SparePrintTypePrint printCategory:pays printCount:count];

    }];
    [HD_FULLView addSubview:printView];
}
#pragma mark -- 获取PDF信息
- (void)getPDFFileWithType:(PDFType)type spareInfo:(NSArray *)spareInfo printType:(SparePrintType)printType printCategory:(NSArray *)category printCount:(NSUInteger)count
{
    
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
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self.view];
    [PorscheRequestManager downloadPDFWithURLStr:URLStr params:param orderid:[[HDStoreInfoManager shareManager] carorderid] completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        if (!error)
        {
            if ([filePath absoluteString].length)
            {
                //                [self initializerPDFInfoWithURL:filePath];
                if (printType == SparePrintTypePreView)
                {
                    [self gotoPrintViewWithPrintType:type count:count];
                }
                else
                {
#warning 直接弹打印 区分 报价单，备货单
                    //
                    [self beginPrintWithCopies:count];
                }
                
            }
        }
//        else
//        {
//            if (error.code != 100 && error.localizedDescription.length)
//            {
//                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:error.localizedDescription height:60 center:self.tableView.center superView:self.view];
//            }
//        }
    }];
}
- (void)gotoPrintViewWithPrintType:(PDFType)pdftype count:(NSInteger)copies
{
    NSNumber *type = nil;
    if (pdftype == PDF_Spare)
    {
        type = @1;
    }
    else
    {
        type = @2;
    }
    // 进入打印页面
    NSDictionary *info = @{@"fromstyle":@0, @"ordertype":type};
//    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_PREVIEW_NOTIFICATION object:info];
    [[HDLeftSingleton shareSingleton] showPreView:info];

}
#pragma mark --- 打印类打印

- (void)beginPrintWithCopies:(NSInteger)copies
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, PDF_NAME];
    //    NSData *pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fullPath]];
    NSFileManager* fm = [NSFileManager defaultManager];
    NSData* data = [fm contentsAtPath:fullPath];
    [self.printer selectPrinterToPrinterWithView:HD_FULLView copies:copies printPDFData:data];
    
}
- (Printer *)printer
{
    if (!_printer) {
        _printer = [[Printer alloc] init];
    }
    return _printer;
}

#pragma mark  判断 备件员是否有选择，自定义方案是未设置名字的
- (BOOL)isStepToShowNext {
    NSString *string = nil;
    
    //保修审核 未完成
//    NSArray *schemeArr = self.carMessage.solutionList;
//    if (schemeArr.count) {
//        for (PorscheNewScheme *scheme in schemeArr) {
//            if ([scheme.wosisguarantee isEqualToNumber:@1]) {//未审核的保-方案
//                string = @"未审核保修项目、工时或备件";
//                NSArray *schemewsArr = scheme.projectList;
//                if (schemewsArr.count) {
//                    for (PorscheNewSchemews *schemews in schemewsArr) {
//                        if ([schemews.schemeswswarrantyconflg isEqualToNumber:@1]) {//未审核的保-工时/备件
//                            string = @"未审核保修项目、工时或备件";
//                            break;
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    
    //预计交车时间(17-02-06 czz 要求只有到客户确认界面的时候才判断是否有预计交车时间)
//    if (![self.carMessage isHasWofinishtime] && [self.carMessage.orderstatus getSwitch] == 3) {
//        string = @"未填写预计交车时间";
//    }
    
    //方案名称
   if (self.carMessage.solutionList.count) {
        for (PorscheNewScheme *scheme in self.carMessage.solutionList) {
            if ([scheme.schemetype isEqual:@3]) {
                if ([scheme.schemename isEqualToString:@""]) {
                    string = @"未填写自定义方案名称";
                    break;
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

#pragma mark  ------底部进入客户------

- (void)sureTechicianAction {

    if (![self isStepToShowNext]) {
        return;
    }
    WeakObject(self);
    OrderOptStatusDto *statusModel = self.carMessage.orderstatus;
    // 进入保修
    if ([statusModel.stateguarantee integerValue] == 1)
    {
        /*
         return @[@"保修审批？",@"确定",@"取消"];
         return @[@"进入保修审批流程？",@"确定",@"取消"];
@[@"进入保修审批流程？",@"先让技师确认",@"先让备件确认"]
         */
        
        if ([statusModel.stateserice integerValue] == 1)
        {
            [HDServiceDealView showMakeSureViewAroundView:self.bottomView.techicianSurebt viewType:HDServiceDealViewFourHandleEnterGuarantee direction:UIPopoverArrowDirectionUp titleArr:@[@"进入保修审批流程",@"直接让客户确认",@"先让技师确认",@"先让备件确认"] first:^{
                // 进入保修审批
                [selfWeak serviceSwitchWithStatus:@4];
            } second:^{
                [selfWeak sureToCustom];
            } three:^{
                // 技师
                
                if (self.bottomView.techicianTF.text.length == 0)
                {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定技师" height:60 center:self.tableView.center superView:self.view];
                    return ;
                }
                
                [selfWeak serviceSwitchWithStatus:@3];
            } four:^{
                // 备件
                if (self.bottomView.materialHelperTF.text.length == 0)
                {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定备件员" height:60 center:selfWeak.tableView.center superView:selfWeak.view];
                    return ;
                }
                [selfWeak serviceSwitchWithStatus:@2];
            }];
        }
        else
        {
            // 三只手
            [HDServiceDealView showMakeSureViewAroundView:self.bottomView.techicianSurebt viewType:HDServiceDealViewThreeHandleEnterGuarantee direction:UIPopoverArrowDirectionUp titleArr:@[@"进入保修审批流程",@"先让技师确认",@"先让备件确认"] first:^{
                // 进入保修审批
                [selfWeak serviceSwitchWithStatus:@4];
            } second:^{
                // 技师
                
                if (self.bottomView.techicianTF.text.length == 0)
                {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定技师" height:60 center:self.tableView.center superView:self.view];
                    return ;
                }
                
                [selfWeak serviceSwitchWithStatus:@3];
            } three:^{
                // 备件
                if (self.bottomView.materialHelperTF.text.length == 0)
                {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定备件员" height:60 center:selfWeak.tableView.center superView:selfWeak.view];
                    return ;
                }
                [selfWeak serviceSwitchWithStatus:@2];
            }];

        }
    }
    // 保修审批
    else if ([statusModel.statuswaitguarantee integerValue] == 1)
    {
        
        if ([statusModel.stateserice integerValue] == 1)
        {
            [HDServiceDealView showMakeSureViewAroundView:self.bottomView.techicianSurebt viewType:HDServiceDealViewFourHandleCheckGuarantee direction:UIPopoverArrowDirectionUp titleArr:@[@"保修审批",@"直接让客户确认",@"先让技师确认",@"先让备件确认"] first:^{
                // 进入保修审批
                [selfWeak serviceSwitchWithStatus:@5];
            } second:^{
                [selfWeak sureToCustom];
            } three:^{
                // 技师
                
                if (self.bottomView.techicianTF.text.length == 0)
                {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定技师" height:60 center:self.tableView.center superView:self.view];
                    return ;
                }
                
                [selfWeak serviceSwitchWithStatus:@3];
            } four:^{
                // 备件
                if (self.bottomView.materialHelperTF.text.length == 0)
                {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定备件员" height:60 center:selfWeak.tableView.center superView:selfWeak.view];
                    return ;
                }
                [selfWeak serviceSwitchWithStatus:@2];
            }];
        }
        else{
            
            [HDServiceDealView showMakeSureViewAroundView:self.bottomView.techicianSurebt viewType:HDServiceDealViewThreeHandleCheckGuarantee direction:UIPopoverArrowDirectionUp titleArr:@[@"保修审批",@"先让技师确认",@"先让备件确认"] first:^{
                // 进入保修审批
                [selfWeak serviceSwitchWithStatus:@5];
            } second:^{
                // 技师
                
                if (self.bottomView.techicianTF.text.length == 0)
                {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定技师" height:60 center:self.tableView.center superView:self.view];
                    return ;
                }
                
                [selfWeak serviceSwitchWithStatus:@3];
            } three:^{
                // 备件
                if (self.bottomView.materialHelperTF.text.length == 0)
                {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定备件员" height:60 center:selfWeak.tableView.center superView:selfWeak.view];
                    return ;
                }
                [selfWeak serviceSwitchWithStatus:@2];
            }];
        }
    }
    // 出现客户确认，技师确认，备件确认
    else if ([statusModel.stateserice integerValue] == 1)
    {
     // 三只手
      [HDServiceDealView showMakeSureViewAroundView:self.bottomView.techicianSurebt viewType:HDServiceDealViewThreeHandle direction:UIPopoverArrowDirectionUp titleArr:@[] first:^{
          // 客户
          [selfWeak sureToCustom];
      } second:^{
          // 技师
          
          if (self.bottomView.techicianTF.text.length == 0)
          {
              [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定技师" height:60 center:self.tableView.center superView:self.view];
              return ;
          }
          
          [selfWeak serviceSwitchWithStatus:@3];
      } three:^{
          // 备件
          if (self.bottomView.materialHelperTF.text.length == 0)
          {
              [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定备件员" height:60 center:selfWeak.tableView.center superView:selfWeak.view];
              return ;
          }
          [selfWeak serviceSwitchWithStatus:@2];
      }];
        
    }
    else
    {
        // 蓝色
        NSArray *titleArray = @[@"先让技师确认",@"先让备件确认"];
        [HDServiceDealView showMakeSureViewAroundView:self.bottomView.techicianSurebt viewType:HDServiceDealViewToTechAndSpare direction:UIPopoverArrowDirectionUp titleArr:titleArray first:^{
            // 客户
            [selfWeak sureToCustom];
        } second:^{
            // 技师
            
            if (self.bottomView.techicianTF.text.length == 0)
            {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定技师" height:60 center:self.tableView.center superView:self.view];
                return ;
            }
            
            [selfWeak serviceSwitchWithStatus:@3];
        } three:^{
            // 备件
            if (self.bottomView.materialHelperTF.text.length == 0)
            {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定备件员" height:60 center:selfWeak.tableView.center superView:selfWeak.view];
                return ;
            }
            [selfWeak serviceSwitchWithStatus:@2];
        }];
    }
}



- (BOOL)isSaveViewWithIdx:(NSString *)idx {
    BOOL isSureView = NO;
    
    for (NSString *number in @[@"1",@"3",@"4",@"5",@"8"]) {
        if ([number isEqualToString:idx]) {
            isSureView = YES;
        }
    }
    return isSureView;
}

- (NSArray *)getStrArrWithIdex:(NSInteger)idex {
    switch (idex) {
        case 1:
            return @[@"保修审批？",@"确定",@"取消"];
            break;
        case 2:
            return @[@"进入保修审批流程？",@"直接让客户确认",@"先让保修员审批"];
            break;
        case 3:
            return @[@"进入客户确认流程？",@"确定",@"取消"];
            break;
        case 4:
            return @[@"进入备件确认流程？",@"确定",@"取消"];
            break;
        case 5:
            return @[@"进入技师流程？",@"确定",@"取消"];
            break;
        case 6:
            return @[@"直接让客户确认",@"先让备件确认"];
            break;
        case 7:
            return @[@"直接让客户确认",@"先让技师确认"];
            break;
        case 8:
            return @[@"进入保修审批流程？",@"确定",@"取消"];
            break;
        default:
            break;
    }
    return nil;
}

- (void)stepToGuaranteeStatusidx:(NSInteger)idex {
    
    
    BOOL isSaveView = [self isSaveViewWithIdx:[NSString stringWithFormat:@"%ld",idex]];
    
    NSArray *titleArr = [self getStrArrWithIdex:idex];
    WeakObject(self);
    if (isSaveView) {
        [HDNewSaveView showMakeSureViewAroundView:self.bottomView.techicianSurebt tittleArray:titleArr direction:UIPopoverArrowDirectionUp makeSure:^{
            if (idex == 3) {//客户
                [selfWeak sureToCustom];
            }else if (idex == 1 || idex == 8) {//保修
                [selfWeak serviceSwitchWithStatus:@4];
            }else if (idex == 4) {//备件
                // 备件
                if (selfWeak.bottomView.materialHelperTF.text.length == 0)
                {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定备件员" height:60 center:selfWeak.tableView.center superView:selfWeak.view];
                    return ;
                }
                [selfWeak serviceSwitchWithStatus:@2];
            }else if (idex == 5) {//技师
                
                if (selfWeak.bottomView.techicianTF.text.length == 0)
                {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定技师" height:60 center:selfWeak.tableView.center superView:self.view];
                    return ;
                }
                
                [selfWeak serviceSwitchWithStatus:@3];
            }
        } cancel:^{
            
        }];
    }else {
        [HDServiceDealView showMakeSureViewAroundView:self.bottomView.techicianSurebt direction:UIPopoverArrowDirectionUp titleArr:titleArr first:^{
            if (idex == 2 || idex == 6 || idex == 7) {//客户
                [self sureToCustom];
            }
        } second:^{
            if (idex == 2) {//保修
                [selfWeak serviceSwitchWithStatus:@4];
            }else if (idex == 6) {//备件
                
                // 备件
                if (selfWeak.bottomView.materialHelperTF.text.length == 0)
                {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定备件员" height:60 center:selfWeak.tableView.center superView:selfWeak.view];
                    return ;
                }
                
                [selfWeak serviceSwitchWithStatus:@2];
            }else if (idex == 7) {//技师
                
                if (selfWeak.bottomView.techicianTF.text.length == 0)
                {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未指定技师" height:60 center:selfWeak.tableView.center superView:self.view];
                    return ;
                }
                [selfWeak serviceSwitchWithStatus:@3];
            }
        }];
    }
    
}

//让客户确认 /并跳转
- (void)sureToCustom {
    WeakObject(self);
    if (![self.carMessage isHasWofinishtime]) {
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未填写预计交车时间" height:60 center:self.tableView.center superView:self.view];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    [PorscheRequestManager orderSureToNextOrder:4 buttonid:0 Complete:^(NSInteger status,PResponseModel *responser) {
        [hud hideAnimated:YES];
        
        if (status == 100) {//开单成功
        
            selfWeak.carMessage.orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
            [HDLeftSingleton shareSingleton].carModel = selfWeak.carMessage;
            NSInteger number = [selfWeak.carMessage.orderstatus.skipstep integerValue];
            if (number > 0  && number != 4 && number < 6) {//跳转
            
                [selfWeak hasNotPermissionPermissionCode:HDOrder_Kehuqueren left:HDLeftStatusStyleBilling right:number - 1 maxStatus:5];

            }else {
                [selfWeak saveActionNew];
            }

        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:HD_FULLView];
 
        }
        
    }];
}

//1:等待车间确认  2：等待备件确认 3：等待增项确认 4：等待保修确认 5: 保修审批 // 自定义code
- (void)serviceSwitchWithStatus:(NSNumber *)code {
    WeakObject(self);
    
    
//    [_stateserice  isEqual: @0] && [_stateguarantee  isEqual:@1]
    
    void(^complete)(NSInteger status,PResponseModel *responser) = ^(NSInteger status, PResponseModel * _Nonnull responser) {
        if (status == 100) {
            selfWeak.carMessage.orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
            [HDLeftSingleton shareSingleton].carModel = selfWeak.carMessage;
            
            
            
            switch ([selfWeak.carMessage.orderstatus.skipstep integerValue]) {//0：当前页面   1：开单  2：技师增项  3：备件确认  4：服务沟通 5：客户确认
                case 1:
                    [selfWeak hasNotPermissionPermissionCode:HDOrder_Kaidan left:HDLeftStatusStyleBilling right:HDRightStatusStyleBilling maxStatus:4];
                    break;
                case 2:
                    [selfWeak hasNotPermissionPermissionCode:HDOrder_Jishizengxiang left:HDLeftStatusStyleSchemeLeft right:HDRightStatusStyleTechician maxStatus:4];
                    
                    break;
                case 3:
                    [selfWeak hasNotPermissionPermissionCode:HDOrder_Beijianqueren left:HDLeftStatusStyleBilling right:HDRightStatusStyleMaterial maxStatus:4];
                    
                    break;
                case 5:
                    [selfWeak hasNotPermissionPermissionCode:HDOrder_Kehuqueren left:HDLeftStatusStyleBilling right:HDRightStatusStyleCustom maxStatus:5];
                    
                    break;
                default:
                    [selfWeak saveActionNew];
                    [selfWeak getOrderList];
                    break;
            }
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:HD_FULLView];
        }
        
    };
    
    
    
    if ([code isEqualToNumber:@5])
    {
        [PorscheRequestManager insuranceConfirmComplete:complete];
    }
    else
    {
        [PorscheRequestManager waitConfirmWithStatus:code complete:complete];
    }
}

//根据权限  停留或者跳转  本界面 刷新
- (void)hasNotPermissionPermissionCode:(NSInteger)code left:(HDLeftStatusStyle)leftStyle right:(HDRightStatusStyle)rightStyle maxStatus:(NSInteger)maxStatus {
    [HDLeftSingleton shareSingleton].maxStatus = maxStatus;

    [self sendNotifinationToLeftToReloadDataType:@1];
    
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:code]) {
        [self saveActionNew];
    }else {
        [HDStatusChangeManager changeStatusLeft:leftStyle right:rightStyle];
    }
}

- (void)showGuaranteeViewAction {
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_FuWuGouTong_BaoXiuShenPi]) {//没有保修审批权限
        [self saveActionNew];
    }else {
        UIView *superView = [HDLeftSingleton shareSingleton].rightBaseView;
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"请审批保修" height:60 center:superView.center superView:superView];
    }
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
                [selfWeak saveActionWithAlert];
                [selfWeak getOrderList];
            }else {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:self.tableView.center superView:self.view];
            }
        }];
    }else {
        
        if ([HDLeftSingleton isUserOrder]) {//自己的单子
            if ([HDPermissionManager isNotThisPermission:HDOrder_FuWuGouTong_Edit]) {
                return;
            }
        }else {//不是自己的单子
            if ([HDPermissionManager isNotThisPermission:HDOrder_FuWuGouTong_OtherAdd_CanChange]) {
                return;
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
//            [selfWeak getOrderList];
            
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


- (void)saveActionWithAlert {//
    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"save_already_billing.png"] message:@"已保存" height:60 center:self.tableView.center superView:self.view];
    [self saveActionNew];
    
}
- (void)saveActionNew {
    [self.bottomView setSaveLbTittleAndImgBool:YES];
    self.saveStatus = @1;
    [self.tableView reloadData];
}

- (void)editAction {
    [self.bottomView setSaveLbTittleAndImgBool:NO];
    self.saveStatus = @0;
    [self.tableView reloadData];
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
                if ([cubScheme.wosisconfirm integerValue] == 2) {
                    return cubScheme.projectList.count + 1;
                }
                return cubScheme.projectList.count + 3;//[cubScheme.schemetype isEqualToNumber:@3] ? cubScheme.projectList.count + 3: cubScheme.projectList.count + 2;
            }
        }else {
            return 0;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    
    return  [self getHeaderViewWithTableView:tableView section:section];
    
}

#pragma mark  ------项目区头------
- (UIView *)getHeaderViewWithTableView:(UITableView *)tableView section:(NSInteger)section {
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

#pragma mark  ------自定义项目区头------
- (UIView *)getCustomHeaderViewWith:(UITableView *)tableView section:(NSInteger)section model:(PorscheNewScheme *)model{
    
    HDWorkListTVHFViewOneNormal *singleItemHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HDWorkListTVHFViewOneNormal"];
    singleItemHeaderView.contentView.backgroundColor = [UIColor clearColor];
    if (!singleItemHeaderView) {
        
        singleItemHeaderView = [[HDWorkListTVHFViewOneNormal alloc]initWithCustomFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 51)];
    }
    singleItemHeaderView.saveStatus = _saveStatus;
    if ([model.wosisconfirm integerValue] == 2) {
        singleItemHeaderView.saveStatus = @1;
    }
    singleItemHeaderView.tmpModel = model;
    if (![HDLeftSingleton isUserAdded:model.schemeaddperson]) {
        singleItemHeaderView.deleteBt.hidden = YES;
        singleItemHeaderView.deleteSuperBt.hidden = YES;
        singleItemHeaderView.chooseBgView.hidden = NO;
        singleItemHeaderView.chooseBt.hidden = NO;

    }else {
        if ([singleItemHeaderView.saveStatus integerValue] == 1) {
            singleItemHeaderView.deleteSuperBt.hidden = YES;
            singleItemHeaderView.deleteBt.hidden = YES;
            singleItemHeaderView.chooseBt.hidden = NO;
        }else {
            
            if ([model.wosisconfirm integerValue] == 0) {
                singleItemHeaderView.deleteBt.hidden = YES;
                singleItemHeaderView.deleteSuperBt.hidden = YES;
                singleItemHeaderView.chooseBt.hidden = NO;
            }else {
                singleItemHeaderView.deleteSuperBt.hidden = NO;
                singleItemHeaderView.deleteBt.hidden = NO;
                singleItemHeaderView.chooseBt.hidden = YES;
            }
            
//            singleItemHeaderView.deleteSuperBt.hidden = NO;
//            singleItemHeaderView.deleteBt.hidden = NO;
//            singleItemHeaderView.chooseBt.hidden = YES;

        }
//        singleItemHeaderView.chooseBgView.hidden = YES;
    }
    
    singleItemHeaderView.delegate = self;
    //是否显示或者隐藏 所属分类的工时和备件
    WeakObject(self);
    
    // 保修审批设置
    //  方案不是保修申请状态和保修确认状态
    if ([model.wosisguarantee integerValue] == 1 )
    {
        // 如果有保修审批权限
        if (![HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_FuWuGouTong_BaoXiuShenPi])
        {
                // 可进行保修审批
                [singleItemHeaderView  guranteeShenPiStatus];
        }
        
    }
    //选择
    singleItemHeaderView.chooseBtBlock = ^(UIButton *sender) {
        [selfWeak chooseActionWithSchemws:model scheme:model view:sender type:@3];
    };
    
    singleItemHeaderView.shadowBlock = ^(UIButton *button,PorscheNewScheme *tmpModel) {
        [selfWeak setTableViewHeaderGiddenStatus:tmpModel];
    };
        //保修
    singleItemHeaderView.guaranteeViewblock = ^(UIButton *guarantee) {
        [selfWeak guaranteeViewActionWithTableView:tableView cell:nil Model:model button:guarantee];
        
    };
    
    singleItemHeaderView.updateLevelBlock = ^(UIButton *button) {
        NSArray *array = [selfWeak getNeededLevelWithScheme:model];
        [HDLeftCustomItemView showCustomViewWithModelArray:array aroundView:button direction:UIPopoverArrowDirectionDown complete:^(PorscheConstantModel *tmp) {
            [selfWeak updateSchemeLevel:model.schemeid levelid:tmp.cvsubid];
        }];
    };
    //编辑方案名称
    singleItemHeaderView.editBlock = ^(NSString *text) {
        PorscheNewScheme *scheme = [PorscheNewScheme new];
        scheme.wosstockid = model.wosstockid;
        scheme.schemename = text;
        [selfWeak editCustomProjectnameScheme:scheme];
    };

    singleItemHeaderView.longPressBlock = ^() {
        [selfWeak showSchemeDetialWithScheme:model];
    };
    return singleItemHeaderView;
}

#pragma mark  ------自定义区头代理--删除------

- (void)didSelectedView:(HDWorkListTVHFViewOneNormal *)view ofButton:(UIButton *)deleteBt model:(PorscheNewScheme *)tmpModel {
    WeakObject(self);
    
//    [HDPoperDeleteView showAlertViewAroundView:deleteBt titleArr:@[@"确定取消",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
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
                [selfWeak chooseBtWithid:tmpModel.schemeid type:@3 isChoose:@0];
                break;
            default:
                break;
        }
    }];
    
    //取消开单原因
    /*
    [HDCancelBillingView showCancelViewBlock:^(NSString *reasonString) {
        
    }];
     */
}



#pragma mark  ------一般方案库区头------
- (UIView *)getNormalHeaderViewWith:(UITableView *)tableView section:(NSInteger)section model:(PorscheNewScheme *)model {
    HDWorkListTVHFViewNormal *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HDWorkListTVHFViewNormal"];
    view.contentView.backgroundColor = [UIColor clearColor];
    if (!view) {
        view = [[HDWorkListTVHFViewNormal alloc]initWithCustomFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    }
    
    view.isGuarantee = YES;
    view.saveStatus = _saveStatus;
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
        if ([view.saveStatus integerValue] == 1) {
            view.deleteSuperBt.hidden = YES;
            view.deleteBt.hidden = YES;
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
//            view.deleteSuperBt.hidden = NO;
//            view.deleteBt.hidden = NO;
        }
//        view.chooseSuperView.hidden = YES;
    }
    
    view.headerLb.text = model.schemename;
    view.delegate = self;
    
    //  方案不是保修申请状态和保修确认状态
    if ([model.wosisguarantee integerValue] == 1)
    {
        // 如果有保修审批权限
        if (![HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_FuWuGouTong_BaoXiuShenPi])
        {
            // 就设置
            [view guranteeShenPiStatus];
        }
        
    }
    
    WeakObject(self);
    WeakObject(view);
    view.confirmActionBlock = ^(UIButton *button){
        [selfWeak chooseActionWithSchemws:model scheme:model view:button type:@3];
    };
    //保修弹窗
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


#pragma mark  其他项目区头代理方法--删除----
- (void)didSelectedView:(HDWorkListTVHFViewNormal *)view ofBt:(UIButton *)deleteBt model:(PorscheNewScheme *)tmpModel{
    WeakObject(self);
    
//    [HDPoperDeleteView showAlertViewAroundView:deleteBt titleArr:@[@"确定取消",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
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
                [selfWeak chooseBtWithid:tmpModel.schemeid type:@3 isChoose:@0];
                break;
            default:
                break;
        }
    }];
    
    //取消开单原因
    /*
     [HDCancelBillingView showCancelViewBlock:^(NSString *reasonString) {
     
     }];
     */
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    PorscheNewScheme *cubScheme = self.dataArray[indexPath.section];
    
    WeakObject(tableView);
#pragma mark  自定义项目相关cell
    
    if ([cubScheme.schemetype isEqualToNumber:@3]) {
        // 非最后一行（非添加配件行）
        
        if (cubScheme.projectList.count >indexPath.row) {
            
            
            PorscheNewSchemews *model = [cubScheme.projectList objectAtIndex:indexPath.row];
            WeakObject(model);
            if ([model.schemesubtype integerValue] == 1) {
                //工时cel
                UITableViewCell *cell = [self getCustomItemTimeCell:tableViewWeak model:modelWeak indexpath:indexPath];
                return cell;
                
            }else//新增配件cell
            {
                UITableViewCell *cell = [self getAddMaterialCellWith:tableView indexPath:indexPath model:modelWeak];
                return cell;
                
            }
            
        }else if (cubScheme.projectList.count == indexPath.row) {//自定义项目
            
            
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
                //添加工时Cell
                UITableViewCell *cell = [self getCustomItemTimeCell:tableViewWeak model:nil indexpath:indexPath];
                return cell;
            }
        }else if (cubScheme.projectList.count + 1 == indexPath.row) {
            
            UITableViewCell *cell = [self getAddMaterialCellWith:tableView indexPath:indexPath model:nil];
            return cell;
        }else {
            //备注行cell
            UITableViewCell *cell = [self getRemarkCellWith:tableView indexPath:indexPath];
            return cell;
        }
#pragma mark  方案库项目相关cell
    }else {
        if (cubScheme.projectList.count > indexPath.row) {
            
            PorscheNewSchemews *indexModel = [cubScheme.projectList objectAtIndex:indexPath.row];
            
            //工时cell
            WeakObject(indexModel);
            if ([indexModel.schemesubtype isEqualToNumber:@1]) {
                
                
//                if ([indexModel.schemewstype integerValue] == 2)
//                {
                    //工时cel
                    UITableViewCell *cell = [self getCustomItemTimeCell:tableViewWeak model:indexModelWeak indexpath:indexPath];
                    return cell;
//                }
//                else
//                {
//                    UITableViewCell *cell = [self getitemTimeCellWith:tableView indexPath:indexPath model:indexModelWeak sectionModel:cubScheme];
//                    return cell;
//                }
                

            }
            
            //新增配件cell
            if ([indexModel.schemewstype integerValue] != 1) {
                
//                if ([indexModel.projectaddstatus integerValue] == 3) {// 服务自己加的
                    UITableViewCell *cell = [self getAddMaterialCellWith:tableView indexPath:indexPath model:indexModelWeak];
                    return cell;
                    
//                }
//                else {
                    //配件cell
//                    UITableViewCell *cell = [self getMaterialCellWith:tableView indexPath:indexPath model:indexModelWeak cubScheme:cubScheme];
//                    return cell;
//                    NSLog(@"不是自己加的");
//                }
            }
            
#pragma mark 备件可以修改名称
            UITableViewCell *cell = [self getAddMaterialCellWith:tableView indexPath:indexPath model:indexModelWeak];
            return cell;
            //配件cell
//            UITableViewCell *cell = [self getMaterialCellWith:tableView indexPath:indexPath model:indexModelWeak cubScheme:cubScheme];
//            return cell;
            
        }
        else if(cubScheme.projectList.count == indexPath.row)
        {
                //工时
            if ([_saveStatus integerValue] == 1)
            {
                //备注行
                UITableViewCell *cell = [self getRemarkCellWith:tableViewWeak indexPath:indexPath];
                return cell;

            }
            else
            {
                //添加工时Cell
                UITableViewCell *cell = [self getCustomItemTimeCell:tableViewWeak model:nil indexpath:indexPath];
                return cell;
            }
        }
        else if ((cubScheme.projectList.count +1) == indexPath.row) {
                
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
                    //添加配件Cell
                    UITableViewCell *cell = [self getAddMaterialCellWith:tableView indexPath:indexPath model:nil];
                    return cell;
                }
            }else if (cubScheme.projectList.count < indexPath.row) {
                //备注行cell
                UITableViewCell *cell = [self getRemarkCellWith:tableView indexPath:indexPath];
                return cell;
            }
    }
    
       return nil;
}

#pragma mark  自定义项目工时行cell
- (UITableViewCell *)getCustomItemTimeCell:(UITableView *)tableView model:(PorscheNewSchemews *)model indexpath:(NSIndexPath *)indexPath {
    WeakObject(self)
    // 工时
    HDServiceSingleItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDServiceSingleItemTableViewCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[HDServiceSingleItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HDServiceSingleItemTableViewCell"];
    }
    
    PorscheNewScheme *scheme = self.dataArray[indexPath.section];
    if (model) {
        model.superschemesettlementway = scheme.wossettlement;
    }
    cell.saveStatus = _saveStatus;
    //编辑工时的权限
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeTime]) {
        cell.saveStatus = @1;
    }
    if ([scheme.wosisconfirm integerValue] == 2) {
        cell.saveStatus = @1;
    }
    
    cell.tmpModel = model;
    
    //  方案不是保修申请状态和保修确认状态
    if ([scheme.wosisguarantee integerValue] != 1 && [scheme.wosisguarantee integerValue] != 2)
    {
        // 如果有保修审批权限
        if (![HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_FuWuGouTong_BaoXiuShenPi])
        {
            // 如果是保修申请状态
            if ([model.schemeswswarrantyconflg integerValue] == 1)
            {
                // 可进行保修审批
                [cell guranteeShenPiStatus];
            }
        }

    }
    
       [cell layoutIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell点击 回调
    WeakObject(cell)
    //保修，折扣事件
    cell.guaranteeViewBlock = ^(UIButton *button) {
        //保修
        if (button.tag == 1) {
            if (model) {

            [selfWeak guaranteeViewActionWithTableView:tableView cell:cellWeak Model:model button:button];
            }
        }else {
            [selfWeak discountViewActionWithTableView:tableView cell:cellWeak Model:model button:button];
        }
    };
    
    //工时行 1.输入内容添加model
    cell.addedreturnBlock = ^(PorscheNewSchemews *schemews) {
        if (!model) {//空白添加时，获取坐在方案id
            schemews.wospwosid = scheme.schemeid;
        }
        [selfWeak editWorkHourOrMaretialWithSchemews:schemews type:kWorkType];
    };
    
    
    
    //工时行 1.添加工时按钮 2.修改工时内容 3.进入工时库添加工时 4.删除新增工时
    cell.hDServiceSingleItemTableViewCellBlock = ^(HDServiceSingleItemTableViewCellStyle style,UIButton *sender) {
        //维修按钮--添加工时
        if (style == HDServiceSingleItemTableViewCellStyleRepair) {
            [selfWeak upDateProjectMaterialTestWithAddedType:kAddition schemeid:scheme.schemeid type:kWorkType source:kCustomScheme stockid:nil];
        //普通输入框
        }else if (style == HDServiceSingleItemTableViewCellStyleTF) {
            //删除按钮
        }else if (style == HDServiceSingleItemTableViewCellStyleChoose) {
            if ([model.schemewstype integerValue] == 1 || ![HDLeftSingleton isUserAdded:model.projectaddid]) {//不是自己加的
                [selfWeak chooseActionWithSchemws:model scheme:scheme view:cellWeak.chooseBt type:@1];
            }else {
                [HDPoperDeleteView showAlertViewAroundView:cellWeak.chooseBt titleArr:@[@"确定删除",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
                    [selfWeak upDateProjectMaterialTestWithAddedType:kDeletion schemeid:model.wospwosid type:kWorkType source:kCustomScheme stockid:@[model.schemewsid]];
                    
                } refuse:^{
                    
                } cancel:^{
                    
                }];
            }
            //工时输入框事件
        }else if (style ==HDServiceSingleItemTableViewCellStyleItemTimeTF) {
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
            

        }else if (style == HDServiceSingleItemTableViewCellStyleReturn) {
           
        }
    };
    
    return cell;
    
}


#pragma mark  工时行cell
- (UITableViewCell *)getitemTimeCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(PorscheNewSchemews *)model sectionModel:(PorscheNewScheme *)cubScheme{
    HDServiceItemTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDServiceItemTimeTableViewCell" forIndexPath:indexPath];
    //给配件赋值 所属方案的自费状态，内结或者保修
    PorscheNewScheme *scheme = self.dataArray[indexPath.section];
    model.superschemesettlementway = scheme.wossettlement;
    cell.saveStatus = _saveStatus;
    //编辑工时的权限
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeTime]) {
        cell.saveStatus = @1;
    }
    if ([scheme.wosisconfirm integerValue] == 2) {
        cell.saveStatus = @1;
    }
    cell.tmpModel = model;
    WeakObject(self);
    WeakObject(cell);
    
    //  方案不是保修申请状态和保修确认状态
    if ([scheme.wosisguarantee integerValue] != 1 && [scheme.wosisguarantee integerValue] != 2)
    {
        // 如果有保修审批权限
        if (![HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_FuWuGouTong_BaoXiuShenPi])
        {
            // 如果是保修申请状态
            if ([model.schemeswswarrantyconflg integerValue] == 1)
            {
                // 可进行保修审批
                [cell guranteeShenPiStatus];
            }
        }
        
    }
    //工时行 1.输入内容编辑工时
    cell.editWorkhourBlock = ^(PorscheNewSchemews *schemews) {
        
        [selfWeak editWorkHourOrMaretialWithSchemews:schemews type:kWorkType];
    };
    cell.guaranteeActionBlock = ^(UIButton *button) {
        //保修
        if (button.tag != 0) {
            [selfWeak guaranteeViewActionWithTableView:tableView cell:cellWeak Model:model button:button];
        //折扣
        }else {
            [selfWeak discountViewActionWithTableView:tableView cell:cellWeak Model:model button:button];
        }
    };
    
    cell.confirmActionBlock = ^(UIButton *button){
        [selfWeak chooseActionWithSchemws:model scheme:scheme view:button type:@1];

    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell layoutIfNeeded];
    return cell;
}


#pragma mark  配件行cell
- (UITableViewCell *)getMaterialCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(PorscheNewSchemews *)model cubScheme:(PorscheNewScheme *)cubScheme{
    //配件cell
    HDServiceMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDServiceMaterialTableViewCell" forIndexPath:indexPath];
    [cell layoutIfNeeded];
    //给配件赋值 所属方案的自费状态，内结或者保修
    PorscheNewScheme *scheme = self.dataArray[indexPath.section];
    model.superschemesettlementway = scheme.wossettlement;
    cell.saveStatus = _saveStatus;
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeMaterial]) {
        cell.saveStatus = @1;
    }
    if ([scheme.wosisconfirm integerValue] == 2) {
        cell.saveStatus = @1;
    }
    cell.tmpModel = model;
    
    
    //  方案不是保修申请状态和保修确认状态
    if ([scheme.wosisguarantee integerValue] != 1 && [scheme.wosisguarantee integerValue] != 2)
    {
        // 如果有保修审批权限
        if (![HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_FuWuGouTong_BaoXiuShenPi])
        {
            // 如果是保修申请状态
            if ([model.schemeswswarrantyconflg integerValue] == 1)
            {
                // 可进行保修审批
                [cell guranteeShenPiStatus];
            }
        }
        
    }
    
    WeakObject(self);
    WeakObject(cell);
    cell.guaranteeActionBlock = ^(UIButton *button) {
        //保修
        if (button.tag != 0) {

            [selfWeak guaranteeViewActionWithTableView:tableView cell:cellWeak Model:model button:button];
            
            //折扣
        }else {
            [selfWeak discountViewActionWithTableView:tableView cell:cellWeak Model:model button:button];
        }
    };
        
    cell.confirmActionBlock = ^(UIButton *button){
        [selfWeak chooseActionWithSchemws:model scheme:scheme view:button type:@2];
    };
    
    cell.editCountBlock = ^(PorscheNewSchemews *schemews) {
        if (schemews) {
            [selfWeak editWorkHourOrMaretialWithSchemews:schemews type:kMaterialType];
        }else {
            [selfWeak.tableView reloadData];
        }
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark  添加配件行cell
- (UITableViewCell *)getAddMaterialCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(PorscheNewSchemews *)model{
    
    HDServiceAddMaterailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDServiceAddMaterailTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PorscheNewScheme *scheme = self.dataArray[indexPath.section];
    if (model) {
        model.superschemesettlementway = scheme.wossettlement;
    }
    cell.saveStatus = _saveStatus;
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_InOrder_ChangeSelectScheme_EditSchemeMaterial]) {
        cell.saveStatus = @1;
    }
    if ([scheme.wosisconfirm integerValue] == 2) {
        cell.saveStatus = @1;
    }
    cell.tmpModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //  方案不是保修申请状态和保修确认状态
    if ([scheme.wosisguarantee integerValue] != 1 && [scheme.wosisguarantee integerValue] != 2)
    {
        // 如果有保修审批权限
        if (![HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_FuWuGouTong_BaoXiuShenPi])
        {
            // 如果是保修申请状态
            if ([model.schemeswswarrantyconflg integerValue] == 1)
            {
                // 可进行保修审批
                [cell guranteeShenPiStatus];
            }
        }
        
    }
    
    WeakObject(self);
    WeakObject(cell);
    
    cell.selectedBlock = ^(UIButton *sender,PorscheNewSchemews *schemews) {
        [selfWeak chooseActionWithSchemws:schemews scheme:scheme view:sender type:@2];
    };
    
    //备件行    //添加行键盘完成键事件
    cell.addedReturnBlock = ^(PorscheNewSchemews *schemews) {
        if (!model) {//空白添加时，获取所在方案id
            schemews.wospwosid = scheme.schemeid;
        }
        [selfWeak editWorkHourOrMaretialWithSchemews:schemews type:kMaterialType];
    };
    
    //保修，折扣事件
    cell.guaranteeBlock = ^(UIButton *button) {
        //保修
        if (button.tag == 1) {
            //如果是新增配件行，才能点击保修
            if (model) {
                [selfWeak guaranteeViewActionWithTableView:tableView cell:cellWeak Model:model button:button];
            }
        //折扣
        }else {
            [selfWeak discountViewActionWithTableView:tableView cell:cellWeak Model:model button:button];
        }
    };
    //添加按钮事件，删除按钮事件，备件弹窗事件
    cell.hDServiceAddMaterailTableViewCellBlock = ^(HDServiceAddMaterailTableViewCellStyle style,UIButton *sender) {
        //添加
        if (style == HDServiceAddMaterailTableViewCellStyleAdd) {
            [selfWeak upDateProjectMaterialTestWithAddedType:kAddition schemeid:scheme.schemeid type:kMaterialType source:kCustomScheme stockid:nil];

        //删除按钮
        }else if (style == HDServiceAddMaterailTableViewCellStyleChoose) {
            
            [HDPoperDeleteView showAlertViewAroundView:cellWeak.chooseBt titleArr:@[@"确定删除",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
                [selfWeak upDateProjectMaterialTestWithAddedType:kDeletion schemeid:scheme.schemeid type:kMaterialType source:kCustomScheme stockid:@[model.schemewsid]];

            } refuse:^{
                
            } cancel:^{
                
            }];
            
        }else if (style == HDServiceAddMaterailTableViewCellStyleTF) {
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

            [HDSchemewsView showHDSchemewsStyle:HDSchemewsViewStyleMaterial model:schemews withSupperVC:selfWeak needMatch:needMatch  addedBlock:^(HDSchemewsViewBlockStyle style) {
                if (style == HDSchemewsViewBlockStyleRefresh) {
                    [selfWeak getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
                }
            }];
            //其他输入框
        }else if (style == HDServiceAddMaterailTableViewCellStyleNormalTF) {

        }else if (style == HDServiceAddMaterailTableViewCellStyleReturn) {
            
        }
        
    };
    
    [cell layoutIfNeeded];
    return cell;
}

#pragma mark  备注行cell
- (UITableViewCell *)getRemarkCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    HDTechicianRemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDTechicianRemarkTableViewCell" forIndexPath:indexPath];
    WeakObject(self);
    PorscheNewScheme *cubScheme = self.dataArray[indexPath.section];
    cell.saveStatus = _saveStatus;
    if ([cubScheme.wosisconfirm integerValue] == 2) {
        cell.saveStatus = @1;
    }
    cell.tmpModel = cubScheme;
    
    cell.HDTechicianRemarkTableViewCellBlock = ^(HDTechicianRemarkTableViewCellStyle style,NSString *text) {
        switch (style) {
            case HDTechicianRemarkTableViewCellStylePhoto:
            {
                [PorschePhotoModelController getPhotoListCompletion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
                    if (responser.status == 100)
                    {
                        PorscheGalleryModel *model = [PorscheGalleryModel yy_modelWithDictionary:responser.object];
                        model.currentSchemeid = cubScheme.schemeid;
                        [selfWeak.modelController showPhotoGalleryWithModel:model viewType:PorschePhotoGalleryPreviewAndShoot];
                    }
                }];
            }
                break;
            case HDTechicianRemarkTableViewCellStyleTFReturn:
            {
                PorscheNewScheme *scheme = [PorscheNewScheme new];
                scheme.schemeid = cubScheme.schemeid;
                scheme.wosremark = text;
                [selfWeak editSchemeRemarkWithScheme:scheme];
                
            }
                break;
             case HDTechicianRemarkTableViewCellStyleCamera:
            {
                selfWeak.modelController.shootType = PorschePhotoCarImage;
                selfWeak.modelController.fileType = PorschePhotoGalleryFileTypeImage;
                selfWeak.modelController.keyType = PorschePhotoGalleryKeyTypeScheme;
                selfWeak.modelController.relativeid = cubScheme.schemeid;
                [selfWeak.modelController cycleTakePhoto:nil video:nil];
            }
                break;
            default:
                break;
        }
    };
    
    
    
    
    [cell layoutIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark  折扣弹窗
//1.目前折扣弹窗，是有数据的情况，
//2.添加行没数据，需要区分，逻辑<点击确定之后，新增一行配件，并且将添加的数据写入。>
- (void)discountViewActionWithTableView:(UITableView *)tableView cell:(UITableViewCell *)cell Model:(PorscheNewSchemews *)model button:(UIButton *)button {
    
    NSInteger permission;
    
    if ([model.schemesubtype integerValue] == 1) {
        
        permission = HDOrder_FuWuGouTong_SchemeTimeDiscount_Rate;
    }else {
        permission = HDOrder_FuWuGouTong_SchemeSpacePartDiscount_Rate;
    }
    
    if([HDPermissionManager isNotThisPermission:permission]) {
        return;
    }
    
    WeakObject(self);
    NSString *alertStr;
    //1 内结  2 保修  3 自费
    //条件，所属方案不为自费
    if (model) {
        if (![model.superschemesettlementway isEqualToNumber:@3]) {
            //内结还是保修
            if ([model.schemesettlementway isEqualToNumber:@2]) {
                alertStr = @"保修项目不能打折";
            }else {
                alertStr = @"内结项目不能打折";
            }
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:alertStr height:60 center:selfWeak.tableView.center superView:selfWeak.view];
            return;
        }else {
            if (![model.schemesettlementway isEqualToNumber:@3]) {
                if ([model.schemesettlementway isEqualToNumber:@2]) {
                    alertStr = @"保修项目不能打折";
                }else {
                    alertStr = @"内结项目不能打折";
                }
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:alertStr height:60 center:selfWeak.tableView.center superView:selfWeak.view];
                return;
            }
        }
    }else {
        NSIndexPath *idx = [tableView indexPathForCell:cell];
        PorscheNewScheme *scheme = self.dataArray[idx.section];
        
        if (![scheme.wossettlement isEqualToNumber:@3]) {
            if ([scheme.wossettlement isEqualToNumber:@2]) {
                alertStr = @"保修项目不能打折";
            }else {
                alertStr = @"内结项目不能打折";
            }
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:alertStr height:60 center:selfWeak.tableView.center superView:selfWeak.view];
            return;
        }else {
            return;
        }
    }
    
    //打折框
    NSString *price = model.schemewsunitprice_yuan ? [NSString stringWithFormat:@"%.2f",[model.schemewsunitprice_yuan floatValue]] : @"0.00";
    NSString *discount = model.schemewstdiscount ? [NSString stringWithFormat:@"%.2f",[model.schemewstdiscount floatValue] *100 ] : @"0.00";
    NSString *realPrice = model.schemewstotalprice ? [NSString stringWithFormat:@"%.2f",[model.schemewstotalprice floatValue]] : @"0.00";
    
    [HDDiscountView showDiscountViewWithPrice:price discount:discount discountPrice:[NSString stringWithFormat:@"%.2f",[model.schemewsunitprice_yuan floatValue] - [model.schemewstotalprice floatValue]] realPrice:realPrice sure:^(NSString *discount, NSString *discountPrice, NSString *realPrice, NSNumber *rangeId) {
        
        [selfWeak discountActionCondition:model rate:@([discount floatValue] /100) rangeid:rangeId];
        
    } withModel:model];
}

- (void)discountActionCondition:(PorscheNewSchemews *)schemews rate:(NSNumber *)rate rangeid:(NSNumber *)rangeid {
    
    WeakObject(self);
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    [PorscheRequestManager editDiscountWithSchemews:schemews rate:rate rangeid:rangeid complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
        [hud hideAnimated:YES];
        if (status != 100) {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:HD_FULLView];
        }else {
            [selfWeak getOrderList];
        }
    }];
}


#pragma mark  结算方式

- (void)guaranteeViewActionWithTableView:(UITableView *)tableView  cell:(UITableViewCell *)cell Model:(id)model button:(UIButton *)buttonDefault{
    
//    if ([HDPermissionManager isNotThisPermission:HDOrder_FuWuGouTong_JiesuanFangshi]) {
//        [self getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
//        return;
//    }
    
    WeakObject(self);
    NSArray *settleArr = [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataPayWay];
    PorscheConstantModel *settlementRepaired = settleArr[1];//保修结算方式
    /*          方案/工时备件  已设置    过结算方式     */
    if ([model isKindOfClass:[PorscheNewScheme class]]) {//方案
        PorscheNewScheme *scheme = model;
        if ([scheme.wosisguarantee integerValue] == 1) {//方案 红保
            
            [selfWeak confirmGuaranteeWithButton:buttonDefault model:model type:@2 settlement:settlementRepaired isneedRefresh:YES];
            return;
        }
    }else if ([model isKindOfClass:[PorscheNewSchemews class]]) {
        PorscheNewSchemews *schemews = model;
        if ([schemews.schemeswswarrantyconflg integerValue] == 1) {//红保
            
            [selfWeak confirmGuaranteeWithButton:buttonDefault model:model type:@1 settlement:settlementRepaired isneedRefresh:YES];
            return;
        }
        
    }
    /*          方案/工时备件  未设置    过结算方式     */
    if (!self.guaranteeView) {
        
        NSInteger idx = [self getSettleIdxWithSchemeModel:model modelArr:settleArr];
        
        self.guaranteeView = [[HDPoperDeleteView alloc]initWithGuaranteeChooseViewFrame:CGRectMake(0, 0, 240, 203) dataSource:settleArr idx:idx];
        selfWeak.guaranteeView.poperVC.delegate = self;
    }
    [HD_FULLView endEditing:YES];
    
    selfWeak.guaranteeView.guaranteeChooseView.guaranteeChooseViewBlock = ^(UIButton *button,NSInteger interger) {
        
        //工时，配件保修
        if ([model isKindOfClass:[PorscheNewSchemews class]]) {
            
            if (button.tag == 1) {//确定
                PorscheConstantModel *settlement = settleArr[interger];
                if ([settlement.cvvaluedesc isEqualToString:@"保修"]) {
                    if ([HDPermissionManager isNotThisPermission:HDOrder_FuWuGouTong_BaoXiuShenQing]) {
                        return;
                    }
                    //结算方式设置弹窗消失
                    [selfWeak.guaranteeView.poperVC dismissPopoverAnimated:YES];
                    selfWeak.guaranteeView = nil;
                    //进行 保修设置请求 不刷新
                    [selfWeak schemeSettleWithModel:model isset:YES type:@1 settle:settlement isNeedRefresh:NO view:buttonDefault];
                    
                    
                }else {//
                    if ([settlement.cvvaluedesc isEqualToString:@"内结"]) {
                        if ([HDPermissionManager isNotThisPermission:HDOrder_FuWuGouTong_XuanzeNeijie]) {
                            return;
                        }
                    }
                    [selfWeak schemeSettleWithModel:model isset:YES type:@1 settle:settlement isNeedRefresh:YES view:nil];
                    
                    [selfWeak.guaranteeView.poperVC dismissPopoverAnimated:YES];
                    selfWeak.guaranteeView = nil;
                }
                
            }else {
                [selfWeak.guaranteeView.poperVC dismissPopoverAnimated:YES];
                selfWeak.guaranteeView = nil;
            }
            //项目保修
        }else {
            //0.自费  1.保修  2.内结
            if (button.tag == 1) {//确定
                
                PorscheConstantModel *settlement = settleArr[interger];
                if ([settlement.cvvaluedesc isEqualToString:@"保修"]) {
                    if ([HDPermissionManager isNotThisPermission:HDOrder_FuWuGouTong_BaoXiuShenQing]) {
                        return;
                    }
                    [selfWeak.guaranteeView.poperVC dismissPopoverAnimated:YES];
                    selfWeak.guaranteeView = nil;
                    
                    //进行 保修设置请求 不刷新
                    [selfWeak schemeSettleWithModel:model isset:YES type:@2 settle:settlement isNeedRefresh:NO view:buttonDefault];
                    
                }else {
                    if ([settlement.cvvaluedesc isEqualToString:@"内结"]) {
                        if ([HDPermissionManager isNotThisPermission:HDOrder_FuWuGouTong_XuanzeNeijie]) {
                            return;
                        }
                    }
                    [selfWeak schemeSettleWithModel:model isset:YES type:@2 settle:settlement isNeedRefresh:YES view:buttonDefault];
                    [selfWeak.guaranteeView.poperVC dismissPopoverAnimated:YES];
                    selfWeak.guaranteeView = nil;
                }
                
            }else {
                [selfWeak.guaranteeView.poperVC dismissPopoverAnimated:YES];
                selfWeak.guaranteeView = nil;
            }
        }
        
    };
    [selfWeak.guaranteeView.poperVC presentPopoverFromRect:buttonDefault.bounds inView:buttonDefault permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    self.guaranteeView = nil;
    if ([popoverController isEqual:self.popVC]) {
        [self getOrderList];
    }
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

- (void)confirmGuaranteeWithButton:(UIButton *)button model:(id)model type:(NSNumber *)type settlement:(PorscheConstantModel *)settlementRepaired isneedRefresh:(BOOL)isneed{
    if ([HDPermissionManager isNotThisPermission:HDOrder_FuWuGouTong_BaoXiuShenPi]) {
        return;
    }
    WeakObject(self);
   self.popVC = [HDPoperDeleteView showAlertViewAroundView:button titleArr:@[@"同意保修",@"确认",@"拒绝",@"暂缓"] direction:UIPopoverArrowDirectionRight sure:^{
        [selfWeak schemeSettleWithModel:model isset:NO type:type settle:settlementRepaired isNeedRefresh:isneed view:nil];
        
    } refuse:^{
        NSArray *settleArr = [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataPayWay];
        
        PorscheConstantModel *settle = [selfWeak getSelfSettlementWithArray:settleArr];//获取自费的设置方式
        if (settle) {
            [selfWeak schemeSettleWithModel:model isset:YES type:type settle:settle isNeedRefresh:isneed view:nil];
        }
        
    } cancel:^{
        //如果是服务顾问  刚刚设置过的保修 需要刷新。
        if (isneed) {
            [selfWeak getOrderList];
        }
    }];
    self.popVC.delegate = self;
}
//model：数据源 isset：YES设置/NO审批  type:1.工时/备件  2.方案 settle：结算方式
- (void)schemeSettleWithModel:(id)model isset:(BOOL)isset type:(NSNumber *)type settle:(PorscheConstantModel *)settlement isNeedRefresh:(BOOL)isneed view:(UIButton *)button {
    WeakObject(self);
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    [PorscheRequestManager setsettleWithModel:model isset:isset addStatus:@2 type:type settle:settlement complete:^(NSInteger status, PResponseModel * _Nonnull responser){
        [hud hideAnimated:YES];
        if (status == 100) {
            if (isneed) {
                [selfWeak getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
            }else {
                // 保修设置成功 调用 审批弹窗
                if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_FuWuGouTong_BaoXiuShenPi]) {
                    [self getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
                    return;
                }
                [selfWeak confirmGuaranteeWithButton:button model:model type:type settlement:settlement isneedRefresh:YES];
            }
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
        }
    }];
}

- (PorscheConstantModel *)getSelfSettlementWithArray:(NSArray *)array {
    for (PorscheConstantModel *st in array) {
        if ([st.cvvaluedesc isEqualToString:@"自费"]) {
            return st;
        }
    }
    return nil;
}


#pragma mark  修改方案级别
- (void)updateSchemeLevel:(NSNumber *)schemeid levelid:(NSNumber *)levelid {
    WeakObject(self)
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    [PorscheRequestManager updateSchemeLevelWithSchemeId:schemeid levelid:levelid complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
        [hud hideAnimated:YES];
        if (status == 100) {
            [selfWeak getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
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

#pragma mark  ------lazy------

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


//空白占位图
- (UIButton *)emptyView {
    if (!_emptyView) {
        _emptyView = [UIButton buttonWithType:UIButtonTypeCustom];
        _emptyView.frame = self.view.frame;
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

#pragma mark  钩的点击事件------
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
        [selfWeak getWorkOrderListTestNeedSendNoti:NO schemeType:nil];
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

/****
 *  type:1. 刷新网络数据 2.刷新tableView
 ****/
- (void)sendNotifinationToLeftToReloadDataType:(NSNumber *)type {
    [[HDLeftSingleton shareSingleton] reloadLeftBillingList:type];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- 加载打印分类视图 ----
// 加载打印分类视图
- (void)loadPrintCategorysSelectViewWithPrintType:(SparePrintType)printType
{
    PorschePrintAffirmView *printView = [PorschePrintAffirmView showPrinAffirmViewAndComplete:^(NSArray *pays, NSInteger count) {
        //type 打印类型
        //count 打印份数
        // 进入打印页面
        // 获取打印pdf数据
        [self getPDFFileWithType:PDF_Quotation spareInfo:nil printType:printType printCategory:pays printCount:count];
        //        [self gotoPrintViewWithPrintType:pdftype];
    }];
    printView.titleLabel.text = @"打印";
    
    [HD_FULLView addSubview:printView];
}

@end
