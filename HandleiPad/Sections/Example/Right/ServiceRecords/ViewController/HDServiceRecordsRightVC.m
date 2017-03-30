//
//  HDServiceRecordsRightVC.m
//  HandleiPad
//
//  Created by handou on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceRecordsRightVC.h"
#import "HDServiceRightHeaderView.h"
#import "HDServiceRightBottomView.h"
#import "HDServiceRightContentView.h"
#import "HDLeftListModel.h"
#import "HDServiceRecordsRightModel.h"
#import "HDWorkListTableViews.h"
#import "HDLeftSingleton.h"//单例
#import "PorscheCustomModel.h"
//时间
#import "HWDateHelper.h"
#import "HDPoperDeleteView.h"

#import "HDServiceRightTextFieldView.h"
#import "PorscheConstant.h"//常量接口
#import "PorscheMultipleListhView.h"//新版下拉框
#import "HDServiceRecordsCarflgListSearchView.h"



@interface HDServiceRecordsRightVC ()<HDServiceRightHeaderViewDelegage>
//顶部视图
@property (nonatomic, strong) HDServiceRightHeaderView *headerView;
//底部栏
@property (nonatomic, strong) HDServiceRightBottomView *bottomView;
//内容视图
@property (nonatomic, strong) HDServiceRightContentView *contentView;
//顶部视图标签进行输入下拉提示
@property (nonatomic, strong) HDServiceRecordsCarflgListSearchView *carflgListSearchView;

//顶部下拉视图
@property (nonatomic, strong) HDWorkListTableViews *headerPopTableView;
//遮挡 显示弹出视图
@property (nonatomic, strong) UIView *clearView;
//保留键盘高度
@property (nonatomic, assign) CGRect keyViewRect;
//常量列表->（业务类型）
@property (nonatomic, strong) NSArray *bussnessTypeArray;
//类似常量,公里数列表
@property (nonatomic, strong) NSArray *mileList;
//暂存公里数 model
@property (nonatomic, strong) PorscheConstantModel *mileModel;


@end

@implementation HDServiceRecordsRightVC
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"HDServiceRecordsRightVC.dealloc");
}
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
}
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        //服务档案左侧点击cell传递数据(或者刷新数据)
////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceRightVCAction:) name:SERVICE_LEFT_DETAIL_DATASOURCE_NOTIFINATION object:nil];
//    }
//    return self;
//}
#pragma mark - 懒加载
- (HDServiceRightHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HDServiceRightHeaderView alloc] initWithCustomFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 140)];
        _headerView.delegate = self;
    }
    return _headerView;
}
- (HDServiceRightBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[HDServiceRightBottomView alloc] initWithCustomFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49)];
    }
    return _bottomView;
}
- (HDServiceRightContentView *)contentView {
    if (!_contentView) {
        _contentView = [[HDServiceRightContentView alloc] initWithCustomFrame:CGRectMake(0, 140, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 140 - 49)];
    }
    return _contentView;
}
- (HDServiceRecordsCarflgListSearchView *)carflgListSearchView {
    if (!_carflgListSearchView) {
        _carflgListSearchView = [[[NSBundle mainBundle] loadNibNamed:@"HDServiceRecordsCarflgListSearchView" owner:self options:nil] objectAtIndex:0];
        _carflgListSearchView.hidden = YES;
    }
//    _carflgListSearchView.frame = CGRectMake(CGRectGetMinX(self.headerView.headerViewTF.frame), CGRectGetMaxY(self.headerView.headerViewTF.superview.frame), 80, 1);
    return _carflgListSearchView;
}

//顶部视图下拉tableview
- (HDWorkListTableViews *)headerPopTableView {
    if (!_headerPopTableView) {
        self.headerPopTableView = [[HDWorkListTableViews alloc] initWithCustomFrame:CGRectMake(self.headerView.yewuleixingView.frame.origin.x, self.headerView.yewuleixingView.frame.origin.y + 35, CGRectGetWidth(self.headerView.yewuleixingView.frame), 200)];
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

//界面显示状态
- (void)setViewStatus:(NSNumber *)viewStatus {
    _viewStatus = viewStatus;
//    [[NSNotificationCenter defaultCenter] postNotificationName:SERVICERECORDS_RIGHTTOLEFT_DATA_NOTIFINATION object:_viewStatus];
    [[HDLeftSingleton shareSingleton]reloadServiceHistoryViewFromRight:_viewStatus];
    [self loadDatWithVin:_leftServiceModel.cid];
}

#pragma mark - Layout
- (void)viewWillLayoutSubviews {
    _headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 140);
    _bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49);
    _contentView.frame = CGRectMake(0, 140, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 140 - 49);
    _carflgListSearchView.frame = CGRectMake(CGRectGetMinX(self.headerView.headerViewTF.frame), CGRectGetMaxY(self.headerView.headerViewTF.superview.frame), 80, 1);

}
#pragma mark - 接受左侧的数据
- (void)setLeftServiceModel:(PorscheNewCarMessage *)leftServiceModel {
    _leftServiceModel = leftServiceModel;
    [self loadDatWithVin:_leftServiceModel.cid];
    _carflgListSearchView.frame = CGRectMake(CGRectGetMinX(self.headerView.headerViewTF.frame), CGRectGetMaxY(self.headerView.headerViewTF.superview.frame), 80, 1);
}

#pragma mark - 数据请求
/*
 biztype    业务类型(id)
 miles   公里数
 infactorytime  进厂日期
 outfactorytime   交车日期
 */
- (NSMutableDictionary *)getParamWithCARID:(NSNumber *)carid {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:carid forKey:@"carid"];
    if (_headerView.yewuleixingTF.text.length) {
        for (PorscheConstantModel *model in _bussnessTypeArray) {
            if ([model.cvvaluedesc isEqualToString:_headerView.yewuleixingTF.text]) {
                [param hs_setSafeValue:model.cvsubid forKey:@"biztype"];
            }
        }
    }else {
        [param hs_setSafeValue:@0 forKey:@"biztype"];
    }
    if (!([_mileModel.cvsubid integerValue] < 0) && [_mileModel.secondID integerValue]) {
        [param hs_setSafeValue:_mileModel.cvsubid forKey:@"mile1"];
        [param hs_setSafeValue:_mileModel.secondID forKey:@"mile2"];
    }else {
        [param hs_setSafeValue:@0 forKey:@"mile1"];
        [param hs_setSafeValue:@0 forKey:@"mile2"];
    }
    if (_headerView.jinchangriqiTF.text.length) {
        [param hs_setSafeValue:[NSString getStringForYearAndTime:_headerView.jinchangriqiTF.text] forKey:@"infactorytime"];
    }else {
        [param hs_setSafeValue:@"" forKey:@"infactorytime"];
    }
    if (_headerView.jiaocheriqiTF.text.length) {
        [param hs_setSafeValue:[NSString getStringForYearAndTime:_headerView.jiaocheriqiTF.text] forKey:@"outfactorytime"];
    }else {
        [param hs_setSafeValue:@"" forKey:@"outfactorytime"];
    }
    
    return param;
}
- (void)loadDatWithVin:(NSNumber *)carid {
    self.carflgListSearchView.hidden = YES;
    
    WeakObject(self)
    if ([carid integerValue]) {
        NSMutableDictionary *param = [self getParamWithCARID:carid];
        MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self.view];
        WeakObject(hud)
        [PorscheRequestManager serviceRecordsRightInformationWith:param completion:^(HDServiceRecordsRightModel * _Nonnull serviceRecordsRightModel, PResponseModel * _Nonnull responser) {
            if (responser.status == 100) {
                [hudWeak hideAnimated:YES];
                if (serviceRecordsRightModel) {
                    selfWeak.contentView.rightModel = serviceRecordsRightModel;
                    selfWeak.headerView.rightModel = serviceRecordsRightModel;
                    selfWeak.bottomView.rightModel = serviceRecordsRightModel;
                }
            }else {
                [hudWeak changeTextModeMessage:responser.msg toView:selfWeak.view];
            }
        }];
    }
    
//    self.contentView.viewStyle = (ServiceRightBottomViewStyle)[_viewStatus integerValue];
//    self.headerView.viewStyle = (ServiceRightBottomViewStyle)[_viewStatus integerValue];
//    self.bottomView.viewStyle = (ServiceRightBottomViewStyle)[_viewStatus integerValue];
    // 暂时从什么界面进入的操作都展示不带购物车的界面
    self.contentView.viewStyle = (ServiceRightBottomViewStyle)[@2 integerValue];
    self.headerView.viewStyle = (ServiceRightBottomViewStyle)[@2 integerValue];
    self.bottomView.viewStyle = (ServiceRightBottomViewStyle)[@2 integerValue];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加内容视图
    [self.view addSubview:self.contentView];
    //添加顶部视图
    [self.view addSubview:self.headerView];
    //添加底部视图
    [self.view addSubview:self.bottomView];
    //添加顶部视图标签进行输入下拉提示
    [self.view addSubview:self.carflgListSearchView];
    
    
    
//    //服务档案左侧点击cell传递数据(或者刷新数据)
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceRightVCAction:) name:SERVICE_LEFT_DETAIL_DATASOURCE_NOTIFINATION object:nil];
    
    //添加收键盘通知
    [self registerForKeyBoardNotifinations];
    
    //底部视图返回方法回调
    WeakObject(self)
    [selfWeak bottomViewControlAction];
    
    //内容视图返回方法回调
    [selfWeak contentViewControlAction];
    
    
    // 获取常量列表
    _bussnessTypeArray = [NSArray array];
    _bussnessTypeArray = [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataBusinesstype];
    //公里数列表
    [self getMliePoplist];
    
}

#pragma mark - 服务档案展开右侧的详情
- (void)serviceRightVCAction:(NSDictionary *)notif {
    // 点击cell->selectCell  刷新数据->updata
    NSDictionary *dic = notif;
    if ([dic[@"status"] isEqualToString:@"selectCell"]) {//点击cell
        
        self.leftServiceModel = dic[@"data"];
        
    }else if ([dic[@"status"] isEqualToString:@"updata"]){//数据更新
        
        self.leftServiceModel = dic[@"data"];
    }
}

#pragma mark - -------------------- 顶部视图代理方法 ----------------
- (void)serviceRightHeaderViewButtonAction:(UIButton *)sender withStyle:(ServiceRightHeaderViewButtonStyle)style {
    [self.headerView.headerViewTF resignFirstResponder];
    
    switch (style) {
        case ServiceRightHeaderViewButtonStyle_yewuleixing://业务类型
            [self setHeaderPopViewWithHeader:self.headerView pop:self.headerView.yewuleixingView textField:self.headerView.yewuleixingTF dataSource:_bussnessTypeArray button:sender withStyle:style];
            break;
        case ServiceRightHeaderViewButtonStyle_gognlishu://公里数
            [self setHeaderPopViewWithHeader:self.headerView pop:self.headerView.gonglishuView textField:self.headerView.gonglishuTF dataSource:_mileList button:sender withStyle:style];
            break;
        case ServiceRightHeaderViewButtonStyle_jinchangriqi://进厂时间
            [self predictPayAboutDateWithView:_headerView.jinchangriqiView with:_headerView.jinchangriqiTF withTitle:@"进厂时间"];
            break;
        case ServiceRightHeaderViewButtonStyle_jiaocheruqi://交车时间
            [self predictPayAboutDateWithView:_headerView.jiaocheriqiView with:_headerView.jiaocheriqiTF withTitle:@"交车时间"];
            break;
        case ServiceRightHeaderViewButtonStyle_search://搜索
            [self loadDatWithVin:_leftServiceModel.cid];
            break;
        case ServiceRightHeaderViewButtonStyle_edit://添加标签
            if (![HDPermissionManager isHasThisPermission:HDServiceRecords_EditCarflg]) {
                return;
            }
            [self headerViewTextFieldAction];
            break;
        case ServiceRightHeaderViewButtonStyle_clear://清空
            _mileModel = nil;
            [self loadDatWithVin:_leftServiceModel.cid];

            break;
        default:
            break;
    }
}

#pragma mark - 业务类型/公里数
- (void)setHeaderPopViewWithHeader:(HDServiceRightHeaderView *)view pop:(UIView *)popView textField:(UITextField *)textField dataSource:(NSArray *)array button:(UIButton *)sender withStyle:(ServiceRightHeaderViewButtonStyle)style {
    WeakObject(self)
    //增加全部的选项，选中的效果相当与是清空数据
    PorscheConstantModel *allData = [[PorscheConstantModel alloc] init];
    allData.cvvaluedesc = @"全部";
    allData.cvsubid = @-1;
    NSMutableArray *temp = [array mutableCopy];
    [temp insertObject:allData atIndex:0];
    
    [PorscheMultipleListhView showSingleListViewFrom:textField dataSource:temp selected:nil showArrow:NO direction:ListViewDirectionUp complete:^(PorscheConstantModel *constantModel, NSInteger idx) {
        if ([constantModel.cvsubid isEqual:@-1] && [constantModel.cvvaluedesc isEqualToString:@"全部"]) {
            textField.text = @"";
            selfWeak.mileModel = nil;
        }else {
            textField.text = constantModel.cvvaluedesc;
            if (textField == selfWeak.headerView.gonglishuTF) {
                selfWeak.mileModel = constantModel;
            }
        }
    }];
}

#pragma mark - 公里数列表
- (void)getMliePoplist {
    WeakObject(self)
    [PorscheRequestManager resviceRecordsKMList:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            
            NSMutableArray *temp = [NSMutableArray array];
            /**
             用 cvsubid 来存第一个 id
             用 secondID 来存第二个 id
             */
            for (NSDictionary *dic in responser.list) {
                PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
                model.cvvaluedesc = dic[@"hcldesc"];
                model.cvsubid = dic[@"hclvalue1"];
                model.secondID = dic[@"hclvalue2"];
                [temp addObject:model];
            }
            
            selfWeak.mileList = [NSArray arrayWithArray:temp];
            
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
        }
    }];
}

#pragma mark  - 日期选择
- (void)predictPayAboutDateWithView:(UIView *)view with:(UITextField *)textField withTitle:(NSString *)title {
    [HD_FULLView endEditing:YES];
    [HDPoperDeleteView showDateAndWeekViewWithFrame:CGRectMake(0, 0, 300, 200) aroundView:view direction:UIPopoverArrowDirectionUp headerTitle:title isLimit:NO style:HDRightDateChooseViewStyleBegin complete:^(HDRightDateChooseViewStyle style, NSString *endStr) {
        //赋值
        textField.text = endStr;
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.headerView.headerViewTF resignFirstResponder];
}
#pragma mark - 顶部视图输入方法
- (void)headerViewTextFieldAction {
    [self.headerView.headerViewTF becomeFirstResponder];
}

#pragma mark - 输入添加完成回调
- (BOOL)headerViewTextFieldShouldReturn:(UITextField *)textField withDataSource:(NSMutableArray *)dataSource {
    if (textField == self.headerView.headerViewTF) {
        if (textField.text.length) {
            NSString *string = [NSString stringWithFormat:@"%@", textField.text];
            
            [self addCarflgForServerWith:string];
            
            return YES;
        }else {
            [self.headerView.headerViewTF resignFirstResponder];
            return NO;
        }
    }else if (textField == _headerView.gonglishuTF) {
        return YES;
    }
    return NO;
}
#pragma mark - 添加标签的请求方法
- (void)addCarflgForServerWith:(NSString *)str {
    // 添加标签
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:str forKey:@"targetname"];
    [param hs_setSafeValue:_leftServiceModel.cid forKey:@"carid"];
    WeakObject(self)
    [PorscheRequestManager addCarflgForServiceRecordsRightWithParam:param completion:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            self.headerView.headerViewTF.text = @"";
            [self.headerView.headerViewTF resignFirstResponder];
            [selfWeak loadDatWithVin:_leftServiceModel.cid];
        }else {
            self.headerView.headerViewTF.text = @"";
            [self.headerView.headerViewTF resignFirstResponder];
            [selfWeak loadDatWithVin:_leftServiceModel.cid];
        }
    }];
}

#pragma mark - 顶部视图输入显示车辆标签提示列表
//- (BOOL)headerViewTextFiel:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSString *tempStr = textField.text;
//    if (textField.text.length >= range.length && [string isEqualToString:@""]) {
//        tempStr = [tempStr substringWithRange:NSMakeRange(0, textField.text.length - range.length)];
//    }else {
//        tempStr = [textField.text stringByAppendingString:string];
//    }
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    if (tempStr.length) {
//        [param hs_setSafeValue:tempStr forKey:@"targetname"];
//    }
//    WeakObject(self)
//    [PorscheRequestManager searchCarflgListSearchForServiceRecordsRightWithParam:param completion:^(NSArray * _Nonnull carflgTableViewArray, PResponseModel * _Nonnull responser) {
//        
//        selfWeak.carflgListSearchView.carflgSearchList = [NSMutableArray arrayWithArray:carflgTableViewArray];
//        selfWeak.carflgListSearchView.selectCellBlock = ^(HDServiceRecordsCarflgTableViewModel *model) {
//            [selfWeak addCarflgForServerWith:model.targetname];
//        };
//        
//    }];
//    
//    return YES;
//}

- (void)headerViewTextDidEnd:(UITextField *)textField {
    BOOL isChinese;
    if ([[[UIApplication sharedApplication] textInputMode].primaryLanguage isEqualToString:@"en-US"]) {
        isChinese = NO;
    }else {
        isChinese = YES;
    }
    
    if (textField == _headerView.headerViewTF) {
        NSString *str = [[textField text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
        if (isChinese) {
            UITextRange *selectedRange = [textField markedTextRange];
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                if (str.length >= 1) { // 中文字符
                    // 实时的观察数据，对当前的字符串进行数据的请求
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    [param hs_setSafeValue:textField.text forKey:@"targetname"];
                    WeakObject(self)
                    [PorscheRequestManager searchCarflgListSearchForServiceRecordsRightWithParam:param completion:^(NSArray * _Nonnull carflgTableViewArray, PResponseModel * _Nonnull responser) {
                        
                        selfWeak.carflgListSearchView.carflgSearchList = [NSMutableArray arrayWithArray:carflgTableViewArray];
                        selfWeak.carflgListSearchView.selectCellBlock = ^(HDServiceRecordsCarflgTableViewModel *model) {
                            [selfWeak addCarflgForServerWith:model.targetname];
                        };
                        
                    }];
                }else {
//                    self.searchDataSource = nil;
//                    self.searchTableView.hidden = YES;
//                    [self setTextFieldEditBeginStyle];
                }
            }
            
        }else {
            if ([str length] >= 1) { // 英文字符
                // 实时的观察数据，对当前的字符串进行数据的请求
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param hs_setSafeValue:textField.text forKey:@"targetname"];
                WeakObject(self)
                [PorscheRequestManager searchCarflgListSearchForServiceRecordsRightWithParam:param completion:^(NSArray * _Nonnull carflgTableViewArray, PResponseModel * _Nonnull responser) {
                    
                    selfWeak.carflgListSearchView.carflgSearchList = [NSMutableArray arrayWithArray:carflgTableViewArray];
                    selfWeak.carflgListSearchView.selectCellBlock = ^(HDServiceRecordsCarflgTableViewModel *model) {
                        [selfWeak addCarflgForServerWith:model.targetname];
                    };
                    
                }];
            }else {
//                self.searchDataSource = nil;
//                self.searchTableView.hidden = YES;
//                [self setTextFieldEditBeginStyle];
            }
            
        }
        if (!str.length) {
//            self.searchDataSource = nil;
//            self.searchTableView.hidden = YES;
//            [self setTextFieldEditBeginStyle];
        }
    }
}

//- (void)headerViewTextFieldDidEndEditing:(UITextField *)textField {
//    if (textField == self.headerView.headerViewTF) {
//        if (textField.text.length) {
//            NSString *string = [NSString stringWithFormat:@"%@", textField.text];
//            
//            // 添加标签
//            NSMutableDictionary *param = [NSMutableDictionary dictionary];
//            [param hs_setSafeValue:string forKey:@"targetname"];
//            [param hs_setSafeValue:_leftServiceModel.wovincode forKey:@"carvincode"];
//            WeakObject(self)
//            [PorscheRequestManager addCarflgForServiceRecordsRightWithParam:param completion:^(PResponseModel * _Nonnull responser) {
//                if (responser.status == 100) {
//                    self.headerView.headerViewTF.text = @"";
//                    [self.headerView.headerViewTF resignFirstResponder];
//                    [selfWeak loadDatWithVin:_leftServiceModel.wovincode];
//                }
//            }];
//        }
//    }
//}

#pragma mark - 删除顶部视图，车辆标签
- (void)headerCarflgDeteleWith:(HDServiceRecordsCarflgModel *)model {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:model.targetid forKey:@"targetid"];
    WeakObject(self)
    [PorscheRequestManager deleteCarflgForServiceRecordsRightWithParam:param completion:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            [selfWeak loadDatWithVin:_leftServiceModel.cid];
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
        }
    }];
}


#pragma mark - ----------------------- 内容视图处理操作 --------------------------
- (void)contentViewControlAction {
    WeakObject(self)
    //内容视图右侧cell点击回调方法(重点方法)
    selfWeak.contentView.contentViewCellBlock = ^(NSMutableArray *array, HDServiceRecordsRightModel *model) {
        selfWeak.bottomView.priceArr = array;
        selfWeak.headerView.rightModel = model;
        selfWeak.contentView.rightModel = model;
        selfWeak.bottomView.rightModel = model;
    };
    //内容视图右侧cell侧滑删除，数据刷新
    selfWeak.contentView.refreshVCBlock = ^() {
        [selfWeak loadDatWithVin:selfWeak.leftServiceModel.cid];
    };
}


#pragma mark - ----------------------- 底部视图回调方法 --------------------
- (void)bottomViewControlAction {
    WeakObject(self)
    selfWeak.bottomView.buttomBackButtonBlock = ^() {
        //顶部按钮点击出的服务档案
        if ([_viewStatus isEqualToNumber:@1]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_RIGHT_STEP_NOTIFINATION object:nil];
            [[HDLeftSingleton shareSingleton] changeWorkFlowWithInfo:nil];

        }else {
            [[HDLeftSingleton shareSingleton].VC billingBackToFirstView];
        }
    };
}
#pragma mark - 观察键盘
- (void)registerForKeyBoardNotifinations {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardShow:(NSNotification *)sender {
    //获取键盘的高度
    NSDictionary *info = [sender userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyViewRect = value.CGRectValue;
    
    _keyViewRect = keyViewRect;
}
- (void)keyBoardHidden:(NSNotification *)sender {
    __weak typeof(self) selfWeak = self;
    //结束编辑操作，并把下拉界面取消
    selfWeak.headerView.headerViewTF.text = @"";
    [selfWeak.headerView.headerViewTF resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
