//
//  HDLeftNoticeTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PorscheItemModel.h"

@interface HDLeftNoticeTableViewCell : UITableViewCell

//点击背景图
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
//流程节点图片
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
//车牌号
@property (weak, nonatomic) IBOutlet UILabel *carNumberLb;

//VIN号码
@property (weak, nonatomic) IBOutlet UILabel *vinNumberLb;


//车系车型，年款，
@property (weak, nonatomic) IBOutlet UILabel *carDetialLb;

//  等待您确认备件
@property (weak, nonatomic) IBOutlet UILabel *noticeLb;

@property (nonatomic, strong) PorscheCarMessage *model;

//默认字体颜色
- (void)setDefaultTextColor:(UIColor *)color;
//点击字体颜色
- (void)setSelectedTextColor:(UIColor *)color;
//阴影
- (void)setShadow;



/**************************** 提醒列表下方方案本店提醒使用 **************************/
//正常的cell状态和图片
- (void)setCellDataFormNoticeLeft:(HDLeftNoticeListModel *)model;
//选中的cell状态和图片
- (void)setSelectedCellStyle:(HDLeftNoticeListModel *)model;


@end
