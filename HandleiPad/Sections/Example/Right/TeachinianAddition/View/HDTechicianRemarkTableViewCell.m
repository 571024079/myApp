//
//  HDTechicianRemarkTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDTechicianRemarkTableViewCell.h"

@interface HDTechicianRemarkTableViewCell ()<UITextFieldDelegate>

@end

@implementation HDTechicianRemarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.remarkTF.delegate = self;

    // Initialization code
}


- (void)setTmpModel:(PorscheNewScheme *)tmpModel {
    _tmpModel = tmpModel;
    _remarkTF.text = nil;

    _remarkTF.attributedPlaceholder = [tmpModel.wosremark setTFplaceHolderWithMainGray];

    
    [self setImageRemarkNumber:tmpModel.statememo];
    [self setRemarkAppearance];
}

#pragma mark  ------delegate------

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];

    return YES;
    
}


// 备注行根据相关权限显示调整
- (void)setRemarkAppearance
{
    // 备注能否查看
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_Remark])
    {
        _remarkTF.attributedPlaceholder = nil;
    }
    else
    {
        _remarkTF.attributedPlaceholder = [_tmpModel.wosremark setTFplaceHolderWithMainGray];
    }
    
    BOOL isCanEdit;
    // 备注能否编辑
    if ([_saveStatus integerValue] || [HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_Remark_Edit])
    {
        isCanEdit = NO;
    }
    else
    {
        isCanEdit = YES;
    }
    
    [AlertViewHelpers setupCellTFView:_remarkTF save:!isCanEdit];

}

- (void)setImageRemarkNumber:(NSNumber *)number {
    _imageRemark.layer.masksToBounds = YES;
    _imageRemark.layer.cornerRadius = 3;
    _imageRemark.backgroundColor = MAIN_RED;
    _imageRemark.hidden = YES;
    if ([number integerValue] == 0) {
        _imageRemark.hidden = NO;
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:_remarkTF]) {
        if (self.HDTechicianRemarkTableViewCellBlock) {
            self.HDTechicianRemarkTableViewCellBlock(HDTechicianRemarkTableViewCellStyleTFReturn,textField.text);
        }
    }
}
//收键盘


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cameraBtAction:(UIButton *)sender {
    if ([_saveStatus integerValue]) {
        return;
    }
    if (self.HDTechicianRemarkTableViewCellBlock) {
        self.HDTechicianRemarkTableViewCellBlock(HDTechicianRemarkTableViewCellStyleCamera,nil);
    }
}

- (IBAction)photoBtAction:(UIButton *)sender {
    if ([_saveStatus integerValue]) {
        return;
    }
    if (self.HDTechicianRemarkTableViewCellBlock) {
        self.HDTechicianRemarkTableViewCellBlock(HDTechicianRemarkTableViewCellStylePhoto,nil);
    }
}
@end
