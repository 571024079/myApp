//
//  HDScreenPopFileCellCollectionViewCell.m
//  HandleiPad
//
//  Created by Robin on 16/11/2.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDScreenPopFileCellCollectionViewCell.h"

@interface HDScreenPopFileCellCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@end

@implementation HDScreenPopFileCellCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PorscheSchemeModel *)model {
    
    _model  = model;
    
    switch (model.schemelevelid.integerValue) {
        case 1:
            self.levelLabel.text = @"安全";
            self.selectedImageView.image = [UIImage imageNamed:@"work_list_31"];
            break;
        case 3:
            self.levelLabel.text = @"信息";
            self.selectedImageView.image = [UIImage imageNamed:@"work_list_32"];
            break;
        case 2:
            self.levelLabel.text = @"隐患";
            self.selectedImageView.image = [UIImage imageNamed:@"work_list_33"];
            break;
        case 4:
            self.levelLabel.text = @"自定义";
            self.selectedImageView.image = [UIImage imageNamed:@"work_list_713"];
            break;
        default:
            break;
    }
    self.bgImageView.image = [UIImage imageNamed:[PorscheImageManager getSchemeSmallRectItemBackImage:model.schemelevelid.integerValue selected:NO]];
//    self.contentLabel.text = model.schemename;
    [self setShowSchemeNameLengthWithName:model.schemename];
    self.priceLabel.text  = [NSString formatMoneyStringWithFloat:model.schemeprice.floatValue
                             ];
//    self.selectedImageView.hidden = YES;
//    self.cellSelected = model.flag;
    BOOL isSelect = [model.flag integerValue] == 1?YES:NO;
    self.selectedImageView.hidden = !isSelect;
    self.bgImageView.image = [UIImage imageNamed:[PorscheImageManager getSchemeSmallRectItemBackImage:self.model.schemelevelid.integerValue selected:isSelect]];
}

//- (void)setCellSelected:(BOOL)cellSelected {
//    
//    _cellSelected = cellSelected;
//    
//    self.selectedImageView.hidden = !cellSelected;
//    self.bgImageView.image = [UIImage imageNamed:[PorscheImageManager getSchemeSmallRectItemBackImage:self.model.schemelevelid.integerValue selected:cellSelected]];
//}


#pragma mark - 设置显示收藏夹方案的名称长度
- (void)setShowSchemeNameLengthWithName:(NSString *)nameStr {
    NSString *endString = nameStr;
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    //工时文字个数7，显示为上5，下显示其余
    if (nameStr.length == 7) {
        NSString *string = [nameStr substringToIndex:5];
        NSString *lastString = [nameStr substringFromIndex:5];
        endString = [NSString stringWithFormat:@"%@\n%@", string, lastString]; // 设置特定字符长度换行
        self.contentLabel.text = endString;
        
    }else if (nameStr.length > 7 && nameStr.length<= 10){//工时文字小于7，价格和工时
        NSString *string = [nameStr substringToIndex:6];
        NSString *lastString = [nameStr substringFromIndex:6];
        endString = [NSString stringWithFormat:@"%@\n%@", string, lastString]; // 设置特定字符长度换行
        self.contentLabel.text = endString;
        
    }else if (nameStr.length < 7){
        self.contentLabel.text = endString;
    }else {
        NSString *contentStr = [nameStr substringToIndex:10];
        NSString *string = [contentStr substringToIndex:6];
        NSString *lastString = [contentStr substringFromIndex:6];
        NSString *endString = [NSString stringWithFormat:@"%@\n%@…", string, lastString]; // 设置特定字符长度换行
        self.contentLabel.text = endString;
    }
}

@end
