//
//  TeachnicianAdditionItemHeaderView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
//技师增项headerView
#pragma mark  ------右侧所有的控制器类型------
typedef NS_ENUM(NSInteger, TeachnicianAdditionItemHeaderViewStyle) {
    TeachnicianAdditionItemHeaderViewStyleBilling = 1,// 开单信息
    TeachnicianAdditionItemHeaderViewStyleTechcian,//技师增项
    TeachnicianAdditionItemHeaderViewStyleMaterial,//备件确认
    TeachnicianAdditionItemHeaderViewStyleService,//服务沟通
    TeachnicianAdditionItemHeaderViewStyleCustomSure,// 客户确认
    
    TeachnicianAdditionItemHeaderViewStylePreTime,//预计交车时间
    
    TeachnicianAdditionItemHeaderViewStyleMaterialCub,//备件库
    TeachnicianAdditionItemHeaderViewStyleItemTimeCub,//工时库
    TeachnicianAdditionItemHeaderViewStyleProjectCub,//方案库
    
    TeachnicianAdditionItemHeaderViewStyleCarInFactoryFull,//在场车辆全屏
    TeachnicianAdditionItemHeaderViewStyleServiceHistory,//服务档案
    
    
    
};

typedef void(^TeachnicianAdditionItemHeaderViewBlock)(TeachnicianAdditionItemHeaderViewStyle,UIButton *);



@interface TeachnicianAdditionItemHeaderView : UIView
//开单信息背景图
@property (weak, nonatomic) IBOutlet UIImageView *billingBtBgImageview;
//技师增项背景图
@property (weak, nonatomic) IBOutlet UIImageView *techcianAdditionBgImageView;
//备件确认背景图
@property (weak, nonatomic) IBOutlet UIImageView *materialBgImageView;
//服务沟通背景图

@property (weak, nonatomic) IBOutlet UIImageView *serviceBgimageView;
//客户确认背景图
@property (weak, nonatomic) IBOutlet UIImageView *customBgimageView;
//开单信息按钮
@property (weak, nonatomic) IBOutlet UIButton *billingBt;
//技师增项按钮
@property (weak, nonatomic) IBOutlet UIButton *techcianAddtionBt;
//备件确认按钮
@property (weak, nonatomic) IBOutlet UIButton *materialBt;
//服务沟通按钮
@property (weak, nonatomic) IBOutlet UIButton *serviceBt;
//客户确认按钮
@property (weak, nonatomic) IBOutlet UIButton *customSureBt;

//预计交车时间TF
@property (weak, nonatomic) IBOutlet UITextField *preTimeTF;

//预计交车时间Bt
@property (weak, nonatomic) IBOutlet UIButton *preTimeBt;
//预计交车图标
@property (weak, nonatomic) IBOutlet UIImageView *preTimeImageView;

//已选择label
@property (weak, nonatomic) IBOutlet UILabel *selectedCountLabel;
//工时总计：￥1,300.00/------
@property (weak, nonatomic) IBOutlet UILabel *projectTimeTotalPriceLb;
//备件总计：------
@property (weak, nonatomic) IBOutlet UILabel *materialTotalLb;
//总计：------
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLb;


@property (weak, nonatomic) IBOutlet UIView *secondSuperView;

@property (weak, nonatomic) IBOutlet UIView *thirdSuperView;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;
#pragma mark  ------车辆信息------
@property (weak, nonatomic) IBOutlet UILabel *carNumberLb;
@property (weak, nonatomic) IBOutlet UILabel *carStyleMessageLb;
@property (weak, nonatomic) IBOutlet UILabel *carDistanceLb;
//工时，备件，总计 打折superView
@property (weak, nonatomic) IBOutlet UIView *itemTimeDisTFSuperView;
@property (weak, nonatomic) IBOutlet UIView *materialDisTFsuperView;
@property (weak, nonatomic) IBOutlet UIView *totalDisTFsuperView;

//工时，备件，总计 打折TF
@property (weak, nonatomic) IBOutlet UITextField *itemTimeDisTF;
@property (weak, nonatomic) IBOutlet UITextField *materialDisTF;
@property (weak, nonatomic) IBOutlet UITextField *totalDIsTF;
//工时，备件，总计，打折TF宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemDisTFsuperViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *materialDisTFsuperViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalTFsuperViewWidth;

@property (weak, nonatomic) IBOutlet UIImageView *redImg;




@property (nonatomic, strong) PorscheNewCarMessage *carNewModel;



@property (nonatomic, copy) TeachnicianAdditionItemHeaderViewBlock
 teachnicianAdditionItemHeaderViewBlock;

- (instancetype)initWithCustomFrame:(CGRect)frame;

- (IBAction)billingBtAction:(UIButton *)sender;

- (IBAction)techcianBtAction:(UIButton *)sender;
- (IBAction)materialBtAction:(UIButton *)sender;
- (IBAction)serviceBtAction:(UIButton *)sender;
- (IBAction)customSureAction:(UIButton *)sender;

- (void)billingAction:(UIButton *)sender;
- (void)techcianAction:(UIButton *)sender ;

- (void)materialAction:(UIButton *)sender;

- (void)serviceAction:(UIButton *)sender;

- (void)customAction:(UIButton *)sender;




//预计交车事件
- (IBAction)preTimeBtAction:(UIButton *)sender;

- (void)setupDiscountViewBool:(BOOL)isContain;
//折扣弹窗事件
- (IBAction)disCountBtAction:(UIButton *)sender;
//设置默认图片
- (void)setDefaultImageWithButton:(UIButton *)bt;


@end
