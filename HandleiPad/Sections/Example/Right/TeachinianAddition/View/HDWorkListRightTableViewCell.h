//
//  HDWorkListRightTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/1.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PorscheItemModel.h"

typedef NS_ENUM(NSInteger, CameraAndPicStyle) {
    CameraAndPicStyleCamera = 1,//拍照
    CameraAndPicStylePic,//图片
    LongPressStyle,//cell添加的长按
    chooseBtStyle,
    TextFIeldStyleEndEditting,
    
};

typedef void(^HDWorkListRightTableViewCellBlock)(CameraAndPicStyle,UIView *);
typedef void(^GuaranteeActionBlock)(UIButton *);
typedef void(^HDWorkListRightTableViewReturnBlock)(PorscheNewSchemews *schemews);
@interface HDWorkListRightTableViewCell : UITableViewCell
@property (nonatomic, strong) HDWorkListRightTableViewReturnBlock addedReturnBlock;
//工时imageView
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
//工时编号
@property (weak, nonatomic) IBOutlet UILabel *headerNumLb;
//服务项目
@property (weak, nonatomic) IBOutlet UILabel *seviceLb;
//工时单价
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;
//工时输入
@property (weak, nonatomic) IBOutlet UITextField *itemCountTF;
//工时显示
@property (weak, nonatomic) IBOutlet UILabel *itemCountLb;

//工时总价
@property (weak, nonatomic) IBOutlet UILabel *itemTotalPrice;

//选择背景视图
@property (weak, nonatomic) IBOutlet UIView *chooseBgView;

//选择Bt
@property (weak, nonatomic) IBOutlet UIButton *chooseBt;
//选择按钮改变图片
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;
//拍照Bt
@property (weak, nonatomic) IBOutlet UIButton *cameraBt;
//查看图片Bt
@property (weak, nonatomic) IBOutlet UIButton *picBt;

@property (weak, nonatomic) IBOutlet UILabel *itemTimeSureLb;

//保修图片
@property (weak, nonatomic) IBOutlet UIImageView *guaranteeImg;
@property (weak, nonatomic) IBOutlet UIButton *changeGuaranteeBt;
//保修 弹出
@property (nonatomic, copy) GuaranteeActionBlock guaranteeActionBlock;

@property (nonatomic, copy) HDWorkListRightTableViewCellBlock block;

// 是否处于保存状态 0.非保存  1.保存
@property (nonatomic, strong) NSNumber *saveStatus;

@property (nonatomic, strong) PorscheNewSchemews *tmpModel;
//修改工时保修状态
- (IBAction)changeGuaranteeBtAction:(UIButton *)sender;



- (IBAction)cameraBtAction:(UIButton *)sender;
- (IBAction)picBtAction:(UIButton *)sender;
- (IBAction)chooseBtAction:(UIButton *)sender;


@end
