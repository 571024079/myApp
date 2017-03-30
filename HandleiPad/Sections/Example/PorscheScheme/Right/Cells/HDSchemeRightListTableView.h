//
//  HDSchemeRightListTableView.h
//  HandleiPad
//
//  Created by Robin on 16/10/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HDSchemeRightListTableViewShowDetailBlock)(NSInteger);
typedef void(^HDSchemeRightListTableViewRefreshUIBlock)();
@interface HDSchemeRightListTableView : UIView

- (void)refreshTableViewWithDataSource:(NSMutableArray *)dataSource;

+ (instancetype)viewWithNibdataSource:(NSMutableArray *)dataSoure addSource:(NSMutableArray *)addSource;

@property (nonatomic, copy) HDSchemeRightListTableViewShowDetailBlock showDetailBlock;

@property (nonatomic, copy) HDSchemeRightListTableViewRefreshUIBlock refreshBlock;

@property (nonatomic, copy) void(^loadDataBlock)(BOOL more);

@property (nonatomic, assign) NSInteger cellCount;

@property (weak, nonatomic) IBOutlet UITableView *topTableView;
@property (weak, nonatomic) IBOutlet UITableView *bottomTableView;

@property (nonatomic, assign) BOOL hiddenBottomView;

@property (weak, nonatomic) IBOutlet UILabel *selectedLb;



@end
