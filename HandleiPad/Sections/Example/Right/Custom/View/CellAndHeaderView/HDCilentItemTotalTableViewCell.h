//
//  HDCilentItemTotalTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HDCilentItemTotalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemTimeLb;//工时

@property (weak, nonatomic) IBOutlet UILabel *materialLb;//备件

@property (weak, nonatomic) IBOutlet UILabel *discountPriceLb;//优惠

@property (weak, nonatomic) IBOutlet UILabel *projectTotalPriceLb;//折后总

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (nonatomic, strong) PorscheNewScheme *tmpModel;

@end
