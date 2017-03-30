    //
//  KandanLeftViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/6.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "KandanLeftViewController.h"
#import "KandanLeftTableViewCell.h"
#import "ItemListLeftHeaderView.h"
#import "ItemListLeftBottomView.h"
#import "HDWorkListTableViews.h"
#import "HDLeftBillingDateChooseView.h"
#import "HDLeftSingleton.h"
#import "HWDateHelper.h"
#import "HDPoperDeleteView.h"
#import "HDLeftListModel.h"
#import "HDRightViewController.h"
#import "HDMainShopInformationModel.h"
@interface KandanLeftViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIPopoverControllerDelegate>
//滑动
@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic)  UIScrollView *baseView;
//tableView

@property (strong, nonatomic) UITableView *tableView;

//区头
@property (nonatomic, strong) ItemListLeftHeaderView *headerView;

//底部栏
@property (nonatomic, strong) ItemListLeftBottomView *bottomView;

////点击按钮遮罩
//@property (nonatomic, strong) UIView *clearView;
//高亮view
@property (nonatomic, strong) UIView *helperView;

//时间筛选弹出框
@property (nonatomic, strong) HDPoperDeleteView *dataPopoerView;


//日期选择起始
@property (nonatomic, strong) NSDate *beginTimeDate;
//日期选择截止
@property (nonatomic, strong) NSDate *endTimeDate;
//时间起始
@property (nonatomic, strong) NSDate *beginDate;
//时间终止
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) UILabel *labelGView;//滚动图标
@property (nonatomic, assign) CGFloat labelGViewHeight;//滚动图形的高度
// 列表数据
@property (nonatomic, strong) NSMutableArray *dataSource;
//含有不再厂数据的数组
@property (nonatomic, strong) NSMutableArray *stayListDataSource;
//右侧下拉选项的集合
@property (nonatomic, strong) NSMutableDictionary *typeDic;
@property (nonatomic, strong) NSNumber *todayJiaoOrOverdueJiao;// 0 默认  1 今日交   2过期交
@property (nonatomic, strong) NSNumber *showMainCar;//是否展示我的车辆
//在厂车辆本店工单信息
@property (nonatomic, strong) HDMainShopInformationModel *mainShopInformation;
//数据总页数
@property (nonatomic, assign) NSInteger pagecount;
//当前的页数
@property (nonatomic, assign) NSInteger currpage;

@property (nonatomic, strong) PorscheConstantModel *processConstantModel;
@end

@implementation KandanLeftViewController


- (void)dealloc {
    NSLog(@"KandanLeftViewController_dealloc");
//    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillLayoutSubviews {
    self.baseView.frame = CGRectMake(0, 145, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 145 - 49);
    self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.baseView.frame), CGRectGetHeight(self.baseView.frame));
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.containerView.frame), 49);
    self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), (CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.baseView.frame) - CGRectGetHeight(self.bottomView.frame)));
    self.tableView.frame = CGRectMake(10, 1, CGRectGetWidth(self.containerView.frame) - 20, CGRectGetHeight(self.containerView.frame) - 2);
    _baseView.contentSize = CGSizeMake(CGRectGetWidth(self.baseView.frame),CGRectGetHeight(self.baseView.frame));
}

- (void)baseReloadData
{
    [self.tableView.mj_header beginRefreshing];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //刚进入开单信息，设置状态，没有进入技师增项
    [self setupBaseView];
    [self setupTableView];
//    [self addNotifination];
    // 添加列表数据
    [self setupMJRefresh];
    
    [self setupHeaderView];
    
    //设置tableview周边样式
    [self setViewWithContainerView];
    [self addLineLabel];
    [self setFullScreenBtTittle];
    _containerView.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)setupMJRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCarInFactionList)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithCurrentPagewithKaidanVC)];
}



- (void)addLineLabel {
    //设置右侧滚动条
    _labelGView = [[UILabel alloc] initWithFrame:CGRectMake(self.containerView.frame.size.width - 5, 0, 5, 50)];
    _labelGView.backgroundColor = Color(100, 100, 100);
    [_containerView addSubview:_labelGView];
}

- (void)addNotifination {
    //给右边边添加通知，滑动的时候调用方法（全屏）
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTableViewContentOffSize:) name:FULLSCREEN_LESTLIST_RIGHTSCROLL_NOTIFINATION object:nil];
    
    //给右边添加通知，在右边进行数据类型选择的时候进行数据请求，并将数据传递给右边
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadtableViewData:) name:FULLSCREEN_LESTLIST_RIGHTSELECTSTATUS_NOTIFINATION object:nil];
    //给右侧添加通知，当右侧点击确认返回的时候，执行方法，还原界面
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(helpActionWithRightView:) name:FULLSCREEN_LEFTLIST_ACTIONWITHRIGHTVIEW_NOTIFITION object:nil];
    //右侧开单 实时保存 左侧实时更新开单信息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCarInFactionListAction:) name:NEW_BILLING_CAR_SAVE_NOTIFINATION object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBottomBt) name:NEW_BILLING_CAR_NOTIFINAITON object:nil];
}

- (void)setBottomBt {
    [self.bottomView.fullScreenBt setTitle:@"看车辆进度" forState:UIControlStateNormal];
}

- (void)helpActionWithRightView:(NSDictionary *)noti {
    [_bottomView fullScreenBtAction:_bottomView.fullScreenBt];
}

- (void)setupBaseView {
    //滑动
    _baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 145 + 64, 364, CGRectGetHeight(self.view.frame) - 145 - 49)];
    _baseView.showsHorizontalScrollIndicator = NO;
    _baseView.showsVerticalScrollIndicator = NO;
    _baseView.contentSize = self.containerView.frame.size;
    
    _baseView.bounces = NO;
    
    _baseView.maximumZoomScale = 2;
    
    _baseView.minimumZoomScale = 1;
    
    
    _baseView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_baseView addSubview:self.containerView];
    self.baseView.delegate = self;

    [self.view addSubview:_baseView];
}

- (void)setupTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 1, self.containerView.frame.size.width - 20, CGRectGetHeight(self.containerView.frame) - 2 - 64) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"KandanLeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"KandanLeftTableViewCellid"];
    
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.containerView addSubview:self.tableView];

}

- (void)setFullScreenBtTittle {
    if ([_fullScreenNumber integerValue] != 0) {
        [self setFullBtTitle];
    }
}

- (void)baseReloadDataWithObject:(id)objc
{
    if ([objc isKindOfClass:[PorscheNewCarMessage class]])
    {
        PorscheNewCarMessage *carinfo = objc;
        // 清空搜索条件
        [_headerView cleanAllContent];
        // 搜索车牌
        _headerView.VINSearchTF.text = [NSString stringWithFormat:@"%@%@",carinfo.plateplace, carinfo.ccarplate];
        
        [self clearDataAndLoadAgain];
    }
}

#pragma mark - 请求数据
/*
- (void)loadTableData {
    //现将所有的情况的数据保存
    _stayListDataSource = [NSMutableArray array];
    
    NSMutableArray *list = [HDLeftListModel dataLoad];
    _stayListDataSource = list;

    //处理处理数据，将不再厂的数据移除
    NSMutableArray *array = [NSMutableArray array];
    for (HDLeftListModel *model in _stayListDataSource) {
        if ([model.stayType integerValue]) {
            [array addObject:model];
        }
    }
    self.dataSource = [NSMutableArray arrayWithArray:array];
    [[NSNotificationCenter defaultCenter] postNotificationName:FULLSCREEN_LEFTLIST_LEFTDATASOURCE_NOTIFINATION object:_dataSource];
}
*/
//获取右边开单 实施保存和删除工单信号
- (void)getCarInFactionListAction:(NSNumber *)noti {
    if ([noti isEqual:@2]) {//新建工单时，点击状态取消
        [self.tableView reloadData];
    }else if ([noti isEqual:@1]) {//实时更新车辆工单信息
        
        [self.tableView.mj_header beginRefreshing];
    }else if ([noti isEqual:@3]) {//VIN查询；
        [self getRightDataPredicate:@3];
    }else if ([noti isEqual:@4]) {//车牌号查询；
        [self getRightDataPredicate:@4];
    }
}

- (void)getRightDataPredicate:(NSNumber *)number {
    
    NSString *str ;
    if ([number isEqual:@3]) {
            str = [HDLeftSingleton shareSingleton].carModel.cvincode;
    }else {
        str = [[HDLeftSingleton shareSingleton].carModel.plateplace stringByAppendingString:[HDLeftSingleton shareSingleton].carModel.ccarplate];
    }
    [self.headerView cleanTF];

    _headerView.VINSearchTF.text = str;
    
    [self clearDataAndLoadAgain];
}


//上拉加载
- (void)refreshDataWithCurrentPagewithKaidanVC {
    //如果要拉去的页数已经大于总页数，就不进行网络请求
    if (_pagecount && _currpage == _pagecount) {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    _currpage++;
    [self loadDataWithCurrentPage:_currpage withRefresh:YES];
}

/**
 Title -> 时间参数调整(在不同的条件下的时间参数传递,当开始时间和结束时间是上午或者下午的时候进行判断)
 @param -> AM->AM   00:00:00 -> 11:59:59
 @param -> AM->PM   00:00:00 -> 23:59:59
 @param -> PM->AM   12:00:00 -> 11:59:59(第二天)
 @param -> PM->PM   12:00:00 -> 23:59:59(第二天)
 */
- (NSString *)returnStringWithTextField:(UITextField *)textField withIndex:(NSInteger)index {
    NSString *timeStr = [NSString removerTimeStrAMPMWithTime:textField.text];
    if (index == 1) {//开始
        if ([textField.text containsString:@"AM"]) {
            timeStr = [timeStr stringByReplacingCharactersInRange:NSMakeRange(timeStr.length - 6 , 6) withString:@"000000"];
        }else if ([textField.text containsString:@"PM"]) {
            timeStr = [timeStr stringByReplacingCharactersInRange:NSMakeRange(timeStr.length - 6 , 6) withString:@"120000"];
        }
    }else if (index == 2) {//结束
        if ([textField.text containsString:@"AM"]) {
            timeStr = [timeStr stringByReplacingCharactersInRange:NSMakeRange(timeStr.length - 6 , 6) withString:@"115959"];
        }else if ([textField.text containsString:@"PM"]) {
            timeStr = [timeStr stringByReplacingCharactersInRange:NSMakeRange(timeStr.length - 6 , 6) withString:@"235959"];
        }
    }
    
    return timeStr;
}

#pragma mark - ------    ******  设置请求的参数，用于条件筛选 ********    ---------
- (NSMutableDictionary *)getSearchparameter {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (_headerView.VINSearchTF.text.length) {//车牌/vin/车型
        [param hs_setSafeValue:_headerView.VINSearchTF.text forKey:@"car"];
    }else {
        [param hs_setSafeValue:@"" forKey:@"car"];
    }
    if (_headerView.TimeSearchTF.text.length) {//开始时间
        NSString *startStr = [self returnStringWithTextField:_headerView.TimeSearchTF withIndex:1];
        [param hs_setSafeValue:startStr forKey:@"starttime"];
    }else {
        [param hs_setSafeValue:@"" forKey:@"starttime"];
    }
    if (_headerView.endTimeSearchTF.text.length) {//结束时间
        NSString *endStr = [self returnStringWithTextField:_headerView.endTimeSearchTF withIndex:2];
        [param hs_setSafeValue:endStr forKey:@"endtime"];
    }else {
        [param hs_setSafeValue:@"" forKey:@"endtime"];
    }
    
    if (_headerView.progressTF.text.length) {//进度筛选：1:开单信息 2：技师增项 3：备件确认 4：服务沟通 5：客户确认
        [param hs_setSafeValue:self.processConstantModel.cvsubid forKey:@"process"];
    }else {
        [param hs_setSafeValue:@0 forKey:@"process"];
    }
    
    if ([_todayJiaoOrOverdueJiao integerValue] == 1) {//今日交车 : 1 筛选今日交车的
        [param hs_setSafeValue:@1 forKey:@"subtoday"];
        [param hs_setSafeValue:@0 forKey:@"subexprie"];
        [param hs_setSafeValue:@"" forKey:@"substarttime"];
        [param hs_setSafeValue:@"" forKey:@"subendtime"];
    }else if ([_todayJiaoOrOverdueJiao integerValue] == 2) {//逾期交车:1筛选预期交车的
        [param hs_setSafeValue:@0 forKey:@"subtoday"];
        [param hs_setSafeValue:@1 forKey:@"subexprie"];
        [param hs_setSafeValue:@"" forKey:@"substarttime"];
        [param hs_setSafeValue:@"" forKey:@"subendtime"];
    }else {
        if (_headerView.yujijiaocheStartTF.text.length) {//预计交车时间开始
            NSString *startStr = [self returnStringWithTextField:_headerView.yujijiaocheStartTF withIndex:1];
            [param hs_setSafeValue:startStr forKey:@"substarttime"];
        }else {
            [param hs_setSafeValue:@"" forKey:@"substarttime"];
        }
        if (_headerView.yujijiaocheEndTF.text.length) {//预计交车时间结束
            NSString *endtimeString = [self returnStringWithTextField:_headerView.yujijiaocheEndTF withIndex:2];
            [param hs_setSafeValue:endtimeString forKey:@"subendtime"];
        }else {
            [param hs_setSafeValue:@"" forKey:@"subendtime"];
        }
        [param hs_setSafeValue:@0 forKey:@"subtoday"];
        [param hs_setSafeValue:@0 forKey:@"subexprie"];
    }
    
    if ([_showMainCar integerValue] == 1) {//1：我的车辆
        [param hs_setSafeValue:@1 forKey:@"mine"];
    }else {
        [param hs_setSafeValue:@0 forKey:@"mine"];
    }
    //  在厂车辆的五个状态 0.全部 1.进行中 2.已完成 3.备件通知 4.确认通知 5.增项备件通知 6.增项通知 7.保修待审批 8.待开始 9.车间待确认
    if ([[_typeDic objectForKey:@"type1"] integerValue]) {// '开单状态'
        [param hs_setSafeValue:[_typeDic objectForKey:@"type1"] forKey:@"statestart"];
    }else {
        [param hs_setSafeValue:@0 forKey:@"statestart"];
    }
    if ([[_typeDic objectForKey:@"type2"] integerValue]) {// '增项状态'
        [param hs_setSafeValue:[_typeDic objectForKey:@"type2"] forKey:@"stateincrease"];
    }else {
        [param hs_setSafeValue:@0 forKey:@"stateincrease"];
    }
    if ([[_typeDic objectForKey:@"type3"] integerValue]) { // '备件状态'
        [param hs_setSafeValue:[_typeDic objectForKey:@"type3"] forKey:@"statepart"];
    }else {
        [param hs_setSafeValue:@0 forKey:@"statepart"];
    }
    if ([[_typeDic objectForKey:@"type4"] integerValue]) {// '服务沟通状态'
        [param hs_setSafeValue:[_typeDic objectForKey:@"type4"] forKey:@"stateserice"];
    }else {
        [param hs_setSafeValue:@0 forKey:@"stateserice"];
    }
    if ([[_typeDic objectForKey:@"type5"] integerValue]) {// 客户沟通状态'
        [param hs_setSafeValue:[_typeDic objectForKey:@"type5"] forKey:@"statecustomer"];
    }else {
        [param hs_setSafeValue:@0 forKey:@"statecustomer"];
    }
    
    return param;
}

#pragma mark -   获取在场车辆信息
- (void)loadDataWithCurrentPage:(NSInteger)page withRefresh:(BOOL)isRefresh {
    [HDStoreInfoManager shareManager].currpage = @(_currpage);
    [HDStoreInfoManager shareManager].pagesize = @20;
    
    NSMutableDictionary *param = [self getSearchparameter];
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self.view];
    WeakObject(hud)
    WeakObject(self);
    [PorscheRequestManager carListNewCarWithParam:param complete:^(NSMutableArray *array,PResponseModel *responser) {
        [hudWeak hideAnimated:YES afterDelay:1.0];
        [selfWeak.tableView.mj_header endRefreshing];
        
        if (isRefresh) {
            [selfWeak.tableView.mj_footer endRefreshing];
        }
        else
        {
            selfWeak.dataSource = nil;
        }
        
        if (array.count) {
            selfWeak.pagecount = responser.totalpages;
            [selfWeak.dataSource addObjectsFromArray:array];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:FULLSCREEN_LEFTLIST_LEFTDATASOURCE_NOTIFINATION object:selfWeak.dataSource];
            [selfWeak.tableView reloadData];
        }else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:FULLSCREEN_LEFTLIST_LEFTDATASOURCE_NOTIFINATION object:selfWeak.dataSource];
            [selfWeak.tableView reloadData];
        }
        
        [[HDLeftSingleton shareSingleton] reloadFullRightViewFromLeftData:selfWeak.dataSource];
        
        if (self.dataSource.count < 8) {
            _labelGViewHeight = 0;
        }else {
            _labelGViewHeight = (8 / (self.dataSource.count * 1.0)) * 500.0;
        }
        [selfWeak annimationWithRightLabelView];
        // 获取在厂车辆本店工单信息
        [selfWeak loadMainShooInformationData];
        if (_pagecount && _currpage == _pagecount) {
            [selfWeak.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if ([HDLeftSingleton shareSingleton].carModel) {
            [[HDLeftSingleton shareSingleton].HDRightViewController changeItemColor:nil];
        }
    }];
}
- (void)getCarInFactionList {
    [self clearDataAndLoadAgain];
}
#pragma mark - 在厂车辆本店工单信息
- (void)loadMainShooInformationData {
    WeakObject(self)
    [PorscheRequestManager mainShopInformationcompletion:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            selfWeak.mainShopInformation = [HDMainShopInformationModel dataFormDic:responser.object];
            selfWeak.headerView.todayJiaoNumberLabel.text = [selfWeak.mainShopInformation.todaysubnum stringValue];
            selfWeak.headerView.overdueJiaoNumberLabel.text = [selfWeak.mainShopInformation.exprienum stringValue];
        }
    }];
}

- (void)annimationWithRightLabelView {
    WeakObject(self);
    [UIView animateWithDuration:0.3 animations:^{
        selfWeak.labelGView.frame = CGRectMake(self.containerView.frame.size.width - 5, 0, 5, _labelGViewHeight);
 
    }];
}
////新开单时，刷新数据
//- (void)reloadDataTableView {
//    _selectedRow = -1;
//    [self.tableView reloadData];
//}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _tableView) {//右侧滚动视图联动
        // 当前左边的视图滚动
//        [[NSNotificationCenter defaultCenter] postNotificationName:FULLSCREEN_LESTLIST_LEFTSCROLL_NOTIFINATION object:@(scrollView.contentOffset.y)];
        [[HDLeftSingleton shareSingleton] scrollAtTheSameTImeFromLeftToRight:@(scrollView.contentOffset.y)];
        CGFloat p = 0;
        p = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frame.size.height);// 计算当前偏移的Y在总滚动长度的比例
        CGFloat height = CGRectGetHeight(self.tableView.frame) - _labelGViewHeight;
        if ((p * height) < (CGRectGetHeight(self.tableView.frame) - _labelGViewHeight) && p > 0) {
            _labelGView.frame = CGRectMake(self.containerView.frame.size.width - 5, p * height, 5, _labelGViewHeight);
        }else if (p > 0 && (p * height) > (CGRectGetHeight(self.tableView.frame) - _labelGViewHeight)){
            _labelGView.frame = CGRectMake(self.containerView.frame.size.width - 5, CGRectGetHeight(self.tableView.frame) - _labelGViewHeight, 5, _labelGViewHeight);
        }else if (p < 0) {
            _labelGView.frame = CGRectMake(self.containerView.frame.size.width - 5, 0, 5, _labelGViewHeight);
        }
        
    }
}

- (void)setViewWithContainerView {
    // tableview顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_containerView.frame), 1)];
    topView.backgroundColor = [UIColor lightGrayColor];
    [_containerView addSubview:topView];
    // tableview底部横线
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_tableView.frame) + 1, CGRectGetWidth(_containerView.frame), 1)];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [_containerView addSubview:bottomView];
    // tableview右侧滚条左侧竖线
    UIView *scrollLeftView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_containerView.frame) - 6, 1, 1, CGRectGetHeight(_tableView.frame))];
    scrollLeftView.backgroundColor = [UIColor lightGrayColor];
    [_containerView addSubview:scrollLeftView];
}
#pragma mark - 联动滚动全屏
- (void)setTableViewContentOffSize:(NSNumber *)noti {
    
    //    _tableView.delegate = nil;
    CGPoint tablePoint = _tableView.contentOffset;
    CGFloat offY = [noti floatValue];
    
    tablePoint.y = offY;
    _tableView.contentOffset = tablePoint;
    //    _tableView.delegate = self;
}

/*
    *************通知进行数据的刷新**************
    status 选择状态
    type   选择的类型
 */
- (void)reloadtableViewData:(NSMutableDictionary *)noti {
    NSMutableDictionary *dic = noti;
    _typeDic = [NSMutableDictionary dictionary];
    _typeDic = dic;
    _currpage = 1;
    //            [selfWeak getCarInFactionList];
    [self clearDataAndLoadAgain];
    
}
//清空数据，从新请求
- (void)clearDataAndLoadAgain {
    _currpage = 1;
    _dataSource = nil;//重置数组，防止在之前的数组上添加
    [_tableView.mj_footer resetNoMoreData];
//    _selectedRow = -1;//取消当前状态下的选中
    [self loadDataWithCurrentPage:self.currpage withRefresh:NO];
}

#pragma mark  ------进度筛选------
- (void)progressPredicate {
    
    [HD_FULLView endEditing:YES];

    WeakObject(self);
    
    // 获取状态列表
    
//    NSArray *dataSource = @[@"开单信息",@"技师增项",@"备件确认",@"服务沟通",@"客户确认"];
    NSArray *dataSource = [[PorscheConstant shareConstant] getConstantListHasAllItemAtFirstPostionWithTableName:CoreDataOrderStatus];
//    NSMutableArray *array = [NSMutableArray array];
//    for (NSString *str in dataSource) {
//        PorscheConstantModel *tmp = [PorscheConstantModel new];
//        tmp.cvvaluedesc = str;
//        [array addObject:tmp];
//    }
    [PorscheMultipleListhView showSingleListViewFrom:self.headerView.progressSearchBt dataSource:dataSource selected:nil showArrow:NO direction:ListViewDirectionDown complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
        
        selfWeak.headerView.progressTF.text = constantModel.cvvaluedesc;
        selfWeak.processConstantModel = constantModel;
        [selfWeak clearDataAndLoadAgain];
    }];
}

//处理时间选择传入弹出框的时间
- (NSDate *)getTimeDataWithHeaderTextField:(UITextField *)firstTF with:(UITextField *)secondTF withIndex:(NSInteger)index {
    NSDate *inputD = nil;
    if (index == 1) {// 点开始
        if (secondTF.text.length && !firstTF.text.length) {
            inputD = [NSDate stringToDateWithString:secondTF.text];
            if ([secondTF.text containsString:@"PM"]) {
                inputD = [NSDate dateWithTimeInterval:12*60*60 sinceDate:inputD];
            }
        }else if (firstTF.text.length) {
            inputD = [NSDate stringToDateWithString:firstTF.text];
            if ([firstTF.text containsString:@"PM"]) {
                inputD = [NSDate dateWithTimeInterval:12*60*60 sinceDate:inputD];
            }
        }
    }else {//点结束
        if (firstTF.text.length && !secondTF.text.length) {
            inputD = [NSDate stringToDateWithString:firstTF.text];
            if ([firstTF.text containsString:@"PM"]) {
                inputD = [NSDate dateWithTimeInterval:12*60*60 sinceDate:inputD];
            }
        }else if (secondTF.text.length) {
            inputD = [NSDate stringToDateWithString:secondTF.text];
            if ([secondTF.text containsString:@"PM"]) {
                inputD = [NSDate dateWithTimeInterval:12*60*60 sinceDate:inputD];
            }
        }
    }
    return inputD;
}

#pragma mark - 时间弹窗选择
- (void)predictPayAboutDateWithView:(UIView *)view with:(UITextField *)textField {
     [HD_FULLView endEditing:YES]; //关闭键盘
     WeakObject(self)
     if (textField == _headerView.endTimeSearchTF) {
         NSDate *inputD = [self getTimeDataWithHeaderTextField:_headerView.TimeSearchTF with:_headerView.endTimeSearchTF withIndex:2];
         [HDPoperDeleteView showAlertViewAroundView:view title:@"时间筛选" style:HDLeftBillingDateChooseViewStyleTimeEnd withDate:inputD withResultBlock:^(NSString *resultStr) {
             if (resultStr.length) {
                 textField.text = resultStr;
             }else {
                 textField.text = @"";
             }
         }];
     
     }else if (textField == _headerView.TimeSearchTF){
         NSDate *inputD = [self getTimeDataWithHeaderTextField:_headerView.TimeSearchTF with:_headerView.endTimeSearchTF withIndex:1];
         [HDPoperDeleteView showAlertViewAroundView:view title:@"时间筛选" style:HDLeftBillingDateChooseViewStyleTimeBegin withDate:inputD withResultBlock:^(NSString *resultStr) {
             if (resultStr.length) {
                 textField.text = resultStr;
             }else {
                 textField.text = @"";
             }
        }];
     }else if (textField == _headerView.yujijiaocheStartTF) {
         NSDate *inputD = [self getTimeDataWithHeaderTextField:_headerView.yujijiaocheStartTF with:_headerView.yujijiaocheEndTF withIndex:1];
         [HDPoperDeleteView showAlertViewAroundView:view title:@"预计交车时间" style:HDLeftBillingDateChooseViewStyleTimeBegin withDate:inputD withResultBlock:^(NSString *resultStr) {
             if (resultStr.length) {
                 textField.text = resultStr;
             }else {
                 textField.text = @"";
             }
         }];
     }else if (textField == _headerView.yujijiaocheEndTF) {
         NSDate *inputD = [self getTimeDataWithHeaderTextField:_headerView.yujijiaocheStartTF with:_headerView.yujijiaocheEndTF withIndex:2];
         [HDPoperDeleteView showAlertViewAroundView:view title:@"预计交车时间" style:HDLeftBillingDateChooseViewStyleTimeEnd withDate:inputD withResultBlock:^(NSString *resultStr) {
             if (resultStr.length) {
                 textField.text = resultStr;
             }else {
                 textField.text = @"";
             }
         }];
     }
    
 }
 


//#pragma mark  ------时间筛选------
//- (void)timePredicate:(HDLeftBillingDateChooseViewStyle )style withButtom:(UIButton *)button withTF:(UITextField *)textField {
//    WeakObject(self);
//    //弹出框frame
//    [HD_FULLView endEditing:YES];
//    [HDPoperDeleteView showDateTimePredicateFrame:CGRectMake(0, 0, 480, 300) aroundView:button direction:UIPopoverArrowDirectionUp headerTitle:@"" isLimit:NO style:style complete:^(HDLeftBillingDateChooseViewStyle style, NSString *endStr) {
//        if (style == HDLeftBillingDateChooseViewStyleTimeBegin) {
//            textField.text = endStr;
//            // 选择了预计交车的时间，就清空今日交的选择
//            if (button == selfWeak.headerView.yujijiaocheStartSearchBtn) {
//                [selfWeak.headerView setLittleBtNormalStyleWithButton:selfWeak.headerView.todayJiaoBt withImageView:selfWeak.headerView.todayJiaoImageView];
//                [selfWeak.headerView setLittleBtNormalStyleWithButton:selfWeak.headerView.overdueJiaoBt withImageView:selfWeak.headerView.overdueJiaoImageView];
//                selfWeak.todayJiaoOrOverdueJiao = @0;
//            }
//            
//        }else if (style == HDLeftBillingDateChooseViewStyleTimeEnd) {
//            textField.text = endStr;
//            // 选择了预计交车的时间，就清空过期交的选择
//            if (button == selfWeak.headerView.yujijiaocheEndSearchBtn) {
//                [selfWeak.headerView setLittleBtNormalStyleWithButton:selfWeak.headerView.todayJiaoBt withImageView:selfWeak.headerView.todayJiaoImageView];
//                [selfWeak.headerView setLittleBtNormalStyleWithButton:selfWeak.headerView.overdueJiaoBt withImageView:selfWeak.headerView.overdueJiaoImageView];
//                selfWeak.todayJiaoOrOverdueJiao = @0;
//            }
//        }
//    }];
//    
//}

#pragma mark  ------headerView bottomView 下拉选择视图 ------

- (void)setupHeaderView {
    //日期选择器frame；
    __weak typeof(self) selfWeak = self;

    self.headerView = [[ItemListLeftHeaderView alloc]initWithCustomFrame:CGRectMake(0, 64, CGRectGetWidth(self.containerView.frame), 145)];
    self.bottomView = [[ItemListLeftBottomView alloc]initWithCustomFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49 - 64, CGRectGetWidth(self.containerView.frame), 49)];
    
    //headerView按钮Block事件
    self.headerView.itemListLeftHeaderViewBlock = ^(ItemListLeftHeaderViewStyle style,UIButton *sender) {
        _todayJiaoOrOverdueJiao = @0;
       if (style == ItemListLeftHeaderViewStyleProgressBt) {//进度筛选
           [selfWeak progressPredicate];
        }else if (style == ItemListLeftHeaderViewStyleCleanBt) {//清除按钮
            [selfWeak clearDataAndLoadAgain];
        }else if (style == ItemListLeftHeaderViewStyleSearchBt) {//搜索按钮
            [selfWeak clearDataAndLoadAgain];
            
        }else if (style == ItemListLeftHeaderViewStyleTimeBt) {//起始时间筛选
            
            [selfWeak predictPayAboutDateWithView:selfWeak.headerView.timeBtbg with:selfWeak.headerView.TimeSearchTF];
            
        }else if (style == ItemListLeftHeaderViewStyleEndTimeBt) {//截止时间筛选
            
            [selfWeak predictPayAboutDateWithView:selfWeak.headerView.endTimebtbg with:selfWeak.headerView.endTimeSearchTF];

        }else if (style == ItemListLeftHeaderViewStyleTodayBt) {//今日按钮
            [selfWeak clearDataAndLoadAgain];
          
        }else if (style == ItemListLeftHeaderViewStyleThisWeekBt) {//本周按钮
            [selfWeak clearDataAndLoadAgain];
            
        }else if (style == ItemListLeftHeaderViewStyleYujiJiaocheStartBt) {//预计交车起始
            
            [selfWeak predictPayAboutDateWithView:selfWeak.headerView.yujijiaocheStartBtn with:selfWeak.headerView.yujijiaocheStartTF];

        }else if (style == ItemListLeftHeaderViewStyleYujiJiaocheEndbt) {//预计交车结束
            
            [selfWeak predictPayAboutDateWithView:selfWeak.headerView.yujijiaocheEndBtn with:selfWeak.headerView.yujijiaocheEndTF];

            
        }else if (style == ItemListLeftHeaderViewStyleTodayJiaoBt) {//今日交bt
            _todayJiaoOrOverdueJiao = @1;
            [selfWeak clearDataAndLoadAgain];
        }else if (style == ItemListLeftHeaderViewStyleOverduejiaoBt) {//过期交bt
            _todayJiaoOrOverdueJiao = @2;
            [selfWeak clearDataAndLoadAgain];
        }
    };
   #pragma mark  ------ //底部视图 按钮时间
    self.bottomView.itemListLeftBottomViewBlock = ^(ItemListLeftBottomViewStyle style,UIButton *sender,NSInteger tapCount) {
        //全屏事件
        if (style == ItemListLeftBottomViewStyleFullScreen) {
            
            if ([sender.titleLabel.text isEqualToString:@"看报价详情"]) {
                [sender setTitle:@"看车辆进度" forState:UIControlStateNormal];
                [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleSelf right:[HDLeftSingleton shareSingleton].stepStatus - 1];
                
            }else {
                [sender setTitle:@"看报价详情" forState:UIControlStateNormal];
//<<<<<<< HEAD
//                [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_RIGHT_STEP_NOTIFINATION object:@{@"left":@0,@"right":@9,@"data":selfWeak.dataSource}];
//=======
                
                [[HDLeftSingleton shareSingleton] changeWorkFlowWithInfo:@{@"left":@0,@"right":@9,@"data":selfWeak.dataSource}];
                [[HDLeftSingleton shareSingleton] scrollAtTheSameTImeFromLeftToRight:@(selfWeak.tableView.contentOffset.y)];
////                [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_RIGHT_STEP_NOTIFINATION object:@{@"left":@0,@"right":@9,@"data":selfWeak.dataSource}];
//>>>>>>> 558021f9e266176167c5925c346fc0e88c6f8623
            }
        }
        //我的车辆
        if (style == ItemListLeftBottomViewStyleChooseMyCar) {
            if (tapCount % 2) {
                [selfWeak.bottomView.statusBt setImage:[UIImage imageNamed:@"work_list_29.png"] forState:UIControlStateNormal];
                _showMainCar = @1;
            }else {
                [selfWeak.bottomView.statusBt setImage:nil forState:UIControlStateNormal];
                _showMainCar = @0;
            }
//            [selfWeak getCarInFactionList];
            [selfWeak clearDataAndLoadAgain];
        }
        
    };
    

    
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bottomView];

}

#pragma mark  ------poper代理方法，将要消失- 停止定时器-----

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    
    return YES;
}

#pragma mark  ------scroll------


- (UIView *)containerView {
    if (!_containerView) {
        
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.baseView.frame), CGRectGetHeight(self.baseView.frame))];
        
        _containerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
    
    if ([scrollView isEqual:_baseView]) {
//        //捏合或者移动时，确定正确的center
//        CGFloat centerX = scrollView.center.x;
//        
//        CGFloat centerY = scrollView.center.y;
//        
//        //随时获取center位置
//        centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : centerX;
//        
//        centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height / 2 : centerY;
        
        if (scrollView.contentSize.height > scrollView.frame.size.height) {
            _tableView.scrollEnabled = NO;
        }else {
            _tableView.scrollEnabled = YES;
        }
        
        NSLog(@"scrollView%@",scrollView);
        
        NSLog(@"containerView %@",self.containerView);
        
        
    }
   
}


#pragma mark  ------delegate------


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KandanLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KandanLeftTableViewCellid" forIndexPath:indexPath];
    
    [cell setShadow];
    //默认颜色 --保养，内联图标
    [cell setImage:@"" color:nil];
    
    PorscheNewCarMessage *data = _dataSource[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.carNumberLb.textColor = [UIColor blackColor];
    cell.carCategoryLb.textColor = [UIColor blackColor];
    cell.shadowSuperView.backgroundColor = [UIColor whiteColor];
    
    
    cell.carNumberLb.text = [ data.plateplace stringByAppendingString:data.ccarplate];
    cell.carCategoryLb.text = data.wocarcatena;

    [cell setCellStyleForData:data withSelect:NO];
    
    
//    if (indexPath.section == _selectedRow) {
//        [self setupCellSelected:cell model:data];
//    }
    if ([data.woid isEqual:[HDStoreInfoManager shareManager].carorderid]) {
        [self setupCellSelected:cell model:data];
    }
    
    
    [cell layoutIfNeeded];
    
    return cell;
}

- (void)setupCellSelected:(KandanLeftTableViewCell *)cell model:(PorscheNewCarMessage *)data {
    cell.carNumberLb.textColor = [UIColor whiteColor];
    cell.carCategoryLb.textColor = [UIColor whiteColor];
    cell.shadowSuperView.backgroundColor = MAIN_BLUE;
    [cell setCellStyleForData:data withSelect:YES];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self didClickIndexCell:indexPath];
}

- (void)didClickIndexCell:(NSIndexPath *)idx {
//    _selectedRow = idx.section;
    PorscheNewCarMessage *model = self.dataSource[idx.section];
    //点击 获取工单id，
    [HDStoreInfoManager shareManager].carorderid = model.woid;
    [self.tableView reloadData];
    [HDLeftSingleton shareSingleton].carModel = model;

    [HDLeftSingleton shareSingleton].maxStatus = [model.wostatus integerValue];
    [[HDLeftSingleton shareSingleton].HDRightViewController changeItemColor:nil];
    [self didSelectedCar];
}

- (void)didSelectedCar {
    if (![self.bottomView.fullScreenBt.titleLabel.text isEqualToString:@"看报价详情"]) {
        [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleSelf right:HDRightStatusStyleBilling];
    }
}

/*
//获取单车信息
- (void)getSingleCarMessageWithIndex:(NSIndexPath *)idx {
    WeakObject(self);
    [PorscheRequestManager getSingleCarMessagecomplete:^(PorscheNewCarMessage *model, PResponseModel *responser) {
        if (model) {
            NSLog(@"获取单车信息成功");
            [selfWeak.dataSource replaceObjectAtIndex:idx.section withObject:model];
            [[NSNotificationCenter defaultCenter] postNotificationName:BILLING_CAR_MESSAGE_NOTIFINATION object:model];
        }else {
            NSLog(@"获取单车信息失败");

        }
    }];
}
*/

- (void)hiddenListView:(UIButton *)sender {
    [self setTFregisterFirst];

}

- (void)setTFregisterFirst {
    __weak typeof(self) selfWeak = self;
    [selfWeak.headerView.progressTF resignFirstResponder];
    [selfWeak.headerView.TimeSearchTF resignFirstResponder];
    [selfWeak.headerView.VINSearchTF resignFirstResponder];
    
}

- (void)setFullBtTitle {
    [self.bottomView.fullScreenBt setTitle:@"看报价详情" forState:UIControlStateNormal];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


#pragma mark - 处理进度筛选的参数
- (NSNumber *)getNumeberForProgressText:(NSString *)progressText {
    NSNumber *type = @0;
    if ([progressText isEqualToString:@"开单信息"]) {
        type = @1;
    }else if ([progressText isEqualToString:@"技师增项"]) {
        type = @2;
    }else if ([progressText isEqualToString:@"备件确认"]) {
        type = @3;
    }else if ([progressText isEqualToString:@"服务沟通"]) {
        type = @4;
    }else if ([progressText isEqualToString:@"客户确认"]) {
        type = @5;
    }
    return type;
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
