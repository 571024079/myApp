//
//  HDNetworkTableViewCell.h
//  HandleiPad
//
//  Created by Robin on 16/11/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDNetworkTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *webLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
