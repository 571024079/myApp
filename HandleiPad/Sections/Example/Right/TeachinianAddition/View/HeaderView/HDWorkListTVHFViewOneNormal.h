//
//  HDWorkListTVHFViewOneNormal.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/17.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDWorkListTVHFViewOneNormal;

@protocol HDWorkListTVHFViewOneNormalDelegate <NSObject>

- (void)didSelectedView:(HDWorkListTVHFViewOneNormal *)view ofButton:(UIButton *)deleteBt model:(PorscheNewScheme *)tmpModel;

@end


typedef void(^HDWorkListTVHFViewOneNormalBlock)(UIButton *,PorscheNewScheme *);

typedef void(^GuaranteeAboutActionBlock)(UIButton *);
typedef void(^CustomEditNameBlock)(NSString *text);
@interface HDWorkListTVHFViewOneNormal : UITableViewHeaderFooterView

@property (nonatomic, copy) HDWorkListTVHFViewOneNormalBlock hDWorkListTVHFViewOneNormalBlock;
@property (nonatomic, copy) CustomEditNameBlock editBlock;
@property (nonatomic, weak) id<HDWorkListTVHFViewOneNormalDelegate> delegate;

//项目名称
@property (weak, nonatomic) IBOutlet UITextField *itemNameTF;
@property (weak, nonatomic) IBOutlet UIImageView *itemNameBackImg;

//工时小计

@property (weak, nonatomic) IBOutlet UITextField *itemPriceTF;
//备件小计
@property (weak, nonatomic) IBOutlet UITextField *materialPriceTF;
//方案小计
@property (weak, nonatomic) IBOutlet UITextField *itemTotalPriceTF;

@property (nonatomic, strong) PorscheNewScheme *tmpModel;
@property (nonatomic, strong) NSNumber *saveStatus;

@property (weak, nonatomic) IBOutlet UIButton *deleteBt;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *deleteSuperBt;

#pragma mark  ------客户确认 标识及相关下拉------
@property (weak, nonatomic) IBOutlet UIView *sureHeaderSuperView;
@property (weak, nonatomic) IBOutlet UIView *sureHeaderLineView;
@property (weak, nonatomic) IBOutlet UIView *sureHeaderLbSpview;
@property (weak, nonatomic) IBOutlet UILabel *sureHeaderLb;
@property (weak, nonatomic) IBOutlet UIButton *sureImageBt;
@property (weak, nonatomic) IBOutlet UIButton *sureActionBt;
@property (weak, nonatomic) IBOutlet UIButton *allBt;
@property (nonatomic, copy) HDWorkListTVHFViewOneNormalBlock shadowBlock;
@property (nonatomic, copy) void(^updateLevelBlock)(UIButton *bt);
@property (nonatomic, copy) void(^longPressBlock)();

- (IBAction)upAndDownBtAction:(UIButton *)sender;
- (IBAction)updateSchemeLevelid:(UIButton *)sender;


//保修按钮
@property (weak, nonatomic) IBOutlet UIButton *guaranteebt;
@property (weak, nonatomic) IBOutlet UIImageView *guaranteeImg;
@property (nonatomic, copy) GuaranteeAboutActionBlock guaranteeViewblock;
- (IBAction)guaranteeBtAction:(UIButton *)sender;



//选择按钮
@property (weak, nonatomic) IBOutlet UIView *chooseBgView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImg;
@property (weak, nonatomic) IBOutlet UIButton *chooseBt;
@property (nonatomic, copy) void(^chooseBtBlock)(UIButton *sender) ;


- (IBAction)chooseBtAction:(UIButton *)sender;


- (IBAction)deleteBtAction:(UIButton *)sender;

- (instancetype)initWithCustomFrame:(CGRect)frame;

- (void)guranteeShenPiStatus;


















@end
