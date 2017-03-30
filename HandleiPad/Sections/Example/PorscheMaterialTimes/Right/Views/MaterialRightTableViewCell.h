//
//  MaterialRightTableViewCell.h
//  MaterialDemo
//
//  Created by Robin on 16/9/27.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MaterialRightModel.h"

typedef NS_ENUM(NSInteger, CellType) {
    
    CellTypeWaiting,
    CellTypeSelected
};

typedef void(^TopCellSelectedBlock)(BOOL topCell);

typedef void(^LongPressBlock)(void);

@interface MaterialRightTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fristItemLayoutWidth;

@property (assign, nonatomic) CellType celltype;

@property (nonatomic, assign) BOOL cellSelected;

@property (nonatomic, copy) TopCellSelectedBlock topBlock;

@property (nonatomic, copy) LongPressBlock longTapBlock;

//@property (nonatomic, strong) PorscheSchemews *model;

@property (nonatomic, strong) PorscheSchemeSpareModel *model;

@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end
