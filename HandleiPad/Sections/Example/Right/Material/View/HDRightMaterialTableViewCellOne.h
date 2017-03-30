//
//  HDRightMaterialTableViewCellOne.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDRightMaterialTableViewCellOneStyle) {
    HDRightMaterialTableViewCellOneStyleDown = 1,// <#content#>
    HDRightMaterialTableViewCellOneStylePriceTF,//处理价格试用全店
    HDRightMaterialTableViewCellOneStyleOtherTF,//处理改变数量 修改配件总价
    HDRightMaterialTableViewCellOneStyleAddedCub,//添加库存
    

};
typedef void(^ConfirmActionBlock) (UIButton *);
typedef void(^GuaranteeActionBlock)();
typedef void(^AddedCubMaterialBlock)(BOOL isDelete,PorscheNewSchemews *schemews,NSNumber *cubid);
typedef void(^HDRightMaterialTableViewCellOneBlock)(HDRightMaterialTableViewCellOneStyle style,UIButton *,NSString *);
typedef void(^EditMaterialCubBlock)(NSDictionary *);


@interface HDRightMaterialTableViewCellOne : UITableViewCell

//材料图号
@property (weak, nonatomic) IBOutlet UITextField *materialFigNumTF;
//材料编号
@property (weak, nonatomic) IBOutlet UITextField *materialNumberTF;
//材料名称
@property (weak, nonatomic) IBOutlet UITextField *materailNameTF;
//材料价格
@property (weak, nonatomic) IBOutlet UITextField *materialPriceTF;
//材料数量
@property (weak, nonatomic) IBOutlet UITextField *materialCountTF;

//保修图标
@property (weak, nonatomic) IBOutlet UIImageView *guaranteeImg;
//备件小计
@property (weak, nonatomic) IBOutlet UILabel *materialTotalPriceLb;

//选择备件按钮
@property (weak, nonatomic) IBOutlet UIButton *materialChooseBt;

//选择备件图 <打钩>
@property (weak, nonatomic) IBOutlet UIView *chooseSuperView;

@property (weak, nonatomic) IBOutlet UIImageView *chooseImg;

//下拉按钮
@property (weak, nonatomic) IBOutlet UIButton *downBt;



@property (nonatomic, strong) PorscheNewSchemews *tmpModel;
#pragma mark  ------库存相关------
//备件所在仓库数量
@property (weak, nonatomic) IBOutlet UITextField *materialCubCountTFOne;
@property (weak, nonatomic) IBOutlet UITextField *materialCubCountTFTwo;
@property (weak, nonatomic) IBOutlet UITextField *materialCubCountTFThree;
@property (weak, nonatomic) IBOutlet UITextField *materialCubCountTFFour;

//下拉按钮显示
@property (weak, nonatomic) IBOutlet UITextField *downContentTFOne;
@property (weak, nonatomic) IBOutlet UITextField *downContentTFTwo;
@property (weak, nonatomic) IBOutlet UITextField *downContentTFThree;
@property (weak, nonatomic) IBOutlet UITextField *downContentTFFour;

//备件添加仓库按钮
@property (weak, nonatomic) IBOutlet UIButton *addMCubBtOne;
@property (weak, nonatomic) IBOutlet UIButton *addMCubBtTwo;
@property (weak, nonatomic) IBOutlet UIButton *addMCubBtThree;
@property (weak, nonatomic) IBOutlet UIButton *addMCubBtFour;

@property (weak, nonatomic) IBOutlet UIView *superTwoView;
@property (weak, nonatomic) IBOutlet UIView *superThreeView;
@property (weak, nonatomic) IBOutlet UIView *superFourView;

#pragma mark  保存编辑 相关
@property (nonatomic, strong) NSNumber *saveStatus;

//下拉图标
@property (weak, nonatomic) IBOutlet UIButton *baseBt;

@property (weak, nonatomic) IBOutlet UIButton *Onebt;
@property (weak, nonatomic) IBOutlet UIButton *twoBt;
@property (weak, nonatomic) IBOutlet UIButton *threeBt;
@property (weak, nonatomic) IBOutlet UIButton *changeGuaranteeBt;







//添加库存block
@property (nonatomic, copy) AddedCubMaterialBlock addedCubBlock;
//库存编辑block
@property (nonatomic, copy) EditMaterialCubBlock editMaterialCubBlock;
//一般block
@property (nonatomic, copy) HDRightMaterialTableViewCellOneBlock hDRightMaterialTableViewCellOneStyleBlock;
//保修 弹出
@property (nonatomic, copy) GuaranteeActionBlock guaranteeActionBlock;
@property (nonatomic, copy) ConfirmActionBlock confirmActionBlock;
@property (nonatomic, copy) void(^addedReturnBlock)(PorscheNewSchemews *tmp);


//备件弹窗修改图号/编号
@property (nonatomic, copy) void(^editMaterialAllBlock)(PorscheNewSchemews *schemews);


- (IBAction)showEditViewAction:(UIButton *)sender;

- (IBAction)changeGuaranteeBtAction:(UIButton *)sender;
- (void)isConformWithStatus:(BOOL)ret;
//sender.tag 0.1.2.3 依次对应
- (IBAction)downBtAction:(UIButton *)sender;

- (IBAction)addedBtAction:(UIButton *)sender;

@end
