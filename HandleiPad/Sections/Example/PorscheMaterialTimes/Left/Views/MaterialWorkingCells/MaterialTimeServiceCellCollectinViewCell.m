//
//  MaterialTimeServiceCellCollectinViewCell.m
//  HandleiPad
//
//  Created by Robin on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "MaterialTimeServiceCellCollectinViewCell.h"

@interface MaterialTimeServiceCellCollectinViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@end
@implementation MaterialTimeServiceCellCollectinViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.borderColor = MAIN_PLACEHOLDER_GRAY.CGColor;
    self.layer.borderWidth = .5f;
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifer = @"MaterialTimeServiceCellCollectinViewCell";
    [collectionView registerNib:[UINib nibWithNibName:@"MaterialTimeServiceCellCollectinViewCell" bundle:nil] forCellWithReuseIdentifier:identifer];
    MaterialTimeServiceCellCollectinViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    return cell;
}

- (void)setCellSelected:(BOOL)cellSelected {
    
    _cellSelected = cellSelected;
    if (cellSelected) {
        
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.backgroundColor = MAIN_BLUE;
    } else {
        
        self.textLabel.textColor = MAIN_PLACEHOLDER_GRAY;
        self.textLabel.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setModel:(PorscheConstantModel *)model {
    
    _model = model;
    
    self.textLabel.text = model.cvvaluedesc;
}

@end
