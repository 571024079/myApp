//
//  HDServiceRightDetailCell.h
//  HandleiPad
//
//  Created by handou on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDServiceRightDetailCell;
@protocol HDServiceRightDetailCelldelegate <NSObject>
- (void)cellButtonActionWithcell:(HDServiceRightDetailCell *)cell withButton:(UIButton *)sender;

@end

@interface HDServiceRightDetailCell : UITableViewCell
@property (nonatomic, assign) id<HDServiceRightDetailCelldelegate>delegate;


//左侧cell
@property (weak, nonatomic) IBOutlet UILabel *leftContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *baoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *neiImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContentLbDisPriceLb;


//右侧cell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *rightContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *LeftPriceLabel;
// 标记未完成方案，是否被完成
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;


@end
