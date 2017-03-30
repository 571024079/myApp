//
//  ProjectDetialWorkHourEditTableViewCell.h
//  HandleiPad
//
//  Created by Robin on 2016/11/17.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectDetialWorkHourEditTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL editCell;

@property (nonatomic, strong) PorscheSchemeSpareModel *speraModel;

@property (nonatomic) BOOL newCell;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
