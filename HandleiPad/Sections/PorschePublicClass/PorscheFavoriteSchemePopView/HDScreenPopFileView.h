//
//  HDScreenPopFileView.h
//  HandleiPad
//
//  Created by handou on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDScreenPopFileView : UIView

@property (nonatomic, assign) BOOL beginEdit;

//存放所有的收藏夹
@property (nonatomic, strong) NSMutableArray *favorialDataArray;
// 标题
@property (nonatomic, copy) NSString *titleName;
//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
//判断是不是新建收藏夹的时候进入的
@property (nonatomic, assign) BOOL isNew;
//接收工单中的方案列表，便于将特定数据添加到方案数据中
@property (nonatomic, strong) NSMutableArray *inOrderFanganArray;

//收起视图回调
@property (nonatomic, copy) void(^backBlock)();
@property (nonatomic, copy) void(^shouldReturnBlock)(NSString *string);
@property (nonatomic, copy) void(^deleteFavoritBlock)();

- (instancetype)initWithCustomFrame:(CGRect)frame;
- (void)backWithTap:(UITapGestureRecognizer *)tapG;

@end
