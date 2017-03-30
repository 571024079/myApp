//
//  ProjectDetailPlanSubCollectionAddCell.m
//  HandleiPad
//
//  Created by Robin on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ProjectDetailPlanSubCollectionAddCell.h"

@implementation ProjectDetailPlanSubCollectionAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifer = @"ProjectDetailPlanSubCollectionAddCell";
    [collectionView registerNib:[UINib nibWithNibName:@"ProjectDetailPlanSubCollectionAddCell" bundle:nil] forCellWithReuseIdentifier:identifer];
    ProjectDetailPlanSubCollectionAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    return cell;
}

@end
