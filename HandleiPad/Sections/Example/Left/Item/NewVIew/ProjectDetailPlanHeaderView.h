//
//  ProjectDetailPlanHeaderView.h
//  HandleiPad
//
//  Created by Robin on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectDetailPlanHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign) BOOL editType;

+ (instancetype)headerWithTableView:(UITableView *)tableView withSchemeModel:(PorscheSchemeModel *)schemeModel;

@end
