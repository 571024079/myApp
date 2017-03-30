//
//  HDWorkListCollectionViewCelltwo.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/8/31.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDWorkListCollectionViewCelltwo : UICollectionViewCell
//@property (weak, nonatomic) IBOutlet UIView *imageSuperView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *addView;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end
