		//
//  PrecheckCarBodyCollectionViewCell.m
//  HandleiPad
//
//  Created by Handlecar on 2017/3/2.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "PrecheckCarBodyCollectionViewCell.h"
#import "HDPreCheckModel.h"

@interface PrecheckCarBodyCollectionViewCell ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *yipaizhaoWendangBtnArray;//已拍摄照片稳定选择按钮集合
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldArray;

@property (weak, nonatomic) IBOutlet UIButton *yipaizhaoYESBtn;
@property (weak, nonatomic) IBOutlet UIButton *yipaizhaoNOBtn;


@end

@implementation PrecheckCarBodyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //给所有的输入框设置代理
    for (UITextField *textFidle in _textFieldArray) {
        textFidle.delegate = self;
        textFidle.returnKeyType = UIReturnKeyDone;
        textFidle.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    [self setLabelTextStyleWithLabel:_titleLb];
}
- (void)setViewForm:(NSNumber *)viewForm {
    _viewForm = viewForm;
    for (UITextField *textFidle in _textFieldArray) {
        if ([_viewForm integerValue] == 1) {
            textFidle.userInteractionEnabled = NO;
            textFidle.borderStyle = UITextBorderStyleNone;
        }
    }
}

// 轮胎类型：  1：左前轮胎 2：右前轮胎 3：左后轮胎 4：右后轮胎  5：备胎',
- (void)setPreCheckData:(HDPreCheckModel *)preCheckData {
    _preCheckData = preCheckData;
    _contentImageView.image = [UIImage imageNamed:_preCheckData.cars];
    if (_preCheckData) {
        
        if ([_preCheckData.photoinfo integerValue] == 1) {
            [_yipaizhaoYESBtn setImage:[UIImage imageNamed:@"preCheck_select"] forState:UIControlStateNormal];
            [_yipaizhaoNOBtn setImage:[UIImage imageNamed:@"preCheck_unselect"] forState:UIControlStateNormal];
        }else {
            [_yipaizhaoYESBtn setImage:[UIImage imageNamed:@"preCheck_unselect"] forState:UIControlStateNormal];
            [_yipaizhaoNOBtn setImage:[UIImage imageNamed:@"preCheck_select"] forState:UIControlStateNormal];
        }
        
//        for (UIButton *btn in _yipaizhaoWendangBtnArray) {
//            btn.selected = NO;
//            if (btn.tag == [_preCheckData.photoinfo integerValue]) {
//                btn.selected = YES;
//                [btn setImage:[UIImage imageNamed:@"preCheck_select"] forState:UIControlStateNormal];
//            }else {
//                [btn setImage:[UIImage imageNamed:@"preCheck_unselect"] forState:UIControlStateNormal];
//            }
//        }
        
        if (_preCheckData.tyres.count) {
            for (PreCheckTyre *tyre in _preCheckData.tyres) {
                switch ([tyre.wottype integerValue]) {
                    case 1://左前轮胎
                        _leftFrontWheelTaiwenShenduTF.text = [tyre.wotpatterndepth floatValue] == 0 ? @"" : [tyre.wotpatterndepth stringValue];
                        _leftFrontWheelTyreYearTF.text = [tyre.wotypeuseyear floatValue] == 0 ? @"" : [tyre.wotypeuseyear stringValue];
                        break;
                    case 2://右前轮胎
                        _rightFrontWheelTaiwenShenduTF.text = [tyre.wotpatterndepth floatValue] == 0 ? @"" : [tyre.wotpatterndepth stringValue];
                        _rightFrontWheelTyreYearTF.text = [tyre.wotypeuseyear floatValue] == 0 ? @"" : [tyre.wotypeuseyear stringValue];
                        break;
                    case 3://左后轮胎
                        _leftRearWheelsTaiwenYearTF.text = [tyre.wotpatterndepth floatValue] == 0 ? @"" : [tyre.wotpatterndepth stringValue];
                        _leftRearWheelTyreYearTF.text = [tyre.wotypeuseyear floatValue] == 0 ? @"" : [tyre.wotypeuseyear stringValue];
                        break;
                    case 4://右后轮胎
                        _rightRearWheelsTaiwenYearTF.text = [tyre.wotpatterndepth floatValue] == 0 ? @"" : [tyre.wotpatterndepth stringValue];
                        _rightRearWheelTyreYearTF.text = [tyre.wotypeuseyear floatValue] == 0 ? @"" : [tyre.wotypeuseyear stringValue];
                        break;
                    default:
                        break;
                }
            }
        }else {
            NSMutableArray *temp = [NSMutableArray array];
            for (int i = 1; i < 5; i++) {
                PreCheckTyre *tyre = [[PreCheckTyre alloc] init];
                tyre.wottype = @(i);
                [temp addObject:tyre];
            }
            _preCheckData.tyres = temp;
        }
    }
    
    
}

#pragma mark - 设置label的文字显示
- (void)setLabelTextStyleWithLabel:(UILabel *)label {
    label.attributedText = [label.text changeToBottomLine];
}



#pragma mark - 已拍照照片文档
- (IBAction)jieshouCarKehuShifouzaichagnBtnAction:(UIButton *)sender {
    
    return;//17-03-08 苏磊需求不能进行选择, 只能数据返回使用
    
    [self setAllSelectBtnNormalImageWithSelect:sender withBtnArray:_yipaizhaoWendangBtnArray];
    
    
    if (_selectShifouPaizhaoBlock) {
        BOOL isSelect = NO;
        for (UIButton *btn in _yipaizhaoWendangBtnArray) {
            if (btn.selected) {
                isSelect = YES;
                break;
            }
        }
        if (isSelect) {
            _selectShifouPaizhaoBlock(@(sender.tag));
        }else {
            _selectShifouPaizhaoBlock(@0);
        }
    }
}
//设置所有不选中状态
- (void)setAllSelectBtnNormalImageWithSelect:(UIButton *)button withBtnArray:(NSArray *)btnArray {
    for (UIButton *btn in btnArray) {
        if (button != btn) {
            [btn setImage:[UIImage imageNamed:@"preCheck_unselect"] forState:UIControlStateNormal];
            btn.selected = NO;
        }
    }
    
    button.selected = !button.selected;
    if (button.selected) {
        [button setImage:[UIImage imageNamed:@"preCheck_select"] forState:UIControlStateNormal];
    }else {
        [button setImage:[UIImage imageNamed:@"preCheck_unselect"] forState:UIControlStateNormal];
    }
}


#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
// 轮胎类型：  1：左前轮胎 2：右前轮胎 3：左后轮胎 4：右后轮胎  5：备胎',
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == _rightFrontWheelTaiwenShenduTF) {//(右)侧前车轮胎纹深度
        [self setDataForSupperDataWithWottype:2 withType:1 withTextField:textField];
    }else if (textField == _rightFrontWheelTyreYearTF) {//(右)侧前车轮轮胎年限
        [self setDataForSupperDataWithWottype:2 withType:2 withTextField:textField];
    }else if (textField == _rightRearWheelsTaiwenYearTF) {//(右)侧后车轮胎纹深度
        [self setDataForSupperDataWithWottype:4 withType:1 withTextField:textField];
    }else if (textField == _rightRearWheelTyreYearTF) {//(右)侧后车轮轮胎年限
        [self setDataForSupperDataWithWottype:4 withType:2 withTextField:textField];
    }else if (textField == _leftFrontWheelTaiwenShenduTF) {//(左)侧前车轮胎纹深度
        [self setDataForSupperDataWithWottype:1 withType:1 withTextField:textField];
    }else if (textField == _leftFrontWheelTyreYearTF) {//(左)侧前车轮轮胎年限
        [self setDataForSupperDataWithWottype:1 withType:2 withTextField:textField];
    }else if (textField == _leftRearWheelsTaiwenYearTF) {//(左)侧后车轮胎纹深度
        [self setDataForSupperDataWithWottype:3 withType:1 withTextField:textField];
    }else if (textField == _leftRearWheelTyreYearTF) {//(左)侧后车轮轮胎年限
        [self setDataForSupperDataWithWottype:3 withType:2 withTextField:textField];
    }
    
    if (_saveDataBlock) {
        _saveDataBlock(_preCheckData);
    }
    
}

- (void)setDataForSupperDataWithWottype:(NSInteger)wottype withType:(NSInteger)type withTextField:(UITextField *)textField {
    
    for (PreCheckTyre *tyre in _preCheckData.tyres) {
        if ([tyre.wottype integerValue] == wottype) {
            tyre.wottype = @(wottype);
            if (type == 1) {
                tyre.wotpatterndepth = [NSNumber numberWithFloat:[textField.text floatValue]];
            }else {
                tyre.wotypeuseyear = [NSNumber numberWithFloat:[textField.text floatValue]];
            }
        }
    }
}


@end
