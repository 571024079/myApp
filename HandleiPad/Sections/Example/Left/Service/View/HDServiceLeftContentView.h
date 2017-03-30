//
//  HDServiceLeftContentView.h
//  HandleiPad
//
//  Created by handou on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDServiceLeftContentViewDelegate <NSObject>
- (void)tableViewDidSelectRowAtIndexPathWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath;

@end

@interface HDServiceLeftContentView : UIView
@property (nonatomic, assign) id<HDServiceLeftContentViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//右侧滚动条的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelGViewHeight;
//右侧滚动条距离顶部的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelGViewTopHeight;

// 列表数据
@property (nonatomic, strong) NSMutableArray *dataSource;
//显示状态(1->有购物车   2->没有购物车)
@property (nonatomic, strong) NSNumber *viewStatus;


- (instancetype)initWithCustomFrame:(CGRect)frame;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
