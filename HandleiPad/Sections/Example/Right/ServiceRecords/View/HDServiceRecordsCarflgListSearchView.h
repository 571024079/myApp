//
//  HDServiceRecordsCarflgListSearchView.h
//  HandleiPad
//
//  Created by handlecar on 16/12/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDServiceRecordsCarflgListSearchView : UIView
//标签输入提示界面列表数据
@property (nonatomic, strong) NSMutableArray *carflgSearchList;
// 让VC刷新数据
@property (nonatomic, copy) void(^selectCellBlock)(HDServiceRecordsCarflgTableViewModel *model);
@end








@interface HDServiceRecordsCarflgListSearchViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end
