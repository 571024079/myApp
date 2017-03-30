//
//  HDWorkListTVHFViewNormal.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/8.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

//一般技师增项区头
#import <UIKit/UIKit.h>

typedef void(^ConfirmActionBlock) (UIButton *);
@class HDWorkListTVHFViewNormal;

@protocol HDWorkListTVHFViewNormalDelegate <NSObject>

- (void)didSelectedView:(HDWorkListTVHFViewNormal *)view ofBt:(UIButton *)deleteBt model:(PorscheNewScheme *)tmpModel;

@end

typedef void(^HDWorkListTVHFViewNormalBlock)(UIButton *,PorscheNewScheme *);

@interface HDWorkListTVHFViewNormal : UITableViewHeaderFooterView
//安全标示
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
//项目名称
@property (weak, nonatomic) IBOutlet UILabel *headerLb;
//工时小计，详情图片
@property (weak, nonatomic) IBOutlet UIImageView *workTimeImageView;
//工时
@property (weak, nonatomic) IBOutlet UILabel *workTimeLb;
//工时价格
@property (weak, nonatomic) IBOutlet UILabel *workTimePriceLb;
//备件小计价格
@property (weak, nonatomic) IBOutlet UILabel *sparePartPrice;
//方案小计价格
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;
//方案是否保修 yes:保修（不显示响应事件的buton），NO，不保修（默认）主要区分：备件和其他的方案小计的下划线是否显示
@property (nonatomic, assign) BOOL isGuarantee;
@property (weak, nonatomic) IBOutlet UIImageView *guaranteeImg;
@property (weak, nonatomic) IBOutlet UIButton *guatanteeBt;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBt;
@property (weak, nonatomic) IBOutlet UIButton *deleteSuperBt;
#pragma mark  ------服务沟通  选择按钮------
@property (weak, nonatomic) IBOutlet UIView *chooseSuperView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImg;
#pragma mark  ------客户确认 标识及相关下拉------
@property (weak, nonatomic) IBOutlet UIView *sureHeaderSuperView;
@property (weak, nonatomic) IBOutlet UIView *sureHeaderLineView;
@property (weak, nonatomic) IBOutlet UIView *sureHeaderLbSpview;
@property (weak, nonatomic) IBOutlet UILabel *sureHeaderLb;
@property (weak, nonatomic) IBOutlet UIButton *sureImageBt;
@property (weak, nonatomic) IBOutlet UIButton *sureActionBt;
@property (weak, nonatomic) IBOutlet UIButton *allBt;
@property (nonatomic, copy) void(^updateLevelBlock)(UIButton *bt);
@property (nonatomic, copy) void(^longPressBlock)();

- (IBAction)upAndDownBtAction:(UIButton *)sender;

@property (nonatomic, copy) HDWorkListTVHFViewNormalBlock guaranteeblock;
@property (nonatomic, copy) HDWorkListTVHFViewNormalBlock shadowBlock;

@property (nonatomic, weak) id<HDWorkListTVHFViewNormalDelegate> delegate;

@property (nonatomic, strong) PorscheNewScheme *tmpModel;
@property (nonatomic, strong) NSNumber *saveStatus;
@property (nonatomic, assign) BOOL isMaterial;
@property (nonatomic, copy) ConfirmActionBlock confirmActionBlock;


- (IBAction)updateSchemeLevel:(UIButton *)sender;

- (IBAction)deleteBtAction:(UIButton *)sender;
- (IBAction)confirmAction:(id)sender;

- (instancetype)initWithCustomFrame:(CGRect)frame;
- (void)isConformWithStatus:(BOOL)ret;
//保修按钮事件
- (IBAction)guaranteeBtAction:(UIButton *)sender;
- (void)guranteeShenPiStatus;

@end
