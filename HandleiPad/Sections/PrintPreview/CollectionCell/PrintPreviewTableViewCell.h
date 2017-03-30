//
//  PrintPreviewTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar on 10/17/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PrintPreviewTableViewCell_WorkHour, // 工时
    PrintPreviewTableViewCell_Spare,    // 备件
} PrintPreviewTableViewCellType;

@interface PrintPreviewTableViewCell : UITableViewCell

@property (nonatomic) PrintPreviewTableViewCellType cellType;

- (void)setCellContentWithModel:(id)model;

@end
