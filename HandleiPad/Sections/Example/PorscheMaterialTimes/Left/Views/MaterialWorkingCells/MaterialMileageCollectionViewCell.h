//
//  MaterialMileageCollectionViewCell.h
//  MaterialDemo
//
//  Created by Robin on 16/9/27.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialMileageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic, assign) BOOL selectedStatus;
@end
