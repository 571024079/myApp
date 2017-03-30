//
//  PorscheMultipleListTableViewCell.h
//  HandleiPad
//
//  Created by Robin on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PorscheMultipleListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@property (nonatomic, assign) BOOL select;

@property (nonatomic, assign) BOOL mutltiple;

+ (instancetype)cellWithTableVIew:(UITableView *)tableView;

@end
