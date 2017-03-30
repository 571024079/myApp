//
//  HDPopSelectTableView.h
//  HandleiPad
//
//  Created by handlecar on 2017/3/10.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDPopSelectTableView : UIView
@property (strong, nonatomic) NSMutableArray *dataSource;//列表数据

@property (copy, nonatomic) void(^selectCellButtonBlock)(NSInteger index);

+ (instancetype)loadPopSelectTableViewWithDataArray:(NSArray *)dataSource;



@end
