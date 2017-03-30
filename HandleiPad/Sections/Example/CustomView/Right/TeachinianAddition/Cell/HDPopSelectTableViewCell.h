//
//  HDPopSelectTableViewCell.h
//  HandleiPad
//
//  Created by handlecar on 2017/3/10.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDPopSelectTableViewCell;

@protocol HDPopSelectTableViewCellDelegate <NSObject>
- (void)tableViewCellRightButtonActionWith:(UIButton *)button withCell:(HDPopSelectTableViewCell *)thisCell;

@end

@interface HDPopSelectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftContentLb;//左侧内容
@property (weak, nonatomic) IBOutlet UIButton *rightButton;//右侧按钮
@property (weak, nonatomic) IBOutlet UIView *leftLine;//左侧横线
@property (weak, nonatomic) IBOutlet UIView *rightLine;//右侧横线


@property (assign, nonatomic) id<HDPopSelectTableViewCellDelegate>delegate;//设置代理


@end
