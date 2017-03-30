//
//  ProjectDetailPlanTableViewCell.h
//  HandleiPad
//
//  Created by Robin on 2016/10/16.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectDetailPlanSubCollectionCell.h"

@interface ProjectDetailPlanTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL editCell;

@property (nonatomic, assign) MaterialTaskTimeDetailsType cellType;

@property (nonatomic, assign) BOOL newObject;
@property (nonatomic) BOOL isFromNotice;

//+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (instancetype)speraCellWithTableView:(UITableView *)tableView withSperaModel:(PorscheSperaModel *)speraModel;

+ (instancetype)workHourCellWithTableView:(UITableView *)tableView withWorkHourModel:(PorscheWorkHoursModel *)workHourModel;

+ (instancetype)schemeCellWithTableView:(UITableView *)tableView withSchemeModel:(PorscheSchemeModel *)schemeModel;

@end
