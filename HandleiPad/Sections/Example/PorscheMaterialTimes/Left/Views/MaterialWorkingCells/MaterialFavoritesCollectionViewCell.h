//
//  MaterialFavoritesCollectionViewCell.h
//  MaterialDemo
//
//  Created by Robin on 16/9/26.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MaterialFavoritesCollectionViewCellTickBlock)();

@interface MaterialFavoritesCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) PorscheSchemeFavoriteModel *favoriteModel;

@property (weak, nonatomic) IBOutlet UIView *borderView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, copy) MaterialFavoritesCollectionViewCellTickBlock tickBlock;

@property (nonatomic, assign) BOOL cellSelectd;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
