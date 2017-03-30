//
//  HDWorkListRightTableViewCellTwo.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/5.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDWorkListRightTableViewCellTwoStyle) {
    HDWorkListRightTableViewCellTwoStyleChoose = 1,// 选择
    HDWorkListRightTableViewCellTwoStyleAdd,//添加
    HDWorkListRightTableViewCellTwoStyleTF,//编辑框<图号编号>
    HDWorkListRightTableViewCellTwoStyleNormalTF,//非图号编号编辑器
    HDWorkListRightTableViewCellTwoStyleReturn,//完成键
    HDWorkListRightTableViewCellTwoStyleDelete//删除
};

typedef void(^HDWorkListRightTableViewCellTwoBlock)(HDWorkListRightTableViewCellTwoStyle,UIButton *);
typedef void(^AddedReturnBlock)(PorscheNewSchemews *);
typedef void(^GuaranteeActionBlock)(UIButton *);

@interface HDWorkListRightTableViewCellTwo : UITableViewCell

@property (nonatomic, strong) GuaranteeActionBlock guaranteeBlock;
//库存待确认按钮
@property (weak, nonatomic) IBOutlet UILabel *itemNeedResureLb;

//添加按钮
@property (weak, nonatomic) IBOutlet UIButton *addBt;
@property (weak, nonatomic) IBOutlet UIImageView *addBtbg;

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

//删除图片
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;
@property (weak, nonatomic) IBOutlet UIView *chooseImgViewSuperView;
//选择图片
@property (weak, nonatomic) IBOutlet UIImageView *chooseSaveImageView;
@property (weak, nonatomic) IBOutlet UIView *superChooseImageView;

//选择按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseBt;

@property (nonatomic, strong) PorscheNewSchemews *tmpModel;

#pragma mark  ------图号编号父视图------
@property (weak, nonatomic) IBOutlet UIView *numberSuperView;
@property (weak, nonatomic) IBOutlet UITextField *addedNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *addedNumberListTF;
@property (weak, nonatomic) IBOutlet UITextView *materialNameTView;

#pragma mark  ------保修，内结，自费相关，按钮------
@property (weak, nonatomic) IBOutlet UIImageView *guaranteeImg;
@property (weak, nonatomic) IBOutlet UIButton *guaranteeBt;
//保存状态 0.编辑 1.保存
@property (nonatomic, strong) NSNumber *saveStatus;


- (IBAction)guaranteeBtAction:(UIButton *)sender;


@property (nonatomic, copy)  HDWorkListRightTableViewCellTwoBlock hDWorkListRightTableViewCellTwoBlock;

@property (nonatomic, copy) AddedReturnBlock addedReturnBlock;

- (IBAction)numberBtAction:(UIButton *)sender;


- (IBAction)chooseBtAction:(UIButton *)sender;

- (IBAction)addBtAction:(UIButton *)sender;

- (void)cleanCell;


@end
