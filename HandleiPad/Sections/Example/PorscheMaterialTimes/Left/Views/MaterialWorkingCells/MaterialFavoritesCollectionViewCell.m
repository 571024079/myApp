//
//  MaterialFavoritesCollectionViewCell.m
//  MaterialDemo
//
//  Created by Robin on 16/9/26.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "MaterialFavoritesCollectionViewCell.h"
#import "MaterialFavoritesCollectionViewCellSmallCell.h"

@interface MaterialFavoritesCollectionViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *tickButton;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) NSArray <PorscheSchemeModel *>*dataSource;

@end

@implementation MaterialFavoritesCollectionViewCell 


+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifer = @"MaterialFavoritesCollectionViewCell";
    [collectionView registerNib:[UINib nibWithNibName:@"MaterialFavoritesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifer];
    MaterialFavoritesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MaterialFavoritesCollectionViewCellSmallCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MaterialFavoritesCollectionViewCellSmallCell"];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)setFavoriteModel:(PorscheSchemeFavoriteModel *)favoriteModel {
    
    _favoriteModel = favoriteModel;
    self.titleLabel.text = favoriteModel.favoritename;
    self.dataSource = favoriteModel.schemelist;
}

- (void)setCellSelectd:(BOOL)cellSelectd {
    
    _cellSelectd = cellSelectd;
    
    NSString *str = cellSelectd ? @"materialtime_list_checkbox_selected.png":@"materialtime_list_checkbox_normal.png";
    [self.tickButton setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
}

- (void)setDataSource:(NSMutableArray<PorscheSchemeModel *> *)dataSource {
    _dataSource = dataSource;
    [_collectionView reloadData];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _borderView.layer.borderWidth = 2.f/[UIScreen mainScreen].scale;
    _borderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _borderView.layer.cornerRadius = 4;
   
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (self.collectionView.bounds.size.width - 4*3)/3.0;
    CGFloat height = (self.collectionView.bounds.size.height - 4*3)/3.0;
    
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 3;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 3;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(3, 3, 3, 3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MaterialFavoritesCollectionViewCellSmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MaterialFavoritesCollectionViewCellSmallCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MaterialFavoritesCollectionViewCellSmallCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (IBAction)tickAction:(UIButton *)sender {

    if (self.tickBlock) {
        self.tickBlock();
    }
}

@end
