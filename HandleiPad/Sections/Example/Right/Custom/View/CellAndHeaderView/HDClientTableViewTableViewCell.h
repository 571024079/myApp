//
//  HDClientTableViewTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDClientTableViewTableViewCell : UITableViewCell
//1. 备件：  2. 工时：
@property (weak, nonatomic) IBOutlet UILabel *itemStyleLb;
//名称
@property (weak, nonatomic) IBOutlet UILabel *itemNameLb;
//单价
@property (weak, nonatomic) IBOutlet UILabel *itemPriceLb;
//数量
@property (weak, nonatomic) IBOutlet UILabel *itemCountLb;
//总价
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLb;
//折扣
@property (weak, nonatomic) IBOutlet UILabel *disCountLb;
//折后总价
@property (weak, nonatomic) IBOutlet UILabel *disCountTotalLb;
//保修图片
@property (weak, nonatomic) IBOutlet UIImageView *guaranreeIg;


@property (nonatomic, strong) PorscheNewSchemews *tmpModel;
@property (nonatomic, strong) PorscheNewScheme *supperModel;





@end
