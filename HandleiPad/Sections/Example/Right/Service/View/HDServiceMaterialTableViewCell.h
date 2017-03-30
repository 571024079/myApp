//
//  HDServiceMaterialTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GuaranteeActionBlock)(UIButton *);
typedef void(^ConfirmActionBlock) (UIButton *);

@interface HDServiceMaterialTableViewCell : UITableViewCell

//库存显示
@property (weak, nonatomic) IBOutlet UILabel *materialCubLb;

//时号
@property (weak, nonatomic) IBOutlet UILabel *itemTimeNumberLb;
//名称
@property (weak, nonatomic) IBOutlet UILabel *itemTimeNameLb;
//单价
@property (weak, nonatomic) IBOutlet UILabel *itemTimePriceLb;
//数量
@property (weak, nonatomic) IBOutlet UITextField *itemCountTF;
//保修图片
@property (weak, nonatomic) IBOutlet UIImageView *guaranteeImg;
//总价
@property (weak, nonatomic) IBOutlet UILabel *itemTimeTotalPriceLb;
//折扣
@property (weak, nonatomic) IBOutlet UITextField *discountTF;
//折扣按钮
@property (weak, nonatomic) IBOutlet UIButton *discountBt;
@property (weak, nonatomic) IBOutlet UIButton *chooseBt;

@property (weak, nonatomic) IBOutlet UIView *chooseSuperView;

@property (nonatomic, strong) PorscheNewSchemews *tmpModel;
@property (nonatomic, strong) NSNumber *saveStatus;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

@property (weak, nonatomic) IBOutlet UIButton *changeGuaranteeBt;
//保修 弹出
@property (nonatomic, copy) GuaranteeActionBlock guaranteeActionBlock;
@property (nonatomic, copy) ConfirmActionBlock confirmActionBlock;
@property (nonatomic, copy) void(^editCountBlock)(PorscheNewSchemews *schemews);


- (IBAction)changeGuaranteeBtAction:(UIButton *)sender;
- (IBAction)discountBtAction:(UIButton *)sender;
- (IBAction)confirmButtonAction:(id)sender;
- (void)isConfirmStatus:(BOOL)ret;
- (void)guranteeShenPiStatus;

@end
