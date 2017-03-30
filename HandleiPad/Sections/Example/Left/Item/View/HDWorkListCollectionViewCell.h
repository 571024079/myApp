//
//  HDWorkListCollectionViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/8/31.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PorscheItemModel.h"
@class HDWorkListCollectionViewCell;

typedef NS_ENUM(NSInteger, HDWorkListCollectionViewCellTapStyle) {
    HDWorkListCollectionViewCellTapStyleOne = 1,// 单击
    HDWorkListCollectionViewCellTapStyleTwo,//双击
};

typedef void(^HDWorkListCollectionViewCellBlock)(UIView *,HDWorkListCollectionViewCellTapStyle);

typedef void(^HDWorkListCollectionViewCellClickBlock)();

@interface HDWorkListCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSDate *date;
//workListCVCell--one
//----------------------------------方案库属性
@property (weak, nonatomic) IBOutlet UIImageView *oneCellBGImgTwo;

//当工时文字小于7.用来合并显示工时和价格
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *oneCellBGImg;
//工时名字
@property (weak, nonatomic) IBOutlet UILabel *oneCellContentLb;
//价格
@property (weak, nonatomic) IBOutlet UILabel *oneCellPriceLb;
//分类文本框：安全，信息，隐患，价格，方案.....
@property (weak, nonatomic) IBOutlet UILabel *categoryLb;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
//显示详情标识
@property (weak, nonatomic) IBOutlet UIImageView *detialImg;

//-------------------------------外加提醒通知属性
@property (weak, nonatomic) IBOutlet UILabel *noticeLb;


//单击
@property (nonatomic, assign) BOOL tapSingle;

@property (nonatomic, copy) HDWorkListCollectionViewCellBlock block;

@property (nonatomic, copy) HDWorkListCollectionViewCellClickBlock clickBlock;

@property (nonatomic, assign) NSTimeInterval startTime;

@property (nonatomic, assign) NSTimeInterval endTime;

@property (nonatomic, assign) NSInteger tapCount;

@property (nonatomic, strong) PorscheCarMessage *model;

//设置方案图片背景色，和选中图片 钩钩的颜色
//- (void)setPicTinColor:(UIColor *)color imageOne:(NSString *)imageOne imageTwo:(NSString *)imageTwo selectedImg:(NSString *)selectedImg;
//设置default hidden
- (void)setDefaultHidden;


@end
