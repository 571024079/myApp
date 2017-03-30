//
//  HDLeftNoticeViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDLeftNoticeViewController.h"
#import "MJRefresh.h"

//底部视图，
#import "ItemListLeftBottomView.h"
//底部本店提醒视图
#import "HDLeftNoticeLocationView.h"
//中间cell
#import "HDLeftNoticeTableViewCell.h"
//顶部视图
#import "HDLeftNoticeHeaderView.h"
//model数据
#import "PorscheItemModel.h"
//时间选择弹窗
#import "HDPoperDeleteView.h"

//单例
#import "HDLeftSingleton.h"
#import "AppDelegate.h"
#import "JPUSHService.h"

@interface HDLeftNoticeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIPopoverControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
//时间筛选弹出框
@property (nonatomic, strong) HDPoperDeleteView *dataPopoerView;

@property (nonatomic, strong) UILabel *labelGView;//滚动图标
@property (nonatomic, assign) CGFloat labelGViewHeight;//滚动图形的高度

@property (nonatomic, strong) HDLeftNoticeLocationView *locationNoticeView;

//顶部
@property (nonatomic, strong) HDLeftNoticeHeaderView *headerView;
//底部
@property (nonatomic, strong) ItemListLeftBottomView *footerView;;

//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
//保存所有状态的数据
@property (nonatomic, strong) NSMutableArray *allDataDource;

@property (nonatomic, assign) NSInteger selectedRow;
//当前的页数
@property (nonatomic, assign) NSInteger currpage;
//当前选中的消息类型
@property (nonatomic, assign) NSInteger currentNoticeType;
//数据总页数
@property (nonatomic, assign) NSInteger pagecount;
//只显示已读按钮是否选中
@property (nonatomic, assign) BOOL isShowReadData;


@end

NSString *cellIdentifier  = @"HDLeftNoticeTableViewCell";

@implementation HDLeftNoticeViewController
#pragma mark  ------懒加载------

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)allDataDource {
    if (!_allDataDource) {
        _allDataDource = [NSMutableArray array];
    }
    return _allDataDource;
}
#pragma mark - -----------界面布局----------
- (void)viewWillLayoutSubviews {

    _tableView.frame =CGRectMake(10, 100, CGRectGetWidth(self.view.frame) - 20, CGRectGetHeight(self.view.frame) - 100 - 49 - 125);
    _locationNoticeView.frame = CGRectMake(0, HD_HEIGHT - 125 - 49 - 64, LEFT_WITH, 125);
    _headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame),100);
    _footerView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadDataWithInfo:nil];
    //进入就刷新
    [self.tableView.mj_header beginRefreshing];
    [self loadDataWithFanganList];
    
    //
    NSLog(@"view Status %@",self.viewStatus);
    [self upadeRedTip];

}

- (void)upadeRedTip
{
    if ([self.viewStatus integerValue])
    {
        [self hearderViewTipStatusWithModel:[HDLeftSingleton shareSingleton].carModel.msgcount];
    }
    else
    {
        [self hearderViewTipStatusWithModel:[HDLeftSingleton shareSingleton].remindModel];
    }
}

// 设置红点显示
- (void)hearderViewTipStatusWithModel:(RemindModel *)model
{
    [self.headerView tipsDisplayStatusWithModel:model];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
//    _isSingleNotice = @0;
    _selectedRow = -1;
    _currpage = 1;
    _isShowReadData = NO;
    _currentNoticeType = 1;
    
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setupTableView];
    [self setHeaderFooterView];
    [self setScrollLb];
    
    
    //利用(方案详情里面修改方案所在收藏夹通知左侧我的收藏夹刷新数据)方法进行数据的刷新，当点击弹窗的放回的时候，刷新界面列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSchemeList:) name:SCHEME_DETAIL_REFRESH_MYFAVORITE_NOTIFICATION object:nil];
    
}

- (void)reloadNoticeData
{
    [self updataAction];
}

- (void)reloadDataWithInfo:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.remoteNotificationUserInfo) {
        
        NSInteger status = [[delegate.remoteNotificationUserInfo objectForKey:@"redirect_type"] integerValue];
        
        UIButton *button = [self.headerView getButtonWithStatus:status];
//        [self headerViewButtonAction:button];
        [self.headerView buttonAction:button];
    }
    delegate.remoteNotificationUserInfo = nil;
    
}

- (void)setupTableView {
    //64(导航栏) + 100(顶部视图) + 49(底部视图) + 200(底部本店提醒视图)
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 100, CGRectGetWidth(self.view.frame) - 20, CGRectGetHeight(self.view.frame) - 100 - 49 - 125) style:UITableViewStyleGrouped];
    [_tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 添加上拉加载
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithCurrentPage)];
    // 添加下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updataAction)];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(singleCarNotifination:) name:SINGLE_CAR_NOTIFICATION object:nil];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, -50, 0);
    [self.view addSubview:_tableView];
}
- (void)updataAction {
    _currpage = 1;
    _dataSource = nil;
    [_tableView.mj_footer resetNoMoreData];
    [self loadDataWithCurrentNoticeType:_currentNoticeType withRefresh:NO withPage:_currpage];
}
//弹出方案详情点击返回的时候刷新界面数据
- (void)refreshSchemeList:(NSNotification *)noti {
    [self loadDataWithFanganList];
}
#pragma mark - 数据加载-（车辆提醒列表）
//      readstate       0：未读 1：已读 2：全部
- (void)loadDataWithCurrentNoticeType:(NSInteger)type withRefresh:(BOOL)isRefresh withPage:(NSInteger)page {
    [HDStoreInfoManager shareManager].currpage = @(page);
    [HDStoreInfoManager shareManager].pagesize = @20;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:@(type) forKey:@"type"];
    
    if (_headerView.vinSearchTF.text.length) {
        [param hs_setSafeValue:_headerView.vinSearchTF.text forKey:@"car"];
    }else {
        [param hs_setSafeValue:@"" forKey:@"car"];
    }
    if (_headerView.timeSearchTF.text.length) {
        NSString *time = [NSString getStringForYearAndTime:_headerView.timeSearchTF.text];
        
        time = [time convertFromFormat:@"yyyyMMddHHmmss" toAnotherFormat:@"yyyyMMdd"];
        
        [param hs_setSafeValue:time forKey:@"createtime"];
    }else {
        [param hs_setSafeValue:@"" forKey:@"createtime"];
    }
    if (_isShowReadData) {
        [param hs_setSafeValue:@0 forKey:@"readstate"];
    }else {
        [param hs_setSafeValue:@2 forKey:@"readstate"];
    }
    
    
    if ([_viewStatus integerValue] == 1) {
        [param setValue:[HDStoreInfoManager shareManager].carorderid forKey:@"orderid"];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self.view];
    WeakObject(hud)
    WeakObject(self)
    
    [PorscheRequestManager noticeLeftListWithParams:param completion:^(NSMutableArray * _Nonnull noticeLeftArray, PResponseModel * _Nonnull responser) {
        [selfWeak.tableView.mj_header endRefreshing];
        [hudWeak hideAnimated:YES];
        if (isRefresh) {
            [selfWeak.tableView.mj_footer endRefreshing];
        }
        if (noticeLeftArray.count) {
            selfWeak.pagecount = responser.totalpages;
            [selfWeak.dataSource addObjectsFromArray:noticeLeftArray];
            [selfWeak.tableView reloadData];
//            if (selfWeak.isShowReadData) {
//                [selfWeak handleDataWithOnlyShowUnreadData];
//            }else {
//                selfWeak.dataSource = selfWeak.allDataDource;
//                [selfWeak.tableView reloadData];
//            }
        }else {
           [selfWeak.tableView reloadData];
        }
        if (selfWeak.dataSource.count < 6) {
            _labelGViewHeight = 0;
        }else {
            _labelGViewHeight = (6 / (selfWeak.dataSource.count * 1.0)) * CGRectGetHeight(self.tableView.frame);
        }
        _labelGView.frame = [selfWeak setLabelGViewFrame];
        
        if (_pagecount && _currpage == _pagecount) {
            [selfWeak.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
#pragma mark - 数据加载-（本店提醒列表）
- (void)loadDataWithFanganList {

    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDTaskNotice_MyShopNotice])
    {
        return;
    }
//    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self.view];
//    WeakObject(hud)
    WeakObject(self)
    [PorscheRequestManager noticeLeftBottomFanganListWithCompletion:^(NSMutableArray * _Nonnull fanganListArray, PResponseModel * _Nonnull responser) {
//        [hudWeak hideAnimated:YES afterDelay:1.0];
        if (fanganListArray.count) {
            selfWeak.locationNoticeView.dataSource = fanganListArray;
        }
    }];
}
#pragma mark - 未读的任务处理
- (void)handleUnreadNoticeWithModel:(HDLeftNoticeListModel *)model WithIndex:(NSIndexPath *)indexPath {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:model.taskid forKey:@"taskid"];
    
//    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self.view];
//    WeakObject(hud)
    WeakObject(self)
    [PorscheRequestManager noticeLeftListHandleUnreadNoticeWithParams:param completion:^(PResponseModel * _Nonnull responser) {
//        [hudWeak hideAnimated:YES afterDelay:1.0];
        if (responser.status == 100) {
            
            //当只显示未读的状态是选中的时候，更改总的数据，将当前的这条提醒的状态改变，在刷新整个列表
            for (HDLeftNoticeListModel *data in _dataSource) {
                if ([data.taskid isEqualToNumber:model.taskid]) {
                    data.stateread = @1;
                }
            }
//            if (selfWeak.isShowReadData) {
//                _selectedRow = -1;//因为当前的更改过后的状态已读，不在列表中展示，吧选中的参数清空
//                [selfWeak handleDataWithOnlyShowUnreadData];
//            }else {
//                selfWeak.dataSource = selfWeak.allDataDource;
//            }
            [selfWeak reloadNoticeCount];
            [selfWeak.tableView reloadData];
            
        }else {
            [selfWeak.tableView reloadData];
        }
    }];
}

#pragma mark -- 刷新消息数量
- (void)reloadNoticeCount
{
//    NSNumber *orderid = [[HDStoreInfoManager shareManager] carorderid];
    [PorscheRequestManager getNoticeWithOrderid:@0 complete:^(NSInteger status, PResponseModel * _Nullable responser) {
        if (status == SUCCESS_STATUS)
        {
             RemindModel *remindModel = [RemindModel yy_modelWithDictionary:responser.object];
            [[HDLeftSingleton shareSingleton] setNoticeCount:remindModel.allnum];
            [[HDLeftSingleton shareSingleton] setRemindModel:remindModel];
        }
    }];
}

#pragma mark - 上拉刷新进行数据的加载
- (void)refreshDataWithCurrentPage {
    //如果要拉去的页数已经大于总页数，就不进行网络请求
    if (_pagecount && _currpage == _pagecount) {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    _currpage++;
    [self loadDataWithCurrentNoticeType:_currentNoticeType withRefresh:YES withPage:_currpage];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /*
    [self.view addSubview:_tableView];
    [self setHeaderFooterView];
    [self setScrollLb];
     */
}

#pragma mark - 处理数据---（只显示未读的数据）
- (void)handleDataWithOnlyShowUnreadData {
    
    self.currpage = 1;
    self.dataSource = nil;
    [_tableView.mj_footer resetNoMoreData];
    [self loadDataWithCurrentNoticeType:self.currentNoticeType withRefresh:NO withPage:self.currpage];
    
//    NSMutableArray *array = [NSMutableArray array];
//    for (HDLeftNoticeListModel *data in _allDataDource) {
//        if ([data.state integerValue] != 2) {
//            [array addObject:data];
//        }
//    }
//    _dataSource = array;
//    [_tableView reloadData];
}
#pragma mark  -------单一车辆的服务提醒信息-----
- (void)singleCarNotifination:(NSDictionary *)sender {
    self.viewStatus = @1;
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark  ------顶部视图，底部视图------
- (void)setHeaderFooterView {
    WeakObject(self);
    _headerView = [[HDLeftNoticeHeaderView alloc]initWithCustomFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    //时间筛选
    _headerView.hDLeftNoticeHeaderViewBlock = ^(UIButton *sender) {
        [selfWeak headerViewButtonAction:sender];
    };
    
    _footerView = [[ItemListLeftBottomView alloc]initWithCustomFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49)];
    _locationNoticeView= [[HDLeftNoticeLocationView alloc]initWithCustomFrame:CGRectMake(0, HD_HEIGHT - 125 - 49, LEFT_WITH, 125)];
    [_footerView.fullScreenBt setTitle:@"全部" forState:UIControlStateNormal];
    _footerView.rightLb.text = @"只显示未读";
    
    _footerView.itemListLeftBottomViewBlock = ^ (ItemListLeftBottomViewStyle style,UIButton *sender,NSInteger tapCount) {

            //全部事件
            if (style == ItemListLeftBottomViewStyleFullScreen) {
//             [AlertViewHelpers setAlertViewWithViewController:selfWeak button:sender];
                selfWeak.headerView.vinSearchTF.text = nil;
                selfWeak.headerView.timeSearchTF.text = nil;
                if (!tapCount % 2) {
                    selfWeak.viewStatus = @0;
                    [selfWeak hearderViewTipStatusWithModel:[HDLeftSingleton shareSingleton].remindModel];
                }
                [selfWeak  updataAction];
            }
            //只显示未读
            if (style == ItemListLeftBottomViewStyleChooseMyCar) {
                if (tapCount % 2) {
                    selfWeak.isShowReadData = YES;
                    [selfWeak.footerView.statusBt setImage:[UIImage imageNamed:@"billing_left_bottom_selected.png"] forState:UIControlStateNormal];
                    
                    [selfWeak handleDataWithOnlyShowUnreadData];
                    
                }else {
                    selfWeak.isShowReadData = NO;
                    [selfWeak.footerView.statusBt setImage:nil forState:UIControlStateNormal];
//                    selfWeak.dataSource = selfWeak.allDataDource;
//                    [selfWeak.tableView reloadData];
                    [selfWeak handleDataWithOnlyShowUnreadData];
                }
            }
    };
    #pragma mark  ------添加视图------
    [self.view addSubview:_headerView];
    [self.view addSubview:_locationNoticeView];
    [self.view addSubview:_footerView];
}
#pragma mark -      ------  顶部按钮点击事件
- (void)headerViewButtonAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        case 2:
        case 3:
        case 4:
        {
            _currentNoticeType = sender.tag;
            _selectedRow = -1;//取消当前状态下的选中
            [_tableView.mj_header beginRefreshing];
//            _currpage = 1;
//            _dataSource = nil; //重置数组，防止在之前的数组上添加
//            [self loadDataWithCurrentNoticeType:_currentNoticeType withRefresh:NO withPage:_currpage];
        }
            break;
        case 5://时间筛选
        {
            [self timePredicate:HDLeftBillingDateChooseViewStyleTimeBegin view:self.headerView];
        }
            break;
        case 6://搜索
        {
            _selectedRow = -1;//取消当前状态下的选中
            [_tableView.mj_header beginRefreshing];
//            _currpage = 1;
//            _dataSource = nil; //重置数组，防止在之前的数组上添加
//            [self loadDataWithCurrentNoticeType:_currentNoticeType withRefresh:NO withPage:_currpage];
        }
            break;
        default:
            break;
    }
}

#pragma mark  ------时间筛选------
- (void)timePredicate:(HDLeftBillingDateChooseViewStyle )style view:(HDLeftNoticeHeaderView *)view {
    WeakObject(self);
    //弹出框frame
    [HD_FULLView endEditing:YES];    
    [HDPoperDeleteView showDateTimePredicateFrame:CGRectMake(0, 0, 480, 200) aroundView:view.timeSearchTF direction:UIPopoverArrowDirectionUp headerTitle:@"" isLimit:NO style:style complete:^(HDLeftBillingDateChooseViewStyle style, NSString *endStr) {
        view.timeSearchTF.text = endStr;

    }];
    
    
    
}


#pragma mark  ------设置滚动条------
- (void)setScrollLb {
    //设置右侧滚动条
    _labelGView = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_WITH - 5, 100, 5, 65)];
    _labelGView.backgroundColor = Color(100, 100, 100);
    [self.view addSubview:_labelGView];
    
    // tableview右侧滚条左侧竖线
    UIView *scrollLeftView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_WITH - 6, 100, 1, HD_HEIGHT - 125 - 49 - 100 - 64)];
    scrollLeftView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:scrollLeftView];

}

#pragma mark  ------滚动条scroll------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {//右侧滚动视图联动
//        CGFloat p = 0;
//        p = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frame.size.height);// 计算当前偏移的Y在总滚动长度的比例
//        CGFloat height = CGRectGetHeight(self.tableView.frame) - _labelGViewHeight;
//        if ((p * height) < (CGRectGetHeight(self.tableView.frame) - _labelGViewHeight) && p > 0) {
//            _labelGView.frame = CGRectMake(self.view.frame.size.width - 5, p * height + 100, 5, _labelGViewHeight);
//        }else if (p > 0 && (p * height) > (CGRectGetHeight(self.tableView.frame) - _labelGViewHeight)){
//            _labelGView.frame = CGRectMake(self.view.frame.size.width - 5, CGRectGetHeight(self.view.frame) -125-49-_labelGViewHeight, 5, _labelGViewHeight);
//        }else if (p < 0) {
//            _labelGView.frame = CGRectMake(self.view.frame.size.width - 5, 100, 5, _labelGViewHeight);
//        }
//        
        CGRect labelGViewFrame = _labelGView.frame;
        
        
        CGFloat offSetY = scrollView.contentOffset.y;
        
        CGFloat labelGViewCurrentY = 0;
        if (offSetY > 0)
        {
            CGFloat labelGViewScale = offSetY / (scrollView.contentSize.height - scrollView.bounds.size.height);
            
            labelGViewCurrentY = labelGViewScale * (_tableView.frame.size.height - self.labelGView.bounds.size.height) + 100;
            
            
            if ((labelGViewCurrentY + self.labelGView.bounds.size.height) >= (_tableView.frame.size.height + 100))
            {
                labelGViewCurrentY =_tableView.bounds.size.height + 100 - self.labelGView.bounds.size.height;
            }
        }
        else
        {
            labelGViewCurrentY = 100;
        }

        
        labelGViewFrame.origin.y = labelGViewCurrentY;
        
        _labelGView.frame = labelGViewFrame;

    }
}

- (CGRect)setLabelGViewFrame {
    CGRect frame = self.labelGView.frame;
    
//    CGFloat p = self.tableView.contentOffset.y / (self.tableView.contentSize.height - self.tableView.frame.size.height);// 计算当前偏移的Y在总滚动长度的比例
//    CGFloat height = CGRectGetHeight(self.tableView.frame) - _labelGViewHeight;
//    frame.origin.y = p * height + 100;
    frame.size.height = _labelGViewHeight;
    
    return frame;
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
        return YES;
}


#pragma mark  ------delgate  dataSource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HDLeftNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setShadow];
    
    HDLeftNoticeListModel *data = _dataSource[indexPath.section];
    [cell setCellDataFormNoticeLeft:data];
    
    cell.backgroundColor = [UIColor whiteColor];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDefaultTextColor:[UIColor blackColor]];
    
    if (indexPath.section == _selectedRow) {
        [cell setSelectedCellStyle:data];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedRow = indexPath.section;
    
    HDLeftNoticeListModel *model = self.dataSource[indexPath.section];
    
    if ([model.state integerValue] == 0 && [model.stateread integerValue] == 0) { //未读状态
        [self handleUnreadNoticeWithModel:model WithIndex:indexPath];
    }else {
        [tableView reloadData];
    }
    
    self.locationNoticeView.model = model;
    
    [self readNoticeModel:model];
}

- (void)readNoticeModel:(HDLeftNoticeListModel *)model {
    [HDStoreInfoManager shareManager].carorderid = model.orderid;
    [HDStoreInfoManager shareManager].carplate = model.ccarplate;
    [HDStoreInfoManager shareManager].plateplace = model.plateplace;
    [HDLeftSingleton shareSingleton].maxStatus = [model.wostatus integerValue];
    [HDLeftSingleton shareSingleton].isHiddenTF = YES;
    
    HDRightStatusStyle style = [self getNoticeRightVCWithModel:model];
    if ([model.wostatus integerValue] == 99) {//车辆取消
        [HDStoreInfoManager shareManager].carorderid = nil;
        [HDStoreInfoManager shareManager].carplate = nil;
        [HDStoreInfoManager shareManager].plateplace = nil;
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:model.content height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
    }

    [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleSelf right:style];

    [HDStatusChangeManager removeNetVC];
}
#pragma mark -- 跳转对应页面
// 根据职位 显示右侧流程界面 跳转页面 0：根据职位跳转   1：开单 2：技师 3：备件  4：服务沟通  5:客户确认
- (HDRightStatusStyle)getNoticeRightVCWithModel:(HDLeftNoticeListModel *)model {
    
    switch ([model.directtype integerValue]) {

        case 0:
            return [self getNoticeRightVC];
        case 1:
            return HDRightStatusStyleBilling;// HDRightStatusStyleTechician;
            break;
        case 2:
            return HDRightStatusStyleTechician;// HDRightStatusStyleMaterial;
            break;
        case 3:
            return HDRightStatusStyleMaterial;//HDRightStatusStyleService;
            break;
        case 4:
            return HDRightStatusStyleService;//HDRightStatusStyleBilling;
            break;
        case 5:
            return HDRightStatusStyleCustom;
            break;
        default:
            break;
    }
    return HDRightStatusStyleBilling;
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
