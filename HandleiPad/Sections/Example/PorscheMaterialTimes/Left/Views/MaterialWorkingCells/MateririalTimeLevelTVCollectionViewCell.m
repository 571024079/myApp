//
//  MateririalTimeLevelTVCollectionViewCell.m
//  HandleiPad
//
//  Created by 岳小龙 on 2016/12/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "MateririalTimeLevelTVCollectionViewCell.h"

@interface MateririalTimeLevelTVCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *contentButton;
@end

@implementation MateririalTimeLevelTVCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifer = @"MateririalTimeLevelTVCollectionViewCell";
    [collectionView registerNib:[UINib nibWithNibName:@"MateririalTimeLevelTVCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifer];
    MateririalTimeLevelTVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.contentButton.userInteractionEnabled = NO;
    
    self.layer.borderColor = MAIN_PLACEHOLDER_GRAY.CGColor;
    self.layer.borderWidth = .5f;
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    

    self.contentButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
}

- (void)setModel:(PorscheConstantModel *)model {
    
    _model = model;
    
    [self.contentButton setTitle:model.cvvaluedesc forState:UIControlStateNormal];
    NSString *imageName = [PorscheImageManager getSafetyColorImage:self.model.cvsubid.integerValue selected:NO];
    [self.contentButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
        
    UIColor *titleColor = selected ? [UIColor whiteColor] : MAIN_PLACEHOLDER_GRAY;
    NSString *imageName = [PorscheImageManager getSafetyColorImage:self.model.cvsubid.integerValue selected:selected];
    self.contentView.backgroundColor = selected ? MAIN_BLUE : [UIColor clearColor];
    [self.contentButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.contentButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
