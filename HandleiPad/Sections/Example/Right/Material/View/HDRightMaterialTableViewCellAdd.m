//
//  HDRightMaterialTableViewCellAdd.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDRightMaterialTableViewCellAdd.h"

@implementation HDRightMaterialTableViewCellAdd

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)downBtAction:(UIButton *)sender {
    
    if (self.hDRightMaterialTableViewCellAddBlock) {
        self.hDRightMaterialTableViewCellAddBlock(HDRightMaterialTableViewCellAddStyleDown,sender);
    }
    
    
    
}
@end
