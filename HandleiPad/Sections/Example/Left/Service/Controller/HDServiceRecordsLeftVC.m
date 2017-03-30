//
//  HDServiceRecordsLeftVC.m
//  HandleiPad
//
//  Created by handou on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceRecordsLeftVC.h"
#import "HDServiceLeftHeaderView.h"
#import "KandanLeftTableViewCell.h"
#import "HDServiceLeftBottomView.h"
#import "HDServiceLeftContentView.h"
#import "HDLeftSingleton.h"//单例
#import "PorscheCustomModel.h"//常量
#import "HWDateHelper.h"//时间
#import "HDPoperDeleteView.h"//时间弹出有
#import "PHTTPManager.h"
#import "HDMoreListView.h"//下拉框


@interface HDServiceRecordsLeftVC ()<HDServiceLeftHeaderViewDelegate, UIPopoverControllerDelegate>
//显示状态(1->有购物车   2->没有购物车)
@property (nonatomic, strong) NSNumber *viewStatus;
////
//@property (nonatomic, strong) MBProgressHUD *refreshView;
//顶部视图
@property (nonatomic, strong) HDServiceLeftHeaderView *headerView;
//底部栏
@property (nonatomic, strong) HDServiceLeftBottomView *bottomView;
//内容视图
@property (nonatomic, strong) HDServiceLeftContentView *contentView;
// 列表数据
@property (nonatomic, strong) NSMutableArray *dataSource;
//选中index
@property (nonatomic, assign) NSInteger selectedRow;

//保存车系列表数据
@property(nonatomic, strong) NSArray *carSeries;
//常量人员列表
@property (nonatomic, strong) NSMutableArray *personnelArray;
//选择的人员数据
@property (nonatomic, strong) PorscheConstantModel *personSelectData;
//选择的更多标签数据
@property (nonatomic, strong) PorscheConstantModel *carflgSelectData;
//暂存车系类型
@property (nonatomic, strong) NSNumber *chexiID;
//暂存车型类型
@property (nonatomic, strong) NSNumber *typeID;
//保存我的车辆选择
@property (nonatomic, assign) BOOL isShowMyCar;
//全部按钮的选择
@property (nonatomic, assign) BOOL isSelectAll;
//赋值界面style的时候只刷新一次
@property (nonatomic, assign) BOOL isFirstGetViewStatus;
//数据总页数
@property (nonatomic, assign) NSInteger pagecount;
//当前的页数
@property (nonatomic, assign) NSInteger currpage;

@end

@implementation HDServiceRecordsLeftVC
- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"HDServiceRecordsLeftVC释放啦!!!");
}
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        //增加通知判断在什么界面
////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setViewForm:) name:SERVICERECORDS_RIGHTTOLEFT_DATA_NOTIFINATION object:nil];
//    }
//    return self;
//}
#pragma mark - 懒加载
- (HDServiceLeftHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HDServiceLeftHeaderView alloc] initWithCustomFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 140)];
        _headerView.delegate = self;
    }
    return _headerView;
}
- (HDServiceLeftBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[HDServiceLeftBottomView alloc] initWithCustomFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49)];
    }
    return _bottomView;
}
- (HDServiceLeftContentView *)contentView {
    if (!_contentView) {
        _contentView = [[HDServiceLeftContentView alloc] initWithCustomFrame:CGRectMake(0,  140, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 140 - 49)];
    }
    return _contentView;
}

- (void)viewWillLayoutSubviews {
    _headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 140);
    _bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49);
    _contentView.frame = CGRectMake(0, 140, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 140 - 49);
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加顶部视图
    [self.view addSubview:self.headerView];
    //添加底部视图
    [self.view addSubview:self.bottomView];
    //添加内容视图
    [self.view addSubview:self.contentView];
    //添加底部视图回调方法
    [self bottomViewAction];
    // 获取人员常量列表
    [self getCustomData];
    
    self.contentView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.contentView.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithCurrentPagewithKaidanVC)];
    _contentView.viewStatus = _viewStatus;
}

#pragma mark - 设置界面进入的状态
- (void)setViewForm:(NSNumber *)noti {
    _viewStatus = noti;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 搜索车牌
    if ([HDLeftSingleton shareSingleton].carModel.plateplace.length && [HDLeftSingleton shareSingleton].carModel.ccarplate.length)
    {
        self.headerView.textFTopOne.text = [NSString stringWithFormat:@"%@%@",[HDLeftSingleton shareSingleton].carModel.plateplace,[HDLeftSingleton shareSingleton].carModel.ccarplate];
        _currpage = 1;
        self.dataSource = nil;//重置数组，防止在之前的数组上添加
        [_contentView.tableView.mj_footer resetNoMoreData];
        
        // 选择在场 并点击该车辆
        [self.headerView selectOnFactory];
    }
    else
    {
        [self clearDataAndLoadAgain];
    }
}

#pragma mark - 上拉加载
- (void)refreshDataWithCurrentPagewithKaidanVC {
    //如果要拉去的页数已经大于总页数，就不进行网络请求
    if (_pagecount && _currpage == _pagecount) {
        [self.contentView.tableView.mj_footer endRefreshing];
        return;
    }
    _currpage++;
    [self getCarInFactionListWithRefresh:YES];
}
#pragma mark - 下拉刷新
- (void)refreshData {
    [self clearDataAndLoadAgain];
    
}
//清空数据，从新请求
- (void)clearDataAndLoadAgain {
    _currpage = 1;
    self.dataSource = nil;//重置数组，防止在之前的数组上添加
    [_contentView.tableView.mj_footer resetNoMoreData];
    [self getCarInFactionListWithRefresh:NO];
    
}
#pragma mark - 获取人员常量列表
- (void)getCustomData {
    // 获取人员常量列表
    WeakObject(self)
    [PorscheRequestManager getStaffListTestWithGroupId:@0 positionId:@0 complete:^(NSMutableArray * _Nonnull classifyArray, PResponseModel * _Nonnull responser) {
        selfWeak.personnelArray = [NSMutableArray arrayWithArray:classifyArray];
    }];
}

//获取传递的参数
- (NSMutableDictionary *)getParam {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:_headerView.textFTopOne.text forKey:@"carinfo"];
    
    if ([_typeID integerValue] && [_chexiID integerValue]) {
        [param hs_setSafeValue:_typeID forKey:@"cartypeid"];
        [param hs_setSafeValue:@2 forKey:@"wocarlevel"];
    }else if (![_typeID integerValue] && [_chexiID integerValue] ) {
        [param hs_setSafeValue:_chexiID forKey:@"cartypeid"];
        [param hs_setSafeValue:@1 forKey:@"wocarlevel"];
    }
//    [param hs_setSafeValue:_chexiStr.length?_chexiStr:@"" forKey:@"carcatena"];
//    [param hs_setSafeValue:_typeStr.length?_typeStr:@"" forKey:@"cartype"];
    if (_headerView.textFMiddleOne.text.length) {
        [param hs_setSafeValue:[NSString removerTimeStrAMPMWithTime:_headerView.textFMiddleOne.text] forKey:@"startinfactory"];
    }else {
        [param hs_setSafeValue:@"" forKey:@"startinfactory"];
    }
    if (_headerView.textFMiddleTwo.text.length) {
        
        NSString *endtimeString = [NSString removerTimeStrAMPMWithTime:_headerView.textFMiddleTwo.text];
        endtimeString = [endtimeString stringByReplacingCharactersInRange:NSMakeRange(endtimeString.length - 6 , 6) withString:@"235959"];
        [param hs_setSafeValue:endtimeString forKey:@"endinfactory"];

    }else {
        [param hs_setSafeValue:@"" forKey:@"endinfactory"];
    }
    if (_personSelectData) {
        [param hs_setSafeValue:_personSelectData.cvsubid forKey:@"operator"];
    }else {
        [param hs_setSafeValue:@0 forKey:@"operator"];
    }
    if (_headerView.buttonBottomOne.selected) {
        [param hs_setSafeValue:@1 forKey:@"onlineflag"];
    }else {
        [param hs_setSafeValue:@0 forKey:@"onlineflag"];
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    if (_headerView.buttonBottomTwo.selected) {
        [tempArr addObject:@2];
    }
    if (_headerView.buttonBottomThree.selected) {
        [tempArr addObject:@3];
    }
    if (_carflgSelectData) {
        [tempArr addObject:_carflgSelectData.cvsubid];
    }
    NSString *carflgIDStr = @"";
    if (tempArr.count) {
        carflgIDStr = [tempArr componentsJoinedByString:@","];
    }
    [param hs_setSafeValue:carflgIDStr forKey:@"targetidarr"];
    
    if (_isShowMyCar) {
        [param hs_setSafeValue:[HDStoreInfoManager shareManager].userid forKey:@"userid"];
    }
    
    if ([_viewStatus integerValue] == 1) {
        if (!_isSelectAll) {
            [param hs_setSafeValue:[HDStoreInfoManager shareManager].carorderid forKey:@"orderid"];
        }
    }
    
    return param;
}
#pragma mark - 请求数据
//获取在场车辆信息
- (void)getCarInFactionListWithRefresh:(BOOL)isNeedRefresh {
    WeakObject(self);
    [HDStoreInfoManager shareManager].currpage = @(_currpage);
    [HDStoreInfoManager shareManager].pagesize = @20;
    NSMutableDictionary *param = [selfWeak getParam];
    
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self.view];
    WeakObject(hud)
    [PorscheRequestManager serviceRecordsLeftCarListWithParam:param completion:^(NSArray<PorscheNewCarMessage *> * _Nonnull carList, PResponseModel * _Nonnull responser) {
        [hudWeak hideAnimated:YES];
        [selfWeak.contentView.tableView.mj_header endRefreshing];
        if (isNeedRefresh) {
            [selfWeak.contentView.tableView.mj_footer endRefreshing];
        }
        if (carList.count && ![selfWeak.dataSource isEqual:carList]) {
            selfWeak.pagecount = responser.totalpages;
            [selfWeak.dataSource addObjectsFromArray:carList];
        }
        selfWeak.contentView.dataSource = selfWeak.dataSource;

        // 选中工单车辆
        // 搜索车牌
        if ([HDLeftSingleton shareSingleton].carModel.plateplace.length && [HDLeftSingleton shareSingleton].carModel.ccarplate.length)
        {
            NSString *carplate = [NSString stringWithFormat:@"%@%@",[HDLeftSingleton shareSingleton].carModel.plateplace,[HDLeftSingleton shareSingleton].carModel.ccarplate];
            for (PorscheNewCarMessage *carmessage in selfWeak.dataSource)
            {
                NSString *onecarplate = [NSString stringWithFormat:@"%@%@",carmessage.plateplace,carmessage.ccarplate];
                if ([onecarplate isEqualToString:carplate])
                {
                    NSInteger index = [selfWeak.dataSource indexOfObject:carmessage];
                    [selfWeak.contentView tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
                    break;
                }
            }
            
        }
        
        if (_pagecount && _currpage == _pagecount) {
            [selfWeak.contentView.tableView.mj_footer endRefreshingWithNoMoreData];
        }else if (!selfWeak.dataSource.count) {
            [selfWeak.contentView.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [selfWeak.contentView.tableView.mj_footer resetNoMoreData];
        }
    }];
}



#pragma mark - 底部视图点击方法block
- (void)bottomViewAction {
    WeakObject(self)
    self.bottomView.serviceLeftBottomViewBlock = ^(ServiceLeftBottomViewStyle style, UIButton *button, NSInteger count) {
        if (style == ServiceLeftBottomViewStyle_all) { //全部按钮
            if ([selfWeak.viewStatus integerValue] == 2) {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"已显示全部车辆" height:60 center:HD_FULLView.center superView:HD_FULLView];
                return ;
            }
            if (count % 2) {
                selfWeak.isSelectAll = YES;
            }else {
                selfWeak.isSelectAll = NO;
            }
            selfWeak.isSelectAll = YES;
            [selfWeak.headerView clear];

        }
        if (style == ServiceLeftBottomViewStyle_mycar) {//我的车辆
            if (count % 2) {
                selfWeak.isShowMyCar = YES;
                [selfWeak.bottomView.imageButton setImage:[UIImage imageNamed:@"billing_left_bottom_selected.png"] forState:UIControlStateNormal];
            }else {
                selfWeak.isShowMyCar = NO;
                [selfWeak.bottomView.imageButton setImage:nil forState:UIControlStateNormal];
            }
            [selfWeak clearDataAndLoadAgain];
        }
    };
}


#pragma mark - 顶部视图内容点击方法
- (void)serviceLeftHeaderButtonAction:(UIButton *)button withStyle:(ServiceLeftHeaderStyle)style {
    
    switch (style) {
        case ServiceLeftHeaderStyle_top_one://牌照/VIN/车型
            [self.headerView.textFTopOne becomeFirstResponder];
            break;
            
        case ServiceLeftHeaderStyle_top_two://车系
            [self getSeriesList];
            break;
            
        case ServiceLeftHeaderStyle_top_three://搜索

            [self clearDataAndLoadAgain];
            break;
        
        case ServiceLeftHeaderStyle_top_four: //清空
            
            [self clearAllSearchStatus];
            [self clearDataAndLoadAgain];
            break;
            
        case ServiceLeftHeaderStyle_middle_one://进厂时间
            
            [self predictPayAboutDateWithView:_headerView.viewMiddleOne with:_headerView.textFMiddleOne];
            break;
            
        case ServiceLeftHeaderStyle_middle_two://进厂时间
            
            [self predictPayAboutDateWithView:_headerView.viewMiddleTwo with:_headerView.textFMiddleTwo];
            break;
            
        case ServiceLeftHeaderStyle_middle_three://人员
            
            [self getPersonCustomList];
            break;
            
        case ServiceLeftHeaderStyle_bottom_one://在厂
            
            [self clearDataAndLoadAgain];
            break;
            
        case ServiceLeftHeaderStyle_bottom_two://常客
            
            [self clearDataAndLoadAgain];
            break;
            
        case ServiceLeftHeaderStyle_bottom_three://VIP
            
            [self clearDataAndLoadAgain];
            break;
            
        case ServiceLeftHeaderStyle_bottom_four://更多

            [self getCarflgList];
            break;
            
        default:
            break;
    }
}
#pragma mark - 获取车系车型列表
- (void)getSeriesList {
    WeakObject(self)
    [PorscheRequestManager getAllCarSeriersConstant:^(NSArray<PorscheConstantModel *> * _Nonnull carseriesList, PResponseModel * _Nonnull responser) {
        if (carseriesList.count) {
            //增加全部的选项，选中的效果相当与是清空数据
            PorscheConstantModel *allData = [[PorscheConstantModel alloc] init];
            allData.cvvaluedesc = @"全部";
            allData.cvsubid = @-1;
            NSMutableArray *temp = [carseriesList mutableCopy];
            [temp insertObject:allData atIndex:0];
            
            [HDMoreListView showListViewWithView:selfWeak.headerView.viewTopTwo Data:temp direction:UIPopoverArrowDirectionDown withType:viewFormStyle_carType complete:^(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx) {
                if ([contentOne.cvsubid isEqual:@-1] && [contentOne.cvvaluedesc isEqualToString:@"全部"]) {
                    selfWeak.headerView.textFTopTwo.text = @"";
                    selfWeak.chexiID  = nil;
                    selfWeak.typeID = nil;
                }else {
                    NSString *string = @"";
                    if (contentOne && contentTwo) {
                        string = [@[contentOne.cvvaluedesc, contentTwo.descr] componentsJoinedByString:@" "];
                        selfWeak.chexiID = contentOne.cvsubid;
                        selfWeak.typeID = contentTwo.cvsubid;
                    }else if (!contentTwo) {
                        string = contentOne.cvvaluedesc;
                        selfWeak.chexiID = contentOne.cvsubid;
                        selfWeak.typeID = nil;
                    }
                    selfWeak.headerView.textFTopTwo.text = string;
//                    selfWeak.chexiStr  = contentOne.cvvaluedesc.length ? contentOne.cvvaluedesc : @"";
//                    selfWeak.typeStr = contentTwo.descr.length ? contentTwo.descr : @"";
                }
            }];
        }
    }];
}
#pragma mark - 获取人员列表
- (void)getPersonCustomList {
    WeakObject(self);
    //增加全部的选项，选中的效果相当与是清空数据
    PorscheConstantModel *allData = [[PorscheConstantModel alloc] init];
    allData.cvvaluedesc = @"全部";
    allData.cvsubid = @-1;
    NSMutableArray *temp = [_personnelArray mutableCopy];
    [temp insertObject:allData atIndex:0];
    
    [PorscheMultipleListhView showSingleListViewFrom:self.headerView.viewMiddleThree dataSource:temp selected:nil showArrow:NO direction:ListViewDirectionUp complete:^(PorscheConstantModel *constantModel, NSInteger idx) {
        if ([constantModel.cvsubid isEqual:@-1] && [constantModel.cvvaluedesc isEqualToString:@"全部"]) {
            selfWeak.headerView.textFMiddleThree.text = @"";
            selfWeak.personSelectData = nil;
        }else {
            selfWeak.headerView.textFMiddleThree.text = constantModel.cvvaluedesc;
            selfWeak.personSelectData = constantModel;
        }
    }];
}
#pragma mark - 获取车辆标签列表
- (void)getCarflgList {
    WeakObject(self);
    
    [PorscheRequestManager carflgListForServiceRecordsLeftCompletion:^(NSArray<PorscheConstantModel *> * _Nonnull carflgList, PResponseModel * _Nonnull responser) {
        if (carflgList.count) {
            //增加全部的选项，选中的效果相当与是清空数据
            PorscheConstantModel *allData = [[PorscheConstantModel alloc] init];
            allData.cvvaluedesc = @"全部";
            allData.cvsubid = @-1;
            NSMutableArray *temp = [carflgList mutableCopy];
            [temp insertObject:allData atIndex:0];
            
            [PorscheMultipleListhView showSingleListViewFrom:self.headerView.viewBottomFour dataSource:temp selected:nil showArrow:NO direction:ListViewDirectionUp complete:^(PorscheConstantModel *constantModel, NSInteger idx) {
                if ([constantModel.cvsubid isEqual:@-1] && [constantModel.cvvaluedesc isEqualToString:@"全部"]) {
                    selfWeak.headerView.textFieldBottomFour.text = @"";
                    selfWeak.carflgSelectData = nil;
                }else {
                    selfWeak.headerView.textFieldBottomFour.text = constantModel.cvvaluedesc;
                    selfWeak.carflgSelectData = constantModel;
                }
            }];
        }
    }];
}
#pragma mark  - 进厂日期选择
- (void)predictPayAboutDateWithView:(UIView *)view with:(UITextField *)textField {
    [HD_FULLView endEditing:YES]; //关闭键盘
    WeakObject(self)
    if (textField == _headerView.textFMiddleTwo) {
        NSDate *inputD = nil;
        if (_headerView.textFMiddleOne.text.length) {
            inputD = [NSDate stringToDateWithString:_headerView.textFMiddleOne.text];
        }
        [HDPoperDeleteView showAlertViewAroundView:view title:@"进厂日期" style:HDLeftBillingDateChooseViewStyleTimeEnd withDate:inputD withResultBlock:^(NSString *resultStr) {
            if (resultStr.length) {
                textField.text = resultStr;
            }else {
                textField.text = @"";
            }
        }];
        
    }else {
        NSDate *inputD = nil;
        if (_headerView.textFMiddleTwo.text.length) {
            inputD = [NSDate stringToDateWithString:_headerView.textFMiddleTwo.text];
        }
        [HDPoperDeleteView showAlertViewAroundView:view title:@"进厂日期" style:HDLeftBillingDateChooseViewStyleTimeBegin withDate:inputD withResultBlock:^(NSString *resultStr) {
            if (resultStr.length) {
                textField.text = resultStr;
            }else {
                textField.text = @"";
            }
        }];
    }
}

#pragma mark - 清空所有的数据
- (void)clearAllSearchStatus {
    _chexiID  = nil;
    _typeID = nil;
    _personSelectData = nil;
    _carflgSelectData = nil;
}
#pragma mark - 顶部视图输入框代理方法
- (void)serviceLeftHeaderViewShouldReturn:(UITextField *)textField {
    if (textField == self.headerView.textFTopOne) {
        if (textField.text.length) {
            self.headerView.textFTopOne.text = textField.text;
            [self.headerView.textFTopOne resignFirstResponder];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
