//
//  PrecheckSubTitleCollectionReusableView.m
//  HandleiPad
//
//  Created by Handlecar on 2017/3/2.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "PrecheckSubTitleCollectionReusableView.h"
#import "HDPreCheckModel.h"
#import "PorscheMultipleListhView.h"

@interface PrecheckSubTitleCollectionReusableView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldArray;
@property (weak, nonatomic) IBOutlet UIImageView *precheckNameImage;


@end

@implementation PrecheckSubTitleCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.cornerRadius = 3;
    self.contentView.layer.borderColor = PRECHECK_BORDER_COLOR.CGColor;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth = 1.0f;
    self.precheckNameImage.hidden = NO;
    //给所有的输入框设置代理
    for (UITextField *textFidle in _textFieldArray) {
        textFidle.delegate = self;
        textFidle.returnKeyType = UIReturnKeyDone;
        if (textFidle == _chejiahaoTF || textFidle == _carPlateTF || textFidle == _dateTF) {
            textFidle.userInteractionEnabled = NO;
            textFidle.borderStyle = UITextBorderStyleNone;
        }
        
    }
}
- (void)setViewForm:(NSNumber *)viewForm {
    _viewForm = viewForm;
    for (UITextField *textFidle in _textFieldArray) {
        if ([_viewForm integerValue] == 1) {
            textFidle.userInteractionEnabled = NO;
            textFidle.borderStyle = UITextBorderStyleNone;
        }
    }
    if ([_viewForm integerValue] == 1) {
        self.precheckNameImage.hidden = YES;
    }
}

- (void)setPreCheckData:(HDPreCheckModel *)preCheckData {
    _preCheckData = preCheckData;
    if (_preCheckData) {
        _orderNumTF.text = _preCheckData.dmsno;
        _checkStaffNameTF.text = _preCheckData.checkpersonname;
        _chejiahaoTF.text = _preCheckData.vin;
        _carPlateTF.text = _preCheckData.plateall;
        _dateTF.text = [_preCheckData.checkday convertFromFormat:@"yyyyMMddHHmmss" toAnotherFormat:@"yyyy-MM-dd"];
        _currentMileageTF.text = @"";
        NSString *moleageStr = _preCheckData.curmiles ? [[NSString formatMoneyStringWithMilesFloat:_preCheckData.curmiles.floatValue] stringByAppendingString:@"公里"] : @"";
        _currentMileageTF.attributedPlaceholder = [moleageStr setTFplaceHolderWithMainGrayWithColor:[UIColor blackColor]];
    }
}


#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSString *moleageStr = _preCheckData.curmiles ? [[NSString formatMoneyStringWithMilesFloat:_preCheckData.curmiles.floatValue] stringByAppendingString:@"公里"] : @"";
    _currentMileageTF.attributedPlaceholder = [moleageStr setTFplaceHolderWithMainGrayWithColor:[UIColor lightGrayColor]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!textField.text.length) {
        textField.text = textField.placeholder;
    }
    
    if (_textFieldBlock) {
        _textFieldBlock((PrecheckSubTitleTF)textField.tag, textField, nil);
    }
}

- (IBAction)checkStaffButtonAction:(UIButton *)sender {
    if ([_viewForm integerValue] == 1) {
        return;
    }
    [self showChooseBottomNameWithTF:sender];
}

- (void)showChooseBottomNameWithTF:(UIButton *)button {

    WeakObject(self);
    // 获取组中员工数组
    [PorscheRequestManager getStaffListTestWithGroupId:@1 positionId:@3 complete:^(NSMutableArray * _Nonnull classifyArray, PResponseModel * _Nonnull responser) {
        
        __block BOOL isMore = NO;
        __block PorscheConstantModel *tmpModel;
        if (classifyArray.count) {
            for (PorscheConstantModel *tmp in classifyArray) {
                if ([tmp.cvsubid integerValue] != 1) {
                    isMore = YES;
                }else {
                    tmpModel = tmp;
                }
                
            }
        }
        
        PorscheConstantModel *more;
        if (isMore) {
            more = [PorscheConstantModel new];
            more.cvsubid = @-1;
            more.cvvaluedesc = @"其他";
            [classifyArray insertObject:more atIndex:0];
        }
        
        NSMutableArray *groupArray = [classifyArray mutableCopy];
        if (tmpModel) {
            [groupArray removeObject:tmpModel];
        }
        
        
        [PorscheMultipleListhView showSingleListViewFrom:button dataSource:groupArray selected:nil showArrow:NO direction:ListViewDirectionUp complete:^(PorscheConstantModel *constantModel, NSInteger idx) {
            if ([constantModel.cvsubid isEqual:@-1] && [constantModel.cvvaluedesc isEqualToString:@"其他"]) {
                selfWeak.checkStaffNameTF.text = @"";
            }else {
                selfWeak.checkStaffNameTF.text = constantModel.cvvaluedesc;
            }
            if (selfWeak.textFieldBlock) {
                selfWeak.textFieldBlock((PrecheckSubTitleTF)selfWeak.checkStaffNameTF.tag, selfWeak.checkStaffNameTF, constantModel);
            }
        }];
    }];
    
}


@end
