//
//  HDPreCheckCommonCellDetailCell.m
//  HandleiPad
//
//  Created by 程凯 on 2017/3/2.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "HDPreCheckCommonCellDetailCell.h"

@implementation HDPreCheckCommonCellDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    //materialtime_list_checkbox_selected
}

- (void)setHpcistate:(NSNumber *)hpcistate {
    _hpcistate = hpcistate;
    
        for (UIButton *btn in _selectBtnArray) {
            btn.selected = NO;
            if (btn.tag == [_hpcistate integerValue]) {
//                [self setAllSelectBtnNormalImageWithSelect:btn withBtnArray:_selectBtnArray];
                btn.selected = YES;
                
                UIImageView *imageView = [self viewWithTag:btn.tag + 10];
                imageView.image = [UIImage imageNamed:@"preCheck_select"];
//                [btn setImage:[UIImage imageNamed:@"preCheck_select"] forState:UIControlStateNormal];
                
            }else {
                UIImageView *imageView = [self viewWithTag:btn.tag + 10];
                imageView.image = [UIImage imageNamed:@"preCheck_unselect"];
//                [btn setImage:[UIImage imageNamed:@"preCheck_unselect"] forState:UIControlStateNormal];
            }
            
        }
}


#pragma mark - ButtonAction
- (IBAction)selectButtonAction:(UIButton *)sender {
    if ([_viewForm integerValue] == 1) {
        return;
    }
    
    [self setAllSelectBtnNormalImageWithSelect:sender withBtnArray:_selectBtnArray];
    
    if (_selectBtnBlock) {
        BOOL isSelect = NO;
        for (UIButton *btn in _selectBtnArray) {
            if (btn.selected) {
                isSelect = YES;
                break;
            }
        }
        if (isSelect) {
            _selectBtnBlock((SelectButtonType)sender.tag);
        }else {
            _selectBtnBlock(SelectButtonType_none);
        }
    }
    
}


//设置所有不选中状态
- (void)setAllSelectBtnNormalImageWithSelect:(UIButton *)button withBtnArray:(NSArray *)btnArray {
    for (UIButton *btn in btnArray) {
        if (button != btn) {
            UIImageView *imageView = [self viewWithTag:btn.tag + 10];
            imageView.image = [UIImage imageNamed:@"preCheck_unselect"];
//            [btn setImage:[UIImage imageNamed:@"preCheck_unselect"] forState:UIControlStateNormal];
            btn.selected = NO;
        }
    }
    
    button.selected = !button.selected;
    if (button.selected) {
        UIImageView *imageView = [self viewWithTag:button.tag + 10];
        imageView.image = [UIImage imageNamed:@"preCheck_select"];
//        [button setImage:[UIImage imageNamed:@"preCheck_select"] forState:UIControlStateNormal];
    }else {
        UIImageView *imageView = [self viewWithTag:button.tag + 10];
        imageView.image = [UIImage imageNamed:@"preCheck_unselect"];
//        [button setImage:[UIImage imageNamed:@"preCheck_unselect"] forState:UIControlStateNormal];
    }
}


@end
