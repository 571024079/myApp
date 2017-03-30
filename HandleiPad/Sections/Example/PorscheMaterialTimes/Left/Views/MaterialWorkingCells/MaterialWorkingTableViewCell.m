//
//  MaterialWorkingTableViewCell.m
//  MaterialDemo
//
//  Created by Robin on 16/9/26.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "MaterialWorkingTableViewCell.h"
#import "MaterialMileageCollectionViewCell.h"
#import "MaterialFavoritesCollectionViewCell.h"
#import "MaterialTimeServiceCellCollectinViewCell.h"
//方案详情
#import "HDScreenPopFileView.h"
//级别cell
#import "MateririalTimeLevelTVCollectionViewCell.h"

#define LEFT_WITH 364

CGFloat const mileageMargin = 10;
CGFloat const favoriteMargin = 40;
CGFloat const serviceMargin = 10;

@interface MaterialWorkingTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *leftArrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *leftArrowButton;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIButton *rightArrowButton;

@property (strong, nonatomic) MaterialMileageCollectionViewCell *refreshCell;
@property (strong, nonatomic) NSIndexPath *lastCellIndexPath;

@property (strong, nonatomic) NSArray *levelConstantArr;
//收藏夹名称数组
@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, strong) NSMutableArray *favorialDataArray;
@property (nonatomic, strong) NSArray *servierDataArray;
@property (nonatomic, strong) NSMutableArray *seletedArray;

@property (nonatomic, assign) BOOL hiddenArrow;

//@property (nonatomic, strong) PorscheSchemeFavoriteModel *selectedFavorite; //选中的方案夹

@property (nonatomic, strong) NSMutableArray <PorscheSchemeFavoriteModel *>*favoriteSelectArray;

@end

@implementation MaterialWorkingTableViewCell {
    
    UIImageView *_cutImageView;
}

- (instancetype)initWithCellType:(CellType)celltype
{
    self = [super init];
    if (self) {
        
        self.cellType = celltype;
    }
    return self;
}


- (NSMutableArray<PorscheSchemeFavoriteModel *> *)favoriteSelectArray {
    
    if (!_favoriteSelectArray) {
        _favoriteSelectArray = [[NSMutableArray alloc] init];
    }
    return _favoriteSelectArray;
}

- (NSArray *)levelConstantArr {
    
    if (!_levelConstantArr) {
        _levelConstantArr = [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataSchemeLevel];
        self.hiddenArrow = _levelConstantArr.count <=4;
    }
    
    return _levelConstantArr;
}

- (NSMutableArray *)seletedArray {
    
    if (!_seletedArray) {
        _seletedArray = [[NSMutableArray alloc] init];
    }
    return _seletedArray;
}

- (NSMutableArray *)favorialDataArray {
    
    if (!_favorialDataArray) {
        _favorialDataArray = [[NSMutableArray alloc] init];
    }
    return _favorialDataArray;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)setCellType:(CellType)cellType {
    
    _cellType = cellType;
    //17-02-04 czz 添加清空操作,处理界面上的显示,不更改之前的逻辑   做法依赖上一级的 tableView 的刷新操作
    if (![[PorscheRequestSchemeListModel shareModel].schemelevelid integerValue] && ![[PorscheRequestSchemeListModel shareModel].businesstypeids integerValue] && ![PorscheRequestSchemeListModel shareModel].favoriteArray.count) {
        self.seletedArray = nil;
        [_collectionView reloadData];
    }
    
    if (cellType == MaterialWorkingTableViewCellTypeFavorite) {
        [self addNotificationCenter];
    }
    
}

- (void)addNotificationCenter {

    if (self.cellType == MaterialWorkingTableViewCellTypeFavorite) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFovriteModel:) name:SCHEME_LEFT_MOVERECTCELL_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createNewFovrite:) name:SCHEME_LEFT_CREATENEWFAVORITE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFavoriteDate:) name:SCHEME_DETAIL_REFRESH_MYFAVORITE_NOTIFICATION object:nil];
    }
}

- (void)refreshFavoriteDate:(NSNotification *)obj {
    
    [self loadFavoritesListwithIsRefresh:YES loadFavoriteSuccess:nil];
}


- (void)addFovriteModel:(NSNotification *)sender {
    
    NSString *pointstr = [sender.object objectForKey:@"point"];
    NSNumber *end = [sender.object objectForKey:@"endPoint"];
    
    CGRect selfRect = [self convertRect:self.bounds toView:KEY_WINDOW];
    CGRect nextRect = CGRectMake(CGRectGetMaxX(selfRect) - 20, CGRectGetMinY(selfRect), 30, CGRectGetHeight(selfRect));
    CGRect prevRect = CGRectMake(0, CGRectGetMinY(selfRect), 20, CGRectGetHeight(selfRect));
    BOOL nextCell = CGRectContainsPoint(nextRect, CGPointFromString(pointstr));
    BOOL prevCell = CGRectContainsPoint(prevRect, CGPointFromString(pointstr));
    
    if (nextCell) {
        NSLog(@"下一页");
        MaterialFavoritesCollectionViewCell *cell = [self.collectionView.visibleCells lastObject];
        NSIndexPath *lastIndexPath = [self.collectionView indexPathForCell:cell];
        if (lastIndexPath.row < self.favorialDataArray.count - 1) {
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:lastIndexPath.row + 1 inSection:lastIndexPath.section];
            [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }
    }
    if (prevCell) {
        MaterialFavoritesCollectionViewCell *cell = [self.collectionView.visibleCells firstObject];
        NSIndexPath *firstIndexPath = [self.collectionView indexPathForCell:cell];
        if (firstIndexPath.row > 0) {
            NSIndexPath *prevIndexPath = [NSIndexPath indexPathForRow:firstIndexPath.row - 1 inSection:firstIndexPath.section];
            [self.collectionView scrollToItemAtIndexPath:prevIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        }
    }
    
    for (MaterialFavoritesCollectionViewCell *cell in self.collectionView.visibleCells) {
        
//        NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
        UIView *coverView = cell.borderView;
        CGRect cellRect = [coverView convertRect:coverView.bounds toView:KEY_WINDOW];
        BOOL contains = CGRectContainsPoint(cellRect, CGPointFromString(pointstr));
        
        if (contains && !nextCell && !prevCell) {
            
            [self hiddenCutImageView];
            [self showCutImageFromCell:coverView withRect:cellRect];
            
            if ([end integerValue]) { //如果是结束通知
                
                [self hiddenCutImageView];
                PorscheSchemeModel *model = [sender.object objectForKey:@"model"];
                
                //添加方案
                WeakObject(self)
                NSIndexPath *thisIndexPath = [_collectionView indexPathForCell:cell];
                PorscheSchemeFavoriteModel *favoriteData = selfWeak.favorialDataArray[thisIndexPath.item];
                [self addSchemeForFavoriteListWithData:model withFavoriteID:favoriteData.favoriteid addSchemeSuccess:^(PResponseModel * _Nonnull responser) {
                    [selfWeak loadFavoritesListwithIsRefresh:YES loadFavoriteSuccess:nil];
                }];
            }
            break;
        } else {
            
            [self hiddenCutImageView];
        }
    }
   
    
}

#pragma mark - -------- 获取我的方案夹列表和名称
- (void)loadFavoritesListwithIsRefresh:(BOOL)isRefresh loadFavoriteSuccess:(void(^)())loadFavoriteSuccess {
    WeakObject(self)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [PorscheRequestManager myFavoriteslistWithParams:param completion:^(NSMutableArray * _Nonnull favoritesList, PResponseModel * _Nonnull responser) {
        if (favoritesList.count) {
            selfWeak.favorialDataArray = favoritesList;
            if (isRefresh) {
                [selfWeak.collectionView reloadData];
            }
            if (loadFavoriteSuccess) {
                loadFavoriteSuccess();
            }
        }else {
            selfWeak.favorialDataArray = favoritesList;
            if (isRefresh) {
                [selfWeak.collectionView reloadData];
            }
        }
    }];
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
- (void)createNewFovrite:(NSNotification *)sender {
    
    NSString *name = [self setName:self.favorialDataArray];
    WeakObject(self)
    //创建方案夹
    [self addFavoriteListWithName:name addFavoriteSuccess:^(PResponseModel * _Nonnull responser) {
        NSNumber *favorite = responser.object;
            //重新从服务器获取方案夹列表数据
            [selfWeak loadFavoritesListwithIsRefresh:NO loadFavoriteSuccess:^{
                //找到刚才创建的方案夹并打开
                NSInteger index = 0;
                for (PorscheSchemeFavoriteModel *data in selfWeak.favorialDataArray) {
                    if ([data.favoriteid isEqual:favorite]) {
                        break;
                    }
                    index++;
                }
                [selfWeak tapShowFavoriteViewForWorkList:index beginEdit:NO isNew:NO];
            }];
    }];
}

- (void)showCutImageFromCell:(UIView *)cell withRect:(CGRect)rect{
    
    if (_cutImageView.frame.origin.x == rect.origin.x) return;
    
    _cutImageView = [[UIImageView alloc] init];
    _cutImageView.frame = rect;
    _cutImageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    _cutImageView.image = [self imageFromView:cell Rect:cell.bounds];
    
    if (_cutImageView.superview != KEY_WINDOW) {
        [KEY_WINDOW insertSubview:_cutImageView atIndex:KEY_WINDOW.subviews.count - 2];
    }
    /*
    if (![KEY_WINDOW.subviews containsObject:_cutImageView]) {
        [KEY_WINDOW addSubview:_cutImageView];
    }
     */
}

- (void)hiddenCutImageView {
    
    [_cutImageView removeFromSuperview];
    _cutImageView.image = nil;
    _cutImageView = nil;
}

- (UIImage *)imageFromView:(UIView *)view  Rect:(CGRect)rect
{
    //创建一个基于位图的图形上下文并指定大小为CGSizeMake(300,500)
    UIGraphicsBeginImageContext(rect.size);
    
    //renderInContext 呈现接受者及其子范围到指定的上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //返回一个基于当前图形上下文的图片
    UIImage *extractImage =UIGraphicsGetImageFromCurrentImageContext();
    
    //移除栈顶的基于当前位图的图形上下文
    UIGraphicsEndImageContext();
    
    //以png格式返回指定图片的数据
    NSData *imageData = UIImagePNGRepresentation(extractImage);
    UIImage *imge = [UIImage imageWithData:imageData];
    
    return imge;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self loadFavoritesListwithIsRefresh:YES loadFavoriteSuccess:nil];
}

- (IBAction)leftAction:(id)sender {
    
    
}

- (IBAction)rightAction:(id)sender {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(20, 0, 20, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    switch (_cellType) {
        case MaterialWorkingTableViewCellTypeLevel:
            return mileageMargin;
            break;
        case MaterialWorkingTableViewCellTypeFavorite:
            return favoriteMargin;
            break;
        case MaterialWorkingTableViewCellTypeService:
            return serviceMargin;
            break;
        default:
            return 0;
            break;
    }

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    switch (_cellType) {
        case MaterialWorkingTableViewCellTypeLevel:
            return mileageMargin;
            break;
        case MaterialWorkingTableViewCellTypeFavorite:
            return favoriteMargin;
            break;
        case MaterialWorkingTableViewCellTypeService:
            return serviceMargin;
            break;
        default:
            return 0;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize cellSize;
    switch (self.cellType) {
        case MaterialWorkingTableViewCellTypeLevel:
            cellSize = CGSizeMake((LEFT_WITH - serviceMargin*6)/4, 30);
            break;
        case MaterialWorkingTableViewCellTypeFavorite:
            cellSize = CGSizeMake((LEFT_WITH - favoriteMargin*2)/2, (LEFT_WITH - favoriteMargin*2)/2);
            break;
        case MaterialWorkingTableViewCellTypeService:
            cellSize = CGSizeMake((LEFT_WITH - serviceMargin*6)/4, 30);
            break;
        default:
            break;
    }
    return cellSize;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (_cellType) {
        case MaterialWorkingTableViewCellTypeLevel:
            return self.levelConstantArr.count;
            break;
        case MaterialWorkingTableViewCellTypeService:
            return self.servierDataArray.count;
            break;
        case MaterialWorkingTableViewCellTypeFavorite:
            return self.favorialDataArray.count;
            break;
        default:
            return 1;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (_cellType) {
        case MaterialWorkingTableViewCellTypeLevel:
        {
            MateririalTimeLevelTVCollectionViewCell *cell = [MateririalTimeLevelTVCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
            cell.model = self.levelConstantArr[indexPath.row];
            return cell;
        }
            break;
        case MaterialWorkingTableViewCellTypeFavorite: {
            
            MaterialFavoritesCollectionViewCell *cell = [MaterialFavoritesCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
            
            PorscheSchemeFavoriteModel *favoriteData = self.favorialDataArray[indexPath.row];
            cell.favoriteModel = favoriteData;
            cell.cellSelectd = [self containsFavorite:favoriteData];
            __weak typeof(cell)weakcell = cell;
            __weak typeof(self)weakself = self;
            cell.tickBlock = ^() {
                
                if (weakcell.cellSelectd) {
                    [[PorscheRequestSchemeListModel shareModel].favoriteArray removeObject:weakcell.favoriteModel.favoriteid];
                } else {
                    [[PorscheRequestSchemeListModel shareModel].favoriteArray addObject:weakcell.favoriteModel.favoriteid];
                }
                [weakself beganScreeningWithFavorite];
                [weakself.collectionView reloadData];
            };
            return cell;

        }
            break;
        case MaterialWorkingTableViewCellTypeService:
        {
            
            MaterialTimeServiceCellCollectinViewCell *cell = [MaterialTimeServiceCellCollectinViewCell cellWithCollectionView:collectionView indexPath:indexPath];
            cell.model = self.servierDataArray[indexPath.row];
            cell.cellSelected = [self.seletedArray containsObject:cell.model];
            return cell;
        }
            break;
        default:
            return [UICollectionViewCell new];
            break;
    }
}

- (BOOL)containsFavorite:(PorscheSchemeFavoriteModel *)favorite {
    
    for (NSNumber *favoriteid in [PorscheRequestSchemeListModel shareModel].favoriteArray) {
        
        if (favoriteid.integerValue == favorite.favoriteid.integerValue) return YES;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (_cellType) {
        case MaterialWorkingTableViewCellTypeLevel:
        {
            PorscheConstantModel *model = self.levelConstantArr[indexPath.row];
            if (model.cvsubid.integerValue == [PorscheRequestSchemeListModel shareModel].schemelevelid.integerValue){
                
                [collectionView deselectItemAtIndexPath:indexPath animated:YES];
                [PorscheRequestSchemeListModel shareModel].schemelevelid = @(0);
            } else {
                [PorscheRequestSchemeListModel shareModel].schemelevelid = @(model.cvsubid.integerValue);
            }
            
        }
            break;
        case MaterialWorkingTableViewCellTypeFavorite:
            
        {
            [self tapShowFavoriteViewForWorkList:indexPath.item beginEdit:NO isNew:NO];
        }
            
            break;
        case MaterialWorkingTableViewCellTypeService:
        {
            MaterialTimeServiceCellCollectinViewCell *cell = (MaterialTimeServiceCellCollectinViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            PorscheConstantModel *serviermodel = cell.model;
            
            if ([self.seletedArray containsObject:serviermodel]) {
                [self.seletedArray removeObject:serviermodel];
            } else {
                [self.seletedArray addObject:serviermodel];
            }
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            
            NSMutableArray *businessTypes = [[NSMutableArray alloc] init];
            for (PorscheConstantModel *model in self.seletedArray) {
                [businessTypes addObject:model.cvsubid];
            }
            
            [PorscheRequestSchemeListModel shareModel].businesstypeids = [businessTypes componentsJoinedByString:@","];
        }
            break;
        default:
            break;
    }
}

- (void)beganScreeningWithFavorite{
    
    [self.favoriteSelectArray removeAllObjects];
    for (PorscheSchemeFavoriteModel *favorite in self.favorialDataArray ) {
        for (NSNumber *favoriteid in [PorscheRequestSchemeListModel shareModel].favoriteArray) {
            
            if (favorite.favoriteid.integerValue == favoriteid.integerValue) {
                
                for (PorscheSchemeModel *scheme in favorite.schemelist)
                {
                    scheme.source = @1;
                }
                
                [self.favoriteSelectArray addObject:favorite];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_SEARCHFAVORITE_NOTIFICATION object:self.favoriteSelectArray];
}

- (NSArray *)servierDataArray {
    
    if (!_servierDataArray) {
        
        _servierDataArray =  [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataBusinesstype];
    }
    return _servierDataArray;
}

- (void)setHiddenArrow:(BOOL)hiddenArrow {
    _hiddenArrow = hiddenArrow;
    
    self.leftArrowButton.hidden = hiddenArrow;
    self.rightArrowButton.hidden = hiddenArrow;
    
    self.leftArrowImageView.hidden = hiddenArrow;
    self.rightImageView.hidden = hiddenArrow;
}

#pragma mark - 长按cell出详情
- (void)tapShowFavoriteViewForWorkList:(NSInteger)index beginEdit:(BOOL)beginEdit isNew:(BOOL)isNew {
    
    HDScreenPopFileView *popView = [[HDScreenPopFileView alloc] initWithCustomFrame:CGRectMake(0, 0, HD_WIDTH, HD_HEIGHT)];
    PorscheSchemeFavoriteModel *data = _favorialDataArray[index];
//    if (isNew) {
//        popView.titleName = @"新建";
//        popView.isNew = isNew;
//    }else {
        popView.titleName = data.favoritename;
//    }
    popView.dataSource = [data.schemelist mutableCopy];
    popView.favorialDataArray = _favorialDataArray;
    
    WeakObject(self);
    WeakObject(popView)
    popView.beginEdit = beginEdit;
    popView.backBlock = ^() {
        [selfWeak loadFavoritesListwithIsRefresh:YES loadFavoriteSuccess:nil];
    };
    
    popView.deleteFavoritBlock = ^() {
        [selfWeak deteleFavoriteForListWithData:data];
    };
    
    popView.shouldReturnBlock = ^(NSString *string) {
        [selfWeak changeFavoriteNameWithName:string withFavoriteData:data withView:popViewWeak];
    };
    
    [HD_FULLView addSubview:popView];
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
- (void)deteleFavoriteForListWithData:(PorscheSchemeFavoriteModel *)data {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:data.favoriteid forKey:@"uid"];
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    WeakObject(hud)
    WeakObject(self)
    [PorscheRequestManager deteleFavoritesListWithParams:param completion:^(PResponseModel * _Nonnull responser) {
        [hudWeak hideAnimated:YES];
        if (responser.status == 100) {
            [selfWeak loadFavoritesListwithIsRefresh:YES loadFavoriteSuccess:nil];
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - 100) superView:KEY_WINDOW];
        }
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
- (void)addSchemeForFavoriteListWithData:(PorscheSchemeModel *)data withFavoriteID:(NSNumber *)ID addSchemeSuccess:(void(^)(PResponseModel * _Nonnull responser))addSchemeSuccess {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:ID forKey:@"favoriteid"];
    [param hs_setSafeValue:(PorscheSchemeModel *)data.schemeid forKey:@"schemeid"];

    [PorscheRequestManager addSchemeForFavoriteListWithParams:param completion:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            if (addSchemeSuccess) {
                addSchemeSuccess(responser);
            }
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"work_list_46"] message:responser.msg height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
        }
    }];
}


- (void)dealloc {
    
    if (self.cellType == MaterialWorkingTableViewCellTypeFavorite) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        NSLog(@"收藏cell的通知被释放");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
