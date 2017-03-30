//
//  HDSchemeRightViewController.m
//  HandleiPad
//
//  Created by Robin on 16/10/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDSchemeRightViewController.h"
#import "HDSchemeRightRectCollectionViewCell.h"
#import "HDSchemeRightListTableView.h"
#import "HDRightViewController.h"
#import "MaterialTaskTimeDetailsView.h"
#import "PorscheCustomView.h"
#import "ServiceShareListView.h"
#import "MaterialRightModel.h"
#import "PorscheCarModel.h"
#import "HDLeftSingleton.h"
#import "HDSlitViewRightViewController.h"
#import "HDServiceViewController.h"
#import "HDSelectStaffView.h"
typedef NS_ENUM(NSInteger, ShowType) {
    
    ShowTypeList, //列表
    ShowTypeRect //九宫格
};

typedef NS_ENUM(NSInteger, DataSourceType) {
    
    dataSourceTypeFactory = 1,//厂方
    dataSourceTypeLocal, //本店
    dataSourceTypeMy, //我的
    dataSourceTypeUndone //未完成
};

@interface HDSchemeRightViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *factoryButton;
@property (weak, nonatomic) IBOutlet UIButton *localButton;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (weak, nonatomic) IBOutlet UIButton *undoneButton;
@property (weak, nonatomic) IBOutlet UIImageView *titleBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextField *counselorTF;
@property (weak, nonatomic) IBOutlet UIButton *changeShowButton;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIView *counselorView;
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bottomBackView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, strong) HDSchemeRightListTableView *listTableView;

@property (nonatomic, strong) MaterialTaskTimeDetailsView *detaileView;

@property (nonatomic, assign) ShowType showType;

@property (nonatomic, assign) PorscheItemModelCategooryStyle dataCategory;

@property (nonatomic, assign) DataSourceType dataSourceType;

//新方案model数组
@property (nonatomic, strong) NSMutableArray *schemeDataArray; //
@property (nonatomic, strong) NSMutableArray *schemeAddSource; //选中的方案
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *factorydataSource; //厂方数据源
@property (nonatomic, strong) NSMutableArray *localdataSource; //本店数据源
@property (nonatomic, strong) NSMutableArray *undonedataSource; //未完成数据源
@property (nonatomic, strong) NSMutableArray *mydataSource; //我的数据源

@property (nonatomic, strong) NSArray *favoritSoruce; //收藏夹数据源
@property (weak, nonatomic) IBOutlet UILabel *techLabel;


@end

@implementation HDSchemeRightViewController {
    NSArray *_buttonArray;
    NSInteger _cellCount;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"方案库左侧视图控制器释放~~~~~~");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConfig];

    self.dataCategory = 0;
    
    //默认选中本地方案
    [self localAction:self.localButton];
    
    [self addNotification];
    
    self.counselorTF.text = [HDLeftSingleton shareSingleton].carModel.serviceadvisorname;
    self.techLabel.text = [HDLeftSingleton shareSingleton].carModel.technicianname;
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDataSource:) name:PORSCHE_LEFT_REQUEST_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortDataSource:) name:SCHEME_LEFT_SEARCHFAVORITE_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDataSource:) name:SCHEME_LEFT_SEARCH_NOTIFICATION object:nil];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.listTableView.frame = self.collectionView.frame;
}

- (void)setupConfig {
    
    //设置数字圆点的layer
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = 6;
    
    _buttonArray = @[self.factoryButton,self.localButton,self.myButton,self.undoneButton];
    
    self.showType = ShowTypeRect;
    
    self.dataCategory = PorscheItemModelCategooryStyleUnknow;
    
    self.collectionView.alwaysBounceVertical = YES;
    
    [self refreshCountLabel];
    [self refreshTotalLabel];
    
    [self addMJRefresh];
}

- (void)setHiddenBottomInfo:(BOOL)hiddenBottomInfo {
    _hiddenBottomInfo = hiddenBottomInfo;
    
    self.counselorView.hidden = hiddenBottomInfo;
    self.totalView.hidden = hiddenBottomInfo;
    
    if (hiddenBottomInfo) {
        self.bottomBackView.backgroundColor = [UIColor whiteColor];
        self.listTableView.hiddenBottomView = self.hiddenBottomInfo;
        [self hiddenUnFinishedTab];
    }
}

- (void)hiddenUnFinishedTab
{
    self.undoneButton.hidden = YES;
    
    self.titleBackImageView.image = [UIImage imageNamed:@"scheme_right_title_second1"];
}

- (void)searchDataSource:(NSNotification *)obj {
    
    [self beginRefreshSource];
}

- (void)sortDataSource:(NSNotification *)obj {
    
    NSArray *favoriteArray = obj.object;
    
    NSMutableArray *favorites = [[NSMutableArray alloc] init];
    for (PorscheSchemeFavoriteModel *favorite in favoriteArray) {
        [favorites addObjectsFromArray:favorite.schemelist];
    }
    
    //去除收藏夹内重复项
    NSMutableArray *favoriteSelecteds = [[NSMutableArray alloc] init];
    for (PorscheSchemeModel *obj in favorites) {
        
        BOOL include = NO;
        for (PorscheSchemeModel *obj_scheme in favoriteSelecteds) {
            if (obj_scheme.schemeid.integerValue == obj.schemeid.integerValue) include = YES;
        }
        if (!include) [favoriteSelecteds addObject:obj];
    }
    
    self.favoritSoruce = favoriteSelecteds;
    
    [self beginRefreshSource];
}


- (void)addMJRefresh {
    
    __weak typeof(self)weakself = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        PorscheRequestSchemeListModel *requestModel = [PorscheRequestSchemeListModel shareModel];
        [weakself loadSource:requestModel More:NO];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        PorscheRequestSchemeListModel *requestModel = [PorscheRequestSchemeListModel shareModel];
        [weakself loadSource:requestModel More:YES];
    }];
    
}

- (void)loadSource:(PorscheRequestSchemeListModel *)requestModel More:(BOOL)more{
    
    if (!more) {
        [HDStoreInfoManager shareManager].currpage = @(0);
    }
    
    NSInteger before = [HDStoreInfoManager shareManager].currpage.integerValue;
    HDStoreInfoManager *pageModel = [HDStoreInfoManager shareManager];
    pageModel.currpage = @(before+1);
    pageModel.pagesize = @(20);
    WeakObject(pageModel);
    WeakObject(self);
    
    if (requestModel.schemetype.integerValue == 4) { //未完成
        
//        NSString *plateplace = self.hiddenBottomInfo ? @"" : [HDStoreInfoManager shareManager].plateplace;
//        NSString *carpalte = self.hiddenBottomInfo ? @"" : [HDStoreInfoManager shareManager].carplate;
        PorscheNewCarMessage *model = [HDLeftSingleton shareSingleton].carModel;
        if (!model) {
            [selfWeak endRefresh];
            return;
        }
        
        NSMutableDictionary *paramers = [NSMutableDictionary dictionaryWithDictionary:[requestModel yy_modelToJSONObject]];
        [paramers hs_setSafeValue:[HDLeftSingleton shareSingleton].carModel.wocarid forKey:@"wocarid"];
        [paramers hs_setSafeValue:@1 forKey:@"isfromunfinished"];
        [paramers removeObjectForKey:@"schemetype"];
        [PorscheRequestManager workOrderUnfinishedSchemeListRequestWith:paramers  complete:^(NSMutableArray * _Nonnull list, PResponseModel * _Nonnull responser) {
            
            [selfWeak endRefresh];
            if (responser.status != SUCCESS_STATUS) return ;
            
            if (list.count == 0) pageModelWeak.currpage = @(before); //如果没有更多恢复之前页码
            
            [selfWeak setupDataSource:list More:more];
            
        }];
        
    } else {
        
        [PorscheRequestManager schemeListRequestWith:requestModel complete:^(NSArray *models, NSError *error) {
            
            [selfWeak endRefresh];
            if (error || !models) return ;
            [PorscheRequestSchemeListModel shareModel].isClearSearchData = NO;//清空参数重置
            if (models.count == 0) pageModelWeak.currpage = @(before); //如果没有更多恢复之前页码
            
            [selfWeak setupDataSource:models More:more];
        }];
    }
}

- (void)setupDataSource:(NSArray *)newDataSource More:(BOOL)more{
    
//    dataSourceTypeFactory,//厂方
//    dataSourceTypeLocal, //本店
//    dataSourceTypeMy, //我的
//    dataSourceTypeUndone //未完成
    
    switch (self.dataSourceType) {
        case dataSourceTypeFactory:
        {
            if (!more) [self.factorydataSource removeAllObjects];
            [self.factorydataSource addObjectsFromArray:newDataSource];
        }
            break;
        case dataSourceTypeLocal:
        {
            if (!more) [self.localdataSource removeAllObjects];
            [self.localdataSource addObjectsFromArray:newDataSource];
        }
            break;
        case dataSourceTypeMy:
        {
            if (!more) [self.mydataSource removeAllObjects];
            [self.mydataSource addObjectsFromArray:newDataSource];
        }
            break;
        case dataSourceTypeUndone:
           if (!more) [self.undonedataSource removeAllObjects];
            [self.undonedataSource addObjectsFromArray:newDataSource];
        default:
            break;
    }
    
    [self resetDataSource];
    [self.collectionView reloadData];
    [self.listTableView.topTableView reloadData];
    
    if (newDataSource.count < [HDStoreInfoManager shareManager].pagesize.integerValue) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        [self.listTableView.topTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.collectionView.mj_footer resetNoMoreData];
        [self.listTableView.topTableView.mj_footer resetNoMoreData];
    }
//    self.listTableView.topTableView.mj_footer.hidden = !newDataSource.count;
//    self.collectionView.mj_footer.hidden = !newDataSource.count;
}
//刷新数据
- (void)beginRefreshSource {
    
    
    switch (self.showType) {
        case ShowTypeRect:
        {
            [self.collectionView.mj_header beginRefreshing];
        }
            break;
        case ShowTypeList:
        {
            [self.listTableView.topTableView.mj_header beginRefreshing];
        }
            break;
        default:
            break;
    }
    
    
}
//加载更多数据
- (void)beginRefreshMoreSource {
    [self.collectionView.mj_footer beginRefreshing];
    [self.listTableView.topTableView.mj_footer beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    
    [self.listTableView.topTableView.mj_header endRefreshing];
    [self.listTableView.topTableView.mj_footer endRefreshing];


}


- (NSMutableArray *)schemeDataArray {

    if (!_schemeDataArray) {
        _schemeDataArray = [[NSMutableArray alloc] init];
        [self loadSource:nil More:NO];
    }
    return _schemeDataArray;
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)factorydataSource {
    
    if (!_factorydataSource) {
        _factorydataSource = [[NSMutableArray alloc] init];
        }
    return _factorydataSource;
}

- (NSMutableArray *)localdataSource {
    
    if (!_localdataSource) {
        _localdataSource = [[NSMutableArray alloc] init];
    }
    return _localdataSource;
}

- (NSMutableArray *)undonedataSource {
    
    if (!_undonedataSource) {
        _undonedataSource = [[NSMutableArray alloc] init];
    }
    return _undonedataSource;

}

- (NSMutableArray *)mydataSource {
    
    if (!_mydataSource) {
        _mydataSource = [[NSMutableArray alloc] init];
    }
    return _mydataSource;
}

- (NSMutableArray *)schemeAddSource {
    
    if (!_schemeAddSource) {
        _schemeAddSource = [[NSMutableArray alloc] init];
    }
    return _schemeAddSource;
}

#pragma mark - 切换数据来源（厂方 本店 我的）
- (IBAction)factoryAction:(UIButton *)sender {
    [self setTitleButtonColor:sender];
    
    self.dataSourceType = dataSourceTypeFactory;
}
- (IBAction)localAction:(UIButton *)sender {
    [self setTitleButtonColor:sender];
    self.dataSourceType = dataSourceTypeLocal;
}
- (IBAction)mySchemeAction:(UIButton *)sender {
    
    [self setTitleButtonColor:sender];
    
    self.dataSourceType = dataSourceTypeMy;
}
- (IBAction)undoneAction:(UIButton *)sender {
    [self setTitleButtonColor:sender];
    
    self.dataSourceType = dataSourceTypeUndone;
}
- (IBAction)changeListAction:(UIButton *)sender {
    
    self.showType = self.showType == ShowTypeRect ? ShowTypeList : ShowTypeRect;
    
    switch (self.showType) {
        case ShowTypeRect:
        {
            self.listTableView.hidden = YES;
            self.collectionView.hidden = NO;
            
        }
            break;
        case ShowTypeList:
        {
            self.listTableView.hidden = NO;
            self.collectionView.hidden = YES;
            
        }
            break;
        default:
            break;
    }

    [self.listTableView refreshTableViewWithDataSource:self.dataSource];
    [self.collectionView reloadData];
}

- (void)setDataSourceType:(DataSourceType)dataSourceType {
    
    _dataSourceType = dataSourceType;
    
    [self resetDataSource];
    
    [self beginRefreshSource];

}

#pragma mark - 去除方案收藏夹已有的数据源
- (NSArray *)deleteRepetitionScheme:(NSArray *)obj_array includeArray:(NSArray *)includeArray {
    
    NSMutableArray *loadSource = [[NSMutableArray alloc] initWithArray:obj_array];
    for (PorscheSchemeModel *schemeModel in includeArray) {
        
        schemeModel.inFavorite = YES;
        [loadSource enumerateObjectsUsingBlock:^(PorscheSchemeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.schemeid.integerValue == schemeModel.schemeid.integerValue) {
                [loadSource removeObject:obj];
            }
        }];
    }
    return loadSource;
}

- (void)resetDataSource {
    
    PorscheRequestSchemeListModel *requestModel = [PorscheRequestSchemeListModel shareModel];
  
    [self.dataSource removeAllObjects];
    if (![PorscheRequestSchemeListModel shareModel].favoriteArray.count) {
        self.favoritSoruce = nil;
    }
    
    NSMutableArray *includeArray = [[NSMutableArray alloc] init];
    for (PorscheSchemeModel *schemeModel in self.favoritSoruce) {
        
        if (schemeModel.schemetype.integerValue == self.dataSourceType) {
            
            if (requestModel.schemelevelid.integerValue == schemeModel.schemelevelid.integerValue || !requestModel.schemelevelid.integerValue) {
                [includeArray addObject:schemeModel];
            }
            
        }
    }
    [self.dataSource addObjectsFromArray:includeArray];
    
    switch (self.dataSourceType) {
        case dataSourceTypeFactory:
        {
//            [self.dataSource addObjectsFromArray:self.factorydataSource];
            [self.dataSource addObjectsFromArray:[self deleteRepetitionScheme:self.factorydataSource includeArray:includeArray]];
            
            NSString *imageString = @"scheme_right_title_first";
            if (self.hiddenBottomInfo)
            {
                imageString = @"scheme_right_title_first1";
            }
            
            self.titleBackImageView.image = [UIImage imageNamed:imageString];
            requestModel.schemetype = @(1);
        }break;
        case dataSourceTypeLocal:
        {
//            [self.dataSource addObjectsFromArray:self.localdataSource];
            [self.dataSource addObjectsFromArray:[self deleteRepetitionScheme:self.localdataSource includeArray:includeArray]];
            
            NSString *imageString = @"scheme_right_title_second";
            if (self.hiddenBottomInfo)
            {
                imageString = @"scheme_right_title_second1";
            }
            
            self.titleBackImageView.image = [UIImage imageNamed:imageString];
            requestModel.schemetype = @(2);
        }break;
        case dataSourceTypeMy:
        {
//            [self.dataSource addObjectsFromArray:self.mydataSource];
            [self.dataSource addObjectsFromArray:[self deleteRepetitionScheme:self.mydataSource includeArray:includeArray]];
            
            NSString *imageString = @"scheme_right_title_third";
            if (self.hiddenBottomInfo)
            {
                imageString = @"scheme_right_title_third1";
            }

            
            self.titleBackImageView.image = [UIImage imageNamed:imageString];
            requestModel.schemetype = @(3);
        }
            break;
        case dataSourceTypeUndone:
        {
//            [self.dataSource addObjectsFromArray:self.undonedataSource];
            [self.dataSource addObjectsFromArray:[self deleteRepetitionScheme:self.undonedataSource includeArray:includeArray]];
            self.titleBackImageView.image = [UIImage imageNamed:@"scheme_right_title_fourth"];
            requestModel.schemetype = @(4);
        }
            break;
        default:
            break;
    }
    [self.collectionView reloadData];
    [self.listTableView.topTableView reloadData];
}

- (void)refreshUI {

    [self refreshCountLabel];//刷新购物车
    [self refreshTotalLabel];//刷新总价
    
}

- (HDSchemeRightListTableView *)listTableView {
    
    if (!_listTableView) {
        _listTableView = [HDSchemeRightListTableView viewWithNibdataSource:self.dataSource addSource:self.schemeAddSource];
        
        __weak typeof(self)weakself = self;

        _listTableView.refreshBlock = ^() {
          
            [weakself refreshUI];
        };
        _listTableView.loadDataBlock = ^(BOOL more) {
          
            [weakself loadSource:[PorscheRequestSchemeListModel shareModel] More:more];
        };
        [self.view addSubview:_listTableView];
        _listTableView.hidden = YES;
    }
    return _listTableView;
}

- (void)setShowType:(ShowType)showType {
    
    _showType = showType;
    
    NSString *imageName = showType == ShowTypeRect ? @"scheme_right_titile_changge_list" : @"scheme_right_titile_changge_rect";
    [self.changeShowButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
}

#pragma mark - 设置导航上的按钮字体颜色
- (void)setTitleButtonColor:(UIButton *)sender {

    for (UIButton *button in _buttonArray) {
        if (button != sender) {
            [button setTitleColor:Color(76, 76, 76) forState:UIControlStateNormal];
        } else {
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}
#pragma mark - collectionView代理
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellWidth = (self.collectionView.bounds.size.width-40)/3.0;
    CGFloat cellHeight = (self.collectionView.bounds.size.height-40)/3.0;
    CGSize itemSize = CGSizeMake(cellWidth, cellHeight);
    
    return itemSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HDSchemeRightRectCollectionViewCell *cell = [HDSchemeRightRectCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.cellRow = indexPath.row;

    PorscheSchemeModel *model = self.dataSource[indexPath.row];
    cell.schemeModel = model;
    [self.schemeAddSource enumerateObjectsUsingBlock:^(PorscheSchemeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.schemeid.integerValue == model.schemeid.integerValue) {
            cell.cellSelected = YES;
        }
    }];
    __weak typeof(self)weakself = self;
    cell.longBlock = ^() {
      
//        [weakself showDetaileSheetView:MaterialTaskTimeDetailsTypeScheme dataSource:@[] edit:NO];
        [weakself showSchemeView:model];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.hiddenBottomInfo) return;
    
    if (![[HDLeftSingleton shareSingleton] isHasAddToOrderPermissionShowMessage:YES])
    {
        return;
    }
    
    HDSchemeRightRectCollectionViewCell *cell = (HDSchemeRightRectCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    PorscheNewSchemews *model = self.dataSource[indexPath.row];
    if ([self.schemeAddSource containsObject:model]) {
        [self.schemeAddSource removeObject:model];
        cell.cellSelected = NO;
    } else {
        [self.schemeAddSource addObject:model];
        cell.cellSelected = YES;
    }
    
    [self refreshUI];
}

- (void)refreshCountLabel {
    
    _countLabel.hidden = self.schemeAddSource.count == 0;
    _countLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)self.schemeAddSource.count];
}

- (void)refreshTotalLabel {
    
    CGFloat totalPrice = 0;

    for (PorscheSchemeModel *scheme in self.schemeAddSource) {
        totalPrice += scheme.schemeprice.floatValue;
    }
    
    _totalLabel.text = [NSString formatMoneyStringWithFloat:totalPrice];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 显示详情页面
-(void)showSchemeView:(PorscheSchemeModel *)model {
    
    WeakObject(self);
    [MaterialTaskTimeDetailsView showWithID:model.schemeid.integerValue detailType:MaterialTaskTimeDetailsTypeScheme clickAction:^(DetailViewBackType backType, NSInteger detailId, id responderModel) {
        
        if (backType == DetailViewBackTypeJoinWorkOrder) {
            
            if (![selfWeak.schemeAddSource containsObject:model]) {
                [selfWeak.schemeAddSource addObject:model];
                [selfWeak.collectionView reloadData];
                [selfWeak refreshUI];
            }
        }
        else if(backType == DetailViewBackTypeSaveToMyScheme)
        {
            [self mySchemeAction:_myButton];
        }
        else if (backType == DetailViewBackTypeSaveToMySchemeAndAddToOrder)
        {
            if (![selfWeak.schemeAddSource containsObject:model]) {
                [selfWeak.schemeAddSource addObject:model];
                [selfWeak.collectionView reloadData];
                [self mySchemeAction:_myButton];
            }
        }
        else {
            
            [self searchDataSource:nil];
        }
    }];
}

- (void)removeCleanView:(UIButton *)sender {
    
    if (self.detaileView.edit) {
        return;
    }
    [sender.superview removeFromSuperview];
    self.detaileView = nil;
}

#pragma mark - 确定返回
- (IBAction)sureToBackBtAction:(UIButton *)sender {
    
    HDRightViewController *selfParentVC = (HDRightViewController *)self.parentViewController;
    
    if (selfParentVC.style == ViewControllerEntryStyleProject) {
        
        [[HDLeftSingleton shareSingleton].VC billingBackToFirstView];
    }else {
        [self removeFromParentViewController];
        
        [self.view removeFromSuperview];
        //通知左侧 退出方案库
        if ([[HDLeftSingleton shareSingleton].carModel.wostatus isEqual:@7]) {
            if ([HDPermissionManager isNotThisPermission:HDOrder_FuWuGouTong_Add_AfterClientAffirm]) {
                return;
            };
        }
//        NSArray *ids = [self getIDArray];
        
        NSDictionary *sendInfo = @{@"ids":self.schemeAddSource,@"type":@3};
        if ([[HDLeftSingleton shareSingleton].rightVC isKindOfClass:[HDSlitViewRightViewController class]]) {//技师界面
            HDSlitViewRightViewController *slitVC = (HDSlitViewRightViewController *)[HDLeftSingleton shareSingleton].rightVC;
            [slitVC materialBackToTechnianVC:sendInfo];
        }else if ([[HDLeftSingleton shareSingleton].rightVC isKindOfClass:[HDServiceViewController class]]) {//服务顾问
            HDServiceViewController *slitVC = (HDServiceViewController *)[HDLeftSingleton shareSingleton].rightVC;
            [slitVC materialBackToTechnianVC:sendInfo];
        }
        
        [[HDLeftSingleton shareSingleton].leftTabBarVC changeBtAction:@{@"left":@2,@"right":@0}];
        [[HDLeftSingleton shareSingleton].HDRightViewController changeBackItemColor:nil];
        [[HDLeftSingleton shareSingleton].rightVC baseReloadData];
    }
    //右侧 流程图
}


- (NSArray *)getIDArray {
    
    __block NSMutableArray *ids = [[NSMutableArray alloc] init];
    [self.schemeAddSource enumerateObjectsUsingBlock:^(PorscheSchemeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [ids addObject:obj.schemeid];
        
    }];
    return ids;
}

#pragma mark - 服务顾问按钮
- (IBAction)counselorButton:(id)sender {
    // 的
    [self showSelectStaffViewWithTF:sender];
    
}
#pragma mark  人员指派
- (void)showSelectStaffViewWithTF:(UITextField *)TF
{
    WeakObject(self);
    WeakObject(TF);
    // 获取组中员工数组
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
        self.counselorTF.text = staffname;
        [HDLeftSingleton shareSingleton].carModel.serviceadvisorname = staffname;
        [HDLeftSingleton shareSingleton].carModel.serviceadvisorid = staffid;
        [HDLeftSingleton shareSingleton].selectedId = staffid;//4
        [selfWeak bottomSaveChooseTechWithUserid:staffid];
    }];
}

#pragma mark  底部员工指派 逻辑<根据职位id，组id，确定>
//组列表
- (void)getStaffGroupTest {
    if (![HDLeftSingleton shareSingleton].groupArray) {
        [HDLeftSingleton shareSingleton].groupArray = [NSMutableArray arrayWithArray:[[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataGroup]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bottomSaveChooseTechWithUserid:(NSNumber *)userid {
    if ([HDStoreInfoManager shareManager].carorderid) {
         NSDictionary * dic = @{@"serviceadvisorid":userid};;
//        WeakObject(self);
        [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_CHANGE_POSITION_URL parameters:dic completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
            if (responser.status == 100)
            {
                
            }
        }];
    }
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
