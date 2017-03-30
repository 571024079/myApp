//
//  PrecheckFileTitleCollectionReusableView.m
//  HandleiPad
//
//  Created by Handlecar on 2017/3/2.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "PrecheckFileTitleCollectionReusableView.h"
#import "HDPreCheckModel.h"

@interface PrecheckFileTitleCollectionReusableView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *dingdangailanBtnArray;//订单概览的 btn 集合
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *suoxuwenjianBtnArray;//所需文件的 btn 集合
@property (strong, nonatomic) NSMutableArray *selectSuoxuWenjianArray;//所需文件的选择项目集合
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *kehushifouzaichangBtnArray;//接受车辆客户是否在场 btn 集合
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *jinxingshijiaBtnArray;//是否在遇到噪音和驾驶动态问题时进行试驾 btn 集合
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *payTypebtnArray;//付款方式 btn 集合
@property (strong, nonatomic) NSMutableArray * selectPayTypeArray;//所需文件的选择项目集合

@end

@implementation PrecheckFileTitleCollectionReusableView
- (NSMutableArray *)selectSuoxuWenjianArray {
    if (!_selectSuoxuWenjianArray) {
        _selectSuoxuWenjianArray = [NSMutableArray array];
    }
    return _selectSuoxuWenjianArray;
}
- (NSMutableArray *)selectPayTypeArray {
    if (!_selectPayTypeArray) {
        _selectPayTypeArray = [NSMutableArray array];
    }
    return _selectPayTypeArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.cornerRadius = 3;
    self.contentView.layer.borderColor = PRECHECK_BORDER_COLOR.CGColor;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth = 1.0f;
    
    [self setLabelTextStyleWithLabel:_dingdangaishuNameLb];
    [self setLabelTextStyleWithLabel:_suoxuwenjianLb];
}

- (void)setPreCheckData:(HDPreCheckModel *)preCheckData {
    _preCheckData = preCheckData;
    
    if (_preCheckData) {
        //订单概述
        for (UIButton *btn in _dingdangailanBtnArray) {
            btn.selected = NO;
            if (btn.tag == [_preCheckData.orderinfo integerValue]) {
                [self setAllSelectBtnNormalImageWithSelect:btn withBtnArray:_dingdangailanBtnArray];
            }
        }
        //所需文件
        if (_preCheckData.needfiles.count) {
            _selectSuoxuWenjianArray = [NSMutableArray arrayWithArray:_preCheckData.needfiles];
            
            NSMutableArray *array2 = [NSMutableArray array];
            for (PreCheckFile *model in _selectSuoxuWenjianArray) {
                model.state = @1;
                [array2 addObject:model.hpcfcid];
            }
            for (UIButton *btn in _suoxuwenjianBtnArray) {
                if ([array2 containsObject:@(btn.tag - 20)]) {
                    [btn setImage:[UIImage imageNamed:@"preCheck_select"] forState:UIControlStateNormal];
                }else {
                    [btn setImage:[UIImage imageNamed:@"preCheck_unselect"] forState:UIControlStateNormal];
                }
            }
        }
        
        //接受车辆客户是否在场
        for (UIButton *btn in _kehushifouzaichangBtnArray) {
            btn.selected = NO;
            if (btn.tag - 300 == [_preCheckData.isinfactory integerValue]) {
                [self setAllSelectBtnNormalImageWithSelect:btn withBtnArray:_kehushifouzaichangBtnArray];
            }
        }
        //是否在遇到噪音和驾驶动态问题时进行试驾
        for (UIButton *btn in _jinxingshijiaBtnArray) {
            btn.selected = NO;
            if (btn.tag - 400 == [_preCheckData.hastrycar integerValue]) {
                [self setAllSelectBtnNormalImageWithSelect:btn withBtnArray:_jinxingshijiaBtnArray];
            }
        }
        //付款方式
        if (_preCheckData.paytypes.count) {
            _selectPayTypeArray = [NSMutableArray arrayWithArray:_preCheckData.paytypes];
            
            NSMutableArray *array2 = [NSMutableArray array];
            for (PreCheckPayType *model in _selectPayTypeArray) {
                model.state = @1;
                [array2 addObject:model.hpcpcid];
            }
            for (UIButton *btn in _payTypebtnArray) {
                if ([array2 containsObject:@(btn.tag - 30)]) {
                    [btn setImage:[UIImage imageNamed:@"preCheck_select"] forState:UIControlStateNormal];
                }else {
                    [btn setImage:[UIImage imageNamed:@"preCheck_unselect"] forState:UIControlStateNormal];
                }
            }
        }
        
    }
    
}

#pragma mark - 设置label的文字显示
- (void)setLabelTextStyleWithLabel:(UILabel *)label {
    label.attributedText = [label.text changeToBottomLine];
}


#pragma mark - ---------按钮的点击事件---------------------
#pragma mark - 订单概述
- (IBAction)dingdanGailanBtnAction:(UIButton *)sender {
    if ([_viewForm integerValue] == 1) {
        return;
    }
    
    [self setAllSelectBtnNormalImageWithSelect:sender withBtnArray:_dingdangailanBtnArray];
    
    if (_selectDingdanGailanBlock) {
        BOOL isSelect = NO;
        for (UIButton *btn in _dingdangailanBtnArray) {
            if (btn.selected) {
                isSelect = YES;
                break;
            }
        }
        if (isSelect) {
            _selectDingdanGailanBlock((DingdanGailanType)sender.tag);
        }else {
            _selectDingdanGailanBlock(DingdanGailanType_none);
        }
    }
}



#pragma mark - 所需文件
- (IBAction)selectSuoxuWenjianButtonAction:(UIButton *)sender {
    
    if ([_viewForm integerValue] == 1) {
        return;
    }
    
//    [self setServiceBtnStyleWithBtnArray:_suoxuwenjianBtnArray withSelectBtnArray:self.selectSuoxuWenjianArray withButton:sender];
    
    PreCheckFile *file = [[PreCheckFile alloc] init];
    file.state = @1;
    file.hpcfcid = @(sender.tag - 20);
    
    NSMutableArray *array = [NSMutableArray array];
    for (PreCheckFile *model in self.selectSuoxuWenjianArray) {
        [array addObject:model.hpcfcid];
    }
    
    if ([array containsObject:file.hpcfcid]) {
        NSInteger index = 0;
        for (NSNumber *num in array) {
            if ([num isEqual:file.hpcfcid]) {
                break;
            }
            index++;
        }
        [self.selectSuoxuWenjianArray removeObjectAtIndex:index];
    }else {
        [self.selectSuoxuWenjianArray addObject:file];
    }
    
    NSMutableArray *array2 = [NSMutableArray array];
    for (PreCheckFile *model in self.selectSuoxuWenjianArray) {
        [array2 addObject:model.hpcfcid];
    }
    
    for (UIButton *btn in _suoxuwenjianBtnArray) {
        if ([array2 containsObject:@(btn.tag - 20)]) {
            [btn setImage:[UIImage imageNamed:@"preCheck_select"] forState:UIControlStateNormal];
        }else {
            [btn setImage:[UIImage imageNamed:@"preCheck_unselect"] forState:UIControlStateNormal];
        }
    }
    
    if (_selectSuoxuWenjianBlock) {
        _selectSuoxuWenjianBlock(_selectSuoxuWenjianArray);
    }
    
}


#pragma mark - 接受车辆客户是否在场
- (IBAction)jieshouCarKehuShifouzaichagnBtnAction:(UIButton *)sender {
    
    if ([_viewForm integerValue] == 1) {
        return;
    }
    [self setAllSelectBtnNormalImageWithSelect:sender withBtnArray:_kehushifouzaichangBtnArray];
    
    if (_selectShifouZaichangBlock) {
        BOOL isSelect = NO;
        for (UIButton *btn in _kehushifouzaichangBtnArray) {
            if (btn.selected) {
                isSelect = YES;
                break;
            }
        }
        if (isSelect) {
            _selectShifouZaichangBlock(@(sender.tag - 300));
        }else {
            _selectShifouZaichangBlock(@0);
        }
    }
}

#pragma mark - 是否在遇到噪音和驾驶动态问题时进行试驾
- (IBAction)shifoushijiaBtnAction:(UIButton *)sender {
    
    if ([_viewForm integerValue] == 1) {
        return;
    }
    [self setAllSelectBtnNormalImageWithSelect:sender withBtnArray:_jinxingshijiaBtnArray];
    
    if (_selectJinxingShijiaBlock) {
        BOOL isSelect = NO;
        for (UIButton *btn in _jinxingshijiaBtnArray) {
            if (btn.selected) {
                isSelect = YES;
                break;
            }
        }
        if (isSelect) {
            _selectJinxingShijiaBlock(@(sender.tag - 400));
        }else {
            _selectJinxingShijiaBlock(@0);
        }
    }
}

#pragma mark - 付款方式
- (IBAction)payTypeBtnAction:(UIButton *)sender {
    if ([_viewForm integerValue] == 1) {
        return;
    }
    
//    [self setServiceBtnStyleWithBtnArray:_payTypebtnArray withSelectBtnArray:self.selectPayTypeArray withButton:sender];
    
    PreCheckPayType *type = [[PreCheckPayType alloc] init];
    type.state = @1;
    type.hpcpcid = @(sender.tag - 30);
    
    NSMutableArray *array = [NSMutableArray array];
    for (PreCheckPayType *model in self.selectPayTypeArray) {
        [array addObject:model.hpcpcid];
    }
    
    if ([array containsObject:type.hpcpcid]) {
        NSInteger index = 0;
        for (NSNumber *num in array) {
            if ([num isEqual:type.hpcpcid]) {
                break;
            }
            index++;
        }
        [self.selectPayTypeArray removeObjectAtIndex:index];
    }else {
        [self.selectPayTypeArray addObject:type];
    }
    
    NSMutableArray *array2 = [NSMutableArray array];
    for (PreCheckPayType *model in self.selectPayTypeArray) {
        [array2 addObject:model.hpcpcid];
    }
    
    for (UIButton *btn in _payTypebtnArray) {
        if ([array2 containsObject:@(btn.tag - 30)]) {
            [btn setImage:[UIImage imageNamed:@"preCheck_select"] forState:UIControlStateNormal];
        }else {
            [btn setImage:[UIImage imageNamed:@"preCheck_unselect"] forState:UIControlStateNormal];
        }
    }
    
    if (_selectPayTypeBlock) {
        _selectPayTypeBlock(_selectPayTypeArray);
    }
}


#pragma mark - 通用方法
- (void)setServiceBtnStyleWithBtnArray:(NSArray *)btnArray withSelectBtnArray:(NSMutableArray *)selectArray withButton:(UIButton *)sender {
    PreCheckFile *file = [[PreCheckFile alloc] init];
    file.state = @1;
    file.hpcfcid = @(sender.tag - 20);
    
    NSMutableArray *array = [NSMutableArray array];
    for (PreCheckFile *model in selectArray) {
        [array addObject:model.hpcfcid];
    }
    
    if ([array containsObject:file.hpcfcid]) {
        NSInteger index;
        for (NSNumber *num in array) {
            if ([num isEqual:file.hpcfcid]) {
                break;
            }
            index++;
        }
        [selectArray removeObjectAtIndex:index];
    }else {
        [selectArray addObject:file];
    }
    
    NSMutableArray *array2 = [NSMutableArray array];
    for (PreCheckFile *model in selectArray) {
        [array2 addObject:model.hpcfcid];
    }
    
    for (UIButton *btn in btnArray) {
        if ([array2 containsObject:@(btn.tag - 20)]) {
            [btn setImage:[UIImage imageNamed:@"preCheck_select"] forState:UIControlStateNormal];
        }else {
            [btn setImage:[UIImage imageNamed:@"preCheck_unselect"] forState:UIControlStateNormal];
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

@end
