//
//  HDServiceSingleItemTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/27.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDServiceSingleItemTableViewCellStyle) {
    HDServiceSingleItemTableViewCellStyleChoose = 1,//点选
    HDServiceSingleItemTableViewCellStyleRepair,//工时添加
    HDServiceSingleItemTableViewCellStyleItemTimeTF,//工时事件
    HDServiceSingleItemTableViewCellStyleTF,//TF事件
    HDServiceSingleItemTableViewCellStyleReturn,//返回按钮
};

typedef void(^HDServiceSingleItemTableViewCellBlock)(HDServiceSingleItemTableViewCellStyle style,UIButton *);
typedef void(^GuaranteeActionBock)(UIButton *);
typedef void(^AddedReturnBlock)(PorscheNewSchemews *);

@interface HDServiceSingleItemTableViewCell : UITableViewCell

@property (nonatomic, copy) HDServiceSingleItemTableViewCellBlock hDServiceSingleItemTableViewCellBlock;

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
//删除图片
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;
//复选框界面
@property (weak, nonatomic) IBOutlet UIView *selectImageViewSuperView;
//复选框的图片
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseBt;
//修理按钮
@property (weak, nonatomic) IBOutlet UIButton *repairBt;
@property (weak, nonatomic) IBOutlet UIImageView *repairBtbgImg;
// 工时编号按钮
@property (weak, nonatomic) IBOutlet UIButton *itemTimeBtn;

@property (weak, nonatomic) IBOutlet UITextField *discountTF;

//自定义项目，添加工时，需要显示(2016.10.18已改。不再显示)

@property (weak, nonatomic) IBOutlet UILabel *itemTimeSureLb;

#pragma mark  ------保修，内结，自费------

@property (weak, nonatomic) IBOutlet UIImageView *guaranteeImg;
@property (weak, nonatomic) IBOutlet UIButton *guaranteeBt;
//保修按钮事件
- (IBAction)guaranteeBtAction:(UIButton *)sender;

//添加 打钩视图， 其他人添加的工时不可以删除，只能选择是否要选中
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImg;

#pragma mark  ------保修------
@property (nonatomic, copy) AddedReturnBlock addedreturnBlock;
@property (nonatomic, strong) GuaranteeActionBock guaranteeViewBlock;
#pragma mark  ------折扣------
@property (weak, nonatomic) IBOutlet UIButton *discountBt;


@property (nonatomic, strong) PorscheNewSchemews *tmpModel;
@property (nonatomic, strong) NSNumber *saveStatus;

- (IBAction)discountBtAction:(UIButton *)sender;

//按钮事件

- (IBAction)chooseBtAction:(UIButton *)sender;

- (IBAction)repairBtAction:(UIButton *)sender;

- (IBAction)itemTimenumberBtAction:(UIButton *)sender;

- (void)setDiscountWithSaveStatus:(NSNumber *)issave;

- (void)guranteeShenPiStatus;
@end
