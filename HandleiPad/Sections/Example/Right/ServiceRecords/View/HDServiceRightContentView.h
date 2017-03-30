//
//  HDServiceRightContentView.h
//  HandleiPad
//
//  Created by handou on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDServiceRecordsHelper.h"//助手


@interface HDServiceRightContentView : UIView

//tableview
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) HDServiceRecordsRightModel *rightModel;
//右侧cell点击回调(过渡层)
@property (nonatomic, copy) void(^contentViewCellBlock)(NSMutableArray *array, HDServiceRecordsRightModel *model);
//回调刷新VC数据(过渡层)
@property (nonatomic, copy) void(^refreshVCBlock)();

//显示状态
@property (nonatomic, assign) ServiceRightBottomViewStyle viewStyle;

- (instancetype)initWithCustomFrame:(CGRect)frame;

@end
