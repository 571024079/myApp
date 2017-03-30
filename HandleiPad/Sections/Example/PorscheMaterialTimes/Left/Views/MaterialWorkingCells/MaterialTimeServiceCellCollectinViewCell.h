//
//  MaterialTimeServiceCellCollectinViewCell.h
//  HandleiPad
//
//  Created by Robin on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialTimeServiceCellCollectinViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL cellSelected;
@property (nonatomic, strong) PorscheConstantModel *model;


+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
