//
//  MaterialRightWorkHoursTableViewCell.h
//  HandleiPad
//
//  Created by Robin on 2016/9/29.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MaterialRightModel.h"

typedef NS_ENUM(NSInteger, HoursCellType) {
    
    HoursCellTypeTop,
    HoursCellTypeBottom
};

typedef void(^TopCellSelectedBlock)(BOOL);

typedef void(^LongPressBlock)(void);

@interface MaterialRightWorkHoursTableViewCell : UITableViewCell

@property (assign, nonatomic) HoursCellType celltype;

@property (nonatomic, assign) BOOL cellSelected;

@property (nonatomic, copy) TopCellSelectedBlock topBlock;

@property (nonatomic, copy) LongPressBlock longTapBlock;

@property (nonatomic, strong) PorscheSchemeWorkHourModel *model;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end
