//
//  ProjectDetailPlanTableViewCell.m
//  HandleiPad
//
//  Created by Robin on 2016/10/16.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ProjectDetailPlanTableViewCell.h"
#import "HDWorkListCollectionViewCell.h"
#import "ProjectDetailPlanSubCollectionModel.h"
#import "ProjectDetailPlanSubCollectionAddCell.h"
#import "HDWorkListTableViews.h"
#import "PorscheCustomView.h"
#import "HDPoperDeleteView.h"
//选择框
#import "PorscheMultipleListhView.h"

@interface ProjectDetailPlanTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//添加方案分类
@property (nonatomic, strong) NSMutableArray *dataSource;

//分类背景图字典
//@property (nonatomic, strong) NSMutableDictionary *picDic;
//车方案数组
//@property (nonatomic, strong) NSMutableArray *carPlans;

//分类

@property (weak, nonatomic) IBOutlet UILabel *typelabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

//右侧右箭头
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (nonatomic, strong) HDWorkListTableViews *planListView;

@property (nonatomic, strong) HDPoperDeleteView *popDeleteView;


@property (nonatomic, strong) PorscheSperaModel *speraModel;

@property (nonatomic, strong) PorscheWorkHoursModel *workHourModel;

@property (nonatomic, strong) PorscheSchemeModel *schemeModel;

@property (nonatomic, strong) PorscheConstantModel *leveModel;
@property (nonatomic, strong) PorscheConstantModel *groupModel;
@property (nonatomic, strong) NSMutableArray *favoriteArray;
@property (nonatomic, strong) NSMutableArray *businessArray;

//业务常量
@property (nonatomic, strong) NSArray <PorscheConstantModel *>*businessConstants;
//级别常量
@property (nonatomic, strong) NSArray <PorscheConstantModel *>*levelConstants;
//备件组别
@property (nonatomic, strong) NSArray <PorscheConstantModel *>*spareGroupConstants;
//工时组别
@property (nonatomic, strong) NSArray <PorscheConstantModel *>*workgroupConstants;
//收藏夹数据
@property (nonatomic, strong) NSArray <PorscheConstantModel *> *favoritesList;

@end
@implementation ProjectDetailPlanTableViewCell

#pragma mark - 获取常量
- (NSArray <PorscheConstantModel *>*)businessConstants {
    
    return [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataBusinesstype];
}

- (NSArray<PorscheConstantModel *> *)levelConstants {
    
    return [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataSchemeLevel];
}

- (NSArray<PorscheConstantModel *> *)spareGroupConstants {
    
    return [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataPartsGroup];
}

- (NSArray<PorscheConstantModel *> *)workgroupConstants {
    
    return [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataWorkHourk];
}

- (NSArray<PorscheConstantModel *> *)getConstantWithType:(PorscheConstantModelType)constantType {
    
    switch (constantType) {
        case PorscheConstantModelTypeCoreDataBusinesstype:
            return self.businessConstants;
            break;
        case PorscheConstantModelTypeCoreDataSchemeLevel:
            return self.levelConstants;
            break;
        case PorscheConstantModelTypeCoreDataPartsGroup:
            return self.spareGroupConstants;
            break;
        case PorscheConstantModelTypeCoreDataWorkHourk:
            return self.workgroupConstants;
            break;
        case PorscheConstantModelTypeCoreDataFavorite:
            return self.favoritesList;
            break;
        default:
            return nil;
            break;
    }
}

- (void)setSperaModel:(PorscheSperaModel *)speraModel {
    _speraModel = speraModel;
    
    //显示常备件
    if (speraModel.parts.parts_stock_type.integerValue == 1) {
        self.secondImageView.hidden = NO;
        self.secondLabel.hidden = NO;
    }
}

#pragma mark -
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.alwaysBounceHorizontal = YES;
}
#pragma mark - 初始化
- (void)setupConfig {
    
    switch (self.cellType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
            self.typelabel.text = @"方案分类：";
            NSInteger schemeType = self.schemeModel.schemetype.integerValue; //方案类型【1：厂方 2：本店;3 自定义方案】

            switch (schemeType) {
                case 1:
                    self.firstLabel.text = @"厂方方案";
                    self.firstImageView.image = [UIImage imageNamed:@"materialtime_detail_factory"];
                    break;
                case 2:
                    self.firstLabel.text = @"本店方案";
                    self.firstImageView.image = [UIImage imageNamed:@"materialtime_detail_store"];
                    break;
                case 3:
                    self.firstLabel.text = @"我的方案";
                    self.firstImageView.image = [UIImage imageNamed:@"materialtime_detail_my"];
                    break;
                default:
                    self.firstLabel.text = [NSString stringWithFormat:@"类型%ld",self.schemeModel.schemetype.integerValue];
                    break;
            }
        }
            break;
            
        case MaterialTaskTimeDetailsTypeMaterial: //备件
        {
            self.typelabel.text = @"备件分类";
            switch (self.speraModel.parts.parts_type.integerValue) { //备件类型（1：厂方 2：本地 3 : 我的）
                case 1:
                    self.firstLabel.text = @"厂方备件";
                    self.firstImageView.image = [UIImage imageNamed:@"materialtime_detail_factory"];
                    break;
                case 2:
                    self.firstLabel.text = @"本店备件";
                    self.firstImageView.image = [UIImage imageNamed:@"materialtime_detail_store"];
                    break;
                case 3:
                    self.firstLabel.text = @"我的备件";
                    self.firstImageView.image = [UIImage imageNamed:@"materialtime_detail_my"];
                    break;
                case 99:
                    self.firstLabel.text = @"新建";
                    self.firstImageView.image = [UIImage imageNamed:@"materialtime_detail_my"];
                    break;
                default:
                    self.firstLabel.text = [NSString stringWithFormat:@"类型%ld",self.speraModel.parts.parts_type.integerValue];
                    break;
            }

        }
            break;
            
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            self.typelabel.text = @"工时分类";
            switch (self.workHourModel.workhour.workhourtype.integerValue) { //备件类型（1：厂方 2：本地 3 : 我的）
                case 1:
                    self.firstLabel.text = @"厂方工时";
                    self.firstImageView.image = [UIImage imageNamed:@"materialtime_detail_factory"];
                    break;
                case 2:
                    self.firstLabel.text = @"本店工时";
                    self.firstImageView.image = [UIImage imageNamed:@"materialtime_detail_store"];
                    break;
                case 3:
                    self.firstLabel.text = @"我的工时";
                    self.firstImageView.image = [UIImage imageNamed:@"materialtime_detail_my"];
                    break;
                case 99:
                    self.firstLabel.text = @"新建";
                    self.firstImageView.image = [UIImage imageNamed:@"materialtime_detail_my"];
                    break;
                default:
                    self.firstLabel.text = [NSString stringWithFormat:@"类型%ld",self.workHourModel.workhour.workhourtype.integerValue];
                    break;
            }
        }
            break;
        default:
            break;
    }
}
- (void)reloadMoreButton {
    
    if (_dataSource.count > 4) {
        self.moreButton.hidden = NO;
    } else {
        self.moreButton.hidden = YES;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifer = @"ProjectDetailPlanTableViewCell";
    ProjectDetailPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectDetailPlanTableViewCell" owner:nil options:nil] firstObject];
    }
    [cell setupConfig];
    return cell;
}

+ (instancetype)speraCellWithTableView:(UITableView *)tableView withSperaModel:(PorscheSperaModel *)speraModel {
    
    static NSString *identifer = @"ProjectDetailPlanTableViewCell";
    ProjectDetailPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectDetailPlanTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.speraModel = speraModel;
    cell.cellType = MaterialTaskTimeDetailsTypeMaterial;
    [cell setupConfig];
    return cell;
}

+ (instancetype)workHourCellWithTableView:(UITableView *)tableView withWorkHourModel:(PorscheWorkHoursModel *)workHourModel {
    
    static NSString *identifer = @"ProjectDetailPlanTableViewCell";
    ProjectDetailPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectDetailPlanTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.workHourModel = workHourModel;
    cell.cellType = MaterialTaskTimeDetailsTypeWorkHours;
    [cell setupConfig];
    return cell;
}

+ (instancetype)schemeCellWithTableView:(UITableView *)tableView withSchemeModel:(PorscheSchemeModel *)schemeModel {
    
    static NSString *identifer = @"ProjectDetailPlanTableViewCell";
    ProjectDetailPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectDetailPlanTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.schemeModel = schemeModel;
    cell.cellType = MaterialTaskTimeDetailsTypeScheme;
    [cell setupConfig];
    return cell;
}

- (void)setEditCell:(BOOL)editCell {
    _editCell = editCell;
    
    [self reloadMoreButton];
    
    [self.collectionView reloadData];
}

- (void)setCellType:(MaterialTaskTimeDetailsType)cellType {
    
    _cellType = cellType;
    
    [self reloadMoreButton];
}

- (NSMutableArray *)dataSource {
    
    _dataSource = [[NSMutableArray alloc] initWithArray:self.businessArray];
        switch (_cellType) {
            case MaterialTaskTimeDetailsTypeMaterial: //备件
                [_dataSource addObject:self.leveModel]; //级别
                [_dataSource addObject:self.groupModel]; //组别
                break;
            case MaterialTaskTimeDetailsTypeScheme:
                [_dataSource addObject:self.leveModel]; //级别
                [_dataSource addObjectsFromArray:self.favoriteArray]; //收藏夹
                break;
            case MaterialTaskTimeDetailsTypeWorkHours:
                [_dataSource addObject:self.groupModel]; //组别
                break;
            default:
                break;
    }
    
    self.moreButton.hidden = _dataSource.count <= 4;
    return _dataSource;
}

#pragma mark - 组别model
- (PorscheConstantModel *)groupModel {
    
    PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
//    model.title = @"组别";
    switch (self.cellType) {

        case MaterialTaskTimeDetailsTypeMaterial:
        {
            model.constantType = PorscheConstantModelTypeCoreDataPartsGroup;
            model.cvsubid = self.speraModel.parts.group_id;
            model.cvvaluedesc = self.speraModel.parts.group_name ? self.speraModel.parts.group_name : @"";
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            model.constantType = PorscheConstantModelTypeCoreDataWorkHourk;
            model.cvsubid = (id)self.workHourModel.workhour.workhourgroupfuid;// 主组id 字符串类型
            model.cvvaluedesc = [NSString stringWithFormat:@"%@\n%@",self.workHourModel.workhour.workhourgroupfuname ? self.workHourModel.workhour.workhourgroupfuname : @"",self.workHourModel.workhour.workhourgroupname ? self.workHourModel.workhour.workhourgroupname : @""];
            
        }
            break;
        default:
            break;
    }
    return model;
}

#pragma mark - 级别model
- (PorscheConstantModel *)leveModel {
    
    PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
//    model.title = @"级别";
    model.constantType = PorscheConstantModelTypeCoreDataSchemeLevel; //级别类型
    switch (self.cellType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
            model.cvsubid = self.schemeModel.schemelevelid;
            model.cvvaluedesc = self.schemeModel.schemelevelname ? self.schemeModel.schemelevelname : @"";
        }
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            model.cvsubid = self.speraModel.parts.parts_level;
            model.cvvaluedesc = self.speraModel.parts.levelname ? self.speraModel.parts.levelname : @"";
            
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            model.cvsubid = self.workHourModel.workhour.workhourlevel;
            model.cvvaluedesc = self.workHourModel.workhour.workhourlevelname ? self.workHourModel.workhour.workhourlevelname : @"";
            
        }
            break;
        default:
            break;
    }
    
    return model;
}

#pragma mark - 收藏夹数组
- (NSMutableArray *)favoriteArray {

    NSMutableArray *favorites = [[NSMutableArray alloc] init];
    for (PorscheSchemeFavoriteModel *favoriteModel in self.schemeModel.favoritelist) {
        PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
//        model.title = @"收藏夹";
        model.constantType = PorscheConstantModelTypeCoreDataFavorite;
        model.cvvaluedesc = favoriteModel.favoritename;
        model.cvsubid = favoriteModel.favoriteid;
        [favorites addObject:model];
    }
    
    return favorites;
}
- (NSArray<PorscheConstantModel *> *)favoritesList {
    
    if (!_favoritesList) {
        
        MBProgressHUD *hub = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
        WeakObject(hub);
        [self loadFavoritesListSuccess:^(PResponseModel * _Nonnull responser) {
            
            if (responser.status == 100) {
                [hubWeak hideAnimated:YES];
            } else {
               [hubWeak changeTextModeMessage:responser.msg toView:KEY_WINDOW];
            }
        }];
    }
    return _favoritesList;
}

#pragma mark - -------- 获取我的方案夹列表和名称
- (void)loadFavoritesListSuccess:(void(^)(PResponseModel * _Nonnull responser))loadFavoriteSuccess {
    WeakObject(self)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [PorscheRequestManager myFavoriteslistWithParams:param completion:^(NSMutableArray * _Nonnull favoritesList, PResponseModel * _Nonnull responser) {
        if (favoritesList.count) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [favoritesList enumerateObjectsUsingBlock:^(PorscheSchemeFavoriteModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                PorscheConstantModel *favoriteModel = [[PorscheConstantModel alloc] init];
                favoriteModel.cvsubid = obj.favoriteid;
                favoriteModel.cvvaluedesc = obj.favoritename;
                favoriteModel.constantType = PorscheConstantModelTypeCoreDataFavorite;
                [arr addObject:favoriteModel];
            }];
            selfWeak.favoritesList = arr;
        }
        if (loadFavoriteSuccess) {
            loadFavoriteSuccess(responser);
        }
    }];
}

#pragma mark - 业务数组
- (NSMutableArray *)businessArray {
    
    
    NSArray *busniessArray;
    switch (self.cellType) {
        case MaterialTaskTimeDetailsTypeScheme:
            busniessArray = self.schemeModel.typelist;
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
            busniessArray = self.speraModel.business;
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
            busniessArray = self.workHourModel.business;
            break;
        default:
            break;
    }
    NSMutableArray *businessArr = [[NSMutableArray alloc] init];
    for (PorscheBusinessModel *businessModel in busniessArray) {
        PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
        
        model.cvsubid = businessModel.businesstypeid;
        model.cvvaluedesc = businessModel.businesstypename;
        model.constantType = PorscheConstantModelTypeCoreDataBusinesstype;
        
        [businessArr addObject:model];
    }
    
    //如果没有业务 需要自己造一个新增默认的
    if (businessArr.count == 0) {
        
        PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
        model.cvsubid = @(0);
        model.cvvaluedesc = @"+新增";
        model.constantType = PorscheConstantModelTypeCoreDataBusinesstype;
        
        [businessArr addObject:model];
    }
    return businessArr;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //固定值，和整个弹窗的宽高相关  collectionView宽度四分
//    return CGSizeMake((HD_WIDTH - 570) / 4 - 20, (HD_WIDTH - 570) / 4 - 20);

    return CGSizeMake(100, 100);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 30;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 30;
}

- (BOOL)setupPermissionWithConstant:(PorscheConstantModel *)constantModel {
    
    if (self.newObject) return YES;
    
    switch (constantModel.constantType) {
            
        case PorscheConstantModelTypeCoreDataSchemeLevel: //级别
        {
            switch (self.cellType) {
                case MaterialTaskTimeDetailsTypeScheme:
                    return _isFromNotice ? [HDPermissionManager isHasThisPermission:HDTaskNotice_MyShopNotice_Edit isNeedShowMessage:NO] :[HDPermissionManager isHasThisPermission:HDOrder_GoSchemeLibrary_EditProperty isNeedShowMessage:NO];
                    break;
                case MaterialTaskTimeDetailsTypeMaterial:
                    return [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_EditProperty isNeedShowMessage:NO];
                    break;
                default:
                    return NO;
                    break;
            }
        }
            break;
        case PorscheConstantModelTypeCoreDataBusinesstype: //业务
        {
            switch (self.cellType) {
                case MaterialTaskTimeDetailsTypeScheme:
                    return _isFromNotice ? [HDPermissionManager isHasThisPermission:HDTaskNotice_MyShopNotice_Edit isNeedShowMessage:NO] :[HDPermissionManager isHasThisPermission:HDOrder_GoSchemeLibrary_EditProperty isNeedShowMessage:NO];
                    break;
                case MaterialTaskTimeDetailsTypeMaterial:
                    return [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_EditProperty isNeedShowMessage:NO];
                    break;
                case MaterialTaskTimeDetailsTypeWorkHours:
                    return [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_EditProperty isNeedShowMessage:NO];
                    break;
                default:
                    break;
            }
        }
            break;
        case PorscheConstantModelTypeCoreDataPartsGroup: // 备件主组
        {
            return self.cellType == MaterialTaskTimeDetailsTypeMaterial ? [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_EditProperty isNeedShowMessage:NO] : NO;

        }
        case PorscheConstantModelTypeCoreDataWorkHourk: //工时主子组
        {
            return self.cellType == MaterialTaskTimeDetailsTypeWorkHours ? [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_EditProperty isNeedShowMessage:NO] : NO;
        }
            break;
        case PorscheConstantModelTypeCoreDataFavorite: //收藏夹
        {
            BOOL isHasPermission = _isFromNotice ? [HDPermissionManager isHasThisPermission:HDTaskNotice_MyShopNotice_Edit isNeedShowMessage:NO] :[HDPermissionManager isHasThisPermission:HDOrder_GoSchemeLibrary_EditProperty isNeedShowMessage:NO];

            return self.cellType == MaterialTaskTimeDetailsTypeScheme ? isHasPermission : NO;
        }
            break;
        default:
            break;
    }
    
    return NO;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PorscheConstantModel *cellConstantModel = self.dataSource[indexPath.row];
    
    
    ProjectDetailPlanSubCollectionCell *cell = [ProjectDetailPlanSubCollectionCell cellWithCollectionView:collectionView indexPath:indexPath withCellType:cellConstantModel.constantType];
    cell.isFromNotice = self.isFromNotice;

    cell.constantModel = cellConstantModel;
    cell.editCell = self.editCell ? [self setupPermissionWithConstant:cellConstantModel] : NO;
    
    __weak typeof(cell)weakcell = cell;
    __weak typeof(self)weakself = self;
    cell.actionBlock = ^(DetailPlanSubCollectionCellActionType actionType, UIView *sender) {

        ListViewDirection direction;
        
        direction = ListViewDirectionRight;
        PorscheConstantModel *model = weakself.dataSource[indexPath.row];
        NSArray<PorscheConstantModel *> *listArray = [weakself getConstantWithType:model.constantType];
        
        NSInteger maxCount;
        NSInteger minCount;
        NSMutableArray *selecteds;
        
        switch (weakcell.constantModel.constantType) {
            case PorscheConstantModelTypeCoreDataBusinesstype:
            {
                maxCount = 20;
                minCount = 1;
                if (!selecteds) selecteds = [[NSMutableArray alloc] initWithArray:weakself.businessArray];
            
            }
            case PorscheConstantModelTypeCoreDataFavorite:
            {
                maxCount = 20;
                minCount = 1;
                if (!selecteds) selecteds = [[NSMutableArray alloc] initWithArray:weakself.favoriteArray];;
 
            }
                break;
            default:
            {
                maxCount = 1;
                minCount = 0;
                selecteds = [[NSMutableArray alloc] init];
            }
                break;
        }
        
        if (weakcell.constantModel.constantType == PorscheConstantModelTypeCoreDataWorkHourk) {
            
            [PorscheMultipleListhView showTwoStageListViewFrom:sender dataSource:listArray selected:nil direction:ListViewDirectionDown complete:^(PorscheConstantModel *constantModel, PorscheSubConstant *subConstantModel) {
                
                [weakself setworkHourGroupDataWithConstantModel:constantModel subConstant:subConstantModel];
                [weakself.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
        } else {
            
            [PorscheMultipleListhView showMultipleListViewFrom:sender dataSource:listArray selecteds:selecteds maxSelectCount:maxCount MinSelectCount:minCount direction:direction complete:^(NSArray<PorscheConstantModel *> *constantModelArray) {
                
                switch (weakcell.constantModel.constantType) {
                    case PorscheConstantModelTypeCoreDataBusinesstype: //业务
                    {
                        [weakself updateBusinessDataSource:constantModelArray];
                        [weakself.collectionView reloadData];
                    }
                        break;
                    case PorscheConstantModelTypeCoreDataSchemeLevel: //级别
                    {
                        [weakself setLevelDataWithConstantModel:constantModelArray.firstObject];
                        [weakself.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    }
                        break;
                    case PorscheConstantModelTypeCoreDataPartsGroup: //备件主组
                    {
                        [weakself setSpareGroupDataWithConstantModel:constantModelArray.firstObject];
                        [weakself.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    }
                        break;
                    case PorscheConstantModelTypeCoreDataFavorite: //收藏
                    {
                        [weakself updateFavoriteDataSource:constantModelArray];
                        [weakself.collectionView reloadData];
                    }
                        break;
                    default:
                        break;
                }
                
                
                [weakself reloadMoreButton];
            }];
        }
        };
    return cell;
}


//将PorscheConstantModel 转化成 PorscheBusinessModel业务model并重新赋值
- (void)updateBusinessDataSource:(NSArray <PorscheConstantModel *>*)arr {
    
    NSMutableArray *businessArr = [[NSMutableArray alloc] init];
    for (PorscheConstantModel *busniess in arr) {
        if (busniess.cvsubid.integerValue == 0) continue;
        PorscheBusinessModel *businessModel = [[PorscheBusinessModel alloc] init];
        businessModel.businesstypeid = busniess.cvsubid;
        businessModel.businesstypename = busniess.cvvaluedesc;
        [businessArr addObject:businessModel];
    }
    switch (self.cellType) {
        case MaterialTaskTimeDetailsTypeScheme:
            self.schemeModel.typelist = businessArr;
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
            self.speraModel.business = businessArr;
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
            self.workHourModel.business = businessArr;
            break;
        default:
            break;
    }
}

- (void)updateFavoriteDataSource:(NSArray <PorscheConstantModel *>*)arr {
    
    NSMutableArray *favoriteArr = [[NSMutableArray alloc] init];
    NSMutableArray *favoriteIds = [[NSMutableArray alloc] init];
    for (PorscheConstantModel *favorite in arr) {
        if (favorite.cvsubid.integerValue == 0) continue;
        PorscheSchemeFavoriteModel *favoriteModel = [[PorscheSchemeFavoriteModel alloc] init];
        favoriteModel.favoriteid = favorite.cvsubid;
        favoriteModel.favoritename = favorite.cvvaluedesc;
        [favoriteArr addObject:favoriteModel];
        
        NSString *schemeid = favoriteModel.favoriteid.stringValue;
        [favoriteIds addObject:schemeid];
    }
    self.schemeModel.favoritelist = favoriteArr;
    self.schemeModel.favoriteids = [favoriteIds componentsJoinedByString:@","];
}

- (void)setLevelDataWithConstantModel:(PorscheConstantModel *)constant {
    
    switch (self.cellType) {
            
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            self.speraModel.parts.parts_level = @(constant.cvsubid.integerValue);
            self.speraModel.parts.levelname = constant.cvvaluedesc;
            
            
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            self.workHourModel.workhour.workhourlevel = @(constant.cvsubid.integerValue);
            self.workHourModel.workhour.workhourlevelname = constant.cvvaluedesc;
        }
            break;
            
        case MaterialTaskTimeDetailsTypeScheme:
        {
            self.schemeModel.schemelevelid = @(constant.cvsubid.integerValue);
            self.schemeModel.schemelevelname = constant.cvvaluedesc;
        }
        default:
            break;
    }
}

- (void)setSpareGroupDataWithConstantModel:(PorscheConstantModel *)constant {
    
    switch (self.cellType) {
            
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            self.speraModel.parts.group_name = constant.cvvaluedesc;
            self.speraModel.parts.group_id = @(constant.cvsubid.integerValue);
            
        }
            break;
        default:
            break;
    }
}

- (void)setworkHourGroupDataWithConstantModel:(PorscheConstantModel *)constant subConstant:(PorscheSubConstant *)subConstant {
    
    switch (self.cellType) {
            
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            self.workHourModel.workhour.workhourgroupfuid = (NSString *)constant.cvsubid;
            self.workHourModel.workhour.workhourgroupfuname = constant.cvvaluedesc;
            self.workHourModel.workhour.workhourgroupid = (NSString *)subConstant.cvsubid;
            self.workHourModel.workhour.workhourgroupname = subConstant.cvvaluedesc;
            
        }
            break;
        default:
            break;
    }

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == 0 && self.editCell && _cellType ==MaterialTaskTimeDetailsTypeScheme) {
//        ProjectDetailPlanSubCollectionModel *model = [[ProjectDetailPlanSubCollectionModel alloc] init];
//        model.title = @"收藏夹";
//        model.content = @"未选择";
//        [self.dataSource insertObject:model atIndex:0];
//        [self reloadMoreButton];
//        [collectionView reloadData];
//    }
}

- (void)popDeleteViewOntableView:(UIView *)view complete:(void(^)(BOOL delete))complete {
    
    if (!self.popDeleteView) {
        self.popDeleteView = [[HDPoperDeleteView alloc]initWithSize:DELETE_VIEW_SIZE];
        self.popDeleteView.poperVC.backgroundColor = [UIColor whiteColor];
    }
    [HD_FULLView endEditing:YES];
    self.popDeleteView.label.text = @"确定删除?";
    
    __weak typeof(self)weakself = self;
    self.popDeleteView.hDPoperDeleteViewBlock =^ (HDdeleteViewStyle style) {
        
        complete(style == HDdeleteViewStyleSure);
        
        [weakself.popDeleteView.poperVC dismissPopoverAnimated:YES];
    };
    
    CGRect cellrect = [view convertRect:view.bounds toView:KEY_WINDOW];
    
    [self.popDeleteView.poperVC presentPopoverFromRect:cellrect inView:HD_FULLView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
}

- (void)showListView:(CGRect)rect andDataArray:(NSArray *)arr{
    
    CGRect listRect;
    if (rect.size.width < 50) {
        listRect = CGRectMake(CGRectGetMaxX(rect) + 10, CGRectGetMaxY(rect), 100, 200);
    } else {
        listRect = CGRectMake(rect.origin.x, CGRectGetMaxY(rect), rect.size.width, 200);
    }
    self.planListView.frame = listRect;
    self.planListView.dataSource = arr;
    [self.planListView.tableView reloadData];
    self.planListView.block = ^(NSNumber *number,BOOL needAccessoryDisclosureIndicator, HDWorkListTableViewsStyle style) {

    };
    UIView *cleanView = [[UIView alloc] initWithFrame:KEY_WINDOW.bounds];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    closeBtn.frame = cleanView.bounds;
    [closeBtn addTarget:self action:@selector(colseListView:) forControlEvents:UIControlEventTouchUpInside];
    [cleanView addSubview:closeBtn];
    [cleanView addSubview:self.planListView];
    [[UIApplication sharedApplication].keyWindow addSubview:cleanView];
}
- (void)colseListView:(UIButton *)sender {
    
    [sender.superview removeFromSuperview];
}

- (IBAction)nextItem:(UIButton *)sender {
    
    UICollectionViewCell *cell = [self.collectionView.visibleCells lastObject];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    if (indexPath.row < [self.collectionView numberOfItemsInSection:0]) {
        
        NSInteger count = self.editCell && _cellType == MaterialTaskTimeDetailsTypeScheme? self.dataSource.count + 1 : self.dataSource.count;
        if (indexPath.row + 1 >= count) return;
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

- (HDWorkListTableViews *)planListView {
    
    if (!_planListView) {
        _planListView = [[HDWorkListTableViews alloc] initWithCustomFrame:CGRectZero];
        _planListView.selectedRow = -1;
        _planListView.style = HDWorkListTableViewsStyleCategory;
    }
    return _planListView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
