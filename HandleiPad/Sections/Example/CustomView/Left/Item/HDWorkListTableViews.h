//
//  HDWorkListTableViews.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDWorkListTableViewsDirectionStyle) {
    HDWorkListTableViewsDirectionStyleUp = 1,// 上
    HDWorkListTableViewsDirectionStyleLeft,//左
    HDWorkListTableViewsDirectionStyleDown,//下
    HDWorkListTableViewsDirectionStyleRight,//右
};

typedef NS_ENUM(NSInteger, HDWorkListTableViewsStyle) {
    HDWorkListTableViewsStyleCategory = 1,// 分类
    HDWorkListTableViewsStyleItem,//业务
    HDWorkListTableViewsStyleTeam,//组别
    HDWorkListTableViewsStyleTeachcianHelper,//服务顾问
    //时间筛选
    HDWorkListTableViewsStyleTime,
    //进度筛选
    HDWorkListTableViewsStyleProgress,
    
    //备件库，图号，编号
    HDWorkListTableViewsStyleMaterialCub,
    //工时主组
    HDWorkListTableViewsStyleItemMain,
};

typedef void(^HDWorkListTableViewsBlock)(NSNumber *,BOOL,HDWorkListTableViewsStyle);
//车系选择headerView 中点击bT弹出选择界面
@interface HDWorkListTableViews : UIView

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//是否有详情
@property (nonatomic, assign) BOOL needAccessoryDisclosureIndicator;

@property (nonatomic, copy) HDWorkListTableViewsBlock block; 
//数据源
@property (nonatomic, strong) NSArray *dataSource;
//是否需要点击之后删除self。
@property (nonatomic, assign) BOOL isNeedDelete;

//选中
@property (nonatomic, assign) NSInteger selectedRow;
//标记是哪个地方选中，方便确定数据及其它
@property (nonatomic, assign) HDWorkListTableViewsStyle style;



- (instancetype)initWithCustomFrame:(CGRect)frame;


+ (HDWorkListTableViews *)showTableViewlistViewAroundView:(UIView *)aroundView direction:(UIPopoverArrowDirection)direction dataSource:(NSMutableArray *)dataSource size:(CGSize)size seletedNeedDelete:(BOOL)isNeed complete:(HDWorkListTableViewsBlock)complete;
+ (HDWorkListTableViews *)showTableViewlistViewAroundView:(UIView *)aroundView superView:(UIView *)superView direction:(UIPopoverArrowDirection)direction dataSource:(NSMutableArray *)dataSource size:(CGSize)size seletedNeedDelete:(BOOL)isNeed complete:(HDWorkListTableViewsBlock)complete;
@end
