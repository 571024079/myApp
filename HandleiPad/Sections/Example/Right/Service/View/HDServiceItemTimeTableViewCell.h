//
//  HDServiceItemTimeTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GuaranteeActionBlock)(UIButton *);
typedef void(^ConfirmActionBlock) (UIButton *);
@interface HDServiceItemTimeTableViewCell : UITableViewCell

//工时号
@property (weak, nonatomic) IBOutlet UILabel *itemTimeNumberLb;
//工时名称
@property (weak, nonatomic) IBOutlet UILabel *itemTimeNameLb;
//工时单价
@property (weak, nonatomic) IBOutlet UILabel *itemTimePriceLb;
//工时数量
@property (weak, nonatomic) IBOutlet UILabel *itemCountLb;
@property (weak, nonatomic) IBOutlet UITextField *itemCountTF;

//折扣 格式 - 20%
@property (weak, nonatomic) IBOutlet UITextField *discountTF;

@property (weak, nonatomic) IBOutlet UIButton *discountBt;

@property (weak, nonatomic) IBOutlet UIButton *chooseBt;


//保修图片
@property (weak, nonatomic) IBOutlet UIImageView *guaranteeImg;
//工时总价
@property (weak, nonatomic) IBOutlet UILabel *itemTimeTotalPriceLb;

@property (nonatomic, strong) PorscheNewSchemews *tmpModel;
@property (nonatomic, strong) NSNumber *saveStatus;
@property (weak, nonatomic) IBOutlet UIButton *changeGuaranteeBt;
@property (weak, nonatomic) IBOutlet UIView *markView;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (nonatomic, copy) ConfirmActionBlock confirmActionBlock;
@property (nonatomic, copy) void(^editWorkhourBlock)(PorscheNewSchemews *schemews);

//保修 弹出
@property (nonatomic, copy) GuaranteeActionBlock guaranteeActionBlock;
//sender.tag 0.折扣    1.保修
- (IBAction)changeGuaranteeBtAction:(UIButton *)sender;
- (IBAction)discountBtAction:(UIButton *)sender;

- (void)isConfirmStatus:(BOOL)ret;
- (void)guranteeShenPiStatus;
@end
