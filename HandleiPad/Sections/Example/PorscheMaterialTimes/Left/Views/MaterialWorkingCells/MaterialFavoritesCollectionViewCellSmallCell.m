//
//  MaterialFavoritesCollectionViewCellSmallCell.m
//  HandleiPad
//
//  Created by Robin on 16/10/31.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "MaterialFavoritesCollectionViewCellSmallCell.h"

@interface MaterialFavoritesCollectionViewCellSmallCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end

@implementation MaterialFavoritesCollectionViewCellSmallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PorscheSchemeModel *)model {
    
    _model = model;
    
    NSString *title;
    switch (model.schemelevelid.integerValue) {
        case 1:
            title = @"安全";
            break;
        case 2:
            title = @"隐患";
            break;
        case 3:
            title = @"信息";
            break;
        case 4:
            title = @"自定义";
            
            break;
        default:
            break;
    }
    self.titleLabel.text = title;
    NSString *imageName = [PorscheImageManager getSchemeSmallRectItemBackImage:model.schemelevelid.integerValue selected:YES];
    self.backImageView.image = [UIImage imageNamed:imageName];
    self.contentLabel.text = model.schemename;
}

@end
