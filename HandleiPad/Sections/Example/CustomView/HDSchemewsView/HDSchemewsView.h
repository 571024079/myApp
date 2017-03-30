//
//  HDSchemewsView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/12/29.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDSchemewsViewLocationStyle) {
    HDSchemewsViewLocationStyleFactory = 1,//厂方
    HDSchemewsViewLocationStyleLocation,//本地
};

typedef NS_ENUM(NSInteger, HDSchemewsViewBlockStyle) {
    HDSchemewsViewBlockStyleEdit = 1,// 编辑
    HDSchemewsViewBlockStyleAdd,//添加
    HDSchemewsViewBlockStyleRefresh,//刷新
};

typedef NS_ENUM(NSInteger, HDSchemewsViewStyle) {
    HDSchemewsViewStyleMaterial = 1,// 备件
    HDSchemewsViewStyleWorkHour,//工时
};

@interface HDSchemewsView : UIView




@property (weak, nonatomic) IBOutlet UIView *contentViewMaterial;
@property (weak, nonatomic) IBOutlet UIView *contentViewWorkHour;


#pragma mark  ------新备件库属性------
//点击变换背景图
@property (weak, nonatomic) IBOutlet UIImageView *bgImageViewMaterial;
//本地，厂方
@property (weak, nonatomic) IBOutlet UILabel *factoryLbMaterial;

@property (weak, nonatomic) IBOutlet UILabel *locationLbMaterial;

@property (weak, nonatomic) IBOutlet UIButton *factoryBtMaterial;

@property (weak, nonatomic) IBOutlet UIButton *locationBtMaterial;

@property (weak, nonatomic) IBOutlet UILabel *changeToITimeLbMaterial;

@property (weak, nonatomic) IBOutlet UIButton *changeToItemTimeBtMaterial;

@property (nonatomic, assign) HDSchemewsViewStyle style;

@property (nonatomic, assign) HDSchemewsViewLocationStyle locationStyle;
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

#pragma mark  工时属性
//工时1.2.3.4

@property (weak, nonatomic) IBOutlet UITextField *ItemTimeOneTF;


@property (weak, nonatomic) IBOutlet UITextField *itemTimeTwoTF;


@property (weak, nonatomic) IBOutlet UITextField *itemTimeThreeTF;

@property (weak, nonatomic) IBOutlet UITextField *itemTimeFourTF;

//工时名称
@property (weak, nonatomic) IBOutlet UITextField *itemTimeNameTF;
//工时数
@property (weak, nonatomic) IBOutlet UITextField *itemTimeCountTF;
//背景
@property (weak, nonatomic) IBOutlet UIImageView *topBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *factoryLbWorkHour;
@property (weak, nonatomic) IBOutlet UIButton *factoryBtWorkHour;
@property (weak, nonatomic) IBOutlet UILabel *loctionLbWorkHour;
@property (weak, nonatomic) IBOutlet UIButton *loctionBtWorkHour;
// 切换至
@property (weak, nonatomic) IBOutlet UILabel *changeToMaterialLb;
@property (weak, nonatomic) IBOutlet UIButton *changeToMaterialBt;


//返回按钮
@property (weak, nonatomic) IBOutlet UIButton *backBt;

//进入工时库按钮
@property (weak, nonatomic) IBOutlet UIButton *stepToCubBt;

//加入工单
@property (weak, nonatomic) IBOutlet UIButton *addedBt;

@property (nonatomic, strong) PorscheNewSchemews *tmpModel;


@property (nonatomic, copy) void(^addedBlock)(HDSchemewsViewBlockStyle style);//1.编辑 2.添加 3.刷新





#pragma mark  工时相关

















#pragma mark  事件
//tag 1001 切换工时/1002 切换备件
- (IBAction)changeToCubBtAction:(UIButton *)sender;//切换至另外一个弹窗

//进入工时库按钮事件
//tag 2001进入备件库 /2002进入工时库
- (IBAction)stepToCubBtAction:(UIButton *)sender;
//返回按钮
//
- (IBAction)backBtAction:(UIButton *)sender;

//加入工单
//tag 3001备件加入工单 /3002工时加入工单
- (IBAction)saveAction:(UIButton *)sender;
//相机按钮
//tag 4001备件相机 /4002工时相机
- (IBAction)cameraAction:(UIButton *)sender;
//相册按钮
//tag 5001备件相册 /5002工时相册
- (IBAction)photoAction:(UIButton *)sender;
//+p按钮
//tag 6001备件+p /6002工时+工时
- (IBAction)repairAction:(UIButton *)sender;

//本店按钮
//tag 7001备件本店 /7002工时本店
- (IBAction)locationBtAction:(UIButton *)sender;
//厂方按钮
//tag 8001备件厂方 /8002工时厂方
- (IBAction)factoryBtAction:(UIButton *)sender;

- (void)cleanTFMaterial;
- (void)cleanTFWorkHour;


/****
 *  style:工时/备件 model:带入数据 superVC:相机所需控制器 addedblock:回调
 ****/
+ (HDSchemewsView *)showHDSchemewsStyle:(HDSchemewsViewStyle)style model:(PorscheNewSchemews *)model withSupperVC:(UIViewController *)supperVC needMatch:(BOOL)needMatch addedBlock:(void(^)(HDSchemewsViewBlockStyle style))addedBlock;


@end
