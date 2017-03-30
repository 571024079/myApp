//
//  PorschePhotoGalleryImageCollectionViewCell.m
//  HandleiPad
//
//  Created by Robin on 16/10/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorschePhotoGalleryImageCollectionViewCell.h"

@implementation PorschePhotoGalleryImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupShandow:self];
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifer = @"PorschePhotoGalleryImageCollectionViewCell";
    [collectionView registerNib:[UINib nibWithNibName:@"PorschePhotoGalleryImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifer];
    PorschePhotoGalleryImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
//    [cell setupShandow:cell];
    return cell;
}

- (void)setupShandow:(UIView *)view {
    
    view.clipsToBounds = NO;
    UIColor *color = [UIColor grayColor];
    view.layer.shadowColor = color.CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(0,3);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 1.0;//阴影透明度，默认0
    view.layer.shadowRadius = 2;//阴影半径，默认3

}

@end
