//
//  HDLeftNoticeLocationView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>


//--------------------------------本店提醒
@interface HDLeftNoticeLocationView : UIView
//本店提醒
@property (weak, nonatomic) IBOutlet UILabel *headerLb;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//左右箭头
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
//左右箭头覆盖按钮，
@property (weak, nonatomic) IBOutlet UIButton *leftBt;

@property (weak, nonatomic) IBOutlet UIButton *rightBt;

//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

// 提醒列表当前提醒
@property (nonatomic, strong) HDLeftNoticeListModel *model;

//左右按钮事件
- (IBAction)leftBtAction:(UIButton *)sender;

- (IBAction)rightBtAction:(UIButton *)sender;


- (instancetype)initWithCustomFrame:(CGRect)frame;



@end
