//
//  HDClientTableViewTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDClientTableViewTableViewCell.h"

@implementation HDClientTableViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTmpModel:(PorscheNewSchemews *)tmpModel {
    _tmpModel = tmpModel;
    
    
    [self setNalormStyle];
    
    _itemStyleLb.text = [tmpModel.schemesubtype isEqualToNumber: @2] ? @"备件:" : @"工时:";
    _itemNameLb.text = tmpModel.schemewsname;
    _itemPriceLb.text = tmpModel.schemewsunitprice ? [NSString formatMoneyStringWithFloat:[tmpModel.schemewsunitprice floatValue]]:@"";
    
    
    
    if ([tmpModel.iscancel integerValue] == 0) {
        [self setUnfinishStyle];
    }else {
        if (tmpModel.schemewscount) {
            _itemCountLb.text = tmpModel.schemewscount ? ([tmpModel.schemesubtype isEqualToNumber: @2]?  [NSString stringWithFormat:@"%.2f", [tmpModel.schemewscount floatValue]] : [NSString stringWithFormat:@"%.2fTU",[tmpModel.schemewscount floatValue]]) : @"";
            
            
        }else {
            _itemCountLb.text = @"";
        }
        
        if ([tmpModel.schemewstdiscount integerValue] != 1) {
            _disCountLb.text = tmpModel.schemewstdiscount ? [NSString stringWithFormat:@"-%.2f%%",[tmpModel.schemewstdiscount floatValue] *100] : @"一";
        }else {
            _disCountLb.text = @"一";
        }
        
        _disCountTotalLb.text = tmpModel.schemewstotalprice ? [NSString formatMoneyStringWithFloat:[tmpModel.schemewstotalprice floatValue]]:[NSString formatMoneyStringWithFloat:0.00];
        
        _totalPriceLb.text = tmpModel.schemewsunitprice_yuan ? [NSString formatMoneyStringWithFloat:[tmpModel.schemewsunitprice_yuan floatValue]]:[NSString formatMoneyStringWithFloat:0.00];
    }
    
    
    
    if ([_supperModel.wossettlement integerValue] != 1 && [_supperModel.wossettlement integerValue] != 2) {
        //保修
        switch ([tmpModel.schemesettlementway integerValue]) {
                //内结
            case 1:
            {
                _guaranreeIg.image = [UIImage imageNamed:@"billing_pay_inside.png"];
            }
                break;
                //b保修
            case 2:
            {
                if ([tmpModel.schemeswswarrantyconflg isEqualToNumber:@2]) {
                    UIImage *image = [UIImage imageNamed:@"fullLeftListForRight_insureBule"];
//                    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                    _guaranreeIg.tintColor = MAIN_BLUE;
                    _guaranreeIg.image = image;
                    
                }else if ([tmpModel.schemeswswarrantyconflg isEqualToNumber:@1]) {
                    
                    _guaranreeIg.image = [UIImage imageNamed:@"billing_guarantee.png"];
                }
                
            }
                break;
            case 3:
            {
                _guaranreeIg.image = [UIImage imageNamed:@""];
                
            }
                break;
                
            default:
                break;
        }
    }else {
        _guaranreeIg.image = [UIImage imageNamed:@""];
    }

    
}

//正常
- (void)setNalormStyle {
    _itemCountLb.textColor = MAIN_PLACEHOLDER_GRAY;
    _disCountLb.textColor = MAIN_PLACEHOLDER_GRAY;
    _disCountTotalLb.textColor = MAIN_PLACEHOLDER_GRAY;
    _totalPriceLb.textColor = MAIN_PLACEHOLDER_GRAY;
    _disCountTotalLb.textAlignment = NSTextAlignmentRight;
    _totalPriceLb.textAlignment = NSTextAlignmentRight;
}
//未确认
- (void)setUnfinishStyle {
    _itemCountLb.text = @"--";
    _itemCountLb.textColor = MAIN_RED;
    _disCountLb.text = @"--";
    _disCountLb.textColor = MAIN_RED;
    _disCountTotalLb.text = @"--";
    _disCountTotalLb.textColor = MAIN_RED;
    _totalPriceLb.text = @"--";
    _totalPriceLb.textColor = MAIN_RED;
    
    _disCountTotalLb.textAlignment = NSTextAlignmentCenter;
    _totalPriceLb.textAlignment = NSTextAlignmentCenter;
}



/*
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
 */




@end
