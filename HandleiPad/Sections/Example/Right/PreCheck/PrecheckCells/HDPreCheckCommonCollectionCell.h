//
//  HDPreCheckCommonCollectionCell.h
//  HandleiPad
//
//  Created by 程凯 on 2017/3/2.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDPreCheckCommonCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLb;//标题 label
@property (weak, nonatomic) IBOutlet UIView *topRightView;//顶部右侧图片的父视图
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;//顶部图片
@property (weak, nonatomic) IBOutlet UISlider *mySlider;// 进度拖动条

@property (weak, nonatomic) IBOutlet UITableView *tableView;//列表视图

@property (strong, nonatomic) NSNumber *wohasfuel;//燃油量

@property (strong, nonatomic) NSMutableArray *dataSource;//数据源

@property (copy, nonatomic) void(^saveCellDataBlock)(NSMutableArray *array);

@property (copy, nonatomic) void(^wohasfuelBlock)(NSNumber *wohasfuel);//回调油表

@property (strong, nonatomic) NSNumber *viewForm;//界面从什么地方过来

@end
