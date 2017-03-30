//
//  HDSchemeRightRectCollectionViewCell.h
//  HandleiPad
//
//  Created by Robin on 16/10/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialRightModel.h"
#import "PorscheCarModel.h"



typedef void(^HDSchemeRightRectCollectionViewCellLongBlock)();
@interface HDSchemeRightRectCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) HDSchemeRightRectCollectionViewCellLongBlock longBlock;

//@property (nonatomic, strong) MaterialRightModel *model;

@property (nonatomic, strong) PorscheSchemeModel *schemeModel;

@property (nonatomic, assign) NSInteger cellRow;

@property (nonatomic, assign) BOOL cellSelected;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
