//
//  MaterialWorkingTableViewCell.h
//  MaterialDemo
//
//  Created by Robin on 16/9/26.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CellType) {
    
    MaterialWorkingTableViewCellTypeLevel = 1,
    MaterialWorkingTableViewCellTypeFavorite,
    MaterialWorkingTableViewCellTypeService
    
};


@interface MaterialWorkingTableViewCell : UITableViewCell

@property (nonatomic, assign) CellType cellType;

@property (nonatomic, assign) MaterialTaskTimeDetailsType detailType;

- (instancetype)initWithCellType:(CellType)celltype;

@end
