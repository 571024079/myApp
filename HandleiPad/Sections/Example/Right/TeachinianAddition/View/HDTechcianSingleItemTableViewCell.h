//
//  HDTechcianSingleItemTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HDTechcianSingleItemTableViewCellStyle) {
    HDTechcianSingleItemTableViewCellStyleChoose = 1,//
    HDTechcianSingleItemTableViewCellStyleRepair,
    HDTechcianSingleItemTableViewCellStyleItemTimeTF,
    HDTechcianSingleItemTableViewCellStyleTF,
    HDTechcianSingleItemTableViewCellStyleCamera,//相机
    HDTechcianSingleItemTableViewCellStylePhoto,//相片
    HDTechcianSingleItemTableViewCellStyleReturn,
};

typedef void(^HDTechcianSingleItemTableViewCellBlock)(HDTechcianSingleItemTableViewCellStyle,UIButton *);
typedef void(^AddedReturnBlock)(PorscheNewSchemews *);

typedef void(^GuaranteeActionBock)(UIButton *);

@interface HDTechcianSingleItemTableViewCell : UITableViewCell

@property (nonatomic, copy) HDTechcianSingleItemTableViewCellBlock hDTechcianSingleItemTableViewCellBlock;
@property (nonatomic, copy) AddedReturnBlock addedreturnBlock;
@property (nonatomic, strong) GuaranteeActionBock guaranteeViewBlock;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

//工时编号
@property (weak, nonatomic) IBOutlet UITextField *itemTimeTF;
//工时名称
@property (weak, nonatomic) IBOutlet UITextField *itemNameTF;
//工时名称非编辑状态显示的lb
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
//工时单价
@property (weak, nonatomic) IBOutlet UITextField *itemPrice;
//工时数
@property (weak, nonatomic) IBOutlet UITextField *itemCountTF;
//工时小计
@property (weak, nonatomic) IBOutlet UITextField *itemtotalPriceTF;
//选择图片
@property (weak, nonatomic) IBOutlet UIView *chooseImageViewSuperView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;
//选择按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseBt;
//修理按钮
@property (weak, nonatomic) IBOutlet UIButton *repairBt;
@property (weak, nonatomic) IBOutlet UIImageView *repairBtbgImg;

@property (weak, nonatomic) IBOutlet UIButton *numberBt;

//自定义项目，添加工时，需要显示(2016.10.18已改。不再显示)

@property (weak, nonatomic) IBOutlet UIButton *cameraBt;
@property (weak, nonatomic) IBOutlet UIButton *photoBt;

@property (weak, nonatomic) IBOutlet UILabel *itemTimeSureLb;

#pragma mark  ------保修，内结，自费------

@property (weak, nonatomic) IBOutlet UIImageView *guaranteeImg;
@property (weak, nonatomic) IBOutlet UIButton *guaranteeBt;
//勾选
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
@property (nonatomic, copy) void(^chooseBlock)(PorscheNewSchemews *schemews,UIButton *sender);


//保修按钮事件
- (IBAction)guaranteeBtAction:(UIButton *)sender;


- (IBAction)cameraBtAction:(UIButton *)sender;

- (IBAction)photoBtAction:(UIButton *)sender;

//按钮事件

- (IBAction)chooseBtAction:(UIButton *)sender;

- (IBAction)repairBtAction:(UIButton *)sender;

- (IBAction)itemTimenumberBtAction:(UIButton *)sender;

@property (nonatomic, strong) PorscheNewSchemews *tmpModel;
@property (nonatomic, strong) NSNumber *saveStatus; // 1 不可编辑状态

@end
