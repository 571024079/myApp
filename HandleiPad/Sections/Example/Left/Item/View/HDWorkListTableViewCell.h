//
//  HDWorkListTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/8/31.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HDLeftSingleton.h"
#import "HDScreenPopFileView.h"

typedef NS_ENUM(NSInteger, HDWorkListTableViewCellStyle) {
    HDWorkListTableViewCellStyleDoubleTap = 1,//双击
    HDWorkListTableViewCellStyleBeginDrag,//拖动
};

typedef void(^HDWorkListTableViewCellBlock)(id model);

@interface HDWorkListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *leftScrollBt;

@property (weak, nonatomic) IBOutlet UIButton *rightScrollBt;

@property (weak, nonatomic) IBOutlet UIButton *leftImageButton;
@property (weak, nonatomic) IBOutlet UIButton *rightImageButton;
@property (weak, nonatomic) IBOutlet UIView *longgrayLine;
@property (nonatomic, strong) NSArray *idArray;


//点击的是哪个row
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

//row个数
//@property (nonatomic, assign) NSInteger itemCount;

//分类   <分区类别>
@property (nonatomic, strong) NSString *style;

//tableView的contentoffset.y

//收藏中的数据格式数组
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) HDWorkListTableViewCellBlock block;

//文件夹名称
@property (nonatomic, strong) NSMutableArray *nameArr;


//文件夹方法弹出视图
@property (nonatomic, strong) HDScreenPopFileView *popView;
//用于在详情方案进行数据上的数据上的处理的时候，让VC进行数据的刷新，实现数据的更新
@property (nonatomic, copy) void(^refreshFovriteListBlock)();

- (void)addLongPressAction;

//数据数组个数。
@property (nonatomic, strong) NSMutableArray *itemArray;

- (IBAction)leftScrollBtAction:(UIButton *)sender;

- (IBAction)rightScrollBtAction:(UIButton *)sender;









@end
