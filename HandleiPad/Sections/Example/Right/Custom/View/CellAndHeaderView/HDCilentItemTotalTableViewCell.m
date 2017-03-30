//
//  HDCilentItemTotalTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDCilentItemTotalTableViewCell.h"

@implementation HDCilentItemTotalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setTmpModel:(PorscheNewScheme *)tmpModel {
    _tmpModel = tmpModel;
    
    [self setNalormStyle];
    
    _itemTimeLb.text = [NSString formatMoneyStringWithFloat:[tmpModel.workhouroriginalpriceforscheme1 floatValue]];
    _materialLb.text = [NSString formatMoneyStringWithFloat:[tmpModel.partsoriginalpriceforscheme1 floatValue]];
    
//    if (![_tmpModel.wosisfinished integerValue]) {
//        [self setUnfinishStyle];
//    }else {
        _discountPriceLb.text = [NSString stringWithFormat:@"%@",[NSString formatMoneyStringWithFloat:[tmpModel.wosdiscountprice floatValue]]];
        
        _projectTotalPriceLb.text = [NSString formatMoneyStringWithFloat:[tmpModel.solutiontotalpriceforscheme floatValue]];
//    }
    //保修
    switch ([tmpModel.wossettlement integerValue]) {
            //内结
        case 1:
        {
            _rightImageView.image = [UIImage imageNamed:@"billing_pay_inside.png"];
        }
            break;
            //b保修
        case 2:
        {
            if ([tmpModel.wosisguarantee isEqualToNumber:@2]) {
                UIImage *image = [UIImage imageNamed:@"fullLeftListForRight_insureBule"];
//                image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                _rightImageView.tintColor = MAIN_BLUE;
                _rightImageView.image = image;
                
            }else if ([tmpModel.wosisguarantee isEqualToNumber:@1]) {
                
                _rightImageView.image = [UIImage imageNamed:@"billing_guarantee.png"];
            }
            
        }
            break;
        case 3:
        {
            _rightImageView.image = [UIImage imageNamed:@""];
            
        }
            break;
            
        default:
            break;
    }
    
}


//正常
- (void)setNalormStyle {
    _discountPriceLb.textColor = MAIN_PLACEHOLDER_GRAY;
    _projectTotalPriceLb.textColor = MAIN_PLACEHOLDER_GRAY;
    _projectTotalPriceLb.textAlignment = NSTextAlignmentRight;
}
//未确认
- (void)setUnfinishStyle {
    _discountPriceLb.text = @"--";
    _discountPriceLb.textColor = MAIN_RED;
    _projectTotalPriceLb.text = @"--";
    _projectTotalPriceLb.textColor = MAIN_RED;
    
    _projectTotalPriceLb.textAlignment = NSTextAlignmentCenter;
}

@end
