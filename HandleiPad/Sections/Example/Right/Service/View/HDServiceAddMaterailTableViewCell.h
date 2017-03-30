//
//  HDServiceAddMaterailTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDServiceAddMaterailTableViewCellStyle) {
    HDServiceAddMaterailTableViewCellStyleChoose = 1,// 选择
    HDServiceAddMaterailTableViewCellStyleAdd,//添加
    HDServiceAddMaterailTableViewCellStyleTF,//编辑框<图号编号>
    HDServiceAddMaterailTableViewCellStyleNormalTF,//非图号编号编辑器
    HDServiceAddMaterailTableViewCellStyleReturn,//完成键
};


typedef void(^HDServiceAddMaterailTableViewCellBlock)(HDServiceAddMaterailTableViewCellStyle,UIButton *);
typedef void(^GuaranteeServiceBlock)(UIButton *);
typedef void(^AddedReturnBlock)(PorscheNewSchemews *);

@interface HDServiceAddMaterailTableViewCell : UITableViewCell

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
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseBt;
//勾选相关参数
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
@property (nonatomic, copy) void(^selectedBlock)(UIButton *sender,PorscheNewSchemews *schemews);






@property (nonatomic, strong) PorscheNewSchemews *tmpModel;

@property (nonatomic, copy)  HDServiceAddMaterailTableViewCellBlock hDServiceAddMaterailTableViewCellBlock;

#pragma mark  保修相关 ------
@property (weak, nonatomic) IBOutlet UIButton *guaranteeBt;
@property (weak, nonatomic) IBOutlet UIImageView *guaranteeImg;
@property (nonatomic, copy) GuaranteeServiceBlock guaranteeBlock;

#pragma mark  ------折扣相关------
@property (weak, nonatomic) IBOutlet UITextField *disCountTF;
@property (weak, nonatomic) IBOutlet UIButton *discountBt;

#pragma mark  ------完成按钮事件<添加配件model>------
@property (nonatomic, copy) AddedReturnBlock addedReturnBlock;

#pragma mark  ------图号编号父视图------
@property (weak, nonatomic) IBOutlet UIView *numberSuperView;
@property (weak, nonatomic) IBOutlet UITextField *addedNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *addedNumberListTF;
@property (weak, nonatomic) IBOutlet UITextView *materialNameTView;
#pragma mark  保存编辑状态
@property (nonatomic, strong) NSNumber *saveStatus;
- (IBAction)disCountBtAction:(UIButton *)sender;

- (IBAction)guaranteeBtAction:(UIButton *)sender;

- (IBAction)numberBtAction:(UIButton *)sender;


- (IBAction)chooseBtAction:(UIButton *)sender;

- (IBAction)addBtAction:(UIButton *)sender;

- (void)cleanCell;
- (void)guranteeShenPiStatus;

@end
