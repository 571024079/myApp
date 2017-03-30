//
//  HDWorkListCollectionViewCelltwo.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/8/31.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDWorkListCollectionViewCelltwo.h"
#import "HDWorkListCollectionViewCelltwoSubCell.h"
extern NSString *const touchStartstr;
extern NSString *const touchMovedstr;

#define cellWidth (LEFT_WITH - 40 - 15)/4 - 10
#define cellHeight (LEFT_WITH - 40 - 15)/4 - 10 + 20

@interface HDWorkListCollectionViewCelltwo () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@end

@implementation HDWorkListCollectionViewCelltwo

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.layer.masksToBounds = YES;
    self.collectionView.layer.borderWidth = 1;
    self.collectionView.layer.cornerRadius = 3;
    self.collectionView.layer.borderColor = Color(200, 200, 200).CGColor;
    
    self.addView.layer.masksToBounds = YES;
    self.addView.layer.borderWidth = 1;
    self.addView.layer.cornerRadius = 3;
    self.addView.layer.borderColor = Color(200, 200, 200).CGColor;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HDWorkListCollectionViewCelltwoSubCell" bundle:nil] forCellWithReuseIdentifier:@"HDWorkListCollectionViewCelltwoSubCell"];
}
/*
- (void)touchBegin:(NSNotification *)sender {
    
    UIEvent *event=[sender.userInfo objectForKey:@"event"];
    
    CGPoint pt = [[[[event allTouches] allObjects] objectAtIndex:0] locationInView:self];
    
    NSLog(@"点击位置X值：%f，Y值：%f",pt.x,pt.y);
    if ((pt.x > 0 && pt.x < cellWidth) && (pt.y > 0 && pt.y < cellHeight)) {
        NSLog(@"cell位置X值：%f，Y值：%f",pt.x,pt.y);
    }
    
    //cell点击空隙，不在cell上
    if ((pt.x > -18 && pt.x < 0) && (pt.y > 0 && pt.y < cellHeight)) {
        NSLog(@"cell点击空隙，不在cell上");
    }
    
}

- (void)touchMove:(NSNotification *)sender {
    
}
*/
- (void)setDataSource:(NSMutableArray *)dataSource {
    
    _dataSource = dataSource;
    
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (self.collectionView.bounds.size.width - 4*3)/3.0;
    CGFloat height = (self.collectionView.bounds.size.height - 4*2-1)/3.0;
    
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(3, 3, 3, 3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HDWorkListCollectionViewCelltwoSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HDWorkListCollectionViewCelltwoSubCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDWorkListCollectionViewCelltwoSubCell" owner:nil options:nil] objectAtIndex:0];
    }
    
//    cell.model = self.dataSource[indexPath.row];
    PorscheSchemeModel *data = self.dataSource[indexPath.row];
    
    [cell loadCellDataFor:data];
    
    return cell;
}



@end
