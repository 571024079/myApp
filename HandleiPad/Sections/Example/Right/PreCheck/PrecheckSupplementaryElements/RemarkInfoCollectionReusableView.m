//
//  RemarkInfoCollectionReusableView.m
//  HandleiPad
//
//  Created by Handlecar on 2017/3/2.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "RemarkInfoCollectionReusableView.h"
#import "HDPreCheckModel.h"

@interface RemarkInfoCollectionReusableView ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSMutableArray *selectArray;//选择的项目集合
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *servicebtnArray;


@end

@implementation RemarkInfoCollectionReusableView
- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.borderColor = PRECHECK_BORDER_COLOR.CGColor;
    self.textView.layer.borderWidth = 0.5f;
    self.textView.layer.masksToBounds = YES;
    self.textView.userInteractionEnabled = YES;
    self.textView.delegate = self;
    
    [self setLabelTextStyleWithLabel:_beizhuNameLb];
    [self setLabelTextStyleWithLabel:_qitafuwuNameLb];
}
- (void)setViewForm:(NSNumber *)viewForm {
    _viewForm = viewForm;
    if ([_viewForm integerValue] == 1) {
        self.textView.layer.cornerRadius = 0;
        self.textView.layer.borderColor = [UIColor clearColor].CGColor;
        self.textView.layer.borderWidth = 0;
        self.textView.layer.masksToBounds = NO;
        self.textView.userInteractionEnabled = NO;
    }
}

- (void)setPreCheckData:(HDPreCheckModel *)preCheckData {
    _preCheckData = preCheckData;
    if (_preCheckData) {
        
        _textView.text = _preCheckData.remark;
        
        
        if (_preCheckData.otherservices.count) {
            _selectArray = [NSMutableArray arrayWithArray:_preCheckData.otherservices];
            
            NSMutableArray *array2 = [NSMutableArray array];
            for (PreCheckOtherService *model in _selectArray) {
                model.state = @1;
                [array2 addObject:model.hpcscid];
            }
            for (UIButton *btn in _servicebtnArray) {
                if ([array2 containsObject:@(btn.tag)]) {
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

#pragma mark - 按钮的点击事件
- (IBAction)selectButtonAction:(UIButton *)sender {
    if ([_viewForm integerValue] == 1) {
        return;
    }
    
    PreCheckOtherService *type = [[PreCheckOtherService alloc] init];
    type.state = @1;
    type.hpcscid = @(sender.tag);
    
    NSMutableArray *array = [NSMutableArray array];
    for (PreCheckOtherService *model in self.selectArray) {
        [array addObject:model.hpcscid];
    }
    
    if ([array containsObject:type.hpcscid]) {
        NSInteger index = 0;
        for (NSNumber *num in array) {
            if ([num isEqual:type.hpcscid]) {
                break;
            }
            index++;
        }
        [self.self.selectArray removeObjectAtIndex:index];
    }else {
        [self.self.selectArray addObject:type];
    }
    
    NSMutableArray *array2 = [NSMutableArray array];
    for (PreCheckOtherService *model in self.self.selectArray) {
        [array2 addObject:model.hpcscid];
    }
    
    for (UIButton *btn in _servicebtnArray) {
        if ([array2 containsObject:@(btn.tag)]) {
            [btn setImage:[UIImage imageNamed:@"preCheck_select"] forState:UIControlStateNormal];
        }else {
            [btn setImage:[UIImage imageNamed:@"preCheck_unselect"] forState:UIControlStateNormal];
        }
    }
    
    if (_selectBtnBlock) {
        _selectBtnBlock(_selectArray);
    }
    
}


#pragma mark - TextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_textViewBlock) {
        _textViewBlock(textView);
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
