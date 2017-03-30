//
//  PrecheckCarBodyCollectionViewCell.h
//  HandleiPad
//
//  Created by Handlecar on 2017/3/2.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDPreCheckModel;
@class HDPreCheckViewController;

@interface PrecheckCarBodyCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLb;//操作步骤标题
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;//车型图片
//(右)侧前车轮胎纹深度
@property (weak, nonatomic) IBOutlet UITextField *rightFrontWheelTaiwenShenduTF;
//(右)侧前车轮轮胎年限
@property (weak, nonatomic) IBOutlet UITextField *rightFrontWheelTyreYearTF;
//(右)侧后车轮胎纹深度
@property (weak, nonatomic) IBOutlet UITextField *rightRearWheelsTaiwenYearTF;
//(右)侧后车轮轮胎年限
@property (weak, nonatomic) IBOutlet UITextField *rightRearWheelTyreYearTF;

//(左)侧前车轮胎纹深度
@property (weak, nonatomic) IBOutlet UITextField *leftFrontWheelTaiwenShenduTF;
//(左)侧前车轮轮胎年限
@property (weak, nonatomic) IBOutlet UITextField *leftFrontWheelTyreYearTF;
//(左)侧后车轮胎纹深度
@property (weak, nonatomic) IBOutlet UITextField *leftRearWheelsTaiwenYearTF;
//(左)侧后车轮轮胎年限
@property (weak, nonatomic) IBOutlet UITextField *leftRearWheelTyreYearTF;

@property (copy, nonatomic) void(^selectShifouPaizhaoBlock)(NSNumber *isStay);//已拍照照片文档 -> 回调选择按钮的点击事件

@property (strong, nonatomic) HDPreCheckModel *preCheckData;


@property (copy, nonatomic) void(^saveDataBlock)(HDPreCheckModel *checkData);

@property (strong, nonatomic) NSNumber *viewForm;//界面从什么地方过来

@end
