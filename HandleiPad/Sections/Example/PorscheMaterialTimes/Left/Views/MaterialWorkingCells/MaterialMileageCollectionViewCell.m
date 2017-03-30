//
//  MaterialMileageCollectionViewCell.m
//  MaterialDemo
//
//  Created by Robin on 16/9/27.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "MaterialMileageCollectionViewCell.h"

typedef NS_ENUM(NSInteger, CellStatus) {
    
    cellStatusSelected,
    cellStatusNormal
};

@interface MaterialMileageCollectionViewCell ()

@end

@implementation MaterialMileageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MaterialMileageCollectionViewCell" owner:nil options:nil] firstObject];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self setShadow];
}

- (void)setShadow {
    
    self.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    self.layer.borderColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1].CGColor;
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
}

- (void)setSelectedStatus:(BOOL)selectedStatus {
    
    _selectedStatus = selectedStatus;

    _mileageLabel.textColor = selectedStatus ? [UIColor whiteColor] : [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1];
    
    _bgImageView.image = selectedStatus ? [UIImage imageNamed:@"hd_work_list_clean.png"] : nil;
    
}

@end
