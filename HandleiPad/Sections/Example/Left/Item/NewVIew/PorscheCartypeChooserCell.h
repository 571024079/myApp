//
//  PorscheCartypeChooserCell.h
//  HandleiPad
//
//  Created by Robin on 16/10/27.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PorscheCartypeChooserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) BOOL multipleCell;

@property (nonatomic, assign) BOOL cellSelected;

+ (instancetype)cellWithTableView:(UITableView *)tableView identifer:(NSString *)identifer;

@end
