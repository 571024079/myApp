//
//  ProjectDetailPlanSubCollectionCell.h
//  HandleiPad
//
//  Created by Robin on 2016/10/16.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectDetailPlanSubCollectionModel.h"

typedef NS_ENUM(NSInteger, DetailPlanSubCollectionCellActionType) {
    
    DetailPlanSubCollectionCellTitleAction,
    DetailPlanSubCollectionCellContentAction,
    DetailPlanSubCollectionCellDeleteAction
};

typedef NS_ENUM(NSInteger, ProjectDetailPlanSubCellType) {
    
    ProjectDetailPlanSubCellTypeBusiness = 1, //业务
    ProjectDetailPlanSubCellTypeLevel, //级别
    ProjectDetailPlanSubCellTypeGroup, //组别
    ProjectDetailPlanSubCellTypeFavorites //收藏夹
};

typedef void(^DetailPlanSubCollectionActionBlock)(DetailPlanSubCollectionCellActionType,UIView *);

@interface ProjectDetailPlanSubCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@property (nonatomic, assign) BOOL editCell;

@property (nonatomic, copy) DetailPlanSubCollectionActionBlock actionBlock;

@property (nonatomic, assign) PorscheConstantModelType cellType;

//@property (nonatomic, strong) ProjectDetailPlanSubCollectionModel *model;

@property (nonatomic, strong) PorscheConstantModel *constantModel;
@property (nonatomic) BOOL isFromNotice;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath withCellType:(PorscheConstantModelType)cellType;

@end
