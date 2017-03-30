//
//  ProjectCarStyleAndDisTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/26.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ProjectCarStyleAndDisTableViewCell.h"
//嵌套的collectionViewCell

#import "ProjectCarStyleCollectionViewCell.h"
//添加样式cell
#import "ProjectAddItemCollectionViewCell.h"

#import "ProjectCarStyleCollectionViewFlowLayout.h"
//车型选择器
#import "PorscheCarTypeChooser.h"
//车型选择器new
#import "PorscheCarTypeChooserView.h"

//添加编辑+号cell
NSString *projectAddCellID = @"ProjectAddItemCollectionViewCell";

NSString *ProjectCarStyleCollectionViewCellID = @"ProjectCarStyleCollectionViewCell";

CGFloat const contentHeight = 35.0;

@interface ProjectCarStyleAndDisTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ProjectCarStyleCollectionViewFlowLayout *layout;

@property (nonatomic, assign) MaterialTaskTimeDetailsType cellType;

@end

@implementation ProjectCarStyleAndDisTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // 注册cell
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ProjectCarStyleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ProjectCarStyleCollectionViewCellID];
    
    [_collectionView registerNib:[UINib nibWithNibName:projectAddCellID bundle:nil] forCellWithReuseIdentifier:projectAddCellID];
    
    _collectionView.collectionViewLayout = self.layout;
    // Initialization code
    _collectionView.alwaysBounceVertical = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView withType:(MaterialTaskTimeDetailsType)cellType {
    
    static NSString *identifer = @"ProjectCarStyleAndDisTableViewCell";
    ProjectCarStyleAndDisTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectCarStyleAndDisTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.cellType = cellType;
    return cell;
}

- (ProjectCarStyleCollectionViewFlowLayout *)layout {
    
    if (!_layout) {
        _layout = [ProjectCarStyleCollectionViewFlowLayout new];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_editCell) {
        
        return self.dataArray.count + 1;
    }
    
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_editCell && self.dataArray.count == indexPath.row) {
        return CGSizeMake(30, 30);
    }
    CGFloat mager = 0;
    if (_editCell) {
        mager = 60;
    }
    PorscheSchemeCarModel *carModel = self.dataArray[indexPath.row];
    NSString *str = carModel.carSting;
    return CGSizeMake([self getStringlength:str] + 30 + mager, contentHeight);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //获取cell

    if (self.editCell && self.dataArray.count == indexPath.row) {
        ProjectAddItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:projectAddCellID forIndexPath:indexPath];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:projectAddCellID owner:nil options:nil];
            cell = [array objectAtIndex:0];
        }
//        [self scrollToAddView];
        return cell;
    }
    ProjectCarStyleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProjectCarStyleCollectionViewCellID forIndexPath:indexPath];
    
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ProjectCarStyleCollectionViewCell" owner:nil options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.editCell = self.editCell;
    
    PorscheSchemeCarModel *carModel = self.dataArray[indexPath.row];
    cell.nameLb.text = carModel.carSting;
    
    __weak typeof(self)weakSelf = self;
    cell.deleteBlock = ^() {
      
        NSLog(@"删除");
        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
        [weakSelf.collectionView reloadData];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.editCell) return;
    
    BOOL multiple =  self.dataArray.count == indexPath.row ; //添加按钮
//    PorscheCarTypeChooser *chooser = [PorscheCarTypeChooser viewWithXib];
//    chooser.frame = KEY_WINDOW.bounds;
//    chooser.multipleChoice = multiple;
//    __weak typeof(self)weakSelf = self;
//    chooser.saveBlcok = ^(NSArray *cars) {
//        if (!cars.count) return;
//        if (multiple) {
//            [weakSelf.dataArray addObjectsFromArray:cars];
//        } else {
//            [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:[cars firstObject]];
//        }
//        weakSelf.clickBlock(indexPath.row, CGRectZero);
//    };
    
    PorscheCarTypeChooserView *chooser = [PorscheCarTypeChooserView viewWithXib];
    chooser.frame = KEY_WINDOW.bounds;
    chooser.multipleChoice = multiple;
    __weak typeof(self)weakSelf = self;
    chooser.saveBlcok = ^(NSArray<PorscheCarSeriesModel *> *cars) {
        if (!cars.count) return;
        if (multiple) {
            NSArray *newcars = [weakSelf transformPorScheCarModelWithPorscheCarSeriesModelArray:cars];
            [weakSelf.dataArray addObjectsFromArray:newcars];
        } else {
            PorscheSchemeCarModel *carModel = [weakSelf transformPorScheCarModelWithPorscheCarSeriesModel:[cars firstObject]];
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:carModel];
        }
        weakSelf.clickBlock(indexPath.row, CGRectZero);
    };
    
    
    [KEY_WINDOW addSubview:chooser];
}

- (NSArray <PorscheSchemeCarModel *>*)transformPorScheCarModelWithPorscheCarSeriesModelArray:(NSArray<PorscheCarSeriesModel *> *)carSeriesArray {
    
    NSMutableArray *schemeCars = [[NSMutableArray alloc] init];
    for (PorscheCarSeriesModel *carSeriesModel in carSeriesArray) {
        PorscheSchemeCarModel *carModel = [[PorscheSchemeCarModel alloc] init];
        carModel.wocarcatena = carSeriesModel.cars;
        carModel.wocarcatenacode = carSeriesModel.carscode;
        carModel.scartypeid = carSeriesModel.pctid;
        
        if (carSeriesModel.selectCartypeArray.count < 1) [schemeCars addObject:carModel];
        for (PorscheCarTypeModel* cartypeInfo in carSeriesModel.selectCartypeArray) {
            
            PorscheSchemeCarModel *carModel = [[PorscheSchemeCarModel alloc] init];
            carModel.wocarcatena = carSeriesModel.cars;
            carModel.wocarcatenacode = carSeriesModel.carscode;
            
            carModel.wocarmodel = cartypeInfo.cartype;
            carModel.wocarmodelcode = cartypeInfo.cartypecode;
            carModel.scartypeid = cartypeInfo.pctid;

            
            if (cartypeInfo.selectCaryearArray.count < 1) [schemeCars addObject:carModel];
            for (PorscheCarYearModel* caryearInfo in cartypeInfo.selectCaryearArray) {
                
                PorscheSchemeCarModel *carModel = [[PorscheSchemeCarModel alloc] init];
                carModel.wocarcatena = carSeriesModel.cars;
                carModel.wocarcatenacode = carSeriesModel.carscode;
                
                carModel.wocarmodel = cartypeInfo.cartype;
                carModel.wocarmodelcode = cartypeInfo.cartypecode;
                
                carModel.woyearstyle = caryearInfo.year;
                carModel.scartypeid = caryearInfo.pctid;

                
                if (caryearInfo.selectCaroutputArray.count < 1) [schemeCars addObject:carModel];
                for (PorscheCarOutputModel* caroutputInfo in caryearInfo.selectCaroutputArray) {
                    
                    PorscheSchemeCarModel *carModel = [[PorscheSchemeCarModel alloc] init];
                    carModel.wocarcatena = carSeriesModel.cars;
                    carModel.wocarcatenacode = carSeriesModel.carscode;
                    
                    carModel.wocarmodel = cartypeInfo.cartype;
                    carModel.wocarmodelcode = cartypeInfo.cartypecode;
                    
                    carModel.woyearstyle = caryearInfo.year;
                    
                    carModel.wooutputvolume = caroutputInfo.displacement;
                    carModel.scartypeid = caroutputInfo.pctid;

                    [schemeCars addObject:carModel];
                }
            }
        }
    }
    return schemeCars;
}

- (PorscheSchemeCarModel *)transformPorScheCarModelWithPorscheCarSeriesModel:(PorscheCarSeriesModel *)carSeries {
    
    PorscheSchemeCarModel *carModel = [[PorscheSchemeCarModel alloc] init];
    carModel.wocarcatena = carSeries.cars;
    carModel.wocarcatenacode = carSeries.carscode;
    carModel.wocarmodel = carSeries.cartypeInfo.cartype;
    carModel.wocarmodelcode = carSeries.cartypeInfo.cartypecode;
    carModel.woyearstyle = carSeries.cartypeInfo.caryearInfo.year;
    carModel.wooutputvolume = carSeries.cartypeInfo.caryearInfo.caroutputInfo.displacement;
    
    if ([carSeries.pctid integerValue])
    {
        carModel.scartypeid = carSeries.pctid;
    }
    
    if ([carSeries.cartypeInfo.pctid integerValue])
    {
        carModel.scartypeid = carSeries.cartypeInfo.pctid;
    }
    
    if ([carSeries.cartypeInfo.caryearInfo.pctid integerValue])
    {
        carModel.scartypeid = carSeries.cartypeInfo.caryearInfo.pctid;
    }
    
    if ([carSeries.cartypeInfo.caryearInfo.caroutputInfo.pctid integerValue])
    {
        carModel.scartypeid = carSeries.cartypeInfo.caryearInfo.caroutputInfo.pctid;
    }
    
    return carModel;
}

- (void)setEditCell:(BOOL)editCell {
    
    _editCell = editCell; //? [HDPermissionManager isHasThisPermission:HDOrder_GoSchemeLibrary_EditContent isNeedShowMessage:NO] : NO;

    [self.collectionView reloadData];
    
    [self scrollToAddView];
}

- (void)scrollToAddView {
    
    if (self.editCell) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        
    }
}

- (CGFloat)getStringlength:(NSString *)string {
    
    return [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
