//
//  ProjectDetailTableView.h
//  KeyBoardDemo
//
//  Created by Robin on 2016/10/15.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectDetailTableView : UITableViewCell

@property (nonatomic, assign) MaterialTaskTimeDetailsType cellType;

@property (nonatomic, assign) BOOL editCell;

@property (nonatomic, assign) BOOL newcell;

@property (nonatomic, strong) PorscheSchemeModel *schemeModel;
@property (nonatomic, assign) BOOL new_object;

@property (nonatomic) BOOL isFromNotice;
@property (nonatomic) BOOL numberAndNameCannotEdit;  // YES 不可编辑

//+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(MaterialTaskTimeDetailsType)cellType;

+ (instancetype)cellWithTableView:(UITableView *)tableView workHours:(NSArray *)workHourArray speras:(NSArray *)speraArray cellType:(MaterialTaskTimeDetailsType)cellType;

@end
