//
//  ProjectDetialEditTableViewCell.h
//  HandleiPad
//
//  Created by Robin on 2016/10/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
//数据model

//typedef NS_ENUM(NSInteger, ProjectDetialEditTableViewCellType) {
//    
//    ProjectDetialEditTableViewCellTypeMaterial,
//    ProjectDetialEditTableViewCellTypeWorkHours
//};

@interface ProjectDetialEditTableViewCell : UITableViewCell

@property (nonatomic, assign) MaterialTaskTimeDetailsType type;
@property (nonatomic, assign) MaterialTaskTimeDetailsType detailType;

@property (nonatomic, strong) PorscheSchemeSpareModel *speraModel;
@property (nonatomic, strong) PorscheSchemeWorkHourModel *hoursModel;

@property (nonatomic, assign) BOOL editCell;
@property (nonatomic, assign) BOOL newCell;
@property (nonatomic) BOOL isFromNotice;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
