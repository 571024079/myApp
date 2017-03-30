//
//  MaterialRightViewController.m
//  MaterialDemo
//
//  Created by Robin on 16/9/27.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "MaterialRightViewController.h"
#import "MaterialRightTableViewCell.h"
#import "MaterialRightWorkHoursTableViewCell.h"
#import "MaterialRightTimeTitleBar.h"
#import "HDPoperDeleteView.h"

//#import "MaterialRightModel.h"  //零时model
#import "PorscheItemModel.h"  //章斌的model 回调用

#import "PorscheCarModel.h" //model


#import "MaterialTaskTimeDetailsView.h" //新view
#import "HDLeftSingleton.h"

#import "HDSlitViewRightViewController.h"
#import "HDServiceViewController.h"
#import "HDRightMaterialDealViewController.h"
typedef NS_ENUM(NSInteger, MaterialTimeDataSourceType) {
    
    MaterialTimeDataSourceTypeFactory, //厂方
    MaterialTimeDataSourceTypeStore, //本店
    MaterialTimeDataSourceTypeMy //我的
};
@interface MaterialRightViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
//上部TableView
@property (weak, nonatomic) IBOutlet UITableView *topTableView;
//下部TableView
@property (weak, nonatomic) IBOutlet UITableView *bottomTableView;
//表头第一个View的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTableViewLayout;
//中间分割View
@property (weak, nonatomic) IBOutlet UIView *cutScreenView;
@property (weak, nonatomic) IBOutlet UILabel *cutScreenLabel;
//上部TableView的高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightLayout;
//页面类型
@property (assign, nonatomic) ControllerType type;

@property (weak, nonatomic) IBOutlet UIView *titleBar;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel4;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel5;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel6;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel7;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel8;

@property (weak, nonatomic) IBOutlet UIButton *factoryButton;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;
@property (weak, nonatomic) IBOutlet UIButton *myButton;

@property (weak, nonatomic) IBOutlet UIButton *addNewItem;
//备件总计
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
//备件个数
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;

@property (strong ,nonatomic) MaterialRightTimeTitleBar *hoursTitlebar;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong ,nonatomic) NSMutableArray *addSource;

@property (strong, nonatomic) HDPoperDeleteView *popDeleteView;

@property (nonatomic, strong) MaterialTaskTimeDetailsView *detaileView;

@property (nonatomic, assign) PorscheItemModelCategooryStyle Level;

//备件工时详情 数据源
@property (nonatomic, strong) NSMutableArray *factorySource;
@property (nonatomic, strong) NSMutableArray *storeSource;
@property (nonatomic, strong) NSMutableArray *mySource;

@property (nonatomic, assign) MaterialTimeDataSourceType dataType;

@property (nonatomic, strong) NSArray *favoritSoruce; //收藏夹数据源

@end

@implementation MaterialRightViewController {
    
    NSArray *_buttonArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self cutScreenViewGesture];

    if (_type == ControllerTypeWithWorkingHours) {
         [self.view addSubview:self.hoursTitlebar];
    }
    
    [self setupInfo:self.type];
    
    [self setupConfig];
    
    [self refreshTotalLabel];
    
    //初始工厂备件
    [self factoryAction:self.factoryButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseModelType:) name:SCHEME_LEFT_LEVEL_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDataSource:) name:PORSCHE_LEFT_REQUEST_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortDataSource:) name:SCHEME_LEFT_SEARCHFAVORITE_NOTIFICATION object:nil];
}

- (void)chooseModelType:(NSNotification *)obj {
    
    self.Level = [obj.object integerValue];
    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    _type = ControllerTypeWithMaterial;
    
        }
    return self;
}

- (instancetype)initWithType:(ControllerType)type
{
    self = [super init];
    if (self) {
        self.type = type;
        
        }
    return self;
}

- (void)setupInfo:(ControllerType)type {
    
    switch (type) {
        case ControllerTypeWithMaterial:
        {
            self.cutScreenLabel.text = @"已选备件";
            [self.addNewItem setTitle:@"      新建备件" forState:UIControlStateNormal];
        }
            break;
        case ControllerTypeWithWorkingHours:
        {
            self.cutScreenLabel.text = @"已选工时";
            [self.addNewItem setTitle:@"      新建工时" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
    NSString *str1 = type == ControllerTypeWithMaterial ? @"厂方备件":@"厂方工时";
    NSString *str2 = type == ControllerTypeWithMaterial ? @"本店备件":@"本店工时";
    NSString *str3 = type == ControllerTypeWithMaterial ? @"我的备件":@"我的工时";
    [self.factoryButton setTitle:str1 forState:UIControlStateNormal];
    [self.storeButton setTitle:str2 forState:UIControlStateNormal];
    [self.myButton setTitle:str3 forState:UIControlStateNormal];
}

- (void)setupConfig {
    
    _buttonArray = @[_factoryButton,_storeButton,_myButton];
    
    self.topTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.topTableView.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    self.topTableView.clipsToBounds = YES;
    
    self.bottomTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bottomTableView.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    self.bottomTableView.clipsToBounds = YES;
    
    self.titleBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.titleBar.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    self.titleBar.clipsToBounds = YES;
    
    self.titleBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.titleBar.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    self.titleBar.clipsToBounds = YES;
    
    self.hoursTitlebar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.hoursTitlebar.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    self.hoursTitlebar.clipsToBounds = YES;
    
    [self addMJRefresh];
}

- (void)addMJRefresh {
    
    __weak typeof(self)weakself = self;
    self.topTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        PorscheRequestSchemeListModel *requestModel = [PorscheRequestSchemeListModel shareModel];
        [weakself loadSource:requestModel More:NO];
    }];
    [self.topTableView.mj_header beginRefreshing];
    
        self.topTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    
            PorscheRequestSchemeListModel *requestModel = [PorscheRequestSchemeListModel shareModel];
            [weakself loadSource:requestModel More:YES];
        }];
}

//刷新数据
- (void)beginRefreshSource {
     [self.topTableView.mj_header beginRefreshing];
}
//加载更多数据
- (void)beginRefreshMoreSource {
    [self.topTableView.mj_footer beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [self.topTableView.mj_header endRefreshing];
    [self.topTableView.mj_footer endRefreshing];
}

- (void)searchDataSource:(NSNotification *)obj {
    
    [self.topTableView.mj_header beginRefreshing];
}

- (void)sortDataSource:(NSNotification *)obj {

    NSArray *favoriteArray = obj.object;
    
    __block NSMutableArray *spareHourArray = [[NSMutableArray alloc] init];
    
    if (self.type == ControllerTypeWithMaterial) {
        for (PorscheSchemeFavoriteModel *favorite in favoriteArray) {
            
            [favorite.schemelist enumerateObjectsUsingBlock:^(PorscheSchemeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [spareHourArray addObjectsFromArray:obj.sparelist];
                
            }];
        }
        //去除收藏夹内重复项
        NSMutableArray *favoriteSelecteds = [[NSMutableArray alloc] init];
        for (PorscheSchemeSpareModel *obj in spareHourArray) {
            
            BOOL include = NO;
            for (PorscheSchemeSpareModel *obj_scheme in favoriteSelecteds) {
                if (obj_scheme.parts_id.integerValue == obj.parts_id.integerValue) include = YES;
            }
            if (!include) [favoriteSelecteds addObject:obj];
        }
        
        self.favoritSoruce = favoriteSelecteds;
        
    } else if (self.type == ControllerTypeWithWorkingHours) {
        
        for (PorscheSchemeFavoriteModel *favorite in favoriteArray) {
            
            [favorite.schemelist enumerateObjectsUsingBlock:^(PorscheSchemeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [spareHourArray addObjectsFromArray:obj.workhourlist];
                
            }];
        }
        //去除收藏夹内重复项
        NSMutableArray *favoriteSelecteds = [[NSMutableArray alloc] init];
        for (PorscheSchemeWorkHourModel *obj in spareHourArray) {
            
            BOOL include = NO;
            for (PorscheSchemeWorkHourModel *obj_scheme in favoriteSelecteds) {
                if (obj_scheme.workhourid.integerValue == obj.workhourid.integerValue) include = YES;
            }
            if (!include) [favoriteSelecteds addObject:obj];
        }
        
        self.favoritSoruce = favoriteSelecteds;
    }
    
    [self beginRefreshSource];
}

- (void)loadSource:(PorscheRequestSchemeListModel *)requestModel More:(BOOL)more{
    
    if (!more) {
        [HDStoreInfoManager shareManager].currpage = 0;
    }
    NSInteger before = [HDStoreInfoManager shareManager].currpage.integerValue;
    HDStoreInfoManager *pageModel = [HDStoreInfoManager shareManager];
    pageModel.currpage = @(before+1);
    pageModel.pagesize = @(20);
    WeakObject(pageModel);
    WeakObject(self);
    
    switch (self.type) {
        case ControllerTypeWithMaterial:
        {
            [PorscheRequestManager speraListWith:requestModel completion:^(NSArray<PorscheSchemeSpareModel *> * _Nullable speraArray, NSError * _Nullable error) {
                
                [selfWeak endRefresh];
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showMessageText:@"服务器错误" toView:selfWeak.view anutoHidden:YES];
                    });
                    return ;
                };
                
                if (!speraArray.count) {
                    pageModelWeak.currpage = @(before);
                }
                
                [selfWeak setupDataSource:speraArray More:more];
            }];
        }
            break;
        case ControllerTypeWithWorkingHours:
        {
            [PorscheRequestManager workHoursListWith:requestModel completion:^(NSArray<PorscheSchemeWorkHourModel *> * _Nullable workHourArray, NSError * _Nullable error) {
                
                [selfWeak endRefresh];
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showMessageText:@"服务器错误" toView:selfWeak.view anutoHidden:YES];
                    });
                    return ;
                };
                
                if (!workHourArray.count) {
                    pageModelWeak.currpage = @(before);
                }
                [selfWeak setupDataSource:workHourArray More:more];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)setupDataSource:(NSArray *)newDataSource More:(BOOL)more{

    switch (self.dataType) {
        case MaterialTimeDataSourceTypeFactory:
        {
            if (!more) [self.factorySource removeAllObjects];
            [self.factorySource addObjectsFromArray:newDataSource];
        }
            break;
        case MaterialTimeDataSourceTypeStore:
        {
            if (!more) [self.storeSource removeAllObjects];
            [self.storeSource addObjectsFromArray:newDataSource];
        }
            break;
        case MaterialTimeDataSourceTypeMy:
        {
            if (!more) [self.mySource removeAllObjects];
            [self.mySource addObjectsFromArray:newDataSource];
        }
            break;
        default:
            break;
    }
    [self resetDataSource];
    [self.topTableView reloadData];
    
    if (newDataSource.count < [HDStoreInfoManager shareManager].pagesize.integerValue) {
        [self.topTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.topTableView.mj_footer resetNoMoreData];
    }

}

#pragma mark - 去除方案收藏夹已有的数据源
- (NSArray *)deleteRepetitionScheme:(NSArray *)obj_array includeArray:(NSArray *)includeArray {
    
    NSMutableArray *loadSource = [[NSMutableArray alloc] initWithArray:obj_array];
    
    switch (self.type) {
        case ControllerTypeWithMaterial:
        {
            for (PorscheSchemeSpareModel *spareModel in includeArray) {
                
                spareModel.inFavorite = YES;
                [loadSource enumerateObjectsUsingBlock:^(PorscheSchemeSpareModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (obj.parts_id.integerValue == spareModel.parts_id.integerValue) {
                        [loadSource removeObject:obj];
                    }
                }];
            }

        }
            break;
        case ControllerTypeWithWorkingHours:
            
            for (PorscheSchemeWorkHourModel *workHourModel in includeArray) {
                
                workHourModel.inFavorite = YES;
                [loadSource enumerateObjectsUsingBlock:^(PorscheSchemeWorkHourModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (obj.workhourid.integerValue == workHourModel.workhourid.integerValue) {
                        [loadSource removeObject:obj];
                    }
                }];
            }

            break;
        default:
            break;
    }
    
    return loadSource;
}
- (void)resetDataSource {
    
    NSMutableArray *includeArray = [[NSMutableArray alloc] init];
    
    if (self.type == ControllerTypeWithMaterial) {
        for (PorscheSchemeSpareModel *spareModel in self.favoritSoruce) {
            
            if (spareModel.parts_type.integerValue == self.dataType) {
                [includeArray addObject:spareModel];
            }
        }
    } else if (self.type == ControllerTypeWithWorkingHours) {
        
        for (PorscheSchemeWorkHourModel *workHourModel in self.favoritSoruce) {
            
            if (workHourModel.workhourtype.integerValue == self.dataType) {
                [includeArray addObject:workHourModel];
            }
        }
    }
    
    [self.dataArray removeAllObjects];
    
    [self.dataArray addObjectsFromArray:includeArray];
    
    PorscheRequestSchemeListModel *requestModel = [PorscheRequestSchemeListModel shareModel];
    NSString *titleImageViewName;
    switch (self.dataType) {
        case MaterialTimeDataSourceTypeFactory:
        {
            [self.dataArray addObjectsFromArray:[self deleteRepetitionScheme:self.factorySource includeArray:includeArray]];
            titleImageViewName = @"materialtime_tablebar_factory";
            requestModel.schemetype = @(1);
        }break;
        case MaterialTimeDataSourceTypeStore:
        {
            [self.dataArray addObjectsFromArray:[self deleteRepetitionScheme:self.storeSource includeArray:includeArray]];
            titleImageViewName = @"materialtime_tablebar_store";
            requestModel.schemetype = @(2);
        }break;
        case MaterialTimeDataSourceTypeMy:
        {
            [self.dataArray addObjectsFromArray:[self deleteRepetitionScheme:self.mySource includeArray:includeArray]];
            titleImageViewName = @"materialtime_tablebar_my";
            requestModel.schemetype = @(3);
        }
            break;
        default:
            break;
    }
    self.topImageView.image = [UIImage imageNamed:titleImageViewName];

}

- (void)setDataType:(MaterialTimeDataSourceType)dataType {
    
    _dataType = dataType;
    
    [self resetDataSource];
    [self.topTableView reloadData];
    [self beginRefreshSource];
}

- (void)viewDidLayoutSubviews {
    
    self.hoursTitlebar.frame = CGRectMake(10, 45, self.view.bounds.size.width - 20, 30);
}

- (MaterialRightTimeTitleBar *)hoursTitlebar {
    
    if (!_hoursTitlebar) {
        _hoursTitlebar = [[MaterialRightTimeTitleBar alloc] initWithFrame:CGRectMake(10, 45, self.view.bounds.size.width - 20, 30)];
    }
    
    return _hoursTitlebar;
}

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)factorySource {
    
    if (!_factorySource) {
        _factorySource = [[NSMutableArray alloc] init];
     
    }
    return _factorySource;
}

- (NSMutableArray *)storeSource {
    
    if (!_storeSource) {
        _storeSource = [[NSMutableArray alloc] init];
       
    }
    return _storeSource;
}

- (NSMutableArray *)mySource {
    
    if (!_mySource) {
        _mySource = [[NSMutableArray alloc] init];
      
    }
    return _mySource;
}

- (NSMutableArray *)addSource {
    
    if (!_addSource) {
        _addSource = [[NSMutableArray alloc] init];
    }
    return _addSource;
}


-(void)cutScreenViewGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cupScreen:)];
    [self.cutScreenView addGestureRecognizer:pan];
}
-(void)cupScreen:(UIPanGestureRecognizer*)sender{
    CGPoint point = [sender locationInView:self.view];
    self.topViewHeightLayout.constant = point.y - CGRectGetMinY(_topTableView.frame);
    NSLog(@"%f",self.topViewHeightLayout.constant);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == _topTableView) {
        return self.dataArray.count;
    } else {
        
        return self.addSource.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellindentifier;
    cellindentifier = tableView == _topTableView ? @"MaterialRightTableViewTopCell" : @"MaterialRightTableViewBottomCell";
    
    switch (_type) {
        case ControllerTypeWithMaterial: //备案库cell
        {
            MaterialRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MaterialRightTableViewCell" owner:nil options:nil] firstObject];
            }
            PorscheSchemeSpareModel *model = nil;

            if (tableView == _topTableView) {
                cell.celltype = CellTypeWaiting;
                model =  self.dataArray[indexPath.section];
                cell.model = self.dataArray[indexPath.section];
                cell.cellSelected = [self containsModelWithID:cell.model.parts_id.integerValue];
                
            } else if (tableView == _bottomTableView) {
                cell.celltype = CellTypeSelected;
                model =  self.addSource[indexPath.section];
                cell.model = self.addSource[indexPath.section];
            }
            
            __weak typeof(self)weakself = self;
            __weak typeof(cell)weakcell = cell;
            cell.topBlock = ^ (BOOL topTableView) {
                NSIndexPath *indexpath = [tableView indexPathForCell:weakcell];

                if (topTableView) {
                    //NSLog(@"上面的cell选择，并改变颜色");
//                    PorscheSchemeSpareModel *model = model;
                    if (weakcell.cellSelected) {
                        [weakself popDeleteViewOntableView:tableView IndexPath:indexpath];
                    } else {
                        [weakself.addSource addObject:model];
                    }
                } else {
                    //NSLog(@"下面的cell，准备删除操作");
                   [weakself popDeleteViewOntableView:tableView IndexPath:indexpath];
                }
                [weakself refreshUI];
            };
            
            cell.longTapBlock = ^(){
                
//                PorscheSchemeSpareModel *model = weakself.dataArray[indexPath.section];
                [MaterialTaskTimeDetailsView showWithID:model.parts_id.integerValue detailType:MaterialTaskTimeDetailsTypeMaterial clickAction:^(DetailViewBackType backType,NSInteger detailId, id responderModel) {
                    
                    if (backType == DetailViewBackTypeJoinWorkOrder) {
                        
                        if (![weakself.addSource containsObject:model]) {
                            [weakself.addSource addObject:model];
                            [weakself refreshUI];
                        }
                    }
                    else if (backType == DetailViewBackTypeSaveToMyScheme)
                    {
                        [weakself myAction:_myButton];
                    }
                    else if (backType == DetailViewBackTypeDelete)
                    {
                        if ([weakself.addSource containsObject:model]) {
                            [weakself.addSource removeObject:model];
                            [weakself refreshUI];
                        }
                        weakself.dataType = weakself.dataType;
                    }
                }];
            };
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case ControllerTypeWithWorkingHours: //工时库cell
        {
            
            MaterialRightWorkHoursTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MaterialRightWorkHoursTableViewCell" owner:nil options:nil] firstObject];
            }
            PorscheSchemeWorkHourModel *model = nil;
            if (tableView == _topTableView) {
                cell.celltype = HoursCellTypeTop;
                model = self.dataArray[indexPath.section];
                cell.model = self.dataArray[indexPath.section];
                cell.cellSelected = [self containsModelWithID:cell.model.workhourid.integerValue];
            } else if (tableView == _bottomTableView) {
                cell.celltype = HoursCellTypeBottom;
                model = self.addSource[indexPath.section];
                cell.model = self.addSource[indexPath.section];
            }
            
            __weak typeof(self)weakself = self;
            __weak typeof(cell)weakcell = cell;
            cell.topBlock = ^ (BOOL topTableView) {
                
                if (topTableView) {
                    //NSLog(@"上面的cell选择，并改变颜色");
//                    PorscheSchemeSpareModel *model = weakself.dataArray[indexPath.section];
                    if (weakcell.cellSelected) {
                        [weakself popDeleteViewOntableView:tableView IndexPath:indexPath];
                    } else {
                        
                        [weakself.addSource addObject:model];
                    }
                } else {
                    [weakself popDeleteViewOntableView:tableView IndexPath:indexPath];
                    //NSLog(@"下面的cell，准备删除操作");
                }
                [weakself refreshUI];
            };
            
            cell.longTapBlock = ^(){
                
//                PorscheSchemeWorkHourModel *model = weakself.dataArray[indexPath.section];
                [MaterialTaskTimeDetailsView showWithID:model.workhourid.integerValue detailType:MaterialTaskTimeDetailsTypeWorkHours clickAction:^(DetailViewBackType backType,NSInteger detailId, id responderModel) {
                    if (backType == DetailViewBackTypeJoinWorkOrder) {
                        
                        if (![weakself.addSource containsObject:model]) {
                            [weakself.addSource addObject:model];
                            [weakself refreshUI];
                        }
                    }
                    else if (backType == DetailViewBackTypeSaveToMyScheme)
                    {
                        [weakself myAction:_myButton];
                    }
                }];
            };

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
            break;
            
        default:
            return [UITableViewCell new];
            break;
    }
   }

- (void)refreshUI {
    
    [self refreshTotalLabel];
    [self.topTableView reloadData];
    [self.bottomTableView reloadData];
}

- (BOOL)containsModelWithID:(NSInteger)modelid {
    
    BOOL contains = NO;
    switch (self.type) {
        case ControllerTypeWithMaterial:
        {
            for (PorscheSchemeSpareModel *model in self.addSource) {
                if (model.parts_id.integerValue == modelid) {
                    contains = YES;
                }
            }
        }
            break;
        case ControllerTypeWithWorkingHours:
        {
            for (PorscheSchemeWorkHourModel *model in self.addSource) {
                if (model.workhourid.integerValue == modelid) {
                    contains = YES;
                }
            }
        }
            break;
        default:
            break;
    }
    
    return contains;
}

- (void)removeModelWithID:(NSInteger)modelid {
    
    switch (self.type) {
        case ControllerTypeWithMaterial:
        {
            [self.addSource enumerateObjectsUsingBlock:^(PorscheSchemeSpareModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                if (model.parts_id.integerValue == modelid) {
                    [self.addSource removeObject:model];
                }
            }];
        }
            break;
        case ControllerTypeWithWorkingHours:
        {
            [self.addSource enumerateObjectsUsingBlock:^(PorscheSchemeWorkHourModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                if (model.workhourid.integerValue == modelid) {
                    [self.addSource removeObject:model];
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.bottomTableView) {
        return;
    }
    
    BOOL showDetail;
    switch (_type) {
        case ControllerTypeWithMaterial: //备案库cell
        {
            MaterialRightTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            showDetail = cell.cellSelected;
        }
            break;
        case ControllerTypeWithWorkingHours: //工时库cell
        {
            MaterialRightWorkHoursTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            showDetail = cell.cellSelected;
        }
            break;
            
        default:
            
            break;
        }

    PorscheSchemeSpareModel *model = self.dataArray[indexPath.section];
    if (showDetail) {
    
        [self popDeleteViewOntableView:tableView IndexPath:indexPath];
    } else {
        
        [self.addSource addObject:model];
        [self refreshTotalLabel];
        [self.topTableView reloadData];
        [self.bottomTableView reloadData];
    }
}

#pragma mark - 新建 备件/工时
- (IBAction)createItemAction:(id)sender {
    NSLog(@"新建");

    if (self.type == ControllerTypeWithMaterial)
    {
        if ([HDPermissionManager isNotThisPermission:HDOrder_GoSpacePartLibrary_Add])
        {
            return;
        }
    }
    else if(self.type == ControllerTypeWithWorkingHours)
    {
        if ([HDPermissionManager isNotThisPermission:HDOrder_GoTimeLibrary_Add])
        {
            return;
        }
    }
    
    MaterialTaskTimeDetailsType detailType = self.type == ControllerTypeWithMaterial ? MaterialTaskTimeDetailsTypeMaterial :MaterialTaskTimeDetailsTypeWorkHours;
    __weak typeof(self)weakself = self;
    [MaterialTaskTimeDetailsView showWithID:0 detailType:detailType clickAction:^(DetailViewBackType backType,NSInteger detailId, id responderModel) {
        
        if (backType == DetailViewBackTypeJoinWorkOrder) {
            
            NSInteger modelid = 0;
            if (self.type == ControllerTypeWithMaterial) {
                PorscheSchemeSpareModel *model = responderModel;
                modelid = model.parts_id.integerValue;
            } else if (self.type == ControllerTypeWithWorkingHours){
                PorscheSchemeWorkHourModel *model = responderModel;
                modelid = model.workhourid.integerValue;
            }
            if (![weakself containsModelWithID:modelid]) {
                [weakself.addSource addObject:responderModel];
                [weakself refreshUI];
            }
        }
        else if (backType == DetailViewBackTypeSaveToMyScheme)
        {
            NSInteger modelid = 0;
            if (self.type == ControllerTypeWithMaterial) {
                PorscheSchemeSpareModel *model = responderModel;
                modelid = model.parts_id.integerValue;
            } else if (self.type == ControllerTypeWithWorkingHours){
                PorscheSchemeWorkHourModel *model = responderModel;
                modelid = model.workhourid.integerValue;
            }
            if (![weakself containsModelWithID:modelid]) {
                [weakself.addSource addObject:responderModel];
                [weakself refreshUI];
            }
            [weakself myAction:_myButton];
        }

        NSLog(@"加入工单回调 %ld",detailId);
    }];
}

//取消返回
- (IBAction)backAction:(id)sender {
    NSLog(@"返回");
//    [[NSNotificationCenter defaultCenter] postNotificationName:BACK_FROM_MATERIAL_AND_ITEM_TIME_NOTIFINATION object:nil];
    [self backHelperActionIsCancel:YES];

    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

- (void)backHelperActionIsCancel:(BOOL)isCancel {
    NSNumber *sender = @2;
    NSArray *ids = [self getIDArray];
    NSDictionary *sendInfo = @{@"ids":ids,@"type":@(self.type)};
    if ([[HDLeftSingleton shareSingleton].rightVC isKindOfClass:[HDSlitViewRightViewController class]]) {//技师界面
        if (!isCancel) {
            HDSlitViewRightViewController *slitVC = (HDSlitViewRightViewController *)[HDLeftSingleton shareSingleton].rightVC;
            [slitVC materialBackToTechnianVC:sendInfo];
        }
        
    }else if ([[HDLeftSingleton shareSingleton].rightVC isKindOfClass:[HDServiceViewController class]]) {//服务顾问
        if (!isCancel) {
            HDServiceViewController *slitVC = (HDServiceViewController *)[HDLeftSingleton shareSingleton].rightVC;
            [slitVC materialBackToTechnianVC:sendInfo];
        }
    }else if ([[HDLeftSingleton shareSingleton].rightVC isKindOfClass:[HDRightMaterialDealViewController class]]) {//备件流程
        if (!isCancel) {
            HDRightMaterialDealViewController *slitVC = (HDRightMaterialDealViewController *)[HDLeftSingleton shareSingleton].rightVC;
            [slitVC materialBackToTechnianVC:sendInfo];
        }
        sender = @0;
    }
    
    [[HDLeftSingleton shareSingleton].leftTabBarVC changeBtAction:@{@"left":sender,@"right":@0}];
    [[HDLeftSingleton shareSingleton].HDRightViewController changeBackItemColor:nil];
}

//确定返回
- (IBAction)confirmAction:(id)sender {

//    NSArray *ids = [self getIDArray];
//    NSDictionary *sendInfo = @{@"ids":ids,@"type":@(self.type)};
//   [[NSNotificationCenter defaultCenter] postNotificationName:BACK_FROM_MATERIAL_AND_ITEM_TIME_NOTIFINATION object:sendInfo];
    [self backHelperActionIsCancel:NO];
   
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}


- (NSArray *)getIDArray {
    
    __block NSMutableArray *ids = [[NSMutableArray alloc] init];
    [self.addSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        switch (self.type) {
            case ControllerTypeWithMaterial:
            {
                PorscheSchemeSpareModel *model = obj;
                [ids addObject:model.parts_id];
                
            }
                break;
            case ControllerTypeWithWorkingHours:
            {
                PorscheSchemeWorkHourModel *model = obj;
                [ids addObject:model.workhourid];
            }
                break;
            default:
                break;
        }
    }];
    return ids;
}

- (void)popDeleteViewOntableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {

    if (!self.popDeleteView) {
        self.popDeleteView = [[HDPoperDeleteView alloc]initWithSize:DELETE_VIEW_SIZE];
        self.popDeleteView.poperVC.backgroundColor = [UIColor whiteColor];
    }
    self.popDeleteView.label.text = @"确定删除?";
    __weak typeof(self)weakself = self;
    self.popDeleteView.hDPoperDeleteViewBlock =^ (HDdeleteViewStyle style) {
        if (style == HDdeleteViewStyleSure) {
            id model;
            if (tableView == _topTableView) {
                model = weakself.dataArray[indexPath.section];
            } else if (tableView == _bottomTableView) {
                model = weakself.addSource[indexPath.section];
            }
            if (weakself.type == ControllerTypeWithMaterial) {
                PorscheSchemeSpareModel *spare = model;
                [weakself removeModelWithID:spare.parts_id.integerValue];
            } else {
                PorscheSchemeWorkHourModel *workHour = model;
                [weakself removeModelWithID:workHour.workhourid.integerValue];
            }
            [weakself refreshTotalLabel];
            [weakself.topTableView reloadData];
            [weakself.bottomTableView reloadData];
        }
        [weakself.popDeleteView.poperVC dismissPopoverAnimated:YES];
    };
    
    CGRect rectTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rect = [tableView convertRect:rectTableView toView:self.view];
    rect.origin.x = self.topTableView.bounds.size.width - 44;
    [self.popDeleteView.poperVC presentPopoverFromRect:rect inView:weakself.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];

    
//    MaterialRightTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    /*
    [HDPoperDeleteView showAlertViewAroundView:cell.changeBtn titleArr:@[@"确定取消",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
        
    } refuse:^{
        
    } cancel:^{
        
    }];
     */
}

- (void)refreshTotalLabel {
    
    CGFloat total = 0;

    switch (self.type) {
        case ControllerTypeWithMaterial:
        {
            for (PorscheSchemeSpareModel *model in self.addSource) {
                
                total += [model.price_after_tax floatValue];
            }
            _quantityLabel.text = [NSString stringWithFormat:@"已选%ld个备件",(long)self.addSource.count];

            _totalLabel.text = [NSString stringWithFormat:@"备件总计：%@",[NSString formatMoneyStringWithFloat:total]];
        }
            break;
        case ControllerTypeWithWorkingHours:
        {
            for (PorscheSchemeWorkHourModel *model in self.addSource) {
                total += [model.workhourpriceall floatValue];
            }
            _quantityLabel.text = [NSString stringWithFormat:@"已选%ld个工时",(long)self.addSource.count];
            _totalLabel.text = [NSString stringWithFormat:@"工时总计：%@",[NSString formatMoneyStringWithFloat:total]];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 切换数据源（厂方 本店 我的）
- (IBAction)factoryAction:(UIButton *)sender {
    
    self.dataType = MaterialTimeDataSourceTypeFactory;
    
    [self setTitleButtonColor:sender];
}
- (IBAction)storeAction:(UIButton *)sender {
    
    self.dataType = MaterialTimeDataSourceTypeStore;
    [self setTitleButtonColor:sender];
}
- (IBAction)myAction:(UIButton *)sender {
    
    self.dataType = MaterialTimeDataSourceTypeMy;
    [self setTitleButtonColor:sender];
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





- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"释放工时备件右侧页面");
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
