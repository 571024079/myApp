//
//  HDServiceRightHeaderCollectionCell.h
//  HandleiPad
//
//  Created by handou on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDServiceRightHeaderCollectionCell : UICollectionViewCell
@property (nonatomic, copy) void(^deleteBlock)(HDServiceRightHeaderCollectionCell *cell);//删除按钮的 block

//标签内容
@property (weak, nonatomic) IBOutlet UILabel *titelLabel;

@end
