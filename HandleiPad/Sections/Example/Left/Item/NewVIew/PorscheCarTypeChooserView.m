//
//  PorscheCarTypeChooserView.m
//  HandleiPad
//
//  Created by Handlecar on 2016/12/15.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheCarTypeChooserView.h"
#import "PorscheCustomModel.h"
#import "PorscheCartypeChooserCell.h"
#import "PorscheMultipleListhView.h"
#import "NSArray+PorscheCarTypeChooserView.h"

@interface PorscheCarTypeChooserView() <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *chooserView;
@property (weak, nonatomic) IBOutlet UITableView *carSeriesTableView;
@property (weak, nonatomic) IBOutlet UITableView *carTypeTableView;
@property (weak, nonatomic) IBOutlet UITableView *carYearTableView;
@property (weak, nonatomic) IBOutlet UITableView *carDispTableView;

@property (weak, nonatomic) IBOutlet UIView *carSeriesView;
@property (weak, nonatomic) IBOutlet UIView *carTypeView;
@property (weak, nonatomic) IBOutlet UIView *carYearView;
@property (weak, nonatomic) IBOutlet UIView *carDispView;

@property (nonatomic, strong) NSMutableArray *carSeriesTableViewSource; // 车系
@property (nonatomic, strong) NSMutableArray *carTypeTableViewSource;   // 车型
@property (nonatomic, strong) NSMutableArray *carYearTableViewSource;          // 年款
@property (nonatomic, strong) NSMutableArray *carDispTableViewSource;          // 排量



@property (weak, nonatomic) IBOutlet UIImageView *seriesBotoomArrow;
@property (weak, nonatomic) IBOutlet UIImageView *seriesUpArrow;
@property (weak, nonatomic) IBOutlet UIImageView *typeUpArrow;
@property (weak, nonatomic) IBOutlet UIImageView *typeBotoomArrow;
@property (weak, nonatomic) IBOutlet UIImageView *yearUpArrow;
@property (weak, nonatomic) IBOutlet UIImageView *yearBotoomArrow;
@property (weak, nonatomic) IBOutlet UIImageView *dispUpArrow;
@property (weak, nonatomic) IBOutlet UIImageView *dispBottomArrow;

@property (nonatomic, strong) NSArray *tableViews;

@property (nonatomic, strong) NSMutableArray *selectArray; // 选中保存数组
@property (nonatomic, strong) PorscheCarSeriesModel *currentCarInfo;  // 当前点击的车型信息

@property (nonatomic, strong) NSIndexPath *previousCarseriesIndexPath;
@property (nonatomic, strong) NSIndexPath *previousCartypeIndexPath;
@property (nonatomic, strong) NSIndexPath *previousYearIndexPath;
@property (nonatomic, strong) NSIndexPath *previousOutputIndexPath;

@property (nonatomic) BOOL isSelectAllCars;


@property (nonatomic, strong) UIButton *carsSelectAllButton;
@property (nonatomic, strong) UIButton *cartypeSelectAllButton;
@property (nonatomic, strong) UIButton *caryearsSelectAllButton;
@property (nonatomic, strong) UIButton *carsOutputAllButton;


@end

@implementation PorscheCarTypeChooserView
{
    
    NSArray *_nextSelecs;
    
    NSArray *_selecs;
    
    NSString *_lastTitle;
    
    UITableView *_lastTableView;
}

+ (instancetype)viewWithXib {
    
    PorscheCarTypeChooserView *chooser = [[[NSBundle mainBundle] loadNibNamed:@"PorscheCarTypeChooserView" owner:nil options:nil] lastObject];
    
    [chooser.carSeriesTableView registerNib:[UINib nibWithNibName:@"PorscheCartypeChooserCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"carSeriesTableView"];
    [chooser.carTypeTableView registerNib:[UINib nibWithNibName:@"PorscheCartypeChooserCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"carTypeTableView"];
    [chooser.carYearTableView registerNib:[UINib nibWithNibName:@"PorscheCartypeChooserCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"carYearTableView"];
    [chooser.carDispTableView registerNib:[UINib nibWithNibName:@"PorscheCartypeChooserCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"carDispTableView"];
    
    chooser.carSeriesTableView.tableFooterView = [UIView new];
    chooser.carTypeTableView.tableFooterView = [UIView new];
    chooser.carYearTableView.tableFooterView = [UIView new];
    chooser.carDispTableView.tableFooterView = [UIView new];
    [chooser getAllCarseries];
    return chooser;
}

- (NSMutableArray *)selectArray
{
    if (!_selectArray)
    {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

#pragma mark --  获取所有车系
- (void)getAllCarseries
{
    MBProgressHUD *hub = [MBProgressHUD showProgressMessage:nil toView:self];
    WeakObject(self);
    [PorscheRequestManager getAllCarSeriers:^(NSArray<PorscheCarSeriesModel *> * _Nonnull carseries, PResponseModel * _Nonnull responser) {
        [hub hideAnimated:YES];
        selfWeak.carSeriesTableViewSource = [NSMutableArray arrayWithArray:carseries];
        [selfWeak.carSeriesTableView reloadData];
    }];
}

#pragma mark -- 获取指定车系的车型列表

- (void)getAllCarTypeWithCarsmodel:(PorscheCarSeriesModel *)cars
{
    MBProgressHUD *hub = [MBProgressHUD showProgressMessage:nil toView:self];
    WeakObject(self);
    [PorscheRequestManager getAllCarTypeWithCarsPctid:cars.pctid completion:^(NSArray<PorscheConstantModel *> * _Nullable cartypes, PResponseModel * _Nullable responseModel) {
        [hub hideAnimated:YES];
        selfWeak.carTypeTableViewSource = [NSMutableArray arrayWithArray:cartypes];
        [selfWeak.carTypeTableView reloadData];
    }];
}

#pragma mark -- 获取指定车型的年款
- (void)getAllCarYearWithCartypemodel:(PorscheCarTypeModel *)cartype
{
    WeakObject(self);
    MBProgressHUD *hub = [MBProgressHUD showProgressMessage:nil toView:self];
    [PorscheRequestManager getAllCarYearWithCartypePctid:cartype.pctid completion:^(NSArray<PorscheCarYearModel *> * _Nullable caryears, PResponseModel * _Nullable responseModel) {
        [hub hideAnimated:YES];
        
        selfWeak.carYearTableViewSource = [NSMutableArray arrayWithArray:caryears];
        [selfWeak.carYearTableView reloadData];
    }];
}


#pragma mark --  获取指定年款的排量
- (void)getAllCarOutputWithCartyear:(PorscheCarYearModel *)caryear
{
    MBProgressHUD *hub = [MBProgressHUD showProgressMessage:nil toView:self];
    WeakObject(self);
    [PorscheRequestManager getAllCarOutputWithCaryearPctid:caryear.pctid completion:^(NSArray<PorscheCarOutputModel *> * _Nullable ouputs, PResponseModel * _Nullable responseModel) {
        [hub hideAnimated:YES];
        selfWeak.carDispTableViewSource = [NSMutableArray arrayWithArray:ouputs];
        [selfWeak.carDispTableView reloadData];
    }];
}



- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (NSArray *)tableViews {
    
    if (!_tableViews) {
        
        _tableViews = @[self.carSeriesTableView,self.carTypeTableView,self.carYearTableView,self.carDispTableView];
    }
    return _tableViews;
}

#pragma mark -- tableViewDelegate ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.carSeriesTableView) {
        return self.carSeriesTableViewSource.count;
    }
    if (tableView == self.carTypeTableView) {
        return self.carTypeTableViewSource.count;
    }
    if (tableView == self.carYearTableView) {
        return self.carYearTableViewSource.count;
    }
    if (tableView == self.carDispTableView) {
        return self.carDispTableViewSource.count;
    }
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier;
    PorscheCartypeChooserCell *cell;
    if (tableView == self.carSeriesTableView) {
        identifier = @"carSeriesTableView";
//        title = self.carSeriesTableViewSource[indexPath.row];
       cell = [self tableView:tableView carSeriesCellForRowAtIndexPath:indexPath identifier:identifier];
        
    }
    if (tableView == self.carTypeTableView) {
        identifier = @"carTypeTableView";
//        title = self.carTypeTableViewSource[indexPath.row];
        cell = [self tableView:tableView carTypeCellForRowAtIndexPath:indexPath identifier:identifier];
    }
    if (tableView == self.carYearTableView) {
        identifier = @"carYearTableView";
//        title = self.carYearTableViewSource[indexPath.row];
        cell = [self tableView:tableView carYearCellForRowAtIndexPath:indexPath identifier:identifier];
    }
    if (tableView == self.carDispTableView) {
        identifier = @"carDispTableView";
//        title = self.carDispTableViewSource[indexPath.row];
        cell = [self tableView:tableView carOutputCellForRowAtIndexPath:indexPath identifier:identifier];
    }
    
//    PorscheCartypeChooserCell *cell = [PorscheCartypeChooserCell cellWithTableView:tableView identifer:identifier];
//    cell.titleLabel.text = title;
    
    cell.multipleCell = self.multipleChoice;
    if (self.multipleChoice) { //多选
        [self multiSelectInTableView:tableView didSelectRowAtIndexPath:indexPath isRowload:YES loadCell:cell];
    }
    [self refreshArrow:tableView];
    return cell;
}

#pragma mark -- 配置车系cell ---
- (PorscheCartypeChooserCell *)tableView:(UITableView *)tableView carSeriesCellForRowAtIndexPath:(NSIndexPath *)indexPath identifier:(NSString *)identifier
{
    PorscheCarSeriesModel *carseries = [self.carSeriesTableViewSource objectAtIndex:indexPath.row];
    PorscheCartypeChooserCell *cell = [PorscheCartypeChooserCell cellWithTableView:tableView identifer:identifier];
    cell.titleLabel.text = carseries.cars;
    
    return cell;
}
#pragma mark -- 配置车型cell ---
- (PorscheCartypeChooserCell *)tableView:(UITableView *)tableView carTypeCellForRowAtIndexPath:(NSIndexPath *)indexPath identifier:(NSString *)identifier
{
    PorscheCarTypeModel *cartype = [self.carTypeTableViewSource objectAtIndex:indexPath.row];
    PorscheCartypeChooserCell *cell = [PorscheCartypeChooserCell cellWithTableView:tableView identifer:identifier];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@",cartype.cars, cartype.cartype];
    
    return cell;
}

#pragma mark -- 配置年款cell ---
- (PorscheCartypeChooserCell *)tableView:(UITableView *)tableView carYearCellForRowAtIndexPath:(NSIndexPath *)indexPath identifier:(NSString *)identifier
{
    PorscheCarYearModel *caryear = [self.carYearTableViewSource objectAtIndex:indexPath.row];
    PorscheCartypeChooserCell *cell = [PorscheCartypeChooserCell cellWithTableView:tableView identifer:identifier];
    cell.titleLabel.text = caryear.year;
    
    return cell;
}

#pragma mark -- 配置排量ell ---
- (PorscheCartypeChooserCell *)tableView:(UITableView *)tableView carOutputCellForRowAtIndexPath:(NSIndexPath *)indexPath identifier:(NSString *)identifier
{
    PorscheCarOutputModel *output = [self.carDispTableViewSource objectAtIndex:indexPath.row];
    PorscheCartypeChooserCell *cell = [PorscheCartypeChooserCell cellWithTableView:tableView identifer:identifier];
    cell.titleLabel.text = output.displacement;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.carSeriesTableView) {
        PorscheCarSeriesModel *carseries = [self.carSeriesTableViewSource objectAtIndex:indexPath.row];
        self.currentCarInfo = carseries;
        // 获取车型
        if (!self.multipleChoice)
        {
            [self getCartype];
            self.currentCarInfo.cartypeInfo = nil;
        }
        [self clearYears];
        [self clearOutput];
        self.previousCartypeIndexPath = nil;
        self.previousYearIndexPath = nil;
        self.previousOutputIndexPath = nil;
    }
    if (tableView == self.carTypeTableView) {
        PorscheCarTypeModel *cartype = [self.carTypeTableViewSource objectAtIndex:indexPath.row];
        self.currentCarInfo.cartypeInfo = cartype;
        
        if (!self.multipleChoice)
        {
            [self getCaryear];
            self.currentCarInfo.cartypeInfo.caryear = nil;
        }
        [self clearOutput];
        self.previousYearIndexPath = nil;
        self.previousOutputIndexPath = nil;
    }
    if (tableView == self.carYearTableView) {
        PorscheCarYearModel *caryear = [self.carYearTableViewSource objectAtIndex:indexPath.row];
        self.currentCarInfo.cartypeInfo.caryearInfo = caryear;
        
        if (!self.multipleChoice)
        {
            [self getOutput];
            self.currentCarInfo.cartypeInfo.caryearInfo.caroutputInfo = nil;
        }
        self.previousOutputIndexPath = nil;
    }
    if (tableView == self.carDispTableView) {
        PorscheCarOutputModel *output = [self.carDispTableViewSource objectAtIndex:indexPath.row];
        self.currentCarInfo.cartypeInfo.caryearInfo.caroutputInfo  = output;
    }
    
    if (self.multipleChoice) { //多选
        [self multiSelectInTableView:tableView didSelectRowAtIndexPath:indexPath isRowload:NO loadCell:nil];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.multipleChoice) {
        return nil;
    }
    UIView *HearderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    HearderView.backgroundColor = ColorHex(0xf2f1f1);

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@" 全部" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSString *imagename = nil;
    if (tableView == self.carSeriesTableView)
    {
        button.tag = 100;
        button.selected = self.isSelectAllCars;
        self.carsSelectAllButton = button;
    }
    else if (tableView == self.carTypeTableView)
    {
        button.tag = 101;
        button.selected = self.currentCarInfo.isSelectAllCartypes;
        self.cartypeSelectAllButton = button;
    }
    else if (tableView == self.carYearTableView)
    {
        button.tag = 102;
        button.selected = self.currentCarInfo.cartypeInfo.isSelectAllCaryears;
        self.caryearsSelectAllButton = button;
    }
    else if (tableView == self.carDispTableView)
    {
        button.tag = 103;
        button.selected = self.currentCarInfo.cartypeInfo.caryearInfo.isSelectAllCaroutputs;
        self.carsOutputAllButton = button;
    }
    imagename = [PorscheImageManager getTickImage:button.selected];

    [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];

    [button addTarget:self action:@selector(selectAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = CGRectMake(10, 0, CGRectGetWidth(HearderView.bounds) - 20, CGRectGetHeight(HearderView.bounds));
    [HearderView addSubview:button];
    
    return HearderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.multipleChoice) {
        return 0;
    }
    
    if (tableView == self.carSeriesTableView)
    {

    }
    else if (tableView == self.carTypeTableView)
    {
        if (!self.carTypeTableViewSource.count)
        {
            return 0;
        }
    }
    else if (tableView == self.carYearTableView)
    {
        if (!self.carYearTableViewSource.count)
        {
            return 0;
        }
    }
    else if (tableView == self.carDispTableView)
    {
        if (!self.carDispTableViewSource.count)
        {
            return 0;
        }
    }
    
    return 30;
}

- (void)getCartype
{
    [self getAllCarTypeWithCarsmodel:self.currentCarInfo];
}

- (void)getCaryear
{
    [self getAllCarYearWithCartypemodel:self.currentCarInfo.cartypeInfo];
}

- (void)getOutput
{
    PorscheCarYearModel *caryear = self.currentCarInfo.cartypeInfo.caryearInfo;
    [self getAllCarOutputWithCartyear:caryear];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UITableView *tableView = (UITableView *)scrollView;
    
    [self refreshArrow:tableView];
    
}

- (void)refreshArrow:(UITableView *)tableView {
    
    NSInteger topRow = [tableView.indexPathsForVisibleRows firstObject].row;
    NSInteger botoomRow = [tableView.indexPathsForVisibleRows lastObject].row;
    
    if (tableView == self.carSeriesTableView) {
        
        _seriesUpArrow.hidden = topRow==0;
        _seriesBotoomArrow.hidden = botoomRow == self.carSeriesTableViewSource.count - 1;
        
        if (self.carSeriesTableView.hidden) {
            _seriesUpArrow.hidden = YES;
            _seriesBotoomArrow.hidden = YES;
        }
        
    } else if (tableView == self.carTypeTableView) {
        
        _typeUpArrow.hidden = topRow==0;
        _typeBotoomArrow.hidden = botoomRow == self.carTypeTableViewSource.count - 1;
        if (self.carTypeTableView.hidden) {
            _typeUpArrow.hidden = YES;
            _typeBotoomArrow.hidden = YES;
        }
        
    } else if (tableView == self.carYearTableView) {
        
        _yearUpArrow.hidden = topRow==0;
        _yearBotoomArrow.hidden = botoomRow == self.carYearTableViewSource.count - 1;
        
        if (self.carYearTableView.hidden) {
            _yearUpArrow.hidden = YES;
            _yearBotoomArrow.hidden = YES;
        }
    } else if (tableView == self.carDispTableView) {
        
        _dispUpArrow.hidden = topRow==0;
        _dispBottomArrow.hidden = botoomRow == self.carDispTableViewSource.count - 1;
        
        if (self.carDispTableView.hidden) {
            _dispUpArrow.hidden = YES;
            _dispBottomArrow.hidden = YES;
        }
    }
}
- (IBAction)confirmAction:(id)sender {
    
    if (self.saveBlcok) {
        
        if (self.multipleChoice) {
//            NSMutableArray *selectItems = [self handleSelectItems];
            self.saveBlcok(self.selectArray);

        } else {
            if (self.currentCarInfo) {
                
                PorscheCarSeriesModel *carseries = [self currentSelectCarInfo];
                self.saveBlcok(@[carseries]);
            }
        }
        
    }
    [self removeFromSuperview];
}


// 单选处理
- (PorscheCarSeriesModel *)currentSelectCarInfo
{
    PorscheCarSeriesModel *carseries = self.currentCarInfo;
    
    if (self.currentCarInfo.cartypeInfo.caryearInfo)
    {
        PorscheCarYearModel *caryear = self.currentCarInfo.cartypeInfo.caryearInfo;
        carseries.cars = caryear.cars;
        carseries.carscode = caryear.pctcarsno;
        
        carseries.cartypeInfo.cartype = caryear.cartype;
        carseries.cartypeInfo.cartypecode = caryear.pctcartypeno;
        carseries.cartypeInfo.pctconfigure1 = caryear.pctconfigure1;
        
        
    }
    return carseries;
}

// 多选处理选择的车型车系信息
- (NSMutableArray *)handleSelectItems
{
    NSMutableArray *results = [NSMutableArray array];
    
    for (PorscheCarSeriesModel *carseries in self.selectArray)
    {
        PorscheCarSeriesModel *cloneCarseries = [[PorscheCarSeriesModel alloc] init];
        cloneCarseries.cars  = carseries.cars;
        cloneCarseries.carscode = carseries.carscode;
        
        //
        if (!carseries.selectCartypeArray.count)
        {
            [results addObject:cloneCarseries];
            continue;
        }
        
        for (PorscheCarTypeModel *cartype in carseries.selectCartypeArray)
        {
            // 如果当前车型没有年款 直接添加
            if (!cartype.selectCaryearArray.count)
            {
                [cloneCarseries.selectCartypeArray addObject:cartype];
                if (![results containsObject:cloneCarseries])
                {
                    [results addObject:cloneCarseries];
                    continue;
                }
            }
//            [results addObject:carseries];
            
            for (PorscheCarYearModel *caryear in cartype.selectCaryearArray)
            {
                
                PorscheCarSeriesModel *newCarSerier = [[PorscheCarSeriesModel alloc] init];
                /*
                 @property (nonatomic, copy) NSString *cartype;          // 车型
                 @property (nonatomic, copy) NSString *pctcartypeno;     // 车型code
                 @property (nonatomic, copy) NSString *pctconfigure1;    // 配置信息
                 @property (nonatomic, copy) NSString *pctcarsno;        // 车系code
                 @property (nonatomic, copy) NSString *cars;             // 车系
                 */
                newCarSerier.cars = caryear.cars;
                newCarSerier.carscode = caryear.pctcartypeno;
                
                PorscheCarTypeModel *newCartypeModel = [[PorscheCarTypeModel alloc] init];
                newCartypeModel.cartype = caryear.cartype;
                newCartypeModel.cartypecode = caryear.pctcartypeno;
                newCartypeModel.pctconfigure1 = caryear.pctconfigure1;
                
                [newCartypeModel.selectCaryearArray addObject:caryear];
                
                
                [newCarSerier.selectCartypeArray addObject:newCartypeModel];
                
                [results addObject:newCarSerier];
            }
        }
    }
    
    return results;
}

- (IBAction)cancleAction:(id)sender {
    
    [self removeFromSuperview];
}

- (IBAction)closeAction:(UIButton *)sender {
    [self removeFromSuperview];
    
}

// 清除车型
- (void)clearCartype
{
    [self.carTypeTableViewSource removeAllObjects];
    [self.carTypeTableView reloadData];
    self.previousCartypeIndexPath = nil;
    self.previousYearIndexPath = nil;
    self.previousOutputIndexPath = nil;
}

// 清除年款
- (void)clearYears
{
    [self.carYearTableViewSource removeAllObjects];
    [self.carYearTableView reloadData];
    self.previousYearIndexPath = nil;
    self.previousOutputIndexPath = nil;
}

// 清除排量
- (void)clearOutput
{
    [self.carDispTableViewSource removeAllObjects];
    [self.carDispTableView reloadData];
    self.previousOutputIndexPath = nil;
}

// 多选处理
- (void)multiSelectInTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath isRowload:(BOOL)isRowLoad loadCell:(PorscheCartypeChooserCell *)loadCell
{
    PorscheCartypeChooserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView == self.carSeriesTableView) {
        PorscheCarSeriesModel *carseries = [self.carSeriesTableViewSource objectAtIndex:indexPath.row];
        PorscheCarSeriesModel *containModel = [self.selectArray containCarseriesWithCars:carseries];
        if (!isRowLoad)
        {
            if (containModel)
            {
                if (self.previousCarseriesIndexPath !=nil && self.previousCarseriesIndexPath.row == indexPath.row)
                {
                    [self.selectArray removeObject:containModel];
                    self.isSelectAllCars = NO;
                    self.carsSelectAllButton.selected = self.isSelectAllCars;
                    [self.carsSelectAllButton setImage:[UIImage imageNamed:[PorscheImageManager getTickImage:self.isSelectAllCars]] forState:UIControlStateNormal];
                    [containModel clearSelectCartypeArray];
                    [self clearCartype];
                }
                else
                {
                    [self getCartype];
                    self.previousCarseriesIndexPath = indexPath;
                    return;
                }
            }
            else
            {
                [self.selectArray addObject:carseries];
                if (self.selectArray.count == self.carSeriesTableViewSource.count)
                {
                    self.isSelectAllCars = YES;
                }
                else
                {
                    self.isSelectAllCars = NO;
                }
                self.carsSelectAllButton.selected = self.isSelectAllCars;
                [self.carsSelectAllButton setImage:[UIImage imageNamed:[PorscheImageManager getTickImage:self.isSelectAllCars]] forState:UIControlStateNormal];

                [self getCartype];
            }
            cell.cellSelected = containModel ? NO : YES;
        }
        else
        {
            loadCell.cellSelected = containModel ? YES : NO;
        }
        self.previousCarseriesIndexPath = indexPath;
    }
    if (tableView == self.carTypeTableView) {
        PorscheCarTypeModel *cartype = [self.carTypeTableViewSource objectAtIndex:indexPath.row];
        PorscheCarSeriesModel *containModel = [self.selectArray containCarseriesWithCars:self.currentCarInfo];
        if (containModel)
        {
            PorscheCarTypeModel *containCartype = [containModel.selectCartypeArray containCartypeWithCartype:cartype];
            if (!isRowLoad)
            {
                if (containCartype)
                {
                    
                    if (self.previousCartypeIndexPath !=nil && self.previousCartypeIndexPath.row == indexPath.row)
                    {
                        [containModel.selectCartypeArray  removeObject:containCartype];
                        self.currentCarInfo.isSelectAllCartypes = NO;
                        self.cartypeSelectAllButton.selected =  self.currentCarInfo.isSelectAllCartypes;

                        [self.cartypeSelectAllButton
                         setImage:[UIImage imageNamed:[PorscheImageManager getTickImage:self.currentCarInfo.isSelectAllCartypes]]
                         forState:UIControlStateNormal];

                        [containCartype clearSelectCaryearArray];
                        [self clearYears];
                    }
                    else
                    {
                        [self getCaryear];
                        self.previousCartypeIndexPath = indexPath;
                        return;
                    }

                }
                else
                {
                    [containModel.selectCartypeArray addObject:cartype];
                    
                    if (containModel.selectCartypeArray.count == self.carTypeTableViewSource.count)
                    {
                        self.currentCarInfo.isSelectAllCartypes = YES;
                    }
                    else
                    {
                        self.currentCarInfo.isSelectAllCartypes = NO;
                    }
                    self.cartypeSelectAllButton.selected =  self.currentCarInfo.isSelectAllCartypes;
                    [self.cartypeSelectAllButton
                     setImage:[UIImage imageNamed:[PorscheImageManager getTickImage:self.currentCarInfo.isSelectAllCartypes]]
                     forState:UIControlStateNormal];
                    [self getCaryear];
                }
                cell.cellSelected = containCartype ? NO : YES;
                self.previousCartypeIndexPath = indexPath;
            }
            else
            {
                loadCell.cellSelected = containCartype ? YES : NO;
            }
        }
        else
        {
            NSLog(@"车型未找到");
        }
  
    }
    if (tableView == self.carYearTableView) {
        PorscheCarYearModel *caryear = [self.carYearTableViewSource objectAtIndex:indexPath.row];
        
        PorscheCarSeriesModel *containModel = [self.selectArray containCarseriesWithCars:self.currentCarInfo];
        if (containModel)
        {
            PorscheCarTypeModel *containCartype = [containModel.selectCartypeArray containCartypeWithCartype:self.currentCarInfo.cartypeInfo];
            if (containCartype)
            {
                PorscheCarYearModel *containYear = [containCartype.selectCaryearArray containCaryearWithYear:caryear];
                if (!isRowLoad)
                {
                    if (containYear)
                    {
                        
                        if (self.previousYearIndexPath !=nil && self.previousYearIndexPath.row == indexPath.row)
                        {
                            
                            [containCartype.selectCaryearArray removeObject:containYear];
                            self.currentCarInfo.cartypeInfo.isSelectAllCaryears = NO;
                            self.caryearsSelectAllButton.selected = self.currentCarInfo.cartypeInfo.isSelectAllCaryears;

                            [self.caryearsSelectAllButton
                             setImage:[UIImage imageNamed:[PorscheImageManager getTickImage:self.currentCarInfo.cartypeInfo.isSelectAllCaryears]]
                             forState:UIControlStateNormal];
                            [containYear clearSelectCaroutputArray];
                            [self clearOutput];
                        }
                        else
                        {
                            self.previousYearIndexPath = indexPath;
                            [self getOutput];
                            return;
                        }
                        

                    }
                    else
                    {
                        [containCartype.selectCaryearArray addObject:caryear];
                        if (containCartype.selectCaryearArray.count == self.carYearTableViewSource.count)
                        {
                            self.currentCarInfo.cartypeInfo.isSelectAllCaryears = YES;
                        }
                        else
                        {
                            self.currentCarInfo.cartypeInfo.isSelectAllCaryears = NO;
                        }
                        self.caryearsSelectAllButton.selected = self.currentCarInfo.cartypeInfo.isSelectAllCaryears;
                        [self.caryearsSelectAllButton
                         setImage:[UIImage imageNamed:[PorscheImageManager getTickImage:self.currentCarInfo.cartypeInfo.isSelectAllCaryears]]
                         forState:UIControlStateNormal];
                        [self getOutput];
                    }
                    cell.cellSelected = containYear ? NO : YES;
                    
                    self.previousYearIndexPath = indexPath;
                }
                else
                {
                    loadCell.cellSelected = containYear ? YES : NO;
                }
            }
            else
            {
                NSLog(@"车型未找到");
            }
        }
        else
        {
            NSLog(@"车系未找到");
        }

    }
    if (tableView == self.carDispTableView) {
        PorscheCarOutputModel *output = [self.carDispTableViewSource objectAtIndex:indexPath.row];
        PorscheCarSeriesModel *containModel = [self.selectArray containCarseriesWithCars:self.currentCarInfo];
        if (containModel)
        {
            PorscheCarTypeModel *containCartype = [containModel.selectCartypeArray containCartypeWithCartype:self.currentCarInfo.cartypeInfo];
            if (containCartype)
            {
                PorscheCarYearModel *containYear = [containCartype.selectCaryearArray containCaryearWithYear:self.currentCarInfo.cartypeInfo.caryearInfo];
                if (containYear)
                {
                    PorscheCarOutputModel *containOutput = [containYear.selectCaroutputArray containCaroutputWithDisplacement:output];
                    if (!isRowLoad)
                    {
                        if (containOutput)
                        {
                            
                            if (self.previousOutputIndexPath !=nil && self.previousOutputIndexPath.row == indexPath.row)
                            {
                                [containYear.selectCaroutputArray removeObject:containOutput];
                                self.currentCarInfo.cartypeInfo.caryearInfo.isSelectAllCaroutputs = NO;
                                self.carsOutputAllButton.selected = self.currentCarInfo.cartypeInfo.caryearInfo.isSelectAllCaroutputs;
                                [self.carsOutputAllButton
                                 setImage:[UIImage imageNamed:[PorscheImageManager getTickImage:self.currentCarInfo.cartypeInfo.caryearInfo.isSelectAllCaroutputs]]
                                 forState:UIControlStateNormal];
                            }
                            else
                            {
                                self.previousOutputIndexPath = indexPath;
                                return;
                            }
                            
                        }
                        else
                        {
                            [containYear.selectCaroutputArray addObject:output];
                            if (containYear.selectCaroutputArray.count == self.carDispTableViewSource.count)
                            {
                                self.currentCarInfo.cartypeInfo.caryearInfo.isSelectAllCaroutputs = YES;
                            }
                            else
                            {
                                self.currentCarInfo.cartypeInfo.caryearInfo.isSelectAllCaroutputs = NO;
                            }
                            self.carsOutputAllButton.selected = self.currentCarInfo.cartypeInfo.caryearInfo.isSelectAllCaroutputs;

                            [self.carsOutputAllButton
                             setImage:[UIImage imageNamed:[PorscheImageManager getTickImage:self.currentCarInfo.cartypeInfo.caryearInfo.isSelectAllCaroutputs]]
                             forState:UIControlStateNormal];
                        }
                        cell.cellSelected = containOutput ? NO : YES;
                        self.previousOutputIndexPath = indexPath;
                    }
                    else
                    {
                        loadCell.cellSelected = containOutput ? YES : NO;
                    }
   
                }
                else
                {
                    NSLog(@"年款未找到");
                }
            }
            else
            {
                NSLog(@"车型未找到");
            }
        }
        else
        {
            NSLog(@"车系未找到");
        }
        
    }

}

#pragma mark - 全选事件

- (void)selectAllButtonAction:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    NSString *imagename = [PorscheImageManager getTickImage:button.selected];
    [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    
    switch (button.tag) {
        case 100: // 车系
        {
            self.isSelectAllCars = button.isSelected;
            
            if (button.isSelected)
            {
                [self.selectArray removeAllObjects];
                [self.selectArray addObjectsFromArray:self.carSeriesTableViewSource];
                [self.carTypeTableViewSource removeAllObjects];
                self.previousCarseriesIndexPath = nil;
            }
            else
            {
                [self.selectArray removeAllObjects];
            }
            [self.carSeriesTableView reloadData];
            [self.carTypeTableView reloadData];
            [self.carYearTableView reloadData];
            [self.carDispTableView reloadData];
        }
            break;
        case 101: // 车型
        {
            self.currentCarInfo.isSelectAllCartypes = button.isSelected;
            
            if (button.isSelected)
            {
                [self.currentCarInfo.selectCartypeArray removeAllObjects];
                [self.currentCarInfo.selectCartypeArray addObjectsFromArray:self.carTypeTableViewSource];
                [self.carYearTableViewSource removeAllObjects];
                self.previousCartypeIndexPath = nil;
            }
            else
            {
                [self.currentCarInfo.selectCartypeArray removeAllObjects];
            }
            [self.carTypeTableView reloadData];
            [self.carYearTableView reloadData];
            [self.carDispTableView reloadData];
        }
            break;
        case 102: // 年款
        {
            self.currentCarInfo.cartypeInfo.isSelectAllCaryears = button.isSelected;
            if (button.isSelected)
            {
                [self.currentCarInfo.cartypeInfo.selectCaryearArray removeAllObjects];
                [self.currentCarInfo.cartypeInfo.selectCaryearArray addObjectsFromArray:self.carYearTableViewSource];
                [self.carDispTableViewSource removeAllObjects];
                self.previousYearIndexPath = nil;
            }
            else
            {
                [self.currentCarInfo.cartypeInfo.selectCaryearArray removeAllObjects];
            }
            [self.carYearTableView reloadData];
            [self.carDispTableView reloadData];
        }
            break;
        case 103:
        {
            self.currentCarInfo.cartypeInfo.caryearInfo.isSelectAllCaroutputs = button.isSelected;
            if (button.isSelected)
            {
                [self.currentCarInfo.cartypeInfo.caryearInfo.selectCaroutputArray removeAllObjects];
                [self.currentCarInfo.cartypeInfo.caryearInfo.selectCaroutputArray addObjectsFromArray:self.carDispTableViewSource];
                self.previousOutputIndexPath = nil;
            }
            else
            {
                [self.currentCarInfo.cartypeInfo.caryearInfo.selectCaroutputArray removeAllObjects];
            }
            [self.carDispTableView reloadData];
        }
            break;

        default:
            break;
    }
}

@end
