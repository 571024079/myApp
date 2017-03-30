//
//  HDWorkListRightTableViewCellOne.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/5.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDWorkListRightTableViewCellOneStyle) {
    HDWorkListRightTableViewCellOneStyleChoose = 1,// 
    HDWorkListRightTableViewCellOneStyleTF,
};

typedef void(^HDWorkListRightTableViewCellOneBlock)(HDWorkListRightTableViewCellOneStyle,UIButton *);

typedef void(^GuaranteeBtBlock)(UIButton *);
typedef void(^HDWorkListRightTableViewCellOneReturnBlock)(PorscheNewSchemews *schemews);
@interface HDWorkListRightTableViewCellOne : UITableViewCell
@property (nonatomic, strong) HDWorkListRightTableViewCellOneReturnBlock returnBlock;

//配件图号
@property (weak, nonatomic) IBOutlet UILabel *peijianNumberLb;

//配件编号
@property (weak, nonatomic) IBOutlet UILabel *peijianListNumber;

//配件名
@property (weak, nonatomic) IBOutlet UILabel *peijianName;
//配件单价
@property (weak, nonatomic) IBOutlet UILabel *peijiandanjiaLb;
//配件数量
@property (weak, nonatomic) IBOutlet UITextField *peijianCountTF;
//配件总价
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLb;

//配件选择imageView
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;
//配件选择Bt
@property (weak, nonatomic) IBOutlet UIButton *chooseBt;

//库存待确认
@property (weak, nonatomic) IBOutlet UILabel *peijianStatus;

@property (weak, nonatomic) IBOutlet UIImageView *guaranteeImg;

@property (weak, nonatomic) IBOutlet UIButton *changeGuaranteeBt;

@property (nonatomic, copy) GuaranteeBtBlock guaranteeBtBlock;


// 是否处于保存状态 0.非保存  1.保存
@property (nonatomic, strong) NSNumber *saveStatus;

@property (weak, nonatomic) IBOutlet UIView *chooseSuperView;




- (IBAction)changeGuaranteeBtAction:(UIButton *)sender;







@property (nonatomic, strong) PorscheNewSchemews *tmpModel;


@property (nonatomic, copy) HDWorkListRightTableViewCellOneBlock hDWorkListRightTableViewCellOneBlock;

- (IBAction)chooseBtAction:(UIButton *)sender;


@end
