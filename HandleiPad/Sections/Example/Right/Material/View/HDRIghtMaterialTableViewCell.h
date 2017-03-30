//
//  HDRIghtMaterialTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GuaranteeActionBlock)();

@interface HDRIghtMaterialTableViewCell : UITableViewCell
//工时号
@property (weak, nonatomic) IBOutlet UILabel *itemTimeNumberLb;
//工时名称
@property (weak, nonatomic) IBOutlet UILabel *itemTimeNameLb;
//工时单价
@property (weak, nonatomic) IBOutlet UILabel *itemTimePriceLb;
//工时数量
@property (weak, nonatomic) IBOutlet UILabel *itemCountLb;
//保修图片
@property (weak, nonatomic) IBOutlet UIImageView *guaranteeImg;
//工时总价
@property (weak, nonatomic) IBOutlet UILabel *itemTimeTotalPriceLb;

@property (nonatomic, strong) PorscheNewSchemews *tmpModel;

@property (nonatomic, strong) NSNumber *saveStatus;

@property (weak, nonatomic) IBOutlet UIButton *changeGuaranteeBt;

@property (weak, nonatomic) IBOutlet UIView *chooseBgImg;

@property (weak, nonatomic) IBOutlet UIImageView *chooseImg;







//保修 弹出
@property (nonatomic, copy) GuaranteeActionBlock guaranteeActionBlock;

@property (nonatomic, copy) void(^chooseBlock)(PorscheNewSchemews *schemews,UIView *sender);

- (IBAction)changeGuaranteeBtAction:(UIButton *)sender;
- (IBAction)chooseBtAction:(UIButton *)sender;



@end
