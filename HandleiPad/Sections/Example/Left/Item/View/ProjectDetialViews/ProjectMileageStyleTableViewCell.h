//
//  ProjectMileageStyleTableViewCell.h
//  HandleiPad
//
//  Created by Robin on 2016/10/16.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapBlock)(NSInteger);
@interface ProjectMileageStyleTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL editCell;

@property (nonatomic, copy) NSString *mileageString;

@property (nonatomic, copy) NSString *timerString;

@property (nonatomic, copy) tapBlock editBlock;

@property (nonatomic, copy) tapBlock deleteBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView withMilesModel:(PorscheSchemeMilesModel *)milesModel MonthModel:(PorscheSchemeMonthModel *)monthModel;

@end
