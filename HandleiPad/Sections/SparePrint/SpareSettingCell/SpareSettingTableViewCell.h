//
//  SpareSettingTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar on 2016/12/22.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpareSettingTableViewCell;
@protocol SpareSettingTableViewCellDelegate <NSObject>

- (void)spareSettingTableViewCell:(SpareSettingTableViewCell *) cell orderTypeButtonClick:(id)sender;

@end

@interface SpareSettingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *spareNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *needCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *spareDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;

@property (nonatomic, weak) id<SpareSettingTableViewCellDelegate>delegate;

@end
