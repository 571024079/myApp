//
//  BlillingMessageCenterView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, BlillingMessageCenterViewStyle) {
    BlillingMessageCenterViewStyleDMS = 1,// DMS
    BlillingMessageCenterViewStyleAddition,//增项单号
    BlillingMessageCenterViewStyleDate,//日期选择
    BlillingMessageCenterViewStyleGuarantee,//保修
    BlillingMessageCenterViewStyleGuaranteeEnd,//保修到期时间
    BlillingMessageCenterViewStyleCameraUp,//行驶证正面拍照
    BlillingMessageCenterViewStyleCameraDown,//行驶证反面拍照
    BlillingMessageCenterViewStyleCycle,//环车拍
    BlillingMessageCenterViewStyleVideo,//视频播放
    BlillingMessageCenterViewStylePreView,//照片预览
    BlillingMessageCenterViewStyleCarNumber,//车号牌设置
    BlillingMessageCenterViewStyleCarNumberTF,//车牌号输入
    BlillingMessageCenterViewStyleVIN,//VIN设置
    BlillingMessageCenterViewStyleCarCategory,//车系
    BlillingMessageCenterViewStyleCarCategoryTF,//车系TF
    BlillingMessageCenterViewStyleCarStyle,//车型
    BlillingMessageCenterViewStyleCarStyleTF,//车型TF
    BlillingMessageCenterViewStyleCarYear,//年款
    BlillingMessageCenterViewStyleCarDisplacement,//排量
    BlillingMessageCenterViewStyleCarDistanced,//公里数
    BlillingMessageCenterViewStyleFirstLogin,//首登日期
    BlillingMessageCenterViewStyleSecureCompany,//保险公司
    BlillingMessageCenterViewStyleSecureDate,//保险到期日期
    BlillingMessageCenterViewStylePrecious,// 是否有贵重物品
    BlillingMessageCenterViewStyleVinPhotoRecognize,// vin图片识别
    BlillingMessageCenterViewStylePrecheckOrder, // 预检单
};


@protocol BlillingMessageCenterViewDelegate <NSObject>

- (void)billingViewSaveCarInfo:(PorscheNewCarMessage *)carinfo blillingMessageCenterViewStyle:(BlillingMessageCenterViewStyle)style;

@end

typedef void(^MorePicBlock)(NSInteger ,CGRect);
typedef void(^BlillingMessageCenterViewBlock)(BlillingMessageCenterViewStyle,UIButton *,NSInteger idx,UIView *);

@interface BlillingMessageCenterView : UIView

@property (nonatomic, copy) BlillingMessageCenterViewBlock blillingMessageCenterViewBlock;

@property (nonatomic, copy) MorePicBlock morePicBlock;

@property (weak, nonatomic) IBOutlet UIScrollView *centerScrollView;

@property (weak, nonatomic) IBOutlet UIView *cententView;

@property (weak, nonatomic) IBOutlet UIView *roundView;

#pragma mark  ------不包含输入框------

//DMS
@property (weak, nonatomic) IBOutlet UILabel *dmsLb;

//预计交车时间
@property (weak, nonatomic) IBOutlet UILabel *preOutputDateLb;

//保修状态
@property (weak, nonatomic) IBOutlet UILabel *guaranteeStatusLb;
//保修时间
@property (weak, nonatomic) IBOutlet UILabel *guaranreeEndLb;
//行驶证的边框
@property (weak, nonatomic) IBOutlet UIImageView *driverHelperIMg;
@property (weak, nonatomic) IBOutlet UIButton *VINCameraBt;

//车牌号
@property (weak, nonatomic) IBOutlet UILabel *carNumberLb;
//VIN
@property (weak, nonatomic) IBOutlet UILabel *vinLb;


//首登日期
@property (weak, nonatomic) IBOutlet UILabel *firstLoginLb;


//车系文本
@property (weak, nonatomic) IBOutlet UILabel *carCategoryLb;
//车型文本
@property (weak, nonatomic) IBOutlet UILabel *carStyleLb;
//年款文本
@property (weak, nonatomic) IBOutlet UILabel *carYearLb;
//排量文本
@property (weak, nonatomic) IBOutlet UILabel *carDisplacementLb;
//公里数
@property (weak, nonatomic) IBOutlet UILabel *cardistanceLb;

#pragma mark  ------------车辆信息展示辅助隐藏视图------
@property (weak, nonatomic) IBOutlet UIImageView *VINRecogniserHelperImg;

/****车牌显示辅助修改****/
@property (weak, nonatomic) IBOutlet UIView *carNumberAllSuperView;

/****DMS显示边框辅助****/
@property (weak, nonatomic) IBOutlet UIView *DMSNumberHelperView;
//首登辅助view
@property (weak, nonatomic) IBOutlet UIView *firstLoginSuperView;
//预计交车时间辅助视图
@property (weak, nonatomic) IBOutlet UIView *preOutCarSuperView;
//保修状态辅助视图
@property (weak, nonatomic) IBOutlet UIView *guaranteeSuperView;
//保修到期日辅助视图
@property (weak, nonatomic) IBOutlet UIView *guaranteeDateSuperView;
//VIN辅助视图
@property (weak, nonatomic) IBOutlet UIView *vinTFSuperView;
//车系辅助视图
@property (weak, nonatomic) IBOutlet UIView *carCategorySuperView;
//车型辅助视图
@property (weak, nonatomic) IBOutlet UIView *carStyleSuperView;
//年款辅助视图
@property (weak, nonatomic) IBOutlet UIView *carYearSuperView;
//排量辅助视图
@property (weak, nonatomic) IBOutlet UIView *displacementSuperView;




#pragma mark  ------空白开单信息，输入框和弹窗------
//DMS号码
@property (weak, nonatomic) IBOutlet UITextField *DMSnumberTF;
//增项单号
@property (weak, nonatomic) IBOutlet UILabel *additionNumberLb;


//进场日期
@property (weak, nonatomic) IBOutlet UILabel *inputDateLb;
//预计交车时间
@property (weak, nonatomic) IBOutlet UITextField *preOutputDateTF;
//图标按钮
@property (weak, nonatomic) IBOutlet UIImageView *preLocationBt;

//交车时间选择
@property (weak, nonatomic) IBOutlet UIButton *outputDatePickerBt;
//保修状态
@property (weak, nonatomic) IBOutlet UIButton *guaranteeBt;
@property (weak, nonatomic) IBOutlet UIImageView *guaranteeImgv;

@property (weak, nonatomic) IBOutlet UITextField *guaranteeTF;

//保修到期日
@property (weak, nonatomic) IBOutlet UIButton *guaranteeEndBt;
//保修图标
@property (weak, nonatomic) IBOutlet UIImageView *guaranteeEndLocationBt;
@property (weak, nonatomic) IBOutlet UITextField *guaranteeEndTF;


//行驶证正面
@property (weak, nonatomic) IBOutlet UIImageView *driverLicenseUpImgv;
//行驶证反面
//@property (weak, nonatomic) IBOutlet UIImageView *driverLicenseDownImgv;
//行驶证正面拍摄按钮
@property (weak, nonatomic) IBOutlet UIButton *driverLicenseUpBt;

//行驶证反面拍摄背景
//@property (weak, nonatomic) IBOutlet UIImageView *driverLicenceDownBg;

//行驶证反面拍摄按钮
//@property (weak, nonatomic) IBOutlet UIButton *driverLicenseDownBt;
//行驶证反面拍摄Lb
//@property (weak, nonatomic) IBOutlet UILabel *driverLicenceDowmLb;

//环车拍照照片
@property (weak, nonatomic) IBOutlet UIImageView *cycleCarimgv;
//环车拍照按钮
@property (weak, nonatomic) IBOutlet UIButton *cycleCarbt;
@property (weak, nonatomic) IBOutlet UIView *clearView;

#pragma mark  ------collection------
////照片查看1
@property (weak, nonatomic) IBOutlet UICollectionView *picCollectionView;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) ZLCamera *videoModel ;
@property (nonatomic, assign) BOOL isHiddenAllTF;
@property (nonatomic, strong) PorscheNewCarMessage *carModel;
//0.编辑  1.保修
@property (nonatomic, strong) NSNumber *saveStatus;

@property (weak, nonatomic) IBOutlet UIView *videoPlaySView;
@property (weak, nonatomic) IBOutlet UIImageView *playBtBgImg;

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UIButton *videoPlayBt;


//视频播放
- (IBAction)videoPalyBtAction:(UIButton *)sender;


//照片查看更多按钮
@property (weak, nonatomic) IBOutlet UIImageView *picMoreImgV;

@property (weak, nonatomic) IBOutlet UIButton *picPreViewMoreBt;

@property (weak, nonatomic) IBOutlet UIView *carNumberBgView;

//车牌号 省会简称
@property (weak, nonatomic) IBOutlet UILabel *carLocationLb;
//车牌输入
@property (weak, nonatomic) IBOutlet UITextField *carNumberTF;
//省会选择
@property (weak, nonatomic) IBOutlet UIButton *carLocationbt;


//VIN输入
@property (weak, nonatomic) IBOutlet UITextField *VINnumberTF;

@property (weak, nonatomic) IBOutlet UIButton *VINBt;

//首次登陆日期
@property (weak, nonatomic) IBOutlet UITextField *firstLoginTF;
@property (weak, nonatomic) IBOutlet UIButton *firstLoginBt;


//车系
@property (weak, nonatomic) IBOutlet UITextField *carCategoryTF;

@property (weak, nonatomic) IBOutlet UIButton *carCategoryBt;
//车型
@property (weak, nonatomic) IBOutlet UITextField *carStyleTF;
@property (weak, nonatomic) IBOutlet UIButton *carStyleBt;
//年款
@property (weak, nonatomic) IBOutlet UIImageView *carYearImgv;

@property (weak, nonatomic) IBOutlet UIButton *carYearBt;

@property (weak, nonatomic) IBOutlet UITextField *carMadeYearTF;
//排量
@property (weak, nonatomic) IBOutlet UIImageView *carDisplacementImgv;

@property (weak, nonatomic) IBOutlet UIButton *carDisplacementBt;

@property (weak, nonatomic) IBOutlet UITextField *carDisplacementTF;
//当前公里数
@property (weak, nonatomic) IBOutlet UITextField *carDistancedTF;

#pragma mark  保险公司先关
@property (weak, nonatomic) IBOutlet UIView *secureSuperView;
@property (weak, nonatomic) IBOutlet UIImageView *secureImageView;
@property (weak, nonatomic) IBOutlet UITextField *secureTF;
//选择保险公司事件
- (IBAction)chooseSecureCompanyAction:(UIButton *)sender;

#pragma mark  保险日期相关
@property (weak, nonatomic) IBOutlet UIView *secureDateSuperView;
@property (weak, nonatomic) IBOutlet UITextField *secureDateTF;
@property (weak, nonatomic) IBOutlet UIImageView *sceureDateImg;
//选择保险到期日期
- (IBAction)secureDateBtAction:(UIButton *)sender;
#pragma mark  车内是否有贵重物品
@property (weak, nonatomic) IBOutlet UIImageView *chooseImgView;
@property (weak, nonatomic) IBOutlet UIView *chooseSuperView;
@property (weak, nonatomic) IBOutlet UIButton *preciousBt;
@property (nonatomic, copy) void(^BillingTFToReloadBlock)(UITextField *tf);

#pragma mark  预检单
@property (weak, nonatomic) IBOutlet UIButton *preCheckButton;


//选择的-----车型车系年款model
@property (nonatomic, strong) PorscheConstantModel *carSeriesModel;
@property (nonatomic, strong) PorscheConstantModel *carTypeModel;
@property (nonatomic, strong) PorscheConstantModel *carYearModel;

@property (nonatomic, weak) id<BlillingMessageCenterViewDelegate>delegate;





- (IBAction)isHasPrecious:(UIButton *)sender;


//日期选择
- (IBAction)dateChooseBtAction:(UIButton *)sender;



//行驶证
- (IBAction)liscenceUpBtAction:(UIButton *)sender;

- (IBAction)liscenceDownAction:(UIButton *)sender;

//环车拍
- (IBAction)cycleBtAction:(UIButton *)sender;





//照片查看
- (IBAction)picPreViewBtAction:(UIButton *)sender;
//超片查看更多按钮

- (IBAction)preViewMoreBtAction:(UIButton *)sender;
//省会选择按钮
- (IBAction)carLocationBtAction:(UIButton *)sender;
//车系
- (IBAction)carCategoryBtAction:(UIButton *)sender;
//车型
- (IBAction)carStyleBtAction:(UIButton *)sender;

//年款
- (IBAction)carYearBtAction:(UIButton *)sender;
//排量
- (IBAction)carDismentBtAction:(UIButton *)sender;



//VIN按钮事件
- (IBAction)VINBtAction:(UIButton *)sender;

//保修
- (IBAction)guaranteeBtAction:(UIButton *)sender;

//保修到期时间
- (IBAction)guaranteeEndBtAction:(UIButton *)sender;
//首登日期

- (IBAction)firstLoginBtAction:(UIButton *)sender;








+ (instancetype)initWithCustomFrame:(CGRect)frame;

//- (void)cleanData;

//是否显示TF
- (void)setViewHidden:(BOOL)isHidden;

//显示TF下，设置数据 已传进来的数据model
- (void)setDataWithTF;
//不显示TF下，设置数据 已传进来的model；
- (void)setDataWithHidden;
//车系参数获取
- (NSMutableDictionary *)saveViewCarBillingArr:(NSArray *)array;
//获取开单参数
- (NSMutableDictionary *)saveNewCarForBillingTf:(UITextField *)tf;
//贵重物品参数
- (NSMutableDictionary *)savePrecious;
//获取车牌
- (NSMutableDictionary *)getCarplate;
- (void)noGuaranteeActionWithTitle:(NSString *)title;
// VIN 图片识别事件
- (IBAction)vinRecognizeAction:(id)sender;

// 设置页面显示内容
- (void)setViewContentData:(PorscheNewCarMessage *)carInfo;

// 设置 编辑状态、浏览状态
- (void)setViewEdit:(BOOL)isEdit;

@end
