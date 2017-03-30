//
//  BlillingMessageBottomView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, BlillingMessageBottomViewStyle) {
    BlillingMessageBottomViewStyleCreate = 1,// <#content#>
    BlillingMessageBottomViewStyleDelete,
    BlillingMessageBottomViewStyleEdit,
    BlillingMessageBottomViewStyleSave,
    BlillingMessageBottomViewStyleBillingSure,
    BlillingMessageBottomViewStyleTechicain,//选择名字
    BlillingMessageBottomViewStylePosition,//职位选择
};


typedef void(^BlillingMessageBottomViewBlock)(BlillingMessageBottomViewStyle,UIButton *);

@interface BlillingMessageBottomView : UIView

@property (nonatomic, copy) BlillingMessageBottomViewBlock blillingMessageBottomViewBlock;

// 新建BT
@property (weak, nonatomic) IBOutlet UIButton *createBt;
//编辑BT
@property (weak, nonatomic) IBOutlet UIButton *editingBt;
//编辑图片
@property (weak, nonatomic) IBOutlet UIButton *editImageBt;
//编辑文字BT
@property (weak, nonatomic) IBOutlet UIButton *editTextBt;
//开单确认
@property (weak, nonatomic) IBOutlet UIButton *billingSure;
@property (weak, nonatomic) IBOutlet UILabel *colonLabel;




@property (weak, nonatomic) IBOutlet UIButton *deleteImgBt;
@property (weak, nonatomic) IBOutlet UIButton *deleteTextBt;
@property (weak, nonatomic) IBOutlet UIButton *deleteBt;

#pragma mark  ------赋值label------
//开单员
@property (weak, nonatomic) IBOutlet UILabel *techicianNameLb;
//职位
@property (weak, nonatomic) IBOutlet UITextField *positionTF;
//技师
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIImageView *pullBtTechImg;
@property (weak, nonatomic) IBOutlet UIImageView *pullBtNameImg;

//保存/编辑状态
@property (nonatomic, strong) NSNumber *saveStatus;
//传入数据
@property (nonatomic, strong) PorscheNewCarMessage *carMessage;


//选择技师事件
- (IBAction)selectedTechicianBtAction:(UIButton *)sender;
//选择职位
- (IBAction)seletedPositionBtAction:(UIButton *)sender;


//新建
- (IBAction)creatBtAction:(UIButton *)sender;

//删除
- (IBAction)deleteBtAction:(UIButton *)sender;

//编辑/保存
- (IBAction)editingBtAction:(UIButton *)sender;

//开单确认
- (IBAction)BillingSureBtAction:(UIButton *)sender;

- (instancetype)initWithCustomFrame:(CGRect)frame;

- (void)setBottomViewEditAction:(BOOL)isEdit;

- (void)addObjectToDic:(NSMutableDictionary *)dic;


- (void)setViewContentData:(PorscheNewCarMessage *)carMessage;
- (void)setViewContentWithData:(PorscheNewCarMessage *)carMessage isNew:(BOOL)isnew;

- (void)selectViewContentData:(PorscheNewCarMessage *)carMessage;

- (void)setupBillingSureisHidden:(BOOL)isHidden;

- (void)setBillButtonEnabel:(BOOL)isEnable;
@end
