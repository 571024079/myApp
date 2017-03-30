//
//  HDRightMaterialRemarkTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDRightMaterialRemarkTableViewCell.h"

@implementation HDRightMaterialRemarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cameraBtAction:(UIButton *)sender {
    if ([_saveStatus integerValue] == 1) {
        return;
    }
    
    if (self.hDRightMaterialRemarkTableViewCellBlock) {
        self.hDRightMaterialRemarkTableViewCellBlock(HDRightMaterialRemarkTableViewCellStyleCamera, sender);
    }
}

- (IBAction)photoBtAction:(UIButton *)sender {
    if ([_saveStatus integerValue] == 1) {
        return;
    }
    if (self.hDRightMaterialRemarkTableViewCellBlock) {
        self.hDRightMaterialRemarkTableViewCellBlock(HDRightMaterialRemarkTableViewCellStylePhoto, sender);
    }
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
@end
