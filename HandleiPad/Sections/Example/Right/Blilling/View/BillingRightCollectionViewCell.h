//
//  BillingRightCollectionViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PlayActionBlock)(UIButton *);

@interface BillingRightCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *conImgView;

@property (weak, nonatomic) IBOutlet UIButton *playBt;

- (IBAction)playBtAction:(UIButton *)sender;


@property (nonatomic, copy) PlayActionBlock playBlock;


@end
