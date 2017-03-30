//
//  HDRightViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/11.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDRightViewController.h"
#import "HDRightCustomVCHelper.h"
#import "HDPoperDeleteView.h"

#import "CustomBarItemView.h"
//右侧根视图

//预计交车日期
#import "HDWorkListDateChooseView.h"

#import "HWDateHelper.h"
#import "HDLeftListModel.h"

//单例
#import "HDLeftSingleton.h"
#import "RemarkListView.h"
//分享
#import "ServiceShareListView.h"
#import "HDSchemeRightViewController.h"

//服务档案(左侧)
//#import "HDServiceRecordsRightVC.h"
//在厂车辆全屏的时候右侧控制器
//#import "FullScreenLeftListForRightVC.h"

//判断是点击右上角按钮进入还是从主界面进入
typedef enum {
    IsForm_rightButton,//右上角按钮进图
    IsForm_home,//从主界面进入
}IsForm;




@interface HDRightViewController ()<UIPopoverControllerDelegate>
//barbuttonItem

//预计交车日期
//@property (nonatomic, strong) UIPopoverController *preTimePoperController;
//@property (nonatomic, strong) HDWorkListDateChooseView *customDateView;
//开单信息Item
@property (nonatomic, strong) NSArray *billingItemArray;
//技师增项Item
@property (nonatomic, strong) NSArray *techItemArray;
//备件确认
@property (nonatomic, strong) NSArray *materialSureArray;
//服务顾问
@property (nonatomic, strong) NSArray *serviceItemArray;
//客户确认
@property (nonatomic, strong) NSArray *customerItemArray;
//备件库
@property (nonatomic, strong) NSArray *materialCubArray;
//工时库
@property (nonatomic, strong) NSArray *itemTimeCubArray;
//方案库
@property (nonatomic, strong) NSArray *projectCubArray;
//在厂车辆右侧
@property (nonatomic, strong) NSArray *CarInFacItemArray;
//服务档案右侧
@property (nonatomic, strong) NSArray *HistoryItemArray;
@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) IsForm isFormStatus;
@end

@implementation HDRightViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"HDRightViewController.dealloc");
}

- (void)viewDidLayoutSubviews {
    self.headerView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 120);
    _vc.view.frame = _rect;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self changeBottomText];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [HDLeftSingleton shareSingleton].rightBaseView = self.view;
    
    [HDLeftSingleton shareSingleton].HDRightViewController = self;
    
    //默认显示的headerView
    self.headerView = [[TeachnicianAdditionItemHeaderView alloc]initWithCustomFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 120)];
    self.headerView.selectedCountLabel.text = @"共:0个方案";
    [self.view addSubview:self.headerView];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [self addNotifination];
    
    [self configNavitem];
    
    [self addVCAndView];
}

- (void)sendMessageToProject {

}

#pragma mark --- 当前工单提醒数量
- (void)setSingleCarNotice:(NSNumber *)number {
    CustomBarItemView *noticeView = [self getNoticeItem].customView;
    if ([number integerValue] > 0) {
        noticeView.label.hidden = NO;
        if ([number integerValue] >99) {
            noticeView.label.font = [UIFont systemFontOfSize:6];
            noticeView.label.text = [NSString stringWithFormat:@"%@+",number];
        }else {
            noticeView.label.font = [UIFont systemFontOfSize:7];
            noticeView.label.text = [NSString stringWithFormat:@"%@",number];
        }
    }
}

- (void)setRemark:(NSNumber *)number {
    CustomBarItemView *remarkView = [self getRemarkItem].customView;
    if ([number integerValue] == 0) {//未读
        remarkView.redView.hidden = NO;
        
        CGRect redPointFrame = remarkView.redView.frame;
        redPointFrame.origin.x = remarkView.bounds.size.width / 2 + 7;
        redPointFrame.origin.y = 6;
        remarkView.redView.frame = redPointFrame;
    }
}

- (UIBarButtonItem *)getRemarkItem {
    for (UIBarButtonItem *item in _serviceItemArray) {
        CustomBarItemView *view = item.customView;
        view.redView.hidden = YES;
    }
    UIBarButtonItem *remarkItem = _serviceItemArray[4];
//    switch ([HDLeftSingleton shareSingleton].stepStatus) {
//        case 1:
//        {
//            remarkItem = _billingItemArray[3];
//        }
//            break;
//        case 2:
//        {
//            remarkItem = _techItemArray[3];
//        }
//            break;
//        case 3:
//        {
//            remarkItem = _materialSureArray[3];
//        }
//            break;
//        case 4:
//        {
//            remarkItem = _serviceItemArray[4];
//        }
//            break;
//            
//        default:
//            break;
//    }
    return remarkItem;
}


- (UIBarButtonItem *)getNoticeItem {
    for (UIBarButtonItem *item in _serviceItemArray) {
        CustomBarItemView *view = item.customView;
        view.label.hidden = YES;
    }
    UIBarButtonItem *noticeItem = _serviceItemArray[3];
    /*
    switch ([HDLeftSingleton shareSingleton].stepStatus) {
        case 1:
        {
            noticeItem = _billingItemArray[2];
        }
            break;
        case 2:
        {
            noticeItem = _techItemArray[2];
        }
            break;
        case 3:
        {
            noticeItem = _materialSureArray[2];
        }
            break;
        case 4:
        {
            noticeItem = _serviceItemArray[3];
        }
            break;
        case 5:
        {
            noticeItem = _customerItemArray[3];
        }
            break;

        default:
            break;
    }
     */
    return noticeItem;
}


- (void)addNotifination {
    //右侧 流程图
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtAction:) name:CHANGE_RIGHT_STEP_NOTIFINATION object:nil];
    //技师增项已选项目
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSelectItemCount:) name:TECHICIANADDITION_SELECTED_NOTIFINATION object:nil];
    //方案库已添加提示
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertViewForAddedItem) name:ADDED_ITEM_NOTIFINATION object:nil];
    //从方案库备件库，工时库反回，调整返回按钮颜色 修改当前title
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBackItemColor:) name:BACK_FROM_MATERIAL_AND_ITEM_TIME_NOTIFINATION object:nil];
    //当保存工单时，预计交车时间，不可输入
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setheaderUserEnabled:) name:RIGHT_SAVE_LIST_NOTIFINATION object:nil];
    //点击车辆信息 改变顶部备注，提醒，服务档案的图标
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeItemColor:) name:BILLING_CAR_MESSAGE_NOTIFINATION object:nil];
    //顶部按钮的字体颜色
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBottomText) name:CHANGE_HEADER_BUTTON_TEXT_COLOR object:nil];
    
}

#pragma mark  ----入口 --------------------------加载需控制器------
//-----------------[dic[@"left"] integerValue]-------------------0.开单接车 1.提醒  2.方案库左侧  3设置     5.备件库 6.工时库 7.方案库 8.服务档案
- (void)addVCAndView {
    switch (_style) {
            //1.开单
        case ViewControllerEntryStyleBilling:
        {
            [self inputSetActionWithType:@0];

        }
            break;
            //1.在厂车辆
        case ViewControllerEntryStyleCarInFac:
        {
            [self inputSetActionWithType:@9];
            
            
        }
            break;
            //4.设置
        case ViewControllerEntryStyleSet:
            
            break;
            //8.服务档案
        case ViewControllerEntryStyleHistory:
            
        {
            self.isFormStatus = IsForm_home;
            [self inputSetActionWithType:@8];

        }
            
            break;
            //7.方案库
        case ViewControllerEntryStyleProject:
        {
            [self inputSetActionWithType:@7];

        }
            
            break;
            //2.提醒
        case ViewControllerEntryStyleNotice:
        {
            [self inputSetActionWithType:@([self getNoticeRightVC])];//需要和后台结合；

        }
            break;
            
        default:
            break;
    }
}

- (void)inputSetActionWithType:(NSNumber *)sender {
    
//    NSNotification *nottifination = [[NSNotification alloc]initWithName:@"leftBilling" object:@{@"left":@0,@"right":sender} userInfo:nil];
    
    [self changeBtAction:@{@"left":@0,@"right":sender}];
    
    
}

- (void)changeBackItemColor:(NSDictionary *)sender {
    [self changeBackItemImageLightgrayColor:NO];
    [self setupTitle];
}


- (void)setupTitle {
    NSString *title;
    switch ([HDLeftSingleton shareSingleton].stepStatus) {
        case 2:
            title = @"技师增项";
            break;
        case 3:
            title = @"备件确认";
            break;
        case 4:
            title = @"服务沟通";
            break;
        default:
            break;
    }
    
    self
    
    .navigationItem.title = title;
}
#pragma mark  ------流程切换 工时库，方案库------

- (void)changeBtAction:(NSDictionary *)dic {
//    NSDictionary *dic = sender.object;
    
    
    if (!dic) {
        dic = @{@"right":@(_stepStyle-1)};
    }
    //开单信息时，默认灰色且不可点击
    if ([dic[@"right"] isEqual:@0]) {
        if (![HDLeftSingleton shareSingleton].carModel) {
            [self setItemImageisGray:YES];
        }
    }else {
        [self setItemImageisGray:NO];
    }
    
    //服务沟通包含打折框
    if ([dic[@"right"] isEqual:@3]) {
        [self.headerView setupDiscountViewBool:YES];
    }else {
        [self.headerView setupDiscountViewBool:NO];
    }
    
    if ([dic[@"right"] isEqual:@0]) {//开单信息
        [self addVCWithStyle:TeachnicianAdditionItemHeaderViewStyleBilling withData:nil];
        //改变区头显示。。
        [self.headerView billingAction:self.headerView.billingBt];
        //更改流程状态值
        _stepStyle = HDRightViewControllerStyleStatusBilling;
        
        [HDLeftSingleton shareSingleton].stepStatus = _stepStyle;
        
        //
        [self changeBottomText];
        
        
        //返回按钮事件
        [self backBtActionWithNumber:dic[@"right"]];
        
    }else if ([dic[@"right"] isEqual:@1]) {//技师增项
        [self addVCWithStyle:TeachnicianAdditionItemHeaderViewStyleTechcian withData:nil];
        
        [self.headerView techcianAction:self.headerView.techcianAddtionBt];
        
        _stepStyle = HDRightViewControllerStyleStatusTechician;
        
        [HDLeftSingleton shareSingleton].stepStatus = _stepStyle;
        [self changeBottomText];

        //返回按钮事件
        [self backBtActionWithNumber:dic[@"right"]];
    }else if ([dic[@"right"] isEqual:@2]) {//备件确认
        [self addVCWithStyle:TeachnicianAdditionItemHeaderViewStyleMaterial withData:nil];
        [self.headerView materialAction:self.headerView.materialBt];
        
        _stepStyle = HDRightViewControllerStyleStatusMaterial;
        
        [HDLeftSingleton shareSingleton].stepStatus = _stepStyle;
        [self changeBottomText];

        //返回按钮事件
        [self backBtActionWithNumber:dic[@"right"]];
        
    }else if ([dic[@"right"] isEqual:@3]) {//服务沟通
        [self addVCWithStyle:TeachnicianAdditionItemHeaderViewStyleService withData:nil];
        [self.headerView serviceAction:self.headerView.serviceBt];
        _stepStyle = HDRightViewControllerStyleStatusService;
        [HDLeftSingleton shareSingleton].stepStatus = _stepStyle;
        [self changeBottomText];

        //返回按钮事件
        [self backBtActionWithNumber:dic[@"right"]];
        
    }else if ([dic[@"right"] isEqual:@4]) {//客户确认
        [self addVCWithStyle:TeachnicianAdditionItemHeaderViewStyleCustomSure withData:nil];
        [self.headerView customAction:self.headerView.customSureBt];
        _stepStyle = HDRightViewControllerStyleStatusCustom;
        [HDLeftSingleton shareSingleton].stepStatus = _stepStyle;
        [self changeBottomText];

        //返回按钮事件
        [self backBtActionWithNumber:dic[@"right"]];
        
    }else if([dic[@"right"] isEqual:@5]){//备件库
        [self addVCWithStyle:TeachnicianAdditionItemHeaderViewStyleMaterialCub withData:nil];
        //_stepStyle = HDRightViewControllerStatusStyleUnknow;

        [HDLeftSingleton shareSingleton].stepStatus = _stepStyle;

    }else if([dic[@"right"] isEqual:@6]){//工时库
        [self addVCWithStyle:TeachnicianAdditionItemHeaderViewStyleItemTimeCub withData:nil];
        //_stepStyle = HDRightViewControllerStatusStyleUnknow;

        [HDLeftSingleton shareSingleton].stepStatus = _stepStyle;

    }else if([dic[@"right"] isEqual:@7]){//方案库
        [self addVCWithStyle:TeachnicianAdditionItemHeaderViewStyleProjectCub withData:nil];
        //_stepStyle = HDRightViewControllerStatusStyleUnknow;

        [HDLeftSingleton shareSingleton].stepStatus = _stepStyle;

    }else if ([dic[@"right"] isEqual:@8]) {//服务档案
        [self addVCWithStyle:TeachnicianAdditionItemHeaderViewStyleServiceHistory withData:nil];
        //_stepStyle = HDRightViewControllerStatusStyleUnknow;

        [HDLeftSingleton shareSingleton].stepStatus = _stepStyle;

    }else if ([dic[@"right"] isEqual:@9]) {//在厂车辆
        [self addVCWithStyle:TeachnicianAdditionItemHeaderViewStyleCarInFactoryFull withData:dic[@"data"]];
        //_stepStyle = HDRightViewControllerStatusStyleUnknow;

//        [HDLeftSingleton shareSingleton].stepStatus = _stepStyle;

    }
}
#pragma mark  ------返回按钮逻辑------
- (void)backBtActionWithNumber:(NSNumber *)status {
    //返回按钮事件响应
    if ([HDLeftSingleton shareSingleton].isBack) {
        [HDLeftSingleton shareSingleton].isBack = NO;
    }else {
        if (![status isEqual:[HDLeftSingleton shareSingleton].statusArray.lastObject]) {
            [[HDLeftSingleton shareSingleton].statusArray addObject:status];

        }
        //首次显示
        if ([HDLeftSingleton shareSingleton].statusArray.count == 1) {
            [self changeBackItemImageLightgrayColor:YES];
        }
        NSLog(@"save_status_%@",status);
    }
}

- (void)addVCWithStyle:(TeachnicianAdditionItemHeaderViewStyle)style withData:(NSMutableArray *)dataSource {
    switch (style) {
            //开单信息
        case TeachnicianAdditionItemHeaderViewStyleBilling:
        {
            
            [self addVCWithType:TeachnicianAdditionItemHeaderViewStyleBilling navigationItemStr: @"开单信息" navigationItems:_billingItemArray needRemoveOldVC:YES withData:nil];
            [self changeBackItemImageLightgrayColor:NO];

        }
            break;
            
            //技师增项
        case TeachnicianAdditionItemHeaderViewStyleTechcian:
        {
            
            [self addVCWithType:TeachnicianAdditionItemHeaderViewStyleTechcian navigationItemStr: @"技师增项" navigationItems:_techItemArray needRemoveOldVC:YES withData:nil];
            [self changeBackItemImageLightgrayColor:NO];

            
        }
            
            break;
            //备件确认
        case TeachnicianAdditionItemHeaderViewStyleMaterial:
        {
            
            [self addVCWithType:TeachnicianAdditionItemHeaderViewStyleMaterial navigationItemStr: @"备件确认" navigationItems:_materialSureArray needRemoveOldVC:YES withData:nil];
            [self changeBackItemImageLightgrayColor:NO];

            
            
        }
            break;
            //服务沟通
        case TeachnicianAdditionItemHeaderViewStyleService:
            
            [self addVCWithType:TeachnicianAdditionItemHeaderViewStyleService navigationItemStr: @"服务沟通" navigationItems:_serviceItemArray needRemoveOldVC:YES withData:nil];
            [self changeBackItemImageLightgrayColor:NO];

            
            break;
            //客户确认
        case TeachnicianAdditionItemHeaderViewStyleCustomSure:
            
            [self addVCWithType:TeachnicianAdditionItemHeaderViewStyleCustomSure navigationItemStr:@"客户确认" navigationItems:_customerItemArray needRemoveOldVC:YES withData:nil];
            [self changeBackItemImageLightgrayColor:NO];

            
            break;
        case TeachnicianAdditionItemHeaderViewStylePreTime://预估时间
            
            
            break;
            //方案库
        case TeachnicianAdditionItemHeaderViewStyleProjectCub:
            
            [self addVCWithType:TeachnicianAdditionItemHeaderViewStyleProjectCub navigationItemStr:@"方案库" navigationItems:_projectCubArray needRemoveOldVC:NO withData:nil];
            [self changeBackItemImageLightgrayColor:YES];

            
            break;
            //备件库
        case TeachnicianAdditionItemHeaderViewStyleMaterialCub:
            
            [self addVCWithType:TeachnicianAdditionItemHeaderViewStyleMaterialCub navigationItemStr:@"备件库" navigationItems:_materialCubArray needRemoveOldVC:NO withData:nil];
            [self changeBackItemImageLightgrayColor:YES];

            break;
            //工时库
        case TeachnicianAdditionItemHeaderViewStyleItemTimeCub:
            
            [self addVCWithType:TeachnicianAdditionItemHeaderViewStyleItemTimeCub navigationItemStr:@"工时库" navigationItems:_itemTimeCubArray needRemoveOldVC:NO withData:nil];
            [self changeBackItemImageLightgrayColor:YES];

            
            break;
            //在厂车辆右侧
        case TeachnicianAdditionItemHeaderViewStyleCarInFactoryFull:
            
            [self addVCWithType:TeachnicianAdditionItemHeaderViewStyleCarInFactoryFull navigationItemStr:@"在厂车辆" navigationItems:_CarInFacItemArray needRemoveOldVC:NO withData:dataSource];
            [self changeBackItemImageLightgrayColor:YES];

            
            break;
            //服务档案
        case TeachnicianAdditionItemHeaderViewStyleServiceHistory:
            
            [self addVCWithType:TeachnicianAdditionItemHeaderViewStyleServiceHistory navigationItemStr:@"服务档案" navigationItems:_HistoryItemArray needRemoveOldVC:NO withData:nil];
            [self changeBackItemImageLightgrayColor:YES];

            break;
        default:
            break;
    }
}


- (void)changeBottomText {
    [self setTitleWithBt:self.headerView.billingBt idx:HDOrder_Kaidan];//开单
    [self setTitleWithBt:self.headerView.techcianAddtionBt idx:HDOrder_Jishizengxiang];//技师
    [self setTitleWithBt:self.headerView.materialBt idx:HDOrder_Beijianqueren];//备件
    [self setTitleWithBt:self.headerView.serviceBt idx:HDOrder_Fuwugoutong];//服务
    [self setTitleWithBt:self.headerView.customSureBt idx:HDOrder_Kehuqueren];//客户
}

- (void)setTitleWithBt:(UIButton *)button idx:(NSInteger)idx {

    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:idx]) {
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if ([HDLeftSingleton shareSingleton].stepStatus == idx - 102) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}


#pragma mark  改变item的颜色和交互
- (void)setItemImageisGray:(BOOL)isGray {
    UIBarButtonItem *noticeItem = _billingItemArray[2];
    CustomBarItemView *noticeView = noticeItem.customView;
    UIBarButtonItem *serviceItem = _billingItemArray[1];
    CustomBarItemView *serviceView = serviceItem.customView;
    UIBarButtonItem *markItem = _billingItemArray[3];
    CustomBarItemView *markView = markItem.customView;
    
    NSString *markStr = @"work_list_remark.png";
    NSString *noticeStr = @"work_list_notice_pic.png";
    NSString *serviceStr = @"work_list_time_pic.png";
    noticeView.button.userInteractionEnabled = YES;
    serviceView.button.userInteractionEnabled = YES;
    markView.button.userInteractionEnabled = YES;
    if (isGray) {
        noticeStr = @"work_list_notice_pic_gray.png";
        serviceStr = @"work_list_time_pic_gray.png";
        markStr = @"work_list_remark_gray.png";
        noticeView.button.userInteractionEnabled = NO;
        serviceView.button.userInteractionEnabled = NO;
        markView.button.userInteractionEnabled = NO;

    }
    [serviceView.button setImage:[UIImage imageNamed:serviceStr] forState:UIControlStateNormal];
     [noticeView.button setImage:[UIImage imageNamed:noticeStr] forState:UIControlStateNormal];
    [markView.button setImage:[UIImage imageNamed:markStr] forState:UIControlStateNormal];
}

#pragma mark  接收车辆被点击的通知。更改右侧开单中顶部，备注，提醒，服务档案图标
- (void)changeItemColor:(NSDictionary *)noti {
    PorscheNewCarMessage *carModel = [HDLeftSingleton shareSingleton].carModel;
    if (carModel) {
        [self setItemImageisGray:NO];
    }else {
        [self setItemImageisGray:YES];
    }
    
    self.navigationItem.rightBarButtonItems = _billingItemArray;
    
    
}

#pragma mark  ------设置区头 车辆信息------
- (void)setSelectItemCount:(NSDictionary *)noti
{
    PorscheNewCarMessage *carMessage = noti[@"carmessage"];
    self.headerView.carNewModel = carMessage;
}

- (void)hiddenKeyBoard {
    
    [self.view endEditing:YES];
}


#pragma mark  ------顶部按钮事件------

//添加导航栏按钮
- (void)configNavitem {
    CGRect rect = CGRectMake(0, 0, 40, 40);
    __weak typeof(self) selfWeak = self;
    //备注按钮
    CustomBarItemView *detialView = [[CustomBarItemView alloc]initWithFrame:rect];
    [detialView.button setImage:[UIImage imageNamed:@"work_list_remark.png"] forState:UIControlStateNormal];
    //添加按钮
    CustomBarItemView *addView = [[CustomBarItemView alloc]initWithFrame:rect];
    [addView.button setImage:[UIImage imageNamed:@"work_list_add_item.png"] forState:UIControlStateNormal];
    //通知按钮
    CustomBarItemView *noticeView = [[CustomBarItemView alloc]initWithFrame:rect];
    [noticeView.button setImage:[UIImage imageNamed:@"work_list_notice_pic.png"] forState:UIControlStateNormal];
    //历史
    CustomBarItemView *historyView = [[CustomBarItemView alloc]initWithFrame:rect];
    [historyView.button setImage:[UIImage imageNamed:@"work_list_time_pic.png"] forState:UIControlStateNormal];
    //全部按钮
    CustomBarItemView *allitemView = [[CustomBarItemView alloc]initWithFrame:rect];
    [allitemView.button setImage:[UIImage imageNamed:@"work_list_all_bt.png"] forState:UIControlStateNormal];
    //分享
    CustomBarItemView *shareItemView = [[CustomBarItemView alloc]initWithFrame:rect];
    [shareItemView.button setImage:[UIImage imageNamed:@"hd_right_item_share_pic.png"] forState:UIControlStateNormal];
    //回退按钮
    CustomBarItemView *backItemView = [[CustomBarItemView alloc]initWithFrame:rect];
    
    [backItemView.button setImage:[UIImage imageNamed:@"right_Back_item_pic_black.png"] forState:UIControlStateNormal];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof (detialView) weakDetailView = detialView;
    //备注列表
    detialView.buttonBlock = ^(UIButton *sender) {
        [weakSelf getRemarkListFromView:weakDetailView];
    };
    WeakObject(noticeView);
    noticeView.buttonBlock = ^(UIButton *sender) {
        
        noticeViewWeak.label.hidden = YES;
        
        [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleNotice right:[selfWeak getNoticeRightVC]];

        
//        [[NSNotificationCenter defaultCenter] postNotificationName:SINGLE_CAR_NOTIFICATION object:nil];
        [[HDLeftSingleton shareSingleton] singleCarNotice:nil];
    };
    //新开单
    addView.buttonBlock = ^(UIButton *sender) {
        if ([HDPermissionManager isNotThisPermission:HDOrder_KaiDan_BuiltNewOrder]) {
            return;
        } ;

        [HDLeftSingleton shareSingleton].carModel = nil;
        [HDLeftSingleton shareSingleton].isHiddenTF = NO;
        
        [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleBilling right:HDRightStatusStyleBilling];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:NEW_BILLING_CAR_NOTIFINAITON object:nil];
            [[HDLeftSingleton shareSingleton] createNewCarMessage];
        });
//        [selfWeak sendMessageToProject];
    };
    
    
    //服务档案
    historyView.buttonBlock = ^(UIButton *sender) {
        weakSelf.isFormStatus = IsForm_rightButton;
        [[HDLeftSingleton shareSingleton] changeWorkFlowWithInfo:@{@"left":@8,@"right":@8}];
//        [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_RIGHT_STEP_NOTIFINATION object:@{@"left":@8,@"right":@8}];
    };
    allitemView.buttonBlock = ^(UIButton *sender) {
        [AlertViewHelpers setAlertViewWithViewController:selfWeak button:sender];
    };
    shareItemView.buttonBlock = ^(UIButton *sender) {
//        if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share]) {
//            return;
//        }
        CGRect rect = [sender convertRect:sender.bounds toView:KEY_WINDOW];
        ServiceShareListView *shareList = [ServiceShareListView viewFromXibWithItemRect:rect Item:0];
        
        shareList.frame = KEY_WINDOW.bounds;
        
        [HD_FULLView addSubview:shareList];
    };
    
    //回退按钮事件
    backItemView.buttonBlock = ^(UIButton *button){
        [selfWeak clickbackItem];
    };
    //备注
    UIBarButtonItem *markitem = [[UIBarButtonItem alloc]initWithCustomView:detialView];
    //新建
    UIBarButtonItem *createitem = [[UIBarButtonItem alloc]initWithCustomView:addView];
    //提醒
    UIBarButtonItem *noticeitem = [[UIBarButtonItem alloc]initWithCustomView:noticeView];
    //单车提醒
    UIBarButtonItem *singleNoticeitem = [[UIBarButtonItem alloc]initWithCustomView:historyView];
    //全部
//    UIBarButtonItem *item4 = [[UIBarButtonItem alloc]initWithCustomView:allitemView];
    //分享
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithCustomView:shareItemView];
    //回退按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backItemView];
    
    _billingItemArray = @[backItem,singleNoticeitem,noticeitem,markitem,createitem];
    _techItemArray = @[backItem,singleNoticeitem,noticeitem,markitem,createitem];
    _materialSureArray = @[backItem,singleNoticeitem,noticeitem,markitem];
    _serviceItemArray = @[backItem,shareItem,singleNoticeitem,noticeitem,markitem,createitem];
    _customerItemArray = @[backItem,shareItem,singleNoticeitem,noticeitem];
    _materialCubArray = @[backItem,singleNoticeitem,noticeitem,markitem,createitem];
    _itemTimeCubArray = @[backItem,singleNoticeitem,noticeitem,markitem,createitem];
    _projectCubArray = @[backItem,singleNoticeitem,noticeitem,markitem,createitem];
    _CarInFacItemArray = @[backItem,singleNoticeitem,noticeitem,markitem,createitem];
    _HistoryItemArray = @[backItem,singleNoticeitem,noticeitem,markitem,createitem];
    
    
#pragma mark  顶部5按钮   流程切换------
    self.headerView.teachnicianAdditionItemHeaderViewBlock = ^(TeachnicianAdditionItemHeaderViewStyle style,UIButton *sender) {
        [HDLeftSingleton shareSingleton].isHiddenTF = YES;

        switch (style) {
            case TeachnicianAdditionItemHeaderViewStyleBilling://开单
            {
                if ([HDPermissionManager isNotThisPermission:HDOrder_Kaidan]) {
                    [selfWeak changeBottomText];

                    return ;
                }
                [selfWeak.headerView setDefaultImageWithButton:sender];
                
                [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleBilling right:HDRightStatusStyleBilling];
                [selfWeak changeBottomText];

//                [selfWeak setStepAlertViewShowStatus:nil];
            }
                break;
            case TeachnicianAdditionItemHeaderViewStyleTechcian://技师增项
            {
                if ([HDPermissionManager isNotThisPermission:HDOrder_Jishizengxiang]) {
                    [selfWeak changeBottomText];

                    return ;
                }
                [selfWeak.headerView setDefaultImageWithButton:sender];

                [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleSchemeLeft right:HDRightStatusStyleTechician];
                [selfWeak changeBottomText];

//                [selfWeak setStepAlertViewShowStatus:nil];


            }
                break;
            case TeachnicianAdditionItemHeaderViewStyleMaterial://备件确认
            {
                if ([HDPermissionManager isNotThisPermission:HDOrder_Beijianqueren]) {
                    [selfWeak changeBottomText];

                    return ;
                }
                [selfWeak.headerView setDefaultImageWithButton:sender];

                [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleBilling right:HDRightStatusStyleMaterial];
                [selfWeak changeBottomText];

//                [selfWeak setStepAlertViewShowStatus:nil];

            }
                break;
            case TeachnicianAdditionItemHeaderViewStyleService://服务确认
            {
                if ([HDPermissionManager isNotThisPermission:HDOrder_Fuwugoutong]) {
                    [selfWeak changeBottomText];

                    return ;
                }
                [selfWeak.headerView setDefaultImageWithButton:sender];

                [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleSchemeLeft right:HDRightStatusStyleService];
                [selfWeak changeBottomText];

//                [selfWeak setStepAlertViewShowStatus:nil];

            }
                break;
            case TeachnicianAdditionItemHeaderViewStyleCustomSure://客户确认
            {
                if ([HDPermissionManager isNotThisPermission:HDOrder_Kehuqueren]) {
                    [selfWeak changeBottomText];

                    return ;
                }
                [selfWeak.headerView setDefaultImageWithButton:sender];

                [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleBilling right:HDRightStatusStyleCustom];

                [selfWeak changeBottomText];
//                [selfWeak setStepAlertViewShowStatus:nil];
            }
                break;
            case TeachnicianAdditionItemHeaderViewStylePreTime://预计交车
            {
                [selfWeak preTimeAction];
            }
            default:
                break;
        }
    };
    
}


- (HDRightStatusStyle)getNoticeRightVC {
    switch ([[HDStoreInfoManager shareManager].positionid integerValue]) {
        case 0:
            
        case 1:
            return HDRightStatusStyleTechician;
            break;
        case 2:
            return HDRightStatusStyleMaterial;
            
            break;
        case 3:
            return HDRightStatusStyleService;
            
            break;
        case 4:
            return HDRightStatusStyleBilling;
            
            break;
        case 5:
            return HDRightStatusStyleTechician;
            
            break;
        case 6:
            return HDRightStatusStyleService;
            
            break;
        default:
            break;
    }
    return HDRightStatusStyleBilling;
}

/*
- (void)setStepAlertViewShowStatus:(NSString *)message {
    [[HDLeftSingleton shareSingleton] showStepAlertViewShowStatus:message];
}
*/
- (void)showAlert:(NSString *)message {

     [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:message height:60 center:self.view.center superView:self.view];
}

- (void)alertViewForAddedItem {
    [self showAlert:@"该方案已添加"];
}
#pragma mark  ------回退按钮点击事件------

- (void)clickbackItem {

    WeakObject(self);
    if ([HDLeftSingleton shareSingleton].stepStatus < 6) {
        [HDLeftSingleton shareSingleton].isBack = YES;
        if ([HDLeftSingleton shareSingleton].statusArray.count > 1) {
            [[HDLeftSingleton shareSingleton].statusArray removeLastObject];
            NSNumber *rightNumber = [HDLeftSingleton shareSingleton].statusArray.lastObject;
            
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_RIGHT_STEP_NOTIFINATION object:[selfWeak getBackVCWithRightNumber:rightNumber]];
            [[HDLeftSingleton shareSingleton] changeWorkFlowWithInfo:[selfWeak getBackVCWithRightNumber:rightNumber]];

            //会退到 最初的开单信息
            if ([HDLeftSingleton shareSingleton].statusArray.count == 1) {
                [selfWeak changeBackItemImageLightgrayColor:YES];

            }else {
                [selfWeak changeBackItemImageLightgrayColor:NO];
            }
        }else {
            [selfWeak changeBackItemImageLightgrayColor:YES];

        }
    }
}

//改变回退按钮的图片颜色
- (void)changeBackItemImageLightgrayColor:(BOOL)isGray {
    UIBarButtonItem *back = _billingItemArray.firstObject;
    CustomBarItemView *backview = back.customView;
    
    if (isGray) {
        [backview.button setImage:[UIImage imageNamed:@"right_Back_item_pic_gray.png"] forState:UIControlStateNormal];
    }else {
        [backview.button setImage:[UIImage imageNamed:@"right_Back_item_pic_black.png"] forState:UIControlStateNormal];
    }
}

- (NSDictionary *)getBackVCWithRightNumber:(NSNumber *)rightNumber {
    NSInteger leftIdx = -1;
    
    switch ([rightNumber integerValue]) {
        case 0:
            leftIdx = 0;
            break;
        case 1:
            leftIdx = 2;
            break;
        case 2:
            leftIdx = 0;
            break;
        case 3:
            leftIdx = 2;
            break;
        case 4:
            leftIdx = 0;
            break;
            
        default:
            break;
    }
    
    NSDictionary *dic = @{@"left":@(leftIdx),@"right":rightNumber};
    
    return dic;
}


#pragma mark  ------加载右侧控制器------

- (void)addVCWithType:(TeachnicianAdditionItemHeaderViewStyle)type navigationItemStr:(NSString *)string navigationItems:(NSArray *)itemArray needRemoveOldVC:(BOOL)isNeed withData:(NSMutableArray *)dataSource {
    WeakObject(self);
    if (isNeed) {
        [selfWeak removeViewSubiew];
    }

    [selfWeak setPreTimeHidden:NO];
    
    NSDictionary *vcDic = [HDRightCustomVCHelper getVCWithStyle:type];
    
    _vc = vcDic[@"vc"];
    _rect = [vcDic[@"rect"] CGRectValue];
    _vc.view.frame = _rect;
    
    //在厂车辆假数据
    if (type == TeachnicianAdditionItemHeaderViewStyleCarInFactoryFull) {
        FullScreenLeftListForRightVC *vc = (FullScreenLeftListForRightVC *)_vc;
        
        vc.dataSource = dataSource;
    }else
        if (type == TeachnicianAdditionItemHeaderViewStyleCustomSure) {
        [selfWeak setPreTimeHidden:YES];
    }
    

    //从时间按钮点击的服务档案和从firstVIew界面进入的方式
    if (type == TeachnicianAdditionItemHeaderViewStyleServiceHistory) {
        if (_isFormStatus == IsForm_home) {
            HDServiceRecordsRightVC *vc = (HDServiceRecordsRightVC *)_vc;
            vc.viewStatus = @2;
        }else if (_isFormStatus == IsForm_rightButton) {
            HDServiceRecordsRightVC *vc = (HDServiceRecordsRightVC *)_vc;
            vc.viewStatus = @1;
        }
    }
    
    //方案库进入
    if (_style == ViewControllerEntryStyleProject && type == TeachnicianAdditionItemHeaderViewStyleProjectCub) {
        HDSchemeRightViewController *vc = (HDSchemeRightViewController *)_vc;
        vc.hiddenBottomInfo = YES;
    }
    
    [_vc willMoveToParentViewController:selfWeak];
    [selfWeak addChildViewController:_vc];
    [selfWeak.view addSubview:_vc.view]; // or something like this.
    [_vc didMoveToParentViewController:selfWeak];
    
    selfWeak.navigationItem.title = string;
    selfWeak.navigationItem.rightBarButtonItems = itemArray;
    
}

- (void)setheaderUserEnabled:(NSDictionary *)sender {
    [self setPreTimeHidden:[sender[@"issave"] integerValue]];
}

- (void)setPreTimeHidden:(BOOL)isHidden {
    WeakObject(self);
    selfWeak.headerView.preTimeTF.hidden = isHidden;
    selfWeak.headerView.preTimeBt.hidden = isHidden;
    selfWeak.headerView.preTimeImageView.hidden = isHidden;
}

#pragma mark  ------预估时间弹窗------
- (void)preTimeAction{
    WeakObject(self);
    [HDPoperDeleteView showTimeAndSecondViewFrame:CGRectMake(0, 0, 500, 300) aroundView:selfWeak.headerView.preTimeBt style:HDWorkListDateChooseViewStyleTimeBegin direction:UIPopoverArrowDirectionUp sure:^(NSString *string) {
       [selfWeak saveCarPretimeStr:string];
       [HDLeftSingleton shareSingleton].isSelectedPreDate = YES;
//       preTimePoperController = nil;
    } cancel:^{
//        preTimePoperController = nil;
    }];
//    preTimePoperController.delegate = self;
    
}

//TODO:开单保存车辆信息 -预计交车时间
- (void)saveCarPretimeStr:(NSString *)timeStr {
    WeakObject(self);
    timeStr = [NSString getStringForYearAndTime:timeStr];
    NSDictionary *dic = @{@"wofinishtime":timeStr};
    [PorscheRequestManager saveBillingNewCarDic:dic complete:^(NSInteger status,PResponseModel *responser) {
        if (status == 100) {//保存开单车辆信息成功
            NSString *timeStr2 = [timeStr convertFromFormat:@"yyyyMMddHHmmss" toAnotherFormat:@"yyyy-MM-dd HH:mm"];
            selfWeak.headerView.preTimeTF.text = timeStr2;
            selfWeak.headerView.timeLb.text = timeStr2;
            selfWeak.headerView.redImg.hidden = YES;
            [HDLeftSingleton shareSingleton].carModel.wofinishtime = timeStr;
        }else {//保存开单车辆信息失败
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
            
        }
    }];
}

//#pragma mark  ------poper代理方法------poper消失
//
//- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
//    return YES;
//}




//获取日期string
- (NSString *)getEndDateStringWith:(HDWorkListDateChooseView *)dateView {
    //日期
    NSString *dateString =[[[HWDateHelper getPreTime:dateView.bilingDatePicker.date] componentsSeparatedByString:@" "] objectAtIndex:0];
    //时间
    NSString *timeString = [[[HWDateHelper getPreTime:dateView.bilingTimePicker.date]componentsSeparatedByString:@" "] objectAtIndex:1];
    //AM,PM
//    NSString *AMString = [[[HWDateHelper getPreTime:dateView.bilingTimePicker.date]componentsSeparatedByString:@" "] objectAtIndex:2];
    //合成
    NSString *endString = [dateString stringByAppendingString:[NSString stringWithFormat:@"%@",timeString]];
    
    return endString;
}


- (void)removeViewSubiew {
    WeakObject(self);
    if (selfWeak.childViewControllers.count) {
        NSInteger count = selfWeak.childViewControllers.count;
        for (int i = 0 ; i < count; i ++) {
            if (selfWeak.childViewControllers.count) {
                UIViewController * vc = [selfWeak.childViewControllers objectAtIndex:0];
                [vc willMoveToParentViewController:nil];
                [vc.view removeFromSuperview];
                [vc removeFromParentViewController];
                
                vc = nil;
            }
            
        }
    }
    
}

#pragma mark -- 获取备注列表 ---
- (void)getRemarkListFromView:(UIView *)view
{
    // 判断备注查看权限
    if ([HDPermissionManager isNotThisPermission:HDOrder_Remark])
    {
        return;
    }
    
    WeakObject(self);
    [PorscheRequestManager memoTextListCompletion:^(NSArray<RemarkListModel *> * _Nonnull memoList, PResponseModel * _Nonnull responser) {
        [selfWeak popRemarkListViewFromView:view withData:[memoList mutableCopy]];
    }];
}

#pragma mark -- 弹出备注列表
- (void)popRemarkListViewFromView:(UIView *)view withData:(NSMutableArray *)datasource;
{
    RemarkListView *remarkView = [[[NSBundle mainBundle] loadNibNamed:@"RemarkListView" owner:self options:nil] objectAtIndex:0];
//    [remarkView reloadData];
    remarkView.dataSource = datasource;
    remarkView.viewFormStyle = ViewForm_serviceRecordsWorkOrder;
    UIViewController *contentVC = [[UIViewController alloc] init];
    contentVC.view.frame = remarkView.bounds;
    [contentVC.view addSubview:remarkView];
    contentVC.automaticallyAdjustsScrollViewInsets = NO;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:contentVC];
    popover.popoverContentSize = remarkView.bounds.size;// CGSizeMake(300, 300); //弹出窗口大小，如果屏幕画不下，会挤小的。这个值默认是320x1100
    CGRect viewFrame = view.frame;
    viewFrame.origin.y += view.frame.size.height / 2;
    
//    CGRect popoverRect = _detailv
    [popover presentPopoverFromRect:viewFrame  //popoverRect的中心点是用来画箭头的，如果中心点如果出了屏幕，系统会优化到窗口边缘
                             inView:self.view //上面的矩形坐标是以这个view为参考的
           permittedArrowDirections:UIPopoverArrowDirectionDown  //箭头方向
                           animated:YES];
    
    
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
