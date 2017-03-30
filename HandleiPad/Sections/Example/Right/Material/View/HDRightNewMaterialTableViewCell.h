//
//  HDRightNewMaterialTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, HDRightNewMaterialTableViewCellStyle) {
    HDRightNewMaterialTableViewCellStyleChoose = 1,// 选择
    HDRightNewMaterialTableViewCellStyleAdd,//添加
    HDRightNewMaterialTableViewCellStyleTF,//编辑框<图号编号>
    HDRightNewMaterialTableViewCellStyleNormalTF,//非图号编号编辑器
    HDRightNewMaterialTableViewCellStyleReturn,//完成键
    HDRightNewMaterialTableViewCellStyleAddCub,//添加库存
};

typedef void(^HDRightNewMaterialTableViewCellBlock)(HDRightNewMaterialTableViewCellStyle,UIButton *);
typedef void(^AddedReturnBlock)(PorscheNewSchemews *);
typedef void(^AddedCubMaterialBlock)(BOOL ,PorscheNewSchemews *,NSNumber *);
@interface HDRightNewMaterialTableViewCell : UITableViewCell

//库存待确认按钮
//添加按钮
@property (weak, nonatomic) IBOutlet UIButton *addBt;
@property (weak, nonatomic) IBOutlet UIButton *addBtbg;

//cell的headerImageView
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
//图号，编号
@property (weak, nonatomic) IBOutlet UIButton *numberBt;

@property (weak, nonatomic) IBOutlet UITextField *numberTF;
//备件名称
@property (weak, nonatomic) IBOutlet UITextField *materialTF;
//备件单价
@property (weak, nonatomic) IBOutlet UITextField *materialPriceTF;
//备件数量
@property (weak, nonatomic) IBOutlet UITextField *materialCountTF;

//备件小计
@property (weak, nonatomic) IBOutlet UITextField *materialTotalPriceTF;

//选择按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseBt;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImage;
@property (weak, nonatomic) IBOutlet UIView *deleteImgSuperview;

@property (nonatomic, strong) PorscheNewSchemews *tmpModel;

#pragma mark  ------仓库库存相关------

#pragma mark  ------库存相关------
//备件所在仓库数量
@property (weak, nonatomic) IBOutlet UITextField *materialCubCountTFOne;
@property (weak, nonatomic) IBOutlet UITextField *materialCubCountTFTwo;
@property (weak, nonatomic) IBOutlet UITextField *materialCubCountTFThree;
@property (weak, nonatomic) IBOutlet UITextField *materialCubCountTFFour;

//下拉按钮显示
@property (weak, nonatomic) IBOutlet UITextField *downContentTFOne;
@property (weak, nonatomic) IBOutlet UITextField *downContentTFTwo;
@property (weak, nonatomic) IBOutlet UITextField *downContentTFThree;
@property (weak, nonatomic) IBOutlet UITextField *downContentTFFour;

//备件添加仓库按钮
@property (weak, nonatomic) IBOutlet UIButton *addMCubBtOne;
@property (weak, nonatomic) IBOutlet UIButton *addMCubBtTwo;
@property (weak, nonatomic) IBOutlet UIButton *addMCubBtThree;
@property (weak, nonatomic) IBOutlet UIButton *addMCubBtFour;

@property (weak, nonatomic) IBOutlet UIView *superTwoView;
@property (weak, nonatomic) IBOutlet UIView *superThreeView;
@property (weak, nonatomic) IBOutlet UIView *superFourView;
//下拉图标
@property (weak, nonatomic) IBOutlet UIButton *baseBt;

@property (weak, nonatomic) IBOutlet UIButton *Onebt;
@property (weak, nonatomic) IBOutlet UIButton *twoBt;
@property (weak, nonatomic) IBOutlet UIButton *threeBt;
//添加库位
@property (nonatomic, copy) AddedCubMaterialBlock addedCubBlock;

#pragma mark  库存待确认父视图------
@property (weak, nonatomic) IBOutlet UIView *addbtSuperView;
#pragma mark  保修图片------
@property (weak, nonatomic) IBOutlet UIImageView *guaranteeImg;

#pragma mark  ------图号编号父视图------
@property (weak, nonatomic) IBOutlet UIView *numberSuperView;
@property (weak, nonatomic) IBOutlet UITextField *addedNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *addedNumberListTF;
@property (weak, nonatomic) IBOutlet UITextView *materialNameTView;

#pragma mark  保存/编辑 相关
@property (nonatomic, strong) NSNumber *saveStatus;

@property (nonatomic, copy)  HDRightNewMaterialTableViewCellBlock hDRightNewMaterialTableViewCellBlock;
//编辑备件
@property (nonatomic, copy) AddedReturnBlock addedReturnBlock;
@property (nonatomic, copy) void(^editCubCount)(ProscheMaterialLocationModel *psdModel);
- (IBAction)numberBtAction:(UIButton *)sender;

//删除按钮事件
- (IBAction)chooseBtAction:(UIButton *)sender;
//+p
- (IBAction)addBtAction:(UIButton *)sender;

//0.1.2.3.
- (IBAction)cubAction:(UIButton *)sender;
//添加库存
- (IBAction)addedBtAction:(UIButton *)sender;


- (void)cleanCell;




@end
