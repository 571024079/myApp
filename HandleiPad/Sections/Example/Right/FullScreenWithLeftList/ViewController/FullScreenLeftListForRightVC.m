//
//  FullScreenLeftListForRightVC.m
//  HandleiPad
//
//  Created by handou on 16/10/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "FullScreenLeftListForRightVC.h"
#import "FullScreenLeftListForRightHeaderView.h"
#import "HDFullScreenLeftListForRightBottomVeiw.h"
#import "HDFullScreenLeftListForRightCell.h"
#import "HDLeftListModel.h"
#import "HDWorkListTableViews.h"
#import "HDLeftSingleton.h"//单例
#import "HDRightViewController.h"
#import "HDMainShopInformationModel.h"
//保存弹窗
#import "HDNewSaveView.h"
#import "HDPoperDeleteView.h"//确认删除的弹窗
#import "HDLeftSingleton.h"
@interface FullScreenLeftListForRightVC ()<UITableViewDataSource, UITableViewDelegate, FullScreenLeftListForRightHeaderViewDelegate>
//顶部视图
@property (nonatomic, strong) FullScreenLeftListForRightHeaderView *headerView;
//底部视图
@property (nonatomic, strong) HDFullScreenLeftListForRightBottomVeiw *bottomView;
//内容tableview
@property (nonatomic, strong) UITableView *tableView;
//顶部下拉视图
@property (nonatomic, strong) HDWorkListTableViews *headerPopTableView;
//遮挡 显示弹出视图
@property (nonatomic, strong) UIView *clearView;
//下拉选型状态
@property (nonatomic, assign) FullScreenListForRightHeaderBottomPopViewStatus bottomPopStatus;
//下拉选项的集合
@property (nonatomic, strong) NSMutableDictionary *typeDic;
//在厂车辆本店工单信息
@property (nonatomic, strong) HDMainShopInformationModel *mainShopInformation;

@end

@implementation FullScreenLeftListForRightVC
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"FullScreenLeftListForRightVC.dealloc");
}
//数据
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
//下拉选项的集合
- (NSMutableDictionary *)typeDic {
    if (!_typeDic) {
        _typeDic = [NSMutableDictionary dictionary];
        [_typeDic hs_setSafeValue:@0 forKey:@"type1"];
        [_typeDic hs_setSafeValue:@0 forKey:@"type2"];
        [_typeDic hs_setSafeValue:@0 forKey:@"type3"];
        [_typeDic hs_setSafeValue:@0 forKey:@"type4"];
        [_typeDic hs_setSafeValue:@0 forKey:@"type5"];
    }
    return _typeDic;
}
//顶部视图
- (FullScreenLeftListForRightHeaderView *)headerView {
    if (!_headerView) {
        self.headerView = [[FullScreenLeftListForRightHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 145)];
        self.headerView.delegate = self;
    }
    return _headerView;
}
//主视图tableview
- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 145 + 1, CGRectGetWidth(self.view.frame) - 20, CGRectGetHeight(self.view.frame) - 145 - 2 - 49) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"HDFullScreenLeftListForRightCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        _tableView.backgroundColor = Color(240, 240, 240);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
//底部视图
- (HDFullScreenLeftListForRightBottomVeiw *)bottomView {
    if (!_bottomView) {
        _bottomView = [[HDFullScreenLeftListForRightBottomVeiw alloc] initWithCustomFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49)];
    }
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDStayFactoryList_JiaoChe]) {
        
        _bottomView.jiaocheView.hidden = YES;
    }else {
        _bottomView.jiaocheView.hidden = NO;
    }
    return _bottomView;
}
//顶部视图下拉tableview
- (HDWorkListTableViews *)headerPopTableView {
    if (!_headerPopTableView) {
        self.headerPopTableView = [[HDWorkListTableViews alloc] initWithCustomFrame:CGRectMake(self.headerView.bottomView1.frame.origin.x, self.headerView.bottomView1.frame.origin.y + 35, CGRectGetWidth(self.headerView.bottomView1.frame), 200)];
        _headerPopTableView.backgroundColor = MAIN_BLUE;
        _headerPopTableView.needAccessoryDisclosureIndicator = NO;
    }
    return _headerPopTableView;
}
// 遮挡View 收起下拉的view
- (UIView *)clearView {
    if (!_clearView) {
        self.clearView = [HDLeftSingleton shareSingleton].clearView;
    }
    return _clearView;
}

- (void)viewDidLayoutSubviews {
    _headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 145);
    _tableView.frame = CGRectMake(10, 145 + 1, CGRectGetWidth(self.view.frame) - 20, CGRectGetHeight(self.view.frame) - 145 - 2 - 49);
    _bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49);
    // 加载边框线
    [self setViewWithContentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_RIGHT_STEP_NOTIFINATION object:@{@"left":@0,@"right":@0}];
    [[HDLeftSingleton shareSingleton] changeWorkFlowWithInfo:@{@"left":@0,@"right":@0}];

    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color(240, 240, 240);
    
    // 加载顶部视图
    [self.view addSubview:self.headerView];
    // 加载内容视图
    [self.view addSubview:self.tableView];
    // 加载底部视图
    [self.view addSubview:self.bottomView];
    
    //给左边添加通知，滑动的时候调用方法
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTableViewContentOffSize:) name:FULLSCREEN_LESTLIST_LEFTSCROLL_NOTIFINATION object:nil];
    //当左边进行数据请求的时候，接收数据
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataForLeftListViewWithArray:) name:FULLSCREEN_LEFTLIST_LEFTDATASOURCE_NOTIFINATION object:nil];
    
    // 设置底部视图
    [self setBottomViewStyle];
    //获取在厂车辆本店工单信息
    [self loadMainShooInformationData];
}
- (void)setViewWithContentView {
    // tableview顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 145, CGRectGetWidth(self.view.frame), 1)];
    topView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:topView];
    // tableview底部横线
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 1, CGRectGetWidth(self.view.frame), 1)];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bottomView];
    
    
}
#pragma mark - 联动滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        // 当前又边的视图滚动
//        [[NSNotificationCenter defaultCenter] postNotificationName:FULLSCREEN_LESTLIST_RIGHTSCROLL_NOTIFINATION object:@(scrollView.contentOffset.y)];
        [[HDLeftSingleton shareSingleton] scrollAtTheSameTimeFromRightToLeft:@(scrollView.contentOffset.y)];
    }
}
- (void)setTableViewContentOffSize:(NSNumber *)noti {
    CGPoint tablePoint = _tableView.contentOffset;
    CGFloat offY = [noti floatValue];
    
    tablePoint.y = offY;
    _tableView.contentOffset = tablePoint;
}
#pragma mark - 接收左侧数据
- (void)loadDataForLeftListViewWithArray:(NSMutableArray *)noti {
    NSMutableArray *array = noti;
    self.dataSource = [NSMutableArray array];
    self.dataSource = array;
    [_tableView reloadData];
    [self loadMainShooInformationData];
}
#pragma mark - 在厂车辆本店工单信息
- (void)loadMainShooInformationData {
    WeakObject(self)
    [PorscheRequestManager mainShopInformationcompletion:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            selfWeak.mainShopInformation = [HDMainShopInformationModel dataFormDic:responser.object];
            selfWeak.headerView.jinriJiaocheLabel.attributedText = [selfWeak setHeaderViewMainShopInformationLabelStyle:[selfWeak.mainShopInformation.todaysubnum stringValue] WithColor:MAIN_BLUE withAllStr:@"今日交车：台"];
            selfWeak.headerView.yiguoYujiJiaocheShijianLabel.attributedText = [selfWeak setHeaderViewMainShopInformationLabelStyle:[selfWeak.mainShopInformation.exprienum stringValue] WithColor:MAIN_RED withAllStr:@"已过期预计交车：台"];
            selfWeak.headerView.zaichangCheliangZongjiLabel.attributedText = [selfWeak setHeaderViewMainShopInformationLabelStyle:[selfWeak.mainShopInformation.instorenum stringValue] WithColor:MAIN_BLUE withAllStr:@"在厂车辆总计：台"];
            selfWeak.headerView.kehuYiQuerenLabel.attributedText = [selfWeak setHeaderViewMainShopInformationLabelStyle:[selfWeak.mainShopInformation.customerconfirmnum stringValue] WithColor:MAIN_BLUE withAllStr:@"客户已确认：台"];
        }
    }];
}
#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDFullScreenLeftListForRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.cornerRadius = 8;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDFullScreenLeftListForRightCell" owner:self options:nil] firstObject];
    }
    PorscheNewCarMessage *data = _dataSource[indexPath.section];
    
    [cell setCellWithData:data];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 10)];
    view.backgroundColor = Color(240, 240, 240);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }else {
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}




#pragma mark - HeaderDelegate
- (void)bottomViewButtonActionForHeader:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1001: // 开单信息选项
        {
            [self setHeaderPopViewWithHeader:self.headerView pop:self.headerView.bottomView1 label:self.headerView.bottomLabel1 dataSource:@[@"全部显示",@"进行中",@"已完成"] tag:sender.tag];
        }
            break;
        case 1002: // 技师增项
        {
            [self setHeaderPopViewWithHeader:self.headerView pop:self.headerView.bottomView2 label:self.headerView.bottomLabel2 dataSource:@[@"全部显示",@"待开始",@"进行中",@"车间待确认", @"车间进行中", @"车间已确认", @"已完成",@"备件通知",@"确认通知",@"增项通知"] tag:sender.tag];
        }
            break;
        case 1003: // 备件确认
        {
            [self setHeaderPopViewWithHeader:self.headerView pop:self.headerView.bottomView3 label:self.headerView.bottomLabel3 dataSource:@[@"全部显示",@"待开始",@"进行中",@"已完成",@"确认通知",@"增项通知"] tag:sender.tag];
        }
            break;
        case 1004: // 服务沟通
        {
            [self setHeaderPopViewWithHeader:self.headerView pop:self.headerView.bottomView4 label:self.headerView.bottomLabel4 dataSource:@[@"全部显示",@"待开始",@"进行中",@"保修待审批",@"已完成"] tag:sender.tag];
        }
            break;
        case 1005: // 客户确认
        {
            [self setHeaderPopViewWithHeader:self.headerView pop:self.headerView.bottomView5 label:self.headerView.bottomLabel5 dataSource:@[@"全部显示",@"待开始",@"进行中",@"已完成"] tag:sender.tag];
        }
            break;
        default:
            break;
    }
}

- (void)setHeaderPopViewWithHeader:(FullScreenLeftListForRightHeaderView *)view pop:(UIView *)popView label:(UILabel *)label dataSource:(NSArray *)array tag:(NSInteger)tag {
    WeakObject(self)
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSString *str in array) {
        PorscheConstantModel *tmp = [PorscheConstantModel new];
        tmp.cvvaluedesc = str;
        [tempArr addObject:tmp];
    }
    [PorscheMultipleListhView showSingleListViewFrom:popView dataSource:tempArr selected:nil showArrow:NO direction:ListViewDirectionDown complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
        
        label.text = constantModel.cvvaluedesc;
        NSMutableDictionary *dic = [selfWeak bottomPopViewSelectDataWithString:label.text tag:tag];
        
        //通知左侧进行数据刷新
//        [[NSNotificationCenter defaultCenter] postNotificationName:FULLSCREEN_LESTLIST_RIGHTSELECTSTATUS_NOTIFINATION object:dic];
        [[HDLeftSingleton shareSingleton] reloadDataFromRightFull:dic];
    }];
}

- (NSMutableDictionary *)bottomPopViewSelectDataWithString:(NSString *)string tag:(NSInteger)tag {
    //选择状态
    if ([string isEqualToString:@"全部显示"]) {
        _bottomPopStatus = FullScreenListForRightHeaderBottomPopViewStatus_none;
    }else if ([string isEqualToString:@"进行中"]) {
        _bottomPopStatus = FullScreenListForRightHeaderBottomPopViewStatus_ing;
    }else if ([string isEqualToString:@"已完成"]) {
        _bottomPopStatus = FullScreenListForRightHeaderBottomPopViewStatus_finish;
    }else if ([string isEqualToString:@"待开始"]) {
        _bottomPopStatus = FullScreenListForRightHeaderBottomPopViewStatus_waltStart;
    }else if ([string isEqualToString:@"车间进行中"]) {
        _bottomPopStatus = FullScreenListForRightHeaderBottomPopViewStatus_chejianIng;
    }else if ([string isEqualToString:@"增项通知"]) {
        _bottomPopStatus = FullScreenListForRightHeaderBottomPopViewStatus_add_noti;
    }else if ([string isEqualToString:@"确认通知"]) {
        _bottomPopStatus = FullScreenListForRightHeaderBottomPopViewStatus_affirm_noti;
    }else if ([string isEqualToString:@"备件通知"]) {
        _bottomPopStatus = FullScreenListForRightHeaderBottomPopViewStatus_spareParts_noti;
    }else if ([string isEqualToString:@"车间已确认"]) {
        _bottomPopStatus = FullScreenListForRightHeaderBottomPopViewStatus_chejianFinish;
    }else if ([string isEqualToString:@"车间待确认"]) {
        _bottomPopStatus = FullScreenListForRightHeaderBottomPopViewStatus_chejianWait_affirm;
    }else {
        _bottomPopStatus = FullScreenListForRightHeaderBottomPopViewStatus_none;
    }
    
    switch (tag) {
        case 1001:
            [self.typeDic setObject:@(_bottomPopStatus) forKey:@"type1"];
            break;
        case 1002:
            [self.typeDic setObject:@(_bottomPopStatus) forKey:@"type2"];
            break;
        case 1003:
            [self.typeDic setObject:@(_bottomPopStatus) forKey:@"type3"];
            break;
        case 1004:
            [self.typeDic setObject:@(_bottomPopStatus) forKey:@"type4"];
            break;
        case 1005:
            [self.typeDic setObject:@(_bottomPopStatus) forKey:@"type5"];
            break;
        default:
            break;
    }
    return self.typeDic;
}

#pragma mark - 设置底部视图
- (void)setBottomViewStyle {
    WeakObject(self);
    self.bottomView.hDFullScreenLeftListForRightBottomVeiwBlock = ^(UIButton *sender) {
        
        switch (sender.tag) {
            case 1001://确认返回
            {
                HDRightViewController *selfParentVC = (HDRightViewController *)selfWeak.parentViewController;
                
                if (selfParentVC.style == ViewControllerEntryStyleCarInFac) {
                    [[HDLeftSingleton shareSingleton].VC billingBackToFirstView];
                }else {
                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:FULLSCREEN_LEFTLIST_ACTIONWITHRIGHTVIEW_NOTIFITION object:nil];
                    [[HDLeftSingleton shareSingleton] reloadViewAfterFullScreenBack];
                }
            }
                break;
            case 1002://交车
            {
                [selfWeak jiaocheActionWithButton:sender];
            }
                break;
            default:
                break;
        }
    };
}
#pragma mark  获取工单实时状态
/*
- (void)getCurrentStatus {
    WeakObject(self);
    [PorscheRequestManager getWorkOrderCurrentStatusComplete:^(NSInteger status, PResponseModel * _Nullable responser) {
        if (status == 100) {
            OrderOptStatusDto *orderStatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
            if ([orderStatus.wostatus isEqualToNumber:@8]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NEW_BILLING_CAR_SAVE_NOTIFINATION object:@1];
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"当前车辆已交车" height:60 center:self.view.center superView:self.view];
            }else {
                [selfWeak jiaocheActionButton:selfWeak.bottomView.jiaocheBt];
            }
            
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:self.view.center superView:self.view];
        }
    }];
}
*/
#pragma mark - 交车事件
- (void)jiaocheActionWithButton:(UIButton *)sender {
    
    if ([[[HDStoreInfoManager shareManager] carorderid] integerValue] == 0)
    {
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未选择车辆" height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
        return;
    }
    [self getCarOrderMessage];
}
#pragma mark 获取该工单实时工单信息

- (PorscheNewCarMessage *)getCurrentMessage {
    NSNumber *carorderid = [HDStoreInfoManager shareManager].carorderid;

    if (!carorderid)
    {
        return nil;
    }
    
    for (PorscheNewCarMessage *message in self.dataSource) {
        if ([message.woid isEqualToNumber:carorderid]) {
            return message;
        }
    }
    return nil;
}

- (void)getCarOrderMessage {
    if (![[HDStoreInfoManager shareManager].carorderid integerValue]) {
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未选择车辆" height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
        return;
    }
    WeakObject(self);
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self.view];
    __block PorscheNewCarMessage *message = [self getCurrentMessage];
    
    [PorscheRequestManager getSingleCarMessagecomplete:^(PorscheNewCarMessage * _Nonnull model, PResponseModel * _Nonnull responser) {
        [hud hideAnimated:YES];
        if (model) {
            message = model;
            [selfWeak jiaocheActionButton:selfWeak.bottomView.jiaocheBt];
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:HD_FULLView];
        }
    }];
}



- (void)jiaocheActionButton:(UIButton *)sender  {
    WeakObject(self)

    //客户未确认不能交车--获取最新状态
    NSNumber *carorderid = [HDStoreInfoManager shareManager].carorderid;
    
    
    
    if (carorderid) {
        BOOL isShowPop = NO;
        for (PorscheNewCarMessage *model in selfWeak.dataSource) {
            if ([model.woid isEqual:carorderid]) {
                if ([model.wostatus isEqualToNumber:@8]) {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"当前车辆已交车" height:60 center:KEY_WINDOW.center superView:HD_FULLView];
                    [HDStoreInfoManager shareManager].carorderid = nil;
                    [[HDLeftSingleton shareSingleton] reloadLeftBillingList:@1];
                    return;
                }
                if (![model.wostatus isEqualToNumber:@7]) {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"客户未确认不能交车" height:60 center:KEY_WINDOW.center superView:HD_FULLView];
                    return;
                }
                
                
                if ([model.existguarantee integerValue] == 1) {
                    isShowPop = YES;
                }else {
                    isShowPop = NO;
                }
            }
        }
        if (isShowPop) {
            [HDPoperDeleteView showAlertViewAroundView:sender titleArr:@[@"工单存在保修未审核方案，一旦交车确认，视为保修方案审核通过",@"确定",@"取消"] direction:UIPopoverArrowDirectionDown sure:^{
                [HDNewSaveView showMakeSureViewAroundView:sender tittleArray:@[@"确认交车？",@"确定",@"取消"] direction:UIPopoverArrowDirectionUp makeSure:^{
                    
                    
                    [PorscheRequestManager jiaocheForFullScreenRightViewcompletion:^(PResponseModel * _Nonnull responser) {
                        if (responser.status == 100) {
                            [AlertViewHelpers saveDataActionWithImage:nil message:@"交车成功" height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
                            //通知左侧进行数据刷新
//                            [[NSNotificationCenter defaultCenter] postNotificationName:FULLSCREEN_LESTLIST_RIGHTSELECTSTATUS_NOTIFINATION object:selfWeak.typeDic];
                            [[HDLeftSingleton shareSingleton] reloadDataFromRightFull:selfWeak.typeDic];

                        }else {
                            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
                        }
                    }];
                    
                    
                } cancel:^{
                    
                }];
            } refuse:^{
                
            } cancel:^{
                
            }];
        }else {
            [HDNewSaveView showMakeSureViewAroundView:sender tittleArray:@[@"确认交车？",@"确定",@"取消"] direction:UIPopoverArrowDirectionUp makeSure:^{
                
                [PorscheRequestManager jiaocheForFullScreenRightViewcompletion:^(PResponseModel * _Nonnull responser) {
                    if (responser.status == 100) {
                        [AlertViewHelpers saveDataActionWithImage:nil message:@"交车成功" height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
                        //通知左侧进行数据刷新
//                        [[NSNotificationCenter defaultCenter] postNotificationName:FULLSCREEN_LESTLIST_RIGHTSELECTSTATUS_NOTIFINATION object:selfWeak.typeDic];
                        [[HDLeftSingleton shareSingleton] reloadDataFromRightFull:selfWeak.typeDic];

                    }else {
                        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
                    }
                }];
                
            } cancel:^{
                
            }];
        }
        
    }else {
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未选择车辆" height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
    }

}



#pragma mark - 处理headerView标签显示的样式
- (NSMutableAttributedString *)setHeaderViewMainShopInformationLabelStyle:(NSString *)str WithColor:(UIColor *)color withAllStr:(NSString *)allStr {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, str.length)];
    NSMutableAttributedString *allString = [[NSMutableAttributedString alloc] initWithString:allStr];
    [allString insertAttributedString:string atIndex:allStr.length - 1];
    return allString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
