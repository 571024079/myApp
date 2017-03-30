//
//  TechcianItemTimeTFInputView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/26.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TechcianItemTimeTFInputViewStyle) {
    TechcianItemTimeTFInputViewStyleStepToItemTime = 1,// 进入工时库
    TechcianItemTimeTFInputViewStyleCancel,//取消
    TechcianItemTimeTFInputViewStyleTFReturn,//键盘回收 done
    TechcianItemTimeTFInputViewStyleChangeCub,//切换至备件库
};





typedef void(^TechcianItemTimeTFInputViewBlock)(TechcianItemTimeTFInputViewStyle,UIButton *);
typedef void(^SaveBBtActionBlock)(PorscheNewSchemews *);
@interface TechcianItemTimeTFInputView : UIView

@property (nonatomic, copy) TechcianItemTimeTFInputViewBlock techcianItemTimeTFInputViewBlock;
//保存按钮block
@property (nonatomic, copy) SaveBBtActionBlock saveBtBlock;

@property (weak, nonatomic) IBOutlet UIView *contentView;




//工时1.2.3.4

@property (weak, nonatomic) IBOutlet UITextField *ItemTimeOneTF;


@property (weak, nonatomic) IBOutlet UITextField *itemTimeTwoTF;


@property (weak, nonatomic) IBOutlet UITextField *itemTimeThreeTF;

@property (weak, nonatomic) IBOutlet UITextField *itemTimeFourTF;

//工时名称
@property (weak, nonatomic) IBOutlet UITextField *itemTimeNameTF;
//工时数
@property (weak, nonatomic) IBOutlet UITextField *itemTimeCountTF;
//进入工时库按钮
@property (weak, nonatomic) IBOutlet UIButton *stepToItemTimeBt;
//取消返回按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelBt;


@property (nonatomic, strong) PorscheNewSchemews *tmpModel;

#pragma mark  ------新工时库  添加属性------
@property (weak, nonatomic) IBOutlet UIImageView *topBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *factoryLb;
@property (weak, nonatomic) IBOutlet UIButton *factoryBt;
@property (weak, nonatomic) IBOutlet UILabel *loctionLb;
@property (weak, nonatomic) IBOutlet UIButton *loctionBt;

// 切换至
@property (weak, nonatomic) IBOutlet UILabel *changeToMaterialLb;
@property (weak, nonatomic) IBOutlet UIButton *changeToMaterialBt;

@property (nonatomic, copy) void(^addedBlock)(NSInteger tag);



+ (TechcianItemTimeTFInputView *)showTechcianNumberTFInputViewModel:(PorscheNewSchemews *)model withSupperVC:(UIViewController *)supperVC addedBlock:(void(^)(NSInteger tag))addedBlock;

- (IBAction)changeToMaterialAction:(UIButton *)sender;

//拍照
- (IBAction)cameraBtAction:(UIButton *)sender;

//照片库
- (IBAction)photoBtAction:(UIButton *)sender;

//工时按钮
- (IBAction)ItemTimeAction:(UIButton *)sender;

//确认保存
- (IBAction)makeSureBtAction:(UIButton *)sender;



//厂方点击方法
- (IBAction)factoryButtonAction:(UIButton *)sender;
//本店点击方法
- (IBAction)loctionButtonAction:(UIButton *)sender;




- (IBAction)stepToItemTimeBtAction:(UIButton *)sender;


- (IBAction)cancelBtAction:(UIButton *)sender;

//---------<限定尺寸>---------CGRectMake(242,  90,540, 255)
- (instancetype)initWithCustomFrame:(CGRect)frame;




//清空
- (void)cleanTF;


@end
