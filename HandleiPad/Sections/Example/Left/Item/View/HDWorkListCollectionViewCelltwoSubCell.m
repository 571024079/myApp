//
//  HDWorkListCollectionViewCelltwoSubCell.m
//  HandleiPad
//
//  Created by Robin on 16/11/7.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDWorkListCollectionViewCelltwoSubCell.h"

@interface HDWorkListCollectionViewCelltwoSubCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation HDWorkListCollectionViewCelltwoSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PorscheNewScheme *)model {
    /*
    _model = model;
    
    NSString *title;
    switch (model.modelCategoryStyle) {
        case PorscheItemModelCategooryStyleSave:
            title = @"安全";
            break;
        case PorscheItemModelCategooryStyleHiddenDanger:
            title = @"隐患";
            break;
        case PorscheItemModelCategooryStyleMessage:
            title = @"信息";
            break;
        case PorscheItemModelCategooryStyleCustom:
            title = @"自定义";
            
            break;
        default:
            break;
    }
    self.titleLabel.text = title;
    NSString *imageName = [PorscheImageManager getSchemeSmallRectItemBackImage:model.modelCategoryStyle selected:YES];
    self.backImageView.image = [UIImage imageNamed:imageName];
    self.contentLabel.text = model.schemename;
     */
}


//设置cell的数据
- (void)loadCellDataFor:(PorscheSchemeModel *)data {
    self.titleLabel.text = data.schemelevelname;
    self.contentLabel.text = data.schemename;
    NSString *imageName = [PorscheImageManager getSchemeSmallRectItemBackImage:(PorscheItemModelCategooryStyle)[data.schemelevelid integerValue] selected:YES];
    self.backImageView.image = [UIImage imageNamed:imageName];
}


@end
