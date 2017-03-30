//
//  TeachicianAdditionItemBottomView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, TeachicianAdditionItemBottomViewStyle) {
     TeachicianAdditionItemBottomViewStyleSavebt,//保存
    TeachicianAdditionItemBottomViewStyleTechcianSureBt,//技师确认
    TeachicianAdditionItemBottomViewStyleTechicianHelperBt,//技师选择选择

    TeachicianAdditionItemBottomViewStyleMaterialHelperBt,//备件员选择
    TeachicianAdditionItemBottomViewStyleServiceHelperBt,//服务顾问选择
    TeachicianAdditionItemBottomViewStylePrintHelperBt,// 打印事件
};

typedef NS_ENUM(NSInteger, BottomConstantSaveStyle) {
    BottomConstantSaveStyleTechician = 1,// <#content#>
    BottomConstantSaveStylematerial,
    BottomConstantSaveStyleService,
};

typedef void(^TeachicianAdditionItemBottomViewBlock)(TeachicianAdditionItemBottomViewStyle,UIButton *);

@interface TeachicianAdditionItemBottomView : UIView

//技师
@property (weak, nonatomic) IBOutlet UILabel *billingPerson;
@property (weak, nonatomic) IBOutlet UIView *techicianView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *techicianViewWidth;

//服务顾问TF
@property (weak, nonatomic) IBOutlet UITextField *serviceHelperTF;
@property (weak, nonatomic) IBOutlet UILabel *serviceLb;
//服务顾问BT
@property (weak, nonatomic) IBOutlet UIButton *serviceHelperBt;
@property (weak, nonatomic) IBOutlet UIImageView *pullImg;
//服务顾问 下拉相关父视图
@property (weak, nonatomic) IBOutlet UIView *serviceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serviceViewWidth;


//备件员TF
@property (weak, nonatomic) IBOutlet UITextField *materialHelperTF;
@property (weak, nonatomic) IBOutlet UIButton *materialHelperBt;
@property (weak, nonatomic) IBOutlet UIImageView *materialHelperPullImg;
@property (weak, nonatomic) IBOutlet UIView *materialView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *materialViewWidth;


//保存BT
@property (weak, nonatomic) IBOutlet UIButton *saveBt;
@property (weak, nonatomic) IBOutlet UIButton *saveSuperBt;

//技师确认BT
@property (weak, nonatomic) IBOutlet UIButton *techicianSurebt;
#pragma mark  保存/编辑切换
//图片切换
@property (weak, nonatomic) IBOutlet UIImageView *saveImg;
//文字切换
@property (weak, nonatomic) IBOutlet UILabel *saveLb;
#pragma mark  打印相关

@property (weak, nonatomic) IBOutlet UIButton *printBt;
@property (weak, nonatomic) IBOutlet UIImageView *printImg;
@property (weak, nonatomic) IBOutlet UILabel *printLb;

@property (weak, nonatomic) IBOutlet UIView *lineView;
//更新约束
//打印view的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveViewWidth;

@property (nonatomic, strong) NSNumber *saveStatus;

@property (nonatomic, strong) NSNumber *confirmStatus;//0,不可编辑，1可编辑


@property (weak, nonatomic) IBOutlet UILabel *materialLb;

@property (nonatomic, assign) BottomConstantSaveStyle bottomStyle;

#pragma mark  技师选择相关
@property (weak, nonatomic) IBOutlet UITextField *techicianTF;
@property (weak, nonatomic) IBOutlet UIImageView *techicianPullImg;
@property (weak, nonatomic) IBOutlet UIButton *techicianPullBt;


@property (nonatomic, copy) TeachicianAdditionItemBottomViewBlock teachicianAdditionItemBottomViewBlock;
@property (nonatomic, strong) PorscheNewCarMessage *carMessage;

+ (instancetype)getCustomFrame:(CGRect)frame style:(BottomConstantSaveStyle)style;


- (IBAction)techcianHelperBtAction:(UIButton *)sender;

- (IBAction)saveBtAction:(UIButton *)sender;

- (IBAction)techcianSureBtAction:(UIButton *)sender;

- (void)setSaveLbTittleAndImgBool:(BOOL)isSave;



@end
