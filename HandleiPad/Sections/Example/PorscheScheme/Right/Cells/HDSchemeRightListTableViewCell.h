//
//  HDSchemeRightListTableViewCell.h
//  HandleiPad
//
//  Created by Robin on 16/10/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MaterialRightModel.h"
#import "PorscheCarModel.h"

typedef void(^HDSchemeRightListTableViewCellChickBlock)();
typedef void(^HDSchemeRightListTableViewCellLongTapBlock)();
@interface HDSchemeRightListTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL deleteButton;
@property (nonatomic, assign) BOOL cellSelected;
@property (nonatomic, assign) BOOL hiddenSelected;
@property (weak, nonatomic) IBOutlet UIButton *chickButton;

@property (nonatomic, strong) PorscheSchemeModel *model;
@property (nonatomic, copy) HDSchemeRightListTableViewCellChickBlock chickBlock;
@property (nonatomic, copy) HDSchemeRightListTableViewCellLongTapBlock longTapBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
