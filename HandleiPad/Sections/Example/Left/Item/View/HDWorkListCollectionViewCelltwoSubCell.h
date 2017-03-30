//
//  HDWorkListCollectionViewCelltwoSubCell.h
//  HandleiPad
//
//  Created by Robin on 16/11/7.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDWorkListCollectionViewCelltwoSubCell : UICollectionViewCell

@property (nonatomic, strong) PorscheSchemeModel *model;



- (void)loadCellDataFor:(PorscheSchemeModel *)data;

@end
