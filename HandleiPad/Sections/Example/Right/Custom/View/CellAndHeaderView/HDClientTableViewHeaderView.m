//
//  HDClientTableViewHeaderView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDClientTableViewHeaderView.h"

@interface HDClientTableViewHeaderView ()

@property (nonatomic, strong) NSArray *customImgArray;

@end

@implementation HDClientTableViewHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setTmpModel:(PorscheNewScheme *)tmpModel {
    
    _tmpModel = tmpModel;
    
    _headerLb.text = tmpModel.schemename;
    
    if (![tmpModel.wosisconfirm isEqualToNumber:@0]) {
        [self setconfirmImageWithBool:YES];
    }else {
        [self setconfirmImageWithBool:NO];
    }
    
    [self setupHeaderImageView];
}

- (void)setconfirmImageWithBool:(BOOL)isConfirm {
    if (isConfirm) {
        [_sureBt setImage:[UIImage imageNamed:@"work_list_32.png"] forState:UIControlStateNormal];
        _sureLb.text = @"已确认";
    }else {
        [_sureBt setImage:[UIImage imageNamed:@"worklist_unconfirm_item.png"] forState:UIControlStateNormal];
        _sureLb.text = @"未确认";
    }
}

- (void)setupHeaderImageView {
    
    //设置项目的分类图标
    _headerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"work_list_scheme_level_%@.png",_tmpModel.schemelevelid]];

    
}


@end
