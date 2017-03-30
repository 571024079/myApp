//
//  HDProjectUserRangeTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDProjectUserRangeTableViewCell.h"

@implementation HDProjectUserRangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupDefaultImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





- (IBAction)listAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (self.hdProjectBlock) {
        self.hdProjectBlock(sender);
    }
    
}























//修改界面以数据为主，避免重用
- (IBAction)chooseRangeBtAction:(UIButton *)sender {
    [self setupDefaultImageView];
    switch (sender.tag) {
        case 1:
        {
            [self setupViewBorderWithView:_momentChangeImg width:0 color:MAIN_BLUE];
        }
            break;
        case 2:
        {
            [self setupViewBorderWithView:_saveMineImg width:0 color:MAIN_BLUE];
        }
            break;
        case 3:
        {
            [self setupViewBorderWithView:_forAllImg width:0 color:MAIN_BLUE];
        }
            break;
        default:
            break;
    }
 
}

//默认显示
- (void)setupDefaultImageView {
    //设置圆角
    [self setupViewCornerRadiusWithView:_momentChangeImg radius:7];
    [self setupViewCornerRadiusWithView:_saveMineImg radius:7];
    [self setupViewCornerRadiusWithView:_forAllImg radius:7];
    //设置边框颜色
    [self setupViewBorderWithView:_momentChangeImg width:0.5 color:Color(255, 255, 255)];
    [self setupViewBorderWithView:_saveMineImg width:0.5 color:Color(255, 255, 255)];
    [self setupViewBorderWithView:_forAllImg width:0.5 color:Color(255, 255, 255)];
    
}


//圆角
- (void)setupViewCornerRadiusWithView:(UIView *)view radius:(CGFloat)radius {
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
}
//边框及背景色
- (void)setupViewBorderWithView:(UIView *)view width:(CGFloat)width color:(UIColor *)color {
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = width;
    view.layer.borderColor = Color(170, 170, 170).CGColor;
    view.backgroundColor = color;
}


@end
