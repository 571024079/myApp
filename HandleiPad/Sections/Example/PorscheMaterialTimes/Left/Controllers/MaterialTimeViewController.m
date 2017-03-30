//
//  MaterialTimeViewController.m
//  MaterialDemo
//
//  Created by Robin on 16/9/28.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "MaterialTimeViewController.h"

#import "MaterialTimeGroupTableViewCell.h"
#import "MaterialTimeCarTypeTableViewCell.h"
#import "MateririalTimeLevelTableViewCell.h"
#import "MaterialWorkingTableViewCell.h" //带有collectionView的cell；
#import "HDWorkListTableViews.h" //车型选择框
#import "PorscheCustomModel.h" //车型选择模型
#import "MaterialTimeRangeTableViewCell.h"

#import "PorscheMultipleListhView.h"
#import "NSString+Line.h"
#import "HDLeftSingleton.h"

#define VIEW_WIDTH self.view.bounds.size.width

static NSString *const levelCell = @"materirialTimeLevelTableViewCell";
static NSString *const carTypeCell = @"materialTimeCarTypeTableViewCell";
static NSString *const mileageCell = @"materilaWorkingTableCell";
static NSString *const groupCell = @"materialTimeGroupTableViewCell";
static NSString *const favoriteCell = @"materilaWorkingTableCell";
static NSString *const mileageTimeCell = @"MaterialTimeRangeTableViewCell";

@interface MaterialTimeViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

// headerView
@property (nonatomic, strong) UIView *levelHeader;
@property (nonatomic, strong) UIView *carTypeHeader;
@property (nonatomic, strong) UIView *mileageHeader;
@property (nonatomic, strong) UIView *mainGroupHeader;
@property (nonatomic, strong) UIView *groupHeader;
@property (nonatomic, strong) UIView *serviceHeader;
@property (nonatomic, strong) UIView *favoriteHeader;

@property (nonatomic, assign) MaterialTaskTimeDetailsType detailType;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarHeightLayout;

@property (nonatomic, strong) HDWorkListTableViews *carListView; //车型选择列表
@property (nonatomic, strong) UIView *clearView;

@property (nonatomic, strong) PorscheRequestSchemeListModel *requestModel; //数据筛选model

@property (nonatomic, strong) NSArray *dateModelArray; //日期选择框


@end

@implementation MaterialTimeViewController {
    
    NSArray *_cellHeights;
    
    CGFloat _headerLabelToTop;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SCHEME_LEFT_SEARCH_NOTIFICATION object:nil];
    NSLog(@"方案/工时/备件库左侧控制器释放啦！~~~~~~~~~~~~~");
}
- (void)viewDidLayoutSubviews {
    
    _tableView.frame = _tableView.frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerNibs];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchBarHeightLayout.constant = self.detailType == MaterialTaskTimeDetailsTypeScheme ? 55 : 60;

    self.searchTextField.delegate = self;
    [self.searchTextField addTarget:self action:@selector(setSearchName:) forControlEvents:UIControlEventEditingChanged];
    
    [self setupConfig];
        
    self.navigationController.navigationBarHidden = YES;
    
    [self addNotification];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchNotification:) name:SCHEME_LEFT_SEARCH_NOTIFICATION object:nil];
}

- (void)searchNotification:(NSNotification *)obj {
    
    [self searchAction:nil];
}

- (void)setSearchName:(UITextField *)textField {
    
    [PorscheRequestSchemeListModel shareModel].schemename = textField.text;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
 
    self.requestModel = [PorscheRequestSchemeListModel shareModel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.requestModel = nil;
    self.view = nil;
    [PorscheRequestSchemeListModel tearDown];
}

- (void)setupConfig {
    
    switch (self.detailType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
            self.searchTextField.placeholder = @"搜索方案名称";
            NSArray *projectCellHeights = @[@60,@60,@60,@60,@56,@65,@157]; //级别 车型 时间公里 备件主 主子 业务 收藏
            _cellHeights = projectCellHeights;
        }
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            self.searchTextField.placeholder = @"备件名称/备件编号/图号搜索";
            NSArray *materialCellHeights = @[@90,@90,@0,@90,@0,@115,@155];
            _cellHeights = materialCellHeights;
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            self.searchTextField.placeholder = @"工时名称/编号搜索";
            NSArray *taskTimeCellHeights = @[@65,@65,@65,@0,@65,@115,@155];
            _cellHeights = taskTimeCellHeights;
        }
            break;
        default:
            break;
    }
    
    
}

- (NSArray *)dateModelArray {
    
    if (!_dateModelArray) {

        _dateModelArray = [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataInterval];
    }
        return _dateModelArray;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self searchAction:nil];
    return YES;
}

- (instancetype)initWithType:(MaterialTaskTimeDetailsType)detailType
{
    self = [super init];
    if (self) {
        _detailType = detailType;
    }
    return self;
}


- (void)registerNibs {
    
    [_tableView registerNib:[UINib nibWithNibName:@"MateririalTimeLevelTableViewCell" bundle:nil] forCellReuseIdentifier:levelCell];
    [_tableView registerNib:[UINib nibWithNibName:@"MaterialTimeCarTypeTableViewCell" bundle:nil] forCellReuseIdentifier:carTypeCell];
    [_tableView registerNib:[UINib nibWithNibName:@"MaterialWorkingTableViewCell" bundle:nil] forCellReuseIdentifier:mileageCell];
    [_tableView registerNib:[UINib nibWithNibName:@"MaterialTimeGroupTableViewCell" bundle:nil] forCellReuseIdentifier:groupCell];
    [_tableView registerNib:[UINib nibWithNibName:@"MaterialWorkingTableViewCell" bundle:nil] forCellReuseIdentifier:favoriteCell];
    [_tableView registerNib:[UINib nibWithNibName:@"MaterialTimeRangeTableViewCell" bundle:nil] forCellReuseIdentifier:mileageTimeCell];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _cellHeights.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = [_cellHeights[indexPath.section] floatValue];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return [_cellHeights[section] floatValue] == 0 ? 0.0001 : 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([_cellHeights[section] floatValue] == 0)  return nil;
    
    switch (section) {
        case 0:
            return self.levelHeader;
            break;
        case 1:
            return self.carTypeHeader;
            break;
        case 2:
            return self.mileageHeader;
            break;
        case 3:
            return self.mainGroupHeader;
            break;
        case 4:
            return self.groupHeader;
            break;
        case 5:
            return self.serviceHeader;
            break;
        case 6:
            return self.favoriteHeader;
            break;
        default:
            return [UIView new];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_cellHeights[indexPath.section] floatValue] == 0)  return [[UITableViewCell alloc] init];
    
    static NSString *indentifer;
    switch (indexPath.section) {
        case 0://按级别分类
        {
            indentifer = @"materilaWorkingTableCell";
            MaterialWorkingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer forIndexPath:indexPath];
            
            cell.cellType = MaterialWorkingTableViewCellTypeLevel;
            return cell;
        }
            
            break;
        case 1://车型分类
        {
            indentifer = carTypeCell;
            MaterialTimeCarTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer forIndexPath:indexPath];
            if ([PorscheRequestSchemeListModel shareModel].isClearSearchData) {
                cell.setupCar = NO;
                cell.mainCarTF.text = nil;
                cell.subCarTF.text = nil;
                cell.yearCarTF.text = nil;
            }else {
                cell.setupCar = YES;
            }
            return cell;
        }
            break;
        case 2://公里分类 时间范围
        {
            MaterialTimeRangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mileageTimeCell];
            WeakObject(cell)
            WeakObject(self);
            //17-02-04 czz 要求清空操作
            if (![[PorscheRequestSchemeListModel shareModel].beginmiles integerValue] && ![[PorscheRequestSchemeListModel shareModel].endmiles integerValue] && ![[PorscheRequestSchemeListModel shareModel].month integerValue]) {
                cell.firstMileageTF.text = @"0";
                cell.secondMileageTF.text = @"0";
                cell.timeRangeTF.text = @"服务时间";
            }
            cell.clickBlock = ^(UIView *senderView) {
                
                [selfWeak showListViewForView:senderView dataSource:self.dateModelArray direction:ListViewDirectionDown complete:^(PorscheConstantModel *constantModel) {
                   
                    [cellWeak refreshRequestSchemeMonth:constantModel];
                }];
                
            };
            
            return cell;
        }
            break;
        case 3://备件主组
        case 4: //组别分组
        {
            indentifer = groupCell;
            MaterialTimeGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer forIndexPath:indexPath];

            if (self.detailType == MaterialTaskTimeDetailsTypeScheme) {
                cell.cellType = indexPath.section == 3 ? self.detailType :MaterialTaskTimeDetailsTypeWorkHours;
                cell.mainGroupTF.placeholder = indexPath.section == 3 ? @"备件主组" : @"工时主组";
                cell.subGroupTF.placeholder = @"工时子组";
            } else {
                cell.cellType = self.detailType;
            }

            return cell;
        }
            break;
        case 5://业务分类
        {
            
            indentifer = mileageCell;
            MaterialWorkingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer forIndexPath:indexPath];
            
            cell.cellType = MaterialWorkingTableViewCellTypeService;
            return cell;
        }
            
            break;
        case 6://我的收藏夹
        {
            indentifer = favoriteCell;
            MaterialWorkingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer forIndexPath:indexPath];

            cell.cellType = MaterialWorkingTableViewCellTypeFavorite;
            cell.detailType = self.detailType;
            return cell;
        }
            break;
        default:
            
            return [UITableViewCell new];
            break;
    }
}

#pragma mark - 显示组选择器
- (void)showListViewForView:(UIView *)view dataSource:(NSArray *)dataSource direction:(ListViewDirection)direction complete:(void(^)(PorscheConstantModel *))complete{
    
    [PorscheMultipleListhView showSingleListViewFrom:view dataSource:dataSource selected:nil showArrow:NO showClearButton:NO direction:direction complete:^(PorscheConstantModel *constantModel, NSInteger idx) {
       
        complete (constantModel);
    }];
}

- (UIView *)clearView {
    
    if (!_clearView) {
        _clearView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _clearView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = _clearView.bounds;
        [btn addTarget:self action:@selector(closeCarListView) forControlEvents:UIControlEventTouchUpInside];
        [_clearView addSubview:btn];
    }
    return _clearView;
}

- (void)closeCarListView {

    [UIView animateWithDuration:0.2 animations:^{
        
        self.clearView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.clearView removeFromSuperview];
        self.clearView.alpha = 1.0;
    }];
}

- (HDWorkListTableViews *)carListView {
    
    if (!_carListView) {
        
        _carListView = [[HDWorkListTableViews alloc] initWithCustomFrame:CGRectZero];
    }
    
    return _carListView;
}

- (UIView *)levelHeader {
    
    if (!_levelHeader) {
        _levelHeader = [self getHeaderViewWith:@"按级别分类" subString:nil];
    }
    
    return _levelHeader;
}

- (UIView *)carTypeHeader {
    
    if (!_carTypeHeader) {
        _carTypeHeader = [self getHeaderViewWith:@"按车型分类" subString:nil];
    }
    return _carTypeHeader;
}

- (UIView *)mileageHeader {
    
    if (!_mileageHeader) {
        _mileageHeader = [self getHeaderViewWith:@"按公里数范围" subString:@"按时间范围"];
    }
    return _mileageHeader;
}

- (UIView *)mainGroupHeader {
    
    if (!_mainGroupHeader) {
        NSString *str;
        switch (self.detailType) {
            case MaterialTaskTimeDetailsTypeScheme:
                str = @"按备件主组分类";
                break;
            default:
                str = @"按组别分类";
                break;
        }

        _mainGroupHeader = [self getHeaderViewWith:str subString:nil];
    }
    return _mainGroupHeader;
}

- (UIView *)groupHeader {
    
    if (!_groupHeader) {
        NSString *str;
        switch (self.detailType) {
            case MaterialTaskTimeDetailsTypeScheme:
                str = @"按工时主组和子组分类";
                break;
            default:
                str = @"按组别分类";
                break;
        }
        _groupHeader = [self getHeaderViewWith:str subString:nil];
    }
    return _groupHeader;
}

- (UIView *)serviceHeader {
    
    if (!_serviceHeader) {
        _serviceHeader = [self getHeaderViewWith:@"按业务分类" subString:nil];
    }
    
    return _serviceHeader;
}

- (UIView *)favoriteHeader {
    
    if (!_favoriteHeader) {
        _favoriteHeader = [self getHeaderViewWith:@"我的收藏夹" subString:nil];
    }
    return _favoriteHeader;
}

- (UIView *)getHeaderViewWith:(NSString *)str subString:(NSString *)subStr{
    
    switch (self.detailType) {
        case MaterialTaskTimeDetailsTypeMaterial:
            _headerLabelToTop = 12;
            break;
            
        default:
            _headerLabelToTop = 5;
            break;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 20)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _headerLabelToTop, VIEW_WIDTH - 15, 20)];
    headerLabel.text = str;
    headerLabel.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
    headerLabel.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:headerLabel];
    
    if (subStr) {
        UILabel *header2Label = [[UILabel alloc] initWithFrame:CGRectMake(190 + 10, _headerLabelToTop, VIEW_WIDTH - 15, 20)];
        header2Label.text = subStr;
        header2Label.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
        header2Label.font = [UIFont systemFontOfSize:13];
        [headerView addSubview:header2Label];
    }
    
    if (self.detailType == MaterialTaskTimeDetailsTypeScheme && [str isEqualToString:@"我的收藏夹"]) {
        
        UIColor *addColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
        UIButton *craeteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        craeteBtn.frame = CGRectMake(100, _headerLabelToTop, 60, 20);
        craeteBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        UIImage *addImage = [[UIImage imageNamed:@"scheme_newfavorite"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [craeteBtn setImage:addImage forState:UIControlStateNormal];
        craeteBtn.imageEdgeInsets = UIEdgeInsetsMake(3, -5, 3, -3);
        craeteBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        craeteBtn.imageView.tintColor = addColor;

        NSAttributedString *title = [NSString addLineWithSting:@"新建"];
        [craeteBtn setAttributedTitle:title forState:UIControlStateNormal];
        [craeteBtn setTitleColor:addColor forState:UIControlStateNormal];
        [craeteBtn addTarget:self action:@selector(postNotificationForFavorite:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:craeteBtn];

    }
    return headerView;
}

- (void)postNotificationForFavorite:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_CREATENEWFAVORITE object:nil];
}

#pragma mark - 请求数据
- (IBAction)searchAction:(id)sender {
    
//    [_searchTextField resignFirstResponder];
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PORSCHE_LEFT_REQUEST_NOTIFICATION object:nil];
}
#pragma mark - 清空搜索
- (IBAction)clearButtonAction:(id)sender {
    NSLog(@"所有的搜索数据清空了!!!");
    _searchTextField.text = nil;
    
    NSNumber *schemetype = self.requestModel.schemetype;
    NSNumber *isunfinished = self.requestModel.isfromunfinished;
    
    self.requestModel = nil;
    [PorscheRequestSchemeListModel tearDown];
    self.requestModel = [PorscheRequestSchemeListModel shareModel];
    [PorscheRequestSchemeListModel shareModel].isClearSearchData = YES;
    if ([schemetype integerValue] > 0)
    {
        self.requestModel.schemetype = schemetype;
    }
    else if ([isunfinished integerValue])
    {
        self.requestModel.isfromunfinished = isunfinished;
    }
    
    [_tableView reloadData];
    [self searchAction:nil];
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
