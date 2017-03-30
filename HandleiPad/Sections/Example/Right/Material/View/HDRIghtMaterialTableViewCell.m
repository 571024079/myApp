//
//  HDRIghtMaterialTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDRIghtMaterialTableViewCell.h"

@implementation HDRIghtMaterialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupViewSave:(BOOL)saveStatus {
    _chooseBgImg.backgroundColor = saveStatus ? Color(255, 255, 255) : Color(170, 170, 170);
}

- (NSNumber *)showPrice {
    if (![_tmpModel.superschemesettlementway isEqual:@3]) {
        return _tmpModel.schemewstotalprice;
    }else {
        if ([_tmpModel.schemesettlementway isEqual:@3]) {
            return _tmpModel.schemewsunitprice_yuan;
        }else {
            return _tmpModel.schemewstotalprice;
        }
    }
}

- (void)setTmpModel:(PorscheNewSchemews *)tmpModel {
    _tmpModel = tmpModel;
    //[self setupViewSave:[_saveStatus integerValue] == 1 ? YES : NO];
    _itemTimeNumberLb.text = tmpModel.schemewscode;
    _itemTimeNameLb.text = tmpModel.schemewsname;
    _itemTimePriceLb.text = tmpModel.schemewsunitprice ? [NSString formatMoneyStringWithFloat:[tmpModel.schemewsunitprice floatValue]] : @"";
    _itemCountLb.text = tmpModel.schemewscount ? [NSString stringWithFormat:@"%.2fTU",[tmpModel.schemewscount floatValue]] : @"";
    //保修图片 根据数据模型定
    

//    if (tmpModel.schemewstotalprice) {
        _itemTimeTotalPriceLb.text = [NSString formatMoneyStringWithFloat:[[self showPrice] floatValue]];
//    }else {
//        _itemTimeTotalPriceLb.text = [NSString formatMoneyStringWithFloat:0.00];
//    }
    
    _chooseImg.image = [tmpModel.iscancel integerValue] == 0 ? nil : [UIImage imageNamed:@"work_list_29.png"];
    
    //所属方案是否自费  1.内结  2.保修  3.自费
    if (![_tmpModel.superschemesettlementway isEqualToNumber:@3]) {
        _guaranteeImg.image = [UIImage imageNamed:@""];
        
    }else {
        //保修
        switch ([tmpModel.schemesettlementway integerValue]) {
                //内结
            case 1:
            {
                _guaranteeImg.image = [UIImage imageNamed:@"billing_pay_inside.png"];
            }
                break;
                //b保修
            case 2:
            {
                if ([tmpModel.schemeswswarrantyconflg isEqualToNumber:@2]) {
                    UIImage *image = [UIImage imageNamed:@"fullLeftListForRight_insureBule"];
//                    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                    _guaranteeImg.tintColor = MAIN_BLUE;
                    _guaranteeImg.image = image;
                    
                }else {
                    
                    _guaranteeImg.image = [UIImage imageNamed:@"billing_guarantee.png"];
                }
                
            }
                break;
            case 3:
            {
                _guaranteeImg.image = [UIImage imageNamed:@""];
                
            }
                break;
                
            default:
                break;
        }
    }

    
}

- (IBAction)changeGuaranteeBtAction:(UIButton *)sender {
    
    if (self.guaranteeActionBlock) {
        self.guaranteeActionBlock();
    }
}

- (IBAction)chooseBtAction:(UIButton *)sender {
    if ([_saveStatus integerValue]) {
        return;
    }
    if (self.chooseBlock) {
        self.chooseBlock(_tmpModel,sender);
    }
}
@end
