//
//  HDScreenPopFileCell.h
//  HandleiPad
//
//  Created by handou on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDScreenPopFileCell : UICollectionViewCell

@property (nonatomic, strong) NSMutableArray <PorscheSchemeModel *>*dataSource;
//接收工单中的方案列表，便于将特定数据添加到方案数据中
@property (nonatomic, strong) NSMutableArray *inOrderFanganArray;

@end
