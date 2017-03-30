//
//  TechcianNumberTFInputView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TechcianNumberTFInputViewStyle) {
    TechcianNumberTFInputViewStyleCancel = 1,// 取消
    TechcianNumberTFInputViewStyleStepToManHourCub,//进入备件库
    
    TechcianNumberTFInputViewStyleFigueTFOne,//图号1
    TechcianNumberTFInputViewStyleFigueTFTwo,//图号2
    TechcianNumberTFInputViewStyleFigueTFThree,//图号3
    TechcianNumberTFInputViewStyleNumberTFOne,//编号1
    TechcianNumberTFInputViewStyleNumberTFTwo,//编号2
    TechcianNumberTFInputViewStyleNumberTFThree,//编号3
    TechcianNumberTFInputViewStyleNumberTFFour,//编号4
    TechcianNumberTFInputViewStyleNumberTFFive,//编号5
    TechcianNumberTFInputViewStyleReturn,//返回按钮
    TechcianNumberTFInputViewStyleChangeCub,//切换弹窗
};

typedef NS_ENUM(NSInteger, TechcianNumberLocationStyle) {
    TechcianNumberLocationStyleFactory = 1,//
    TechcianNumberLocationStyleLocation,
};

typedef void(^TechcianNumberTFInputViewBlock)(TechcianNumberTFInputViewStyle,UIButton *);

typedef void(^TechcianNumberTFInputViewReturnBlock)(PorscheNewSchemews *);


@interface TechcianNumberTFInputView : UIView

@property (nonatomic, copy) TechcianNumberTFInputViewBlock techcianNumberTFInputViewBlock;

//完成按钮block
@property (nonatomic, copy) TechcianNumberTFInputViewReturnBlock returnBlock;

@property (weak, nonatomic) IBOutlet UIView *contentView;


#pragma mark  ------新备件库属性------
//点击变换背景图
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
//本地，厂方
@property (weak, nonatomic) IBOutlet UILabel *factoryLb;

@property (weak, nonatomic) IBOutlet UILabel *locationLb;

@property (weak, nonatomic) IBOutlet UIButton *factoryBt;

@property (weak, nonatomic) IBOutlet UIButton *locationBt;

@property (weak, nonatomic) IBOutlet UILabel *changeToITimeLb;

@property (weak, nonatomic) IBOutlet UIButton *changeToItemTimeBt;

@property (nonatomic, assign) TechcianNumberLocationStyle locationStyle;

#pragma mark  ---------------------------------
//备件名称
@property (weak, nonatomic) IBOutlet UITextField *materialNameTF;
//备件数
@property (weak, nonatomic) IBOutlet UITextField *materialCountTF;

//图号TF
@property (weak, nonatomic) IBOutlet UITextField *figueTFOne;

@property (weak, nonatomic) IBOutlet UITextField *figueTFTwo;

@property (weak, nonatomic) IBOutlet UITextField *figueTFThree;

@property (weak, nonatomic) IBOutlet UITextField *LandRTF;


//编号TF

@property (weak, nonatomic) IBOutlet UITextField *numberTFOne;
@property (weak, nonatomic) IBOutlet UITextField *numberTFTwo;

@property (weak, nonatomic) IBOutlet UITextField *numberTFThree;

@property (weak, nonatomic) IBOutlet UITextField *numberTFFour;

@property (weak, nonatomic) IBOutlet UITextField *numberTFFive;

@property (weak, nonatomic) IBOutlet UITextField *numberTFSix;



//取消按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelBt;

//进入工时库按钮
@property (weak, nonatomic) IBOutlet UIButton *stepToManHourCubBt;
//确认保存/加入工单
@property (weak, nonatomic) IBOutlet UIButton *saveBt;

@property (nonatomic, strong) PorscheNewSchemews *tmpModel;

@property (nonatomic, copy) void(^addedBlock)(NSInteger tag);//1.编辑 2.添加 3.刷新

+ (TechcianNumberTFInputView *)showTechcianNumberTFInputViewModel:(PorscheNewSchemews *)model withSupperVC:(UIViewController *)supperVC addedBlock:(void(^)(NSInteger tag))addedBlock;
#pragma mark  切换至工时------
//@property (weak, nonatomic) IBOutlet UIButton *changeToItemBt;
- (IBAction)changeToItemCubBtAction:(UIButton *)sender;

- (instancetype)initWithCustomFrame:(CGRect)frame;


//进入工时库按钮事件
- (IBAction)stepToManHourCubBtAction:(UIButton *)sender;
//返回按钮
- (IBAction)cancelBtAction:(UIButton *)sender;

//加入工单
- (IBAction)saveBtAction:(UIButton *)sender;
//相机按钮
- (IBAction)cameraBt:(UIButton *)sender;
//相册按钮
- (IBAction)photoBtAction:(UIButton *)sender;
//+p按钮
- (IBAction)repairBtAction:(UIButton *)sender;

//本店按钮
- (IBAction)locationBtAction:(UIButton *)sender;
//厂方按钮
- (IBAction)factoryBtAction:(UIButton *)sender;

- (void)cleanTF;





@end
