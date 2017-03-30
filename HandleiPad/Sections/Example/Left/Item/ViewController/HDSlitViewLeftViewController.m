//
//  HDSlitViewLeftViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/8/30.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDSlitViewLeftViewController.h"
#import "HDWorkListTableViewCell.h"
#import "HDWorkListHeaderView.h"
#import "HDWorkListTableViews.h"
#import "ItemDetialLeftBottomView.h"

#import "AlertViewHelpers.h"
#import "PorscheCustomModel.h"
#import "HDLeftSingleton.h"
//自定义项目添加辅助视图
#import "HDLeftCustomItemView.h"
// 车辆信息model
#import "PorscheCarModel.h"
//方案详情（新）
#import "MaterialTaskTimeDetailsView.h"

#import "HDScreenPopFileView.h"
//方案 tabbar
#import "ProjectTabbarView.h"
//两级列表
#import "HDMoreListView.h"

typedef NS_ENUM(NSInteger, DataSourceType) {
    
    dataSourceTypeFactory,//厂方
    dataSourceTypeLocal, //本店
    dataSourceTypeMy, //我的
    dataSourceTypeUndone //未完成
};
extern NSString *const touchStartstr;

@interface HDSlitViewLeftViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
//滑动
@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic)  UIScrollView *baseView;
//区头
@property (nonatomic, strong) HDWorkListHeaderView *headerView1;
//底部栏
@property (nonatomic, strong) ItemDetialLeftBottomView *bottomView;

// tab
@property (nonatomic, strong) ProjectTabbarView *tabView;

//高亮view   <点击下拉>
@property (nonatomic, strong) UIView *helperView;

//方案库自定义项目
@property (nonatomic, strong) UIPopoverController *customItemPoperController;

//收藏数组
@property (nonatomic, strong) NSMutableArray *favoriteDataSource;
@property (nonatomic, strong) NSMutableArray *favoriteNames;

//数据源集合视图数组-item
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *otherArray;


//新方案
@property (nonatomic, strong) MaterialTaskTimeDetailsView *detaileView;

//是否是第一次添加 单例collection
@property (nonatomic, assign) NSInteger isFirstAddSingleTonData;

@property (nonatomic, strong) NSString *itemTimeString;

@property (nonatomic, strong) HDScreenPopFileView *popView;

@property (nonatomic, strong) UIView *detailClearView;
//业务分类
@property (nonatomic, strong) NSMutableArray *businessClassifyArray;
//备件主组
@property (nonatomic, strong) NSMutableArray *materialMianGroupArray;
//工时主组
@property (nonatomic, strong) NSMutableArray *itemMainGroupArray;
//安全数据
@property (nonatomic, strong) NSMutableArray *safeArray;
//隐患数据
@property (nonatomic, strong) NSMutableArray *lurkingArray;
//信息数据
@property (nonatomic, strong) NSMutableArray *infoArray;
//未完成方案数据
@property (nonatomic, strong) NSMutableArray *unfinishedArray;

@property (nonatomic, assign) DataSourceType dataSourceType;
//未完成参数type
@property (nonatomic, assign) NSInteger unfinishedType;

@property (nonatomic, strong) NSMutableArray *factorySaveSource;
@property (nonatomic, strong) NSMutableArray *factoryDangerSource;
@property (nonatomic, strong) NSMutableArray *factoryMessageSource;

@property (nonatomic, strong) NSMutableArray *localSaveSource;
@property (nonatomic, strong) NSMutableArray *localDangerSource;
@property (nonatomic, strong) NSMutableArray *localMessageSource;

@property (nonatomic, strong) NSMutableArray *mySaveSource;
@property (nonatomic, strong) NSMutableArray *myDangerSource;
@property (nonatomic, strong) NSMutableArray *myMessageSource;
@property (nonatomic, strong) NSMutableArray *unfinishedSource;

@property (nonatomic, strong) NSArray *idArray;


//暂存车系类型
@property (nonatomic, copy) NSString *chexiStr;
//暂存车型类型
@property (nonatomic, copy) NSString *typeStr;
//暂存工时主组类型
@property (nonatomic, strong) PorscheConstantModel *timeCostMainData;
//暂存工时子组类型
@property (nonatomic, strong) PorscheConstantModel *timeCostSubData;
//暂存备件主组类型
@property (nonatomic, strong) PorscheConstantModel *spareMainData;
//暂存业务类型分类
@property (nonatomic, strong) PorscheConstantModel *businessTypeData;

//方案库pages
@property (nonatomic, assign) NSInteger totalPagesSave;//安全
@property (nonatomic, assign) NSInteger totalPagesDanger;//隐患
@property (nonatomic, assign) NSInteger totalPagesmessage;//信息
@property (nonatomic, assign) NSInteger totalpagesUnfinished;//未完成

@property (nonatomic, strong) NSNumber *wocarlevel;
@property (nonatomic, strong) NSNumber *scartypeid;
@end

@implementation HDSlitViewLeftViewController

//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//    }
//    
//    return self;
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"HDSlitViewLeftViewController.dealloc");
}

- (void)viewDidLayoutSubviews {
    
    self.headerView1.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49);
    self.baseView.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 100 - 49);
    self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.baseView.frame), CGRectGetHeight(self.baseView.frame));
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, CGRectGetHeight(self.baseView.frame));
    _baseView.contentSize = CGSizeMake(CGRectGetWidth(_baseView.frame), CGRectGetHeight(_baseView.frame));

    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [HDLeftSingleton shareSingleton].isItemVC = YES;
    //加载我的收藏夹数据
    [self loadFavoritesListwithIsRefresh:YES loadFavoriteSuccess:nil];
    [self getCarTypeToSearch];
    [self changeBottomView];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [HDLeftSingleton shareSingleton].isItemVC = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.unfinishedType = 3;
    
    self.totalPagesSave = 0;
    self.totalPagesmessage = 0;
    self.totalPagesDanger = 0;
    self.dataSourceType = dataSourceTypeLocal;
    
    [self setupBaseView];
    
    [self setupTableView];
    
    [self setupHeaderView];
    
    [self setheaderViewDataSource];
    
    [self configNavitem];
    
//    [self setupNotifination];
    
    [self setupNeededSingleProperty];
    
    //利用(方案详情里面修改方案所在收藏夹通知左侧我的收藏夹刷新数据)方法进行数据的刷新，当点击弹窗的放回的时候，刷新界面列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSchemeList:) name:SCHEME_DETAIL_REFRESH_MYFAVORITE_NOTIFICATION object:nil];

}
//弹出方案详情点击返回的时候刷新界面数据
- (void)refreshSchemeList:(NSNotification *)noti {
    
    NSDictionary *userInfo = noti.userInfo;
    
    NSNumber *type = [userInfo objectForKey:@"type"];
    
    if ([type integerValue] == MaterialTaskTimeDetailsTypeScheme) {
        [self reloadData];
    }
    
}

- (void)reloadData {
    [self loadAllSourceType:self.dataSourceType levelid:@[@1,@2,@3] more:NO];
    [self loadFavoritesListwithIsRefresh:YES loadFavoriteSuccess:nil];
    [self loadSourceType:dataSourceTypeUndone levelid:@0 more:NO];

}



#pragma mark - -------- 获取我的方案夹列表和名称
- (void)loadFavoritesListwithIsRefresh:(BOOL)isRefresh loadFavoriteSuccess:(void(^)())loadFavoriteSuccess {
    MBProgressHUD *hub = [MBProgressHUD showProgressMessage:@"" toView:self.view];
    WeakObject(hub);
    WeakObject(self)
    PorscheNewCarMessage *carModel = [HDLeftSingleton shareSingleton].carModel;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:selfWeak.wocarlevel forKey:@"wocarlevel"];
    [param hs_setSafeValue:selfWeak.scartypeid forKey:@"scartypeid"];
    [PorscheRequestManager myFavoriteslistWithParams:param completion:^(NSMutableArray * _Nonnull favoritesList, PResponseModel * _Nonnull responser) {
        [hubWeak hideAnimated:YES];
        selfWeak.favoriteDataSource = favoritesList;
        
        for (PorscheSchemeFavoriteModel *data in favoritesList) {
            [selfWeak.favoriteNames addObject:data.favoritename];
        }
        if (isRefresh) {
            [selfWeak.tableView reloadData];
        }
        if (loadFavoriteSuccess) {
            loadFavoriteSuccess();
        }
    }];
}

#pragma mark  进行中

#pragma mark  测试方案库列表 已完成
//初始全部获取，一个type的所有类型数据
- (void)loadAllSourceType:(DataSourceType)dataType levelid:(NSArray *)levelid more:(BOOL)more {
    for (NSNumber *number in levelid) {
        [self loadSourceType:dataType levelid:number more:more];
    }
}

//方案库数据
- (void)loadSourceType:(DataSourceType)dataType levelid:(NSNumber *)levelid more:(BOOL)more {
    PorscheRequestSchemeListModel *manager = [PorscheRequestSchemeListModel new];
    manager.schemetype = @(dataType + 1);
    manager.schemelevelid = levelid;
    //添加搜索的限定参数
    manager.wocarcatena = _chexiStr.length?_chexiStr:@"";
    manager.wocarmodel = _typeStr.length?_typeStr:@"";
    manager.businesstypeids = _businessTypeData.cvsubid?[_businessTypeData.cvsubid stringValue]:@"";
    manager.workhourgroupfuid = (NSString *)_timeCostMainData.cvsubid;//?_timeCostMainData.cvsubid:@0;
    manager.workhourgroupid = (NSString *)_timeCostSubData.cvsubid;//?_timeCostSubData.cvsubid:@0;
    manager.schemename = _headerView1.nameSearchTF.text.length?_headerView1.nameSearchTF.text:@"";
    manager.wocarlevel = self.wocarlevel;
    manager.scartypeid = self.scartypeid;
    
    [self loadSource:manager More:more levelid:levelid];
}



- (PorscheRequestSchemeListModel *)getRequestUnfinishedSchemeListaModel
{
    PorscheRequestSchemeListModel *manager = [PorscheRequestSchemeListModel new];
//    manager.schemetype = @(dataType + 1);
//    manager.schemelevelid = levelid;
    //添加搜索的限定参数
    manager.wocarcatena = _chexiStr.length?_chexiStr:@"";
    manager.wocarmodel = _typeStr.length?_typeStr:@"";
    manager.businesstypeids = _businessTypeData.cvsubid?[_businessTypeData.cvsubid stringValue]:@"";
    manager.workhourgroupfuid = (NSString *)_timeCostMainData.cvsubid;//?_timeCostMainData.cvsubid:@0;
    manager.workhourgroupid = (NSString *)_timeCostSubData.cvsubid;//?_timeCostSubData.cvsubid:@0;
    manager.schemename = _headerView1.nameSearchTF.text.length?_headerView1.nameSearchTF.text:@"";
    manager.wocarlevel = self.wocarlevel;
    manager.scartypeid = self.scartypeid;
    return manager;
}


- (void)loadSource:(PorscheRequestSchemeListModel *)requestModel More:(BOOL)more levelid:(NSNumber *)levelid {
    HDStoreInfoManager *pageModel = [HDStoreInfoManager shareManager];
    NSInteger before = pageModel.currpage.integerValue;
    if (!more) {
        pageModel.currpage = @1;
    }else {
        switch ([levelid integerValue]) {
            case 1:
                if (self.totalPagesSave > 0) {
                    if ([pageModel.currpage integerValue] < self.totalPagesSave) {
                        pageModel.currpage = @([pageModel.currpage integerValue] +1);
                    }else {
                        return;
                    }
                }
                break;
            case 2:
                if (self.totalPagesDanger > 0) {
                    if ([pageModel.currpage integerValue] < self.totalPagesDanger) {
                        pageModel.currpage = @([pageModel.currpage integerValue] +1);
                    }else {
                        return;
                    }
                }
                break;
            case 3:
                if (self.totalPagesmessage > 0) {
                    if ([pageModel.currpage integerValue] < self.totalPagesmessage) {
                        pageModel.currpage = @([pageModel.currpage integerValue] +1);
                    }else {
                        return;
                    }
                }
                break;
                
                
            default:
                break;
        }
    }
    if ([requestModel.schemetype isEqualToNumber:@4]) {//未完成
        PorscheNewCarMessage *model = [HDLeftSingleton shareSingleton].carModel;
        if (!model.wocarid)
        {
            return;
        }
        requestModel.wocarid = model.wocarid;
        requestModel.isfromunfinished = @1;
        if (more) {
            if (self.totalpagesUnfinished > 0) {
                if ([pageModel.currpage integerValue] < self.totalpagesUnfinished) {
                    pageModel.currpage = @([pageModel.currpage integerValue] +1);
                }else {
                    return;
                }
            }
        }
        
    }

    pageModel.pagesize = @(5);
    WeakObject(pageModel);
    WeakObject(self);
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self.view];
    
    NSMutableDictionary *dic = [requestModel yy_modelToJSONObject];
    if ([requestModel.schemetype isEqualToNumber:@4]) {
        [dic removeObjectForKey:@"schemetype"];
    }
    [PorscheRequestManager schemeListWith:dic complete:^(NSArray *models, PResponseModel *responser) {
        switch ([levelid integerValue]) {
            case 1:
                selfWeak.totalPagesSave = responser.totalpages;
                break;
            case 2:
                selfWeak.totalPagesDanger = responser.totalpages;
                break;
            case 3:
                selfWeak.totalPagesmessage = responser.totalpages;
                break;
            default:
                break;
        }
        if ([requestModel.schemetype isEqualToNumber:@4]) {
            selfWeak.totalpagesUnfinished = responser.totalpages;
        }
        
        [hud hideAnimated:YES];
        if (!models) return ;
        
        if (models.count == 0) pageModelWeak.currpage = @(before); //如果没有更多恢复之前页码
        
        [selfWeak setupDataSource:models More:more schemeLevel:requestModel.schemelevelid requestModel:requestModel];
    }];
}

- (void)setupDataSource:(NSArray *)newDataSource More:(BOOL)more schemeLevel:(NSNumber *)levelid requestModel:(PorscheRequestSchemeListModel *)requestModel {
    
    //    dataSourceTypeFactory,//厂方
    //    dataSourceTypeLocal, //本店
    //    dataSourceTypeMy, //我的
    //    dataSourceTypeUndone //未完成
    
    //未完成
    if ([requestModel.schemetype isEqualToNumber:@4]) {
        if (more) {
            [self resetDataSourceWith:more pointArray:self.unfinishedSource data:newDataSource];
            self.unfinishedArray = self.unfinishedSource;
        }else {
            self.unfinishedArray = [newDataSource mutableCopy];
        }
        
    }
    
    switch (self.dataSourceType) {
        case dataSourceTypeFactory:
        {
            switch ([levelid integerValue]) {
                case 1:
                {
                    [self resetDataSourceWith:more pointArray:self.factorySaveSource data:newDataSource];
                    self.safeArray = self.factorySaveSource;
                }
                    break;
                case 2:
                {
                    
                    [self resetDataSourceWith:more pointArray:self.factoryDangerSource data:newDataSource];
                    self.lurkingArray = self.factoryDangerSource;

                }
                    break;
                case 3:
                {
                    
                    [self resetDataSourceWith:more pointArray:self.factoryMessageSource data:newDataSource];
                    self.infoArray = self.factoryMessageSource;

                }
                    break;
                    
                default:
                    break;
            }
            
            
        }
            break;
        case dataSourceTypeLocal:
        {
            
            switch ([levelid integerValue]) {
                case 1:
                {
                    [self resetDataSourceWith:more pointArray:self.localSaveSource data:newDataSource];
                    self.safeArray = self.localSaveSource;

                }
                    break;
                case 2:
                {
                    
                    [self resetDataSourceWith:more pointArray:self.localDangerSource data:newDataSource];
                    self.lurkingArray = self.localDangerSource;

                }
                    break;
                case 3:
                {
                    
                    [self resetDataSourceWith:more pointArray:self.localMessageSource data:newDataSource];
                    self.infoArray = self.localMessageSource;

                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case dataSourceTypeMy:
        {
            
            switch ([levelid integerValue]) {
                case 1:
                {
                    [self resetDataSourceWith:more pointArray:self.mySaveSource data:newDataSource];
                    self.safeArray = self.mySaveSource;

                }
                    break;
                case 2:
                {
                    
                    [self resetDataSourceWith:more pointArray:self.myDangerSource data:newDataSource];
                    self.lurkingArray = self.myDangerSource;

                }
                    break;
                case 3:
                {
                    
                    [self resetDataSourceWith:more pointArray:self.myMessageSource data:newDataSource];
                    self.infoArray = self.myMessageSource;

                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
        default:
            break;
    }

    [self.tableView reloadData];
}

- (void)resetDataSourceWith:(BOOL)more pointArray:(NSMutableArray *)pointArray data:(NSArray *)dataArray{
    if (!more) [pointArray removeAllObjects];
    [pointArray addObjectsFromArray:dataArray];
}
/*
#pragma mark  未完成项目
- (void)getUnfinishedListTest {
    WeakObject(self);
    PorscheNewCarMessage *model = [HDLeftSingleton shareSingleton].carModel;
    if (!model.wocarid)
    {
        return;
    }
    PorscheRequestSchemeListModel *requestModel = [self getRequestUnfinishedSchemeListaModel];
    NSMutableDictionary *paramers = [NSMutableDictionary dictionaryWithDictionary:[requestModel yy_modelToJSONObject]];
    [paramers hs_setSafeValue:model.wocarid forKey:@"wocarid"];
    [paramers hs_setSafeValue:@1 forKey:@"isfromunfinished"];
    
    [PorscheRequestManager workOrderUnfinishedSchemeListRequestWith:paramers complete:^(NSMutableArray * _Nonnull paramers, PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            selfWeak.unfinishedArray = paramers;
        }else if (responser.status == -100){
            selfWeak.unfinishedArray = nil;
        }
        [selfWeak.tableView reloadData];
    }];
}
*/

- (void)setupBaseView {
    //滑动
    _baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 100 - 49 )];

    _baseView.contentSize = CGSizeMake(CGRectGetWidth(_baseView.frame), CGRectGetHeight(_baseView.frame));
    
    _baseView.bounces = NO;
    
    _baseView.maximumZoomScale = 2;
    
    _baseView.minimumZoomScale = 1;
    
    _baseView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_baseView addSubview:self.containerView];
    
    self.baseView.delegate = self;
    _baseView.showsVerticalScrollIndicator = NO;
    _baseView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_baseView];
}

- (void)setupTableView {
    //界面view
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.baseView.frame), CGRectGetHeight(self.baseView.frame)) style:UITableViewStyleGrouped];
    [_tableView registerNib:[UINib nibWithNibName:@"HDWorkListTableViewCell" bundle:nil] forCellReuseIdentifier:@"worklistTVCidentifier1"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.containerView addSubview:self.tableView];
}
/*
- (void)setupNotifination {
    //添加至收藏夹
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addleftmodel:) name:COLLECTION_ADD_ITEM_NOTIFINATION object:nil];
    
    //滑动 tableView 以显示收藏夹相关
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTableView:) name:PROJECT_SCROLL_TABLEVIEW_NOTIFINATION object:nil];
    //改变分类
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCellModelCategory:) name:PROJECT_CHANGE_ITEM_CATEGORY_NOTIFINATION object:nil];
    //滑动collection的Item
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollCollectionCell:) name:PROJECT_SCROLL_COLLECTIONVIEW_NOTIFINATION object:nil];
    //更新按钮title
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBottomViewFullBtTittle:) name:BACK_FROM_MATERIAL_AND_ITEM_TIME_NOTIFINATION object:nil];
    //刷新方案库
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSchemeCub:) name:WORK_ORDER_LEFT_REFRESH_MORE_NOTIFINATION object:nil];
    //获取左侧工单方案数据刷新  左侧方案库
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLoadTableView:) name:WORK_ORDER_REFRESH_LEFT_ITEM_NOTIFINATION object:nil];
    //编辑/保存状态下 bottomView的样式修改
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBottomView) name:WORK_ORDER_SAVE_AND_EDIT_NOTIFINATION object:nil];
}
*/

- (void)changeBottomView {
    NSNumber *saveStatus = [HDLeftSingleton shareSingleton].saveStatus;
    [self.bottomView changeUserEnabledAndViewWithStatus:saveStatus];
}

- (void)reloadLoadTableView:(NSDictionary *)noti {//@{@"type":number,@"idArray":idArray}
    self.idArray = noti[@"idArray"];
    [self loadSourceType:dataSourceTypeUndone levelid:@0 more:NO];
}

- (void)getCarTypeToSearch{
    PorscheNewCarMessage *carModel = [HDLeftSingleton shareSingleton].carModel;
    _chexiStr = carModel.wocarcatena.length?carModel.wocarcatena:@"";
    _typeStr = carModel.wocarmodel.length?carModel.wocarmodel:@"";
    
    self.wocarlevel = @0;
    self.scartypeid = @0;
    if ([carModel.carsid integerValue])
    {
        self.wocarlevel = @1;
        self.scartypeid = carModel.carsid;
    }
    
    if ([carModel.cartypeid integerValue])
    {
        self.wocarlevel = @2;
        self.scartypeid = carModel.cartypeid;
    }
//    self.scartypeid = carModel.ccartypeid;
    
    self.headerView1.categoryTF.text = (carModel && (_chexiStr.length || _typeStr.length)) ? [NSString stringWithFormat:@"%@ %@", self.chexiStr, self.typeStr] : @"";
    
    [self setTFregisterFirst];
}
#pragma mark -- 加载方案列表
- (void)refreshSchemeCub:(NSString *)noti {
    if ([noti isEqual:@"page1"]) {//安全
        [self loadSourceType:self.dataSourceType levelid:@1 more:YES];
    }else if ([noti isEqual:@"page2"]) {//隐患
        [self loadSourceType:self.dataSourceType levelid:@2 more:YES];
    }else if ([noti isEqual:@"page3"]) {//信息
        [self loadSourceType:self.dataSourceType levelid:@3 more:YES];
    }else {
        [self reloadData];
    }
}

#pragma mark -- 切换到我的方案
- (void)refreshMySchemeTabData
{
    [self.tabView switchLocationBtAction:self.tabView.mineBt];
}

- (void)setupNeededSingleProperty {
    //单例中 初始化
    [HDLeftSingleton shareSingleton].tableViewY = 0;
    _isFirstAddSingleTonData = 0;
    [HDLeftSingleton shareSingleton].isDrag = NO;
}

#pragma mark  从方案库返回时改变tittle值------
- (void)changeBottomViewFullBtTittle:(NSNotification *)sender {
    [self.bottomView.fullSrcreenBt setTitle:@"全屏" forState:UIControlStateNormal];
}

#pragma mark   改变model类型
- (void)changeCellModelCategory:(NSDictionary *)sender {
    PorscheSchemeModel *scheme = [HDLeftSingleton shareSingleton].dragCubScheme;

    if ([scheme.schemetype integerValue] == 4) {// 自定义项目不可以修改级别
        return;
    }
    
    //级别
    NSInteger fromeIndex = [HDLeftSingleton shareSingleton].fromIndex;
    //级别中  方案位置
//    NSIndexPath *fromIndexPath = [HDLeftSingleton shareSingleton].fromIndexpath;
    
    //目的地级别
    NSInteger endIndex = [HDLeftSingleton shareSingleton].endIndex;
    
    if (endIndex == fromeIndex) {
        return;
    }
    
    NSArray *levelArr = [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataSchemeLevel];
    NSString *str = @"安全";
    switch (endIndex) {
        case 0:
            str = @"安全";
            break;
        case 1:
            str = @"隐患";
            break;
        case 2:
            str = @"信息";
            break;
        default:
            break;
    }
    PorscheConstantModel *desConstant;
    for (PorscheConstantModel *model in levelArr) {
        if ([model.cvvaluedesc isEqualToString:str]) {
            desConstant = model;
        }
    }
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    WeakObject(self);
    
    [PorscheRequestManager schemeUpdateLevelWithSchemeID:scheme.schemeid constant:desConstant completion:^(NSInteger status, PResponseModel * _Nonnull responser) {
        [hud hideAnimated:YES];
        
        if (status) {
            [selfWeak reloadData];
            
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
        }
    }];
}

//拖动时，滑动tableView至原点位置
- (void)scrollTableView:(NSDictionary *)sender {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

//滑动collectionView 中的item
- (void)scrollCollectionCell:(NSDictionary *)sender {
//    @{@"status":@1,@"cellIndex":@(self.idx),@"leftOrRight":@(self.index)}
    NSDictionary *dic = sender;
    if ([dic[@"status"] integerValue] == 1) {
        //第几分区的cell
        NSInteger idx = [dic[@"cellIndex"] integerValue];
        //左侧按钮，右侧按钮  0：左按钮，1：右按钮
        NSInteger index = [dic[@"leftOrRight"] integerValue];
        
        HDWorkListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:idx]];
        
        if (index) {//右侧按钮
            [cell rightScrollBtAction:nil];
        }else {//左侧按钮
            [cell leftScrollBtAction:nil];
        }
        
    }
}


#pragma mark  ------scroll------


- (UIView *)containerView {
    if (!_containerView) {
        
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.baseView.frame), CGRectGetHeight(self.baseView.frame))];
        
        _containerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return _containerView;
}

- (void)buttonAction:(UIButton *)sender {
    [AlertViewHelpers setAlertViewWithViewController:self button:sender];
}

//设置缩放内容

#pragma mark - 缩放

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.containerView;
}



- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidZoom");
    
//    
//    //捏合或者移动时，确定正确的center
//    CGFloat centerX = scrollView.center.x;
//    
//    CGFloat centerY = scrollView.center.y;
//    
//    //随时获取center位置
//    
//    centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : centerX;
//    
//    centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height / 2 : centerY;
    
    if (scrollView.contentSize.height > scrollView.frame.size.height) {
        _tableView.scrollEnabled = NO;
    }else {
        _tableView.scrollEnabled = YES;
    }
//    _baseView.contentSize = _baseView.frame.size;

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [HDLeftSingleton shareSingleton].tableViewY = _tableView.contentOffset.y;
    
}




#pragma mark  ------headerView  ------
//headerView和点击其中按钮，弹出tableView试图，
- (void)setupHeaderView {
    self.headerView1 = [[HDWorkListHeaderView alloc]initWithCustomFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    
    self.bottomView = [[ItemDetialLeftBottomView alloc]initWithCustomFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49 - 64, CGRectGetWidth(self.view.frame), 49)];
    [self.view addSubview:self.headerView1];
    [self.view addSubview:self.bottomView];
    
}

#pragma mark  ------notification------
//添加至收藏夹
- (void)addleftmodel:(NSDictionary *)sender {
    
    NSInteger integer = [[sender objectForKey:@"item"] integerValue];
    PorscheNewScheme *model = [sender objectForKey:@"model"];
    
    //添加收藏夹
    if (integer == 0) {
        [self createNewFovriteWithScheme:model];
        return;
    }
    
    if (self.favoriteDataSource.count) {
        PorscheSchemeFavoriteModel *favoriteData = self.favoriteDataSource[integer - 1];
        //添加方案
        WeakObject(self)
        [self addSchemeForFavoriteListWithData:model withFavoriteID:favoriteData.favoriteid addSchemeSuccess:^(PResponseModel * _Nonnull responser) {
            [selfWeak loadFavoritesListwithIsRefresh:YES loadFavoriteSuccess:nil];
        }];
    }
    
  
}


- (NSString *)setName:(NSMutableArray *)dataArray {
    // 循环遍历收藏夹列表,查询名称是否存在,存在名称+1不存在名称返回,结束循环
    NSString *name = @"新建";
    NSInteger index = 0;
    
    BOOL isLoop = YES;
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (PorscheSchemeFavoriteModel *data in dataArray) {
        [tempArr addObject:data.favoritename];
    }
    
    while (isLoop && tempArr.count) {
        if ([tempArr containsObject:name]) {
            index++;
            name = [NSString stringWithFormat:@"新建%ld", index];
        }else {
            isLoop = NO;
            break;
        }
    }
    
    return name;
}
#pragma mark - 新建收藏夹
- (void)createNewFovriteWithScheme:(PorscheNewScheme *)model {
    WeakObject(self)
    NSString *name = [selfWeak setName:selfWeak.favoriteDataSource];
    //创建方案夹
    [selfWeak addFavoriteListWithName:name addFavoriteSuccess:^(PResponseModel * _Nonnull responser) {
        NSNumber *favorite = responser.object;
        //添加方案
        [selfWeak addSchemeForFavoriteListWithData:model withFavoriteID:responser.object addSchemeSuccess:^(PResponseModel * _Nonnull responser) {
            //重新从服务器获取方案夹列表数据
            [selfWeak loadFavoritesListwithIsRefresh:NO loadFavoriteSuccess:^{
                //找到刚才创建的方案夹并打开
                NSInteger index = 0;
                for (PorscheSchemeFavoriteModel *data in selfWeak.favoriteDataSource) {
                    if ([data.favoriteid isEqual:favorite]) {
                        break;
                    }
                    index++;
                }
                HDWorkListTableViewCell *cell = [selfWeak.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [selfWeak showSchemePopViewInCell:cell index:index beganEditSchemeName:NO isNew:NO];
            }];
        }];
    }];
}
#pragma mark - ------- 添加收藏夹
- (void)addFavoriteListWithName:(NSString *)name addFavoriteSuccess:(void(^)(PResponseModel * _Nonnull responser))addFavoriteSuccess {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:name forKey:@"favoritename"];
    [PorscheRequestManager addFavoritesListWithParams:param completion:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            if (addFavoriteSuccess) {
                addFavoriteSuccess(responser);
            }
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - 100) superView:KEY_WINDOW];
        }
    }];
}

#pragma mark - 添加收藏夹-方案
- (void)addSchemeForFavoriteListWithData:(PorscheNewScheme *)data withFavoriteID:(NSNumber *)ID addSchemeSuccess:(void(^)(PResponseModel * _Nonnull responser))addSchemeSuccess {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:ID forKey:@"favoriteid"];
    [param hs_setSafeValue:data.schemeid forKey:@"schemeid"];
    
    [PorscheRequestManager addSchemeForFavoriteListWithParams:param completion:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            if (addSchemeSuccess) {
                addSchemeSuccess(responser);
            }
            if (responser.msg.length) {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"work_list_46"] message:responser.msg height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
            }
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
        }
    }];
}


#pragma mark - 显示方案库合集页面
- (void)showSchemePopViewInCell:(HDWorkListTableViewCell *)cell index:(NSInteger)integer beganEditSchemeName:(BOOL)beginEdit isNew:(BOOL)isNew {
    
    HDScreenPopFileView *popView = [[HDScreenPopFileView alloc] initWithCustomFrame:CGRectMake(0, 0, HD_WIDTH, HD_HEIGHT)];
    PorscheSchemeFavoriteModel *data = _favoriteDataSource[integer];
//    if (isNew) {
//        popView.titleName = @"新建";
//        popView.isNew = isNew;
//    }else {
        popView.titleName = data.favoritename;
//    }
    if (self.idArray.count) {
        popView.inOrderFanganArray = [self.idArray mutableCopy];
    }
    popView.dataSource = [data.schemelist mutableCopy];
    popView.favorialDataArray = _favoriteDataSource;
    
    WeakObject(self)
    WeakObject(popView);
    popView.beginEdit = beginEdit;
    popView.backBlock = ^() {
        [selfWeak loadFavoritesListwithIsRefresh:YES loadFavoriteSuccess:nil];
    };
    popView.shouldReturnBlock = ^(NSString *string) {
//        if (!popViewWeak.beginEdit) {
            [selfWeak changeFavoriteNameWithName:string withFavoriteData:data withView:popViewWeak];
//        }
    };
    popView.deleteFavoritBlock = ^() {
        [selfWeak deteleFavoriteForListWithData:data success:^{
//            [popViewWeak backWithTap:nil];
        }];
    };
    
    [KEY_WINDOW addSubview:popView];
}


#pragma mark - -----   修改收藏夹名称
- (void)changeFavoriteNameWithName:(NSString *)name withFavoriteData:(PorscheSchemeFavoriteModel *)data withView:(HDScreenPopFileView *)view {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:data.favoriteid forKey:@"favoriteid"];
    [param hs_setSafeValue:name forKey:@"favoritename"];
    
    WeakObject(self)
    [PorscheRequestManager changeFavoriteNameWithParams:param completion:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            [selfWeak loadFavoritesListwithIsRefresh:YES loadFavoriteSuccess:nil];
        }
//        else {
//            view.beginEdit = YES;
//            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - 100) superView:KEY_WINDOW];
//        }
    } isNeedShowPopView:NO];
}
#pragma mark - ------ 方案夹删除
- (void)deteleFavoriteForListWithData:(PorscheSchemeFavoriteModel *)data success:(void(^)())success {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:data.favoriteid forKey:@"uid"];
    
    WeakObject(self)
    [PorscheRequestManager deteleFavoritesListWithParams:param completion:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            if (success) {
                success();
            }
            [selfWeak loadFavoritesListwithIsRefresh:YES loadFavoriteSuccess:nil];
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - 100) superView:KEY_WINDOW];
        }
    }];
}

#pragma mark  测试    进行中（删除或者添加model）

- (void)addedSchemeTestWithDic:(id)model isDelete:(BOOL)isDelete {

    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    if ([model isKindOfClass:[PorscheSchemeModel class]]) {
        [PorscheRequestManager increaseItemWithModel:model isDelete:isDelete complete:^(NSInteger status, PResponseModel * _Nonnull model) {
            [hud hideAnimated:YES];
            if (status == 100) {
                NSLog(@"添加至工单成功!");
//                [[NSNotificationCenter defaultCenter] postNotificationName:TECHICIANADDITION_ADD_ITEM_NOTIFINATION object:nil];
                [[HDLeftSingleton shareSingleton] reloadOrderList];

            }else {
                NSLog(@"添加至工单失败!");
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:model.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
            }
        }];
    }else {//未完成方案
        [PorscheRequestManager increaseUnfinishedItemWithModel:model isDelete:isDelete complete:^(NSInteger status, PResponseModel * _Nonnull model) {
            [hud hideAnimated:YES];
            if (status == 100) {
                NSLog(@"添加至工单成功!");
//                [[NSNotificationCenter defaultCenter] postNotificationName:TECHICIANADDITION_ADD_ITEM_NOTIFINATION object:nil];
                [[HDLeftSingleton shareSingleton] reloadOrderList];

            }else {
                NSLog(@"添加至工单失败!");
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:model.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
            }
        }];
    }
    
}

#pragma mark  ------删除项目，方案库标记变化------
//删除技师增项中方案库，左边标记恢复
- (void)reAdditem:(NSNotification *)sender {
   
}

#pragma mark  ------赋值车辆信息------
- (void)setheaderViewDataSource {
//    if ([HDLeftSingleton shareSingleton].maxStatus > 1) {
//        self.headerView1.carmodel = [HDLeftSingleton shareSingleton].carModel;
//
//    }
}


#pragma mark - 获取车系车型列表
- (void)getSeriesList {
    WeakObject(self)
    [HDStoreInfoManager shareManager].currpage = @1;
    [HDStoreInfoManager shareManager].pagesize = @100;
    [PorscheRequestManager getAllCarSeriersConstant:^(NSArray<PorscheConstantModel *> * _Nonnull carseriesList, PResponseModel * _Nonnull responser) {
        if (carseriesList.count) {
            //增加全部的选项，选中的效果相当与是清空数据
            PorscheConstantModel *allData = [[PorscheConstantModel alloc] init];
            allData.cvvaluedesc = @"全部";
            allData.cvsubid = @-1;
            NSMutableArray *temp = [carseriesList mutableCopy];
            [temp insertObject:allData atIndex:0];
            
            [HDMoreListView showListViewWithView:selfWeak.headerView1.categoryTF Data:temp  direction:UIPopoverArrowDirectionDown withType:viewFormStyle_carType complete:^(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx) {
                if ([contentOne.cvsubid isEqual:@-1] && [contentOne.cvvaluedesc isEqualToString:@"全部"]) {
                    selfWeak.headerView1.categoryTF.text = @"";
                    selfWeak.chexiStr  = @"";
                    selfWeak.typeStr = @"";
                }else {
                    NSString *string = @"";
                    if (contentOne && contentTwo) {
                        string = [@[contentOne.cvvaluedesc, contentTwo.descr] componentsJoinedByString:@" "];
                    }else if (!contentTwo) {
                        string = contentOne.cvvaluedesc;
                    }
                    selfWeak.headerView1.categoryTF.text = string;
                    selfWeak.chexiStr  = contentOne.cvvaluedesc.length ? contentOne.cvvaluedesc : @"";
                    selfWeak.typeStr = contentTwo.descr.length ? contentTwo.descr : @"";
                }
            } removeComplete:^(NSArray *dataArray) {
//                NSLog(@"%@",dataArray);
                selfWeak.wocarlevel = @0;
                selfWeak.scartypeid = nil;
                PorscheConstantModel *contentOne = [dataArray firstObject];
                
                PorscheConstantModel *contentTwo = nil;
                
                if(dataArray.count > 1)
                {
                    contentTwo = [dataArray lastObject];
                }
                
                if ([contentOne.cvsubid isEqual:@-1] && [contentOne.cvvaluedesc isEqualToString:@"全部"]) {
                    selfWeak.headerView1.categoryTF.text = @"";
                    selfWeak.chexiStr  = @"";
                    selfWeak.typeStr = @"";
                    selfWeak.wocarlevel = @0;
                    selfWeak.scartypeid = nil;
                }else {
                    NSString *string = @"";
                    if (contentOne && contentTwo) {
                        string = [@[contentOne.cvvaluedesc, contentTwo.descr] componentsJoinedByString:@" "];
                        selfWeak.wocarlevel = @2;
                        selfWeak.scartypeid = contentTwo.cvsubid;
                        
                    }else if(!contentTwo){
                        string = contentOne.cvvaluedesc;
                        selfWeak.wocarlevel = @1;
                        selfWeak.scartypeid = contentOne.cvsubid;
                    }
                    selfWeak.headerView1.categoryTF.text = string;
                    selfWeak.chexiStr  = contentOne.cvvaluedesc.length ? contentOne.cvvaluedesc : @"";
                    selfWeak.typeStr = contentTwo.descr.length ? contentTwo.descr : @"";
                }
                [selfWeak setTFregisterFirst];

            }];
            
            
            
        }
    }];
}

#pragma mark  ------区头工时子主组下拉------
- (void)headerItemTime {
    WeakObject(self);
    
    if (self.itemMainGroupArray.count) {
        
        //增加全部的选项，选中的效果相当与是清空数据
        PorscheConstantModel *allData = [[PorscheConstantModel alloc] init];
        allData.cvvaluedesc = @"全部";
        allData.cvsubid = @-1;
        NSMutableArray *temp = [self.itemMainGroupArray mutableCopy];
        [temp insertObject:allData atIndex:0];
        
        [HDMoreListView showListViewWithView:selfWeak.headerView1.itemMainBt Data:temp direction:UIPopoverArrowDirectionDown complete:^(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx) {
            
            if ([contentOne.cvsubid isEqual:@-1] && [contentOne.cvvaluedesc isEqualToString:@"全部"]) {
                selfWeak.headerView1.itemMainTF.text = @"";
                selfWeak.timeCostMainData = nil;
                selfWeak.timeCostSubData = nil;
            }else {
                NSString *string = @"";
                if (contentOne && contentTwo) {
                    string = [@[contentOne.cvvaluedesc, contentTwo.cvvaluedesc] componentsJoinedByString:@"/"];
                }else if (!contentTwo) {
                    string = contentOne.cvvaluedesc;
                }
                
                selfWeak.headerView1.itemMainTF.text = string;
                selfWeak.timeCostMainData = contentOne?contentOne:nil;
                selfWeak.timeCostSubData = contentTwo?contentTwo:nil;
            }
        } removeComplete:^(NSArray *dataArray) {
            
            PorscheConstantModel *contentOne = [dataArray firstObject];
            PorscheConstantModel *contentTwo = nil;
            if(dataArray.count > 1)
            {
                contentTwo = [dataArray lastObject];
            }
            
            
            if ([contentOne.cvsubid isEqual:@-1] && [contentOne.cvvaluedesc isEqualToString:@"全部"]) {
                selfWeak.headerView1.itemMainTF.text = @"";
                selfWeak.timeCostMainData = nil;
                selfWeak.timeCostSubData = nil;
            }else {
                NSString *string = @"";
                if (contentOne && contentTwo) {
                    string = [@[contentOne.cvvaluedesc, contentTwo.cvvaluedesc] componentsJoinedByString:@"/"];
                }else if(!contentTwo){
                    string = contentOne.cvvaluedesc;
                }
                
                selfWeak.headerView1.itemMainTF.text = string;
                selfWeak.timeCostMainData = contentOne?contentOne:nil;
                selfWeak.timeCostSubData = contentTwo?contentTwo:nil;
            }
            
            [selfWeak setTFregisterFirst];
            
            
        }];
    }else {
        self.itemMainGroupArray = [NSMutableArray arrayWithArray:[[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataWorkHourk]];
        
    }
   
}

#pragma mark  ------区头 业务下拉------

- (void)headerItemAction {
    WeakObject(self);

    if (self.businessClassifyArray.count) {
        //增加全部的选项，选中的效果相当与是清空数据
        PorscheConstantModel *allData = [[PorscheConstantModel alloc] init];
        allData.cvvaluedesc = @"全部";
        allData.cvsubid = @-1;
        NSMutableArray *temp = [self.businessClassifyArray mutableCopy];
        [temp insertObject:allData atIndex:0];
        
        [HDMoreListView showListViewWithView:selfWeak.headerView1.itemCategoryBt Data:temp direction:UIPopoverArrowDirectionDown complete:^(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx) {
            if ([contentOne.cvsubid isEqual:@-1] && [contentOne.cvvaluedesc isEqualToString:@"全部"]) {
                selfWeak.headerView1.itemSearchTF.text = @"";
                selfWeak.businessTypeData = nil;
            }else {
                selfWeak.headerView1.itemSearchTF.text = contentOne.cvvaluedesc;
                selfWeak.businessTypeData = contentOne?contentOne:nil;
            }
            [selfWeak setTFregisterFirst];
            
            
        }];
    }else {
        self.businessClassifyArray = [NSMutableArray arrayWithArray:[[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataBusinesstype]];

    }

}

#pragma mark  ------备件主组------

- (void)headerMaterialAction{
    WeakObject(self);
    
    if (self.materialMianGroupArray.count) {
        //增加全部的选项，选中的效果相当与是清空数据
        PorscheConstantModel *allData = [[PorscheConstantModel alloc] init];
        allData.cvvaluedesc = @"全部";
        allData.cvsubid = @-1;
        NSMutableArray *temp = [self.materialMianGroupArray mutableCopy];
        [temp insertObject:allData atIndex:0];
        
        [HDMoreListView showListViewWithView:selfWeak.headerView1.materialMainBt Data:temp direction:UIPopoverArrowDirectionDown complete:^(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx) {
            if ([contentOne.cvsubid isEqual:@-1] && [contentOne.cvvaluedesc isEqualToString:@"全部"]) {
                selfWeak.headerView1.materialMainTF.text = @"";
                selfWeak.spareMainData = nil;
            }else {
                selfWeak.headerView1.materialMainTF.text = contentOne.cvvaluedesc;
                selfWeak.spareMainData = contentOne?contentOne:nil;
            }
            [selfWeak setTFregisterFirst];
        }];
    }else {
        self.materialMianGroupArray = [NSMutableArray arrayWithArray:[[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataPartsGroup]];

    }
    
    
}

#pragma mark  区头、区尾--bottomView----
- (void)configNavitem {
    
    WeakObject(self);

    __weak typeof(HD_FULLView)weakFull = HD_FULLView;
    self.headerView1.block = ^(UIButton *sender) {
        
        [weakFull endEditing:YES];
        //third 中header中的响应事件
        switch (sender.tag) {//车系
            case 1:
                
                [selfWeak getSeriesList];

                break;
            case 2://业务分类

                [selfWeak headerItemAction];
                break;
                
            case 3://工时主子组
                
                [selfWeak headerItemTime];
                break;
                
            case 4://备件主子组
                
                [selfWeak headerMaterialAction];
                break;
                
            case 5://搜索
                [selfWeak setTFregisterFirst];
                break;
            case 15:// 清空
            {
                [selfWeak cleanTF];
                [selfWeak setTFregisterFirst];
            }
            default:
                break;
        }
    };
    
    
#pragma mark  添加自定义项目
    self.bottomView.itemDetialLeftBottomViewBlock = ^ (ItemDetialLeftBottomViewBtStyle style,UIButton *sender) {
      
        switch (style) {
                //自定义项目
            case ItemDetialLeftBottomViewBtStyleAddSingle:
            {
                if (![HDLeftSingleton shareSingleton].isTechicianAdditionVC) {
                    return ;
                }
                if ([[HDLeftSingleton shareSingleton].carModel.wostatus isEqual:@7] && [HDLeftSingleton shareSingleton].stepStatus == 4) {
                    if ([HDPermissionManager isNotThisPermission:HDOrder_FuWuGouTong_Add_AfterClientAffirm]) {
                        return;
                    };
                }
                if ([[HDLeftSingleton shareSingleton].carModel.wostatus isEqual:@7] && [HDLeftSingleton shareSingleton].stepStatus == 2)
                {
                    if ([HDPermissionManager isNotThisPermission:HDOrder_JiShiZengXiang_AfterConfirmAdded]) {
                        return;
                    };
                }
                
                
                NSArray *array =  [[CoreDataManager shareManager] getModelsWithTableName:CoreDataSchemeLevel];
                [HDLeftCustomItemView showCustomViewWithModelArray:array aroundView:selfWeak.bottomView.addSingleItemBt direction:UIPopoverArrowDirectionUp complete:^(PorscheConstantModel *model) {
                    [selfWeak addCustomProjectWithType:[model.cvsubid integerValue]];
                }];
            }
                break;
                
#pragma mark  全屏按钮
            case ItemDetialLeftBottomViewBtStyleFullScreen:
                //编辑状态下，不能进方案库
#pragma mark 进入方案库权限
                if ([HDPermissionManager isNotThisPermission:HDOrder_GoSchemeLibrary]) {
                    return;
                };
                
                if ([sender.titleLabel.text isEqualToString:@"全屏"]){
                    [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleSchemeCub right:HDRightStatusStyleSchemeCub];
                    [sender setTitle:@"还原" forState:UIControlStateNormal];
                    
                }
                break;
            default:
                break;
        }
    };
    
}
//添加自定义项目至工单
- (void)addCustomProjectWithType:(NSInteger)type {
    
    [self addProjectWithType:type];

}

//添加自定义项目至工单中方案
- (void)addProjectWithType:(NSInteger)type {
    ProscheAdditionCondition *tmp = [ProscheAdditionCondition new];
    tmp.processstatus = @([HDLeftSingleton shareSingleton].stepStatus);
    tmp.type = kAddition;//添加/删除
    tmp.schemtype = @9;//1.厂方2.本店 4.未完成  9.自定义方案
    tmp.levelid = @(type);
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    [PorscheRequestManager increaseItemWithParamers:tmp complete:^(NSInteger status, PResponseModel * _Nonnull model) {
        [hud hideAnimated:YES];
        if (status == 100) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:TECHICIANADDITION_ADD_ITEM_NOTIFINATION object:nil];
            [[HDLeftSingleton shareSingleton] reloadOrderList];

        }else {
            NSLog(@"添加自定义方案失败！");
        }
    }];
}

- (void)setTFregisterFirst {
    __weak typeof(self) selfWeak = self;
    [selfWeak.headerView1.nameSearchTF resignFirstResponder];
    [selfWeak.headerView1.categoryTF resignFirstResponder];
    [selfWeak.headerView1.itemSearchTF resignFirstResponder];
    [selfWeak.headerView1.materialMainTF resignFirstResponder];
    [selfWeak.headerView1.itemMainTF resignFirstResponder];
    
    [self loadAllSourceType:self.dataSourceType levelid:@[@1,@2,@3] more:NO];
    [self loadSourceType:dataSourceTypeUndone levelid:nil more:NO];
    [self loadFavoritesListwithIsRefresh:YES loadFavoriteSuccess:nil];

}

- (void)cleanTF {
    _headerView1.nameSearchTF.text = @"";
    _headerView1.categoryTF.text = @"";
    _headerView1.itemSearchTF.text = @"";
    _headerView1.materialMainTF.text = @"";
    _headerView1.itemMainTF.text = @"";
    
    self.businessTypeData = nil;
    self.timeCostMainData = nil;
    self.timeCostSubData = nil;
    self.spareMainData = nil;
    self.wocarlevel = @0;
    self.scartypeid = nil;
    // wocarlevel
}




#pragma mark  ------delegate------

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
            
        case 0:{
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(0, 0, 100, 20);
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentLeft;
            label.text = @"    我的收藏夹";
            return label;
        }
            break;
        case 1:{
            WeakObject(self);
            _tabView = [[ProjectTabbarView alloc]initWithcustomFrame:CGRectMake(0, 0, self.view.frame.size.width, 30) type:selfWeak.dataSourceType complete:^(UIButton *button) {
                selfWeak.dataSourceType = button.tag;
                [selfWeak loadAllSourceType:selfWeak.dataSourceType levelid:@[@1,@2,@3] more:NO];
                [selfWeak loadSourceType:dataSourceTypeUndone levelid:@0 more:NO];

            }];
            return _tabView;

        }
            break;
        case 4:
        {
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(0, 0, 100, 20);
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:12];
            
            label.textAlignment = NSTextAlignmentLeft;
            label.text = @"    未完成";
            return label;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 4) {
        return 20;
    }
    if (section == 1) {
        return 30;
    }
    return 0.01;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            return  (LEFT_WITH - 40 - 15) / 4 + 15;
            

            break;
            
        default:
            return  (LEFT_WITH - 40 - 60)/3 + 5;
            break;
    }

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HDWorkListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"worklistTVCidentifier1" forIndexPath:indexPath];
    
    [self setupCell:cell index:indexPath];
    
    return cell;
}

- (void)setupCell:(HDWorkListTableViewCell *)cell index:(NSIndexPath *)indexPath {
    cell.longgrayLine.hidden = YES;
    cell.dataSource = nil;
    
    switch (indexPath.section) {
        case 0:
            cell.style = @"collection";
            break;
        case 1:
            cell.style = @"page1";
            
            break;
        case 2:
            cell.style = @"page2";
            break;
        case 3:
            cell.style = @"page3";
            break;
        case 4:
            cell.style = @"item";
            break;
        default:
            
            break;
    }
    cell.idArray = self.idArray;

    if (indexPath.section == 0) {
        //收藏夹中的model数据
        cell.dataSource = self.favoriteDataSource;
        cell.nameArr = self.favoriteNames;
        cell.itemArray = self.itemArray;
        cell.longgrayLine.hidden = NO;
    }else if (indexPath.section == 1) {//安全
        cell.itemArray = self.safeArray;
    }else if (indexPath.section == 2) {//隐患
        cell.itemArray = self.lurkingArray;
    }else if (indexPath.section == 3) {//信息
        cell.itemArray = self.infoArray;
    }else if (indexPath.section == 4) {//未完成
        cell.itemArray = self.unfinishedArray;
    }
    
    if (indexPath.section == 4) {//
        cell.longgrayLine.hidden = NO;
    }
    if (_isFirstAddSingleTonData  < 5) {
        if (![[HDLeftSingleton shareSingleton].collectionViewArray containsObject:cell.collectionView]) {
            
            [[HDLeftSingleton shareSingleton].collectionViewArray addObject:cell.collectionView];
        }
        _isFirstAddSingleTonData ++;
    }
    
    if (indexPath.section > 0) {
        [cell addLongPressAction];
    }
    WeakObject(self);
    cell.block = ^(id model){
        [selfWeak showSchemeDetialWithModel:model];
    };
    
    //收藏夹数据操作回调刷新界面
    cell.refreshFovriteListBlock = ^() {
        [selfWeak loadFavoritesListwithIsRefresh:YES loadFavoriteSuccess:nil];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell layoutIfNeeded];
}


#pragma mark  方案详情

- (void)showSchemeDetialWithModel:(id)model {
    NSInteger idNumber;
    if ([model isKindOfClass:[PorscheNewScheme class]]) {
        PorscheNewScheme *scheme = model;
        idNumber = [scheme.wosstockid integerValue];
    }else {
        PorscheSchemeModel *scheme = model;
        idNumber = [scheme.schemeid integerValue];
    }
    
    BOOL isUnfinished = [self.unfinishedArray containsObject:model];
    
    WeakObject(self);
    [MaterialTaskTimeDetailsView showWithID:idNumber detailType:MaterialTaskTimeDetailsTypeScheme clickAction:^(DetailViewBackType type, NSInteger idx, id schemeModel) {
        
        switch (type) {
            case DetailViewBackTypeSaveToMySchemeAndAddToOrder:
            case DetailViewBackTypeSaveToMyScheme:
            {
                [selfWeak.tabView switchLocationBtAction:selfWeak.tabView.mineBt];
                // 刷新工单
                [[HDLeftSingleton shareSingleton] reloadOrderList];
            }
                break;
            case DetailViewBackTypeDelete:
                // 刷新左侧方案库
                [selfWeak loadAllSourceType:selfWeak.dataSourceType levelid:@[@1,@2,@3] more:NO];
//                [selfWeak loadSourceType:dataSourceTypeUndone levelid:@0 more:NO];
//                [selfWeak addedSchemeTestWithDic:model isDelete:YES];
                break;
            case DetailViewBackTypeJoinWorkOrder:
            {
                if (isUnfinished && [model isKindOfClass:[PorscheSchemeModel class]])
                {
                    PorscheSchemeModel *unfinished = (PorscheSchemeModel *)model;
                    unfinished.schemetype = @4;
                    schemeModel = unfinished;
                }
                [selfWeak addSchemeWithModel:model schemeModel:schemeModel];
            }
                break;
            default:
                break;
        }
    }];
}



- (void)addSchemeWithModel:(id)model schemeModel:(id)schemeModel {
    if ([model isKindOfClass:[PorscheSchemeModel class]]) {
        PorscheSchemeModel *scheme = model;
        if ([scheme.flag integerValue] == 1) {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"该方案已添加" height:60 center:HD_FULLView.center superView:HD_FULLView];
        }else {
            [self addedSchemeTestWithDic:schemeModel isDelete:NO];
        }
    }else {//未完成方案
        [self addedSchemeTestWithDic:schemeModel isDelete:NO];
    }

}
- (UIView *)detailClearView {
    
    if (!_detailClearView) {
        _detailClearView = [[UIView alloc] initWithFrame:KEY_WINDOW.bounds];
        _detailClearView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = KEY_WINDOW.bounds;
        [closeButton addTarget:self action:@selector(closeDetaileView:) forControlEvents:UIControlEventTouchUpInside];
        [_detailClearView addSubview:closeButton];
    }
    return _detailClearView;
}

- (void)closeDetaileView:(UIButton *)button {
    
    if (self.detaileView.edit) return;
    [self.detailClearView removeFromSuperview];
    self.detaileView = nil;
    self.detailClearView = nil;
}

- (UIImageView *)createCellImageView:(UITableViewCell *)cell {
    
    //打开图形上下文，并将cell的根层渲染到上下文中，生成图片
    UIGraphicsBeginImageContext(cell.bounds.size);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *cellImageView = [[UIImageView alloc] initWithImage:image];
    cellImageView.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    cellImageView.layer.shadowRadius = 5.0;
    [_tableView addSubview:cellImageView];
    return cellImageView;
}

- (NSMutableArray *)favoriteDataSource {
    if (!_favoriteDataSource) {
        _favoriteDataSource = [NSMutableArray array];
    }
    return _favoriteDataSource;
}

- (NSMutableArray *)favoriteNames {
    
    if (!_favoriteNames) {
        _favoriteNames = [NSMutableArray array];
    }
    return _favoriteNames;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array], nil];
    }
    return _itemArray;
}

- (NSMutableArray *)otherArray {
    if (!_otherArray) {
        _otherArray = [NSMutableArray array];
    }
    return _otherArray;
}

- (NSMutableArray *)businessClassifyArray {
    if (!_businessClassifyArray) {
        _businessClassifyArray = [NSMutableArray array];
    }
    return _businessClassifyArray;
}

- (NSMutableArray *)materialMianGroupArray {
    if (!_materialMianGroupArray) {
        _materialMianGroupArray = [NSMutableArray array];
    }
    return _materialMianGroupArray;
}

- (NSMutableArray *)itemMainGroupArray {
    if (!_itemMainGroupArray) {
        _itemMainGroupArray = [NSMutableArray array];
    }
    return _itemMainGroupArray;
}

//获取的数据
- (NSMutableArray *)factorySaveSource {
    if (!_factorySaveSource) {
        _factorySaveSource = [NSMutableArray array];
    }
    return _factorySaveSource;
}
- (NSMutableArray *)factoryDangerSource {
    if (!_factoryDangerSource) {
        _factoryDangerSource = [NSMutableArray array];
    }
    return _factoryDangerSource;
}
- (NSMutableArray *)factoryMessageSource {
    if (!_factoryMessageSource) {
        _factoryMessageSource = [NSMutableArray array];
    }
    return _factoryMessageSource;
}
- (NSMutableArray *)localSaveSource {
    if (!_localSaveSource) {
        _localSaveSource = [NSMutableArray array];
    }
    return _localSaveSource;
}
- (NSMutableArray *)localDangerSource {
    if (!_localDangerSource) {
        _localDangerSource = [NSMutableArray array];
    }
    return _localDangerSource;
}
- (NSMutableArray *)localMessageSource {
    if (!_localMessageSource) {
        _localMessageSource = [NSMutableArray array];
    }
    return _localMessageSource;
}
- (NSMutableArray *)mySaveSource {
    if (!_mySaveSource) {
        _mySaveSource = [NSMutableArray array];
    }
    return _mySaveSource;
}
- (NSMutableArray *)myDangerSource {
    if (!_myDangerSource) {
        _myDangerSource = [NSMutableArray array];
    }
    return _myDangerSource;
}
- (NSMutableArray *)myMessageSource {
    if (!_myMessageSource) {
        _myMessageSource = [NSMutableArray array];
    }
    return _myMessageSource;
}


//给cell赋值数据源
- (NSMutableArray *)safeArray {
    if (!_safeArray) {
        _safeArray = [NSMutableArray array];
    }
    return _safeArray;
}

- (NSMutableArray *)lurkingArray {
    if (!_lurkingArray) {
        _lurkingArray = [NSMutableArray array];
    }
    return _lurkingArray;
}

- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        _infoArray = [NSMutableArray array];
    }
    return _infoArray;
}

- (NSMutableArray *)unfinishedArray {
    if (!_unfinishedArray) {
        _unfinishedArray = [NSMutableArray array];
    }
    return _unfinishedArray;
}

- (NSMutableArray *)unfinishedSource {
    if (!_unfinishedSource) {
        _unfinishedSource = [NSMutableArray array];
    }
    return _unfinishedSource;
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
