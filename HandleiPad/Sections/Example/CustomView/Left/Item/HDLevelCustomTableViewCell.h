//
//  HDLevelCustomTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/12/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDLevelCustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImg;

@property (weak, nonatomic) IBOutlet UILabel *levelLb;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineRIghtDis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftDis;

@end
