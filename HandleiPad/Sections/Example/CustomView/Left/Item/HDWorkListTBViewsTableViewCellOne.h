//
//  HDWorkListTBViewsTableViewCellOne.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
//车系选择弹出框 中tableView中的cell

@interface HDWorkListTBViewsTableViewCellOne : UITableViewCell

//数据label
@property (weak, nonatomic) IBOutlet UILabel *label;
//详情图片
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@end
