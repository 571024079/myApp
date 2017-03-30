//
//  MateririalTimeLevelTVCollectionViewCell.h
//  HandleiPad
//
//  Created by 岳小龙 on 2016/12/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MateririalTimeLevelTVCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) PorscheConstantModel *model;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
