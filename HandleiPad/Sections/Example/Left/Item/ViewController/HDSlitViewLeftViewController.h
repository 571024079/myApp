//
//  HDSlitViewLeftViewController.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/8/30.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLeftViewController.h"

@interface HDSlitViewLeftViewController : BaseLeftViewController

//tableView

@property (strong, nonatomic) UITableView *tableView;

- (void)setTFregisterFirst;
//方案库赋值
- (void)setheaderViewDataSource;
//修改底部视图显示
- (void)changeBottomView;
//刷新方案库网络数据
- (void)refreshSchemeCub:(NSString *)noti;
//本地数据刷新界面
- (void)reloadLoadTableView:(NSDictionary *)noti;
//添加至收藏夹
- (void)addleftmodel:(NSDictionary *)sender;
//拖动时，滑动tableView至原点位置
- (void)scrollTableView:(NSDictionary *)sender;
//改变方案级别
- (void)changeCellModelCategory:(NSDictionary *)sender;
//滑动collectionView 中的item
- (void)scrollCollectionCell:(NSDictionary *)sender;
// 刷新我的方案
- (void)refreshMySchemeTabData;
@end
