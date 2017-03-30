//
//  TeachnicianAdditionItemHeaderView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "TeachnicianAdditionItemHeaderView.h"
#import "HDDiscountView.h"
#import "HDLeftSingleton.h"
@implementation TeachnicianAdditionItemHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCustomFrame:(CGRect)frame {
        
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TeachnicianAdditionItemHeaderView" owner:self options:nil];
    
    self = [array objectAtIndex:0];
    

    
    _secondSuperView.layer.masksToBounds = YES;
    _secondSuperView.layer.cornerRadius = 3;
    _secondSuperView.layer.borderColor = Color(170, 170, 170).CGColor;
    _secondSuperView.layer.borderWidth = 0.5;
    
    _thirdSuperView.layer.masksToBounds = YES;
    _thirdSuperView.layer.cornerRadius = 3;
    _thirdSuperView.layer.borderWidth = 0.5;
    _thirdSuperView.layer.borderColor = Color(170, 170, 170).CGColor;
    [self setupdisTFView];
    [self setupIntDisTF];

    return self;
}

- (void)setupdisTFView {
    for (UITextField *tf in @[_itemTimeDisTF,_materialDisTF,_totalDIsTF]) {
        [AlertViewHelpers setupCellTFView:tf save:NO];

    }
}

- (void)setupDiscountViewBool:(BOOL)isContain {
//    if (isContain) {
//        [self setupDisTFShow];
//    }else {
        [self setupIntDisTF];
//    }
}

- (void)setupDisTFShow {
    _itemTimeDisTFSuperView.hidden = NO;
    _materialDisTFsuperView.hidden = NO;
    _totalDisTFsuperView.hidden = NO;
    _itemDisTFsuperViewWidth.constant = 46;
    _materialDisTFsuperViewWidth.constant = 46;
}

- (void)setupIntDisTF {
    
    _itemDisTFsuperViewWidth.constant = 0;
    _materialDisTFsuperViewWidth.constant = 0;
    _totalTFsuperViewWidth.constant = 0;
    _itemTimeDisTFSuperView.hidden = YES;
    _materialDisTFsuperView.hidden = YES;
    _totalDisTFsuperView.hidden = YES;
}


//方案库
- (void)projectAction {
    if (self.teachnicianAdditionItemHeaderViewBlock) {
        self.teachnicianAdditionItemHeaderViewBlock(TeachnicianAdditionItemHeaderViewStyleProjectCub,nil);
    }
    
}
//工时库
- (void)itemTimeAction {
    if (self.teachnicianAdditionItemHeaderViewBlock) {
        self.teachnicianAdditionItemHeaderViewBlock(TeachnicianAdditionItemHeaderViewStyleItemTimeCub,nil);
    }
    
}
//备件库
- (void)materialAction {
    if (self.teachnicianAdditionItemHeaderViewBlock) {
        self.teachnicianAdditionItemHeaderViewBlock(TeachnicianAdditionItemHeaderViewStyleMaterialCub,nil);
    }
    
}


#pragma mark - 没有效果。。。。
- (void)chengeHeaderViewLabelChange:(NSNotification *)sender {
    NSNumber *count = (NSNumber *)sender.object;
    NSString *string = [NSString stringWithFormat:@"已选择: %@项", count];
    _selectedCountLabel.text = string;
}

- (IBAction)billingBtAction:(UIButton *)sender {
    if (self.teachnicianAdditionItemHeaderViewBlock) {
        self.teachnicianAdditionItemHeaderViewBlock(TeachnicianAdditionItemHeaderViewStyleBilling,sender);
    }
}



- (IBAction)techcianBtAction:(UIButton *)sender {
    if (self.teachnicianAdditionItemHeaderViewBlock) {
        self.teachnicianAdditionItemHeaderViewBlock(TeachnicianAdditionItemHeaderViewStyleTechcian,sender);
    }
}



- (IBAction)materialBtAction:(UIButton *)sender {
    
    if (self.teachnicianAdditionItemHeaderViewBlock) {
        self.teachnicianAdditionItemHeaderViewBlock(TeachnicianAdditionItemHeaderViewStyleMaterial,sender);
    }
}


- (IBAction)serviceBtAction:(UIButton *)sender {
    if (self.teachnicianAdditionItemHeaderViewBlock) {
        self.teachnicianAdditionItemHeaderViewBlock(TeachnicianAdditionItemHeaderViewStyleService,sender);
    }
}

- (IBAction)customSureAction:(UIButton *)sender {

    if (self.teachnicianAdditionItemHeaderViewBlock) {
        self.teachnicianAdditionItemHeaderViewBlock(TeachnicianAdditionItemHeaderViewStyleCustomSure,sender);
    }
}

- (void)billingAction:(UIButton *)sender {
    [self setDefaultImageWithButton:sender];
}
- (void)techcianAction:(UIButton *)sender {
    [self setDefaultImageWithButton:sender];
}

- (void)materialAction:(UIButton *)sender {
    
    [self setDefaultImageWithButton:sender];
    
}

- (void)serviceAction:(UIButton *)sender {
    [self setDefaultImageWithButton:sender];

}

- (void)customAction:(UIButton *)sender {
    [self setDefaultImageWithButton:sender];
}

//设置默认图片
- (void)setDefaultImageWithButton:(UIButton *)bt {
    self.billingBtBgImageview.image = [UIImage imageNamed:@"hd_work_list_create_message_white"];
    self.techcianAdditionBgImageView.image = [UIImage imageNamed:@"hd_work_list_mid_white"];
    self.materialBgImageView.image = [UIImage imageNamed:@"hd_work_list_mid_white"];
    self.serviceBgimageView.image = [UIImage imageNamed:@"hd_work_list_mid_white"];
    self.customBgimageView.image = [UIImage imageNamed:@"white5"];
    /*
     
    [self.billingBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     
    [self.techcianAddtionBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.materialBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.serviceBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.customSureBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     
    */
    if ([bt isEqual:self.billingBt]) {
        _billingBtBgImageview.image = [UIImage imageNamed:@"hd_work_list_create_message.png"];
    }else if ([bt isEqual:_techcianAddtionBt]){
        self.techcianAdditionBgImageView.image = [UIImage imageNamed:@"hd_work_list_mid_blue.png"];
    }else if ([bt isEqual:_materialBt]){
        self.materialBgImageView.image = [UIImage imageNamed:@"hd_work_list_mid_blue.png"];
    }else if ([bt isEqual:_serviceBt]){
        self.serviceBgimageView.image = [UIImage imageNamed:@"hd_work_list_mid_blue.png"];
    }else if ([bt isEqual:_customSureBt]){
        self.customBgimageView.image = [UIImage imageNamed:@"blue5"];
    }
    
    
}

- (void)addRedViewToPreDate {
    if ([HDLeftSingleton shareSingleton].stepStatus == 4) {
        if (_carNewModel.woid) {
            if (_preTimeTF.text.length > 0) {
                _redImg.hidden = YES;
            }else {
                _redImg.hidden = NO;
            }
        }else {
            _redImg.hidden = YES;
        }
    }else {
        _redImg.hidden = YES;
    }
}

- (void)setCarNewModel:(PorscheNewCarMessage *)carNewModel {
    _carNewModel = carNewModel;
    
    NSString *carNumber = carNewModel.ccarplate.length > 0 && carNewModel.plateplace.length > 0 ? [NSString stringWithFormat:@"%@%@",carNewModel.plateplace,carNewModel.ccarplate] : @"车牌号";
    _carNumberLb.text = carNumber;
    
//    NSString *str = carNewModel.wocarcatena.length > 0 && carNewModel.wocarmodel.length >0 ? [NSString stringWithFormat:@"%@%@",carNewModel.wocarcatena,carNewModel.wocarmodel] : @"";
    NSString *str = [[[carNewModel.wocarcatena stringByAppendingString:@" "] stringByAppendingString:[carNewModel.wocarmodel stringByAppendingString:@" "]] stringByAppendingString:[carNewModel.woyearstyle stringByAppendingString:@" "]];

    _carStyleMessageLb.text = carNewModel.wocarcatena.length > 0 ? str : @"车型";
    NSString *string = [NSString formatMoneyStringWithMilesFloat:[carNewModel.wocurmiles floatValue]];
    NSString *distance = [NSString stringWithFormat:@"%@公里",string];
    _carDistanceLb.text = [carNewModel.wocurmiles floatValue] ? distance : @"公里数";
    
    NSString *time = carNewModel.wofinishtime.length ? [carNewModel.wofinishtime convertFromFormat:@"yyyyMMddHHmmss" toAnotherFormat:@"yyyy-MM-dd HH:mm"] : @"";
    
    _preTimeTF.text = time;
    if (time.length > 0) {
        [HDLeftSingleton shareSingleton].isSelectedPreDate = YES;
    }else {
        [HDLeftSingleton shareSingleton].isSelectedPreDate = NO;
    }
    _timeLb.text = time;
    
    _selectedCountLabel.text =  [NSString stringWithFormat:@"共:%ld个方案",carNewModel.solutionList.count];
    //小计
    [self setupTotalPrice];
    //折扣
    _itemTimeDisTF.text = carNewModel.workhourdiscount ? [NSString stringWithFormat:@"%@",carNewModel.workhourdiscount] : @"";
    _materialDisTF.text = carNewModel.partdiscount ? [NSString stringWithFormat:@"%@",carNewModel.partdiscount] : @"";
    if ([_carNewModel.workhourdiscount integerValue] == 1) {
        _itemTimeDisTF.text = nil;
    }else {
        
    }
    
    //折扣 格式 - 20%
    //工时
    if ([_carNewModel.workhourdiscount integerValue] == 1) {
        _itemTimeDisTF.text = nil;
    }else {
        _itemTimeDisTF.text = _carNewModel.workhourdiscount ? [NSString stringWithFormat:@"-%.2f%%", [_carNewModel.workhourdiscount floatValue] *100] : nil;
    }
    //备件
    if ([_carNewModel.partdiscount integerValue] == 1) {
        _materialDisTF.text = nil;
    }else {
        _materialDisTF.text = _carNewModel.partdiscount ? [NSString stringWithFormat:@"-%.2f%%", [_carNewModel.partdiscount floatValue] *100] : nil;
    }
    
    [self addRedViewToPreDate];
}

- (void)setupTotalPrice {
    if ([HDLeftSingleton shareSingleton].stepStatus != 4) {//原价(技师和备件)
        _projectTimeTotalPriceLb.text = _carNewModel.workhouroriginalprice1 ? [NSString formatMoneyStringWithFloat:[_carNewModel.workhouroriginalprice1 floatValue]] : @"-----";
        _materialTotalLb.text = _carNewModel.partsoriginalprice1 ? [NSString formatMoneyStringWithFloat:[_carNewModel.partsoriginalprice1 floatValue]] : @"-----";
        _totalPriceLb.text = _carNewModel.ordertotaloriginalprice1 ? [NSString formatMoneyStringWithFloat:[_carNewModel.ordertotaloriginalprice1 floatValue]] : @"-----";
    }else {
        _projectTimeTotalPriceLb.text = _carNewModel.workhourprice ? [NSString formatMoneyStringWithFloat:[_carNewModel.workhourprice floatValue]] : @"-----";
        _materialTotalLb.text = _carNewModel.partsprice ? [NSString formatMoneyStringWithFloat:[_carNewModel.partsprice floatValue]] : @"-----";
        _totalPriceLb.text = _carNewModel.ordertotalprice ? [NSString formatMoneyStringWithFloat:[_carNewModel.ordertotalprice floatValue]] : @"-----";
    }
}





- (IBAction)preTimeBtAction:(UIButton *)sender {
    
    if (self.teachnicianAdditionItemHeaderViewBlock) {
        self.teachnicianAdditionItemHeaderViewBlock(TeachnicianAdditionItemHeaderViewStylePreTime,sender);
    }
}
//折扣 弹窗 将工单中数据传入弹窗
- (IBAction)disCountBtAction:(UIButton *)sender {

    NSString *total;

    NSString *discount;

    switch (sender.tag) {
        case 101://工时小计
        {
            
            total = _carNewModel.workhourprice ?  [NSString stringWithFormat:@"%@",_carNewModel.workhourprice] : @"";
                discount = _carNewModel.workhourdiscount > 0 ? [NSString stringWithFormat:@"%.2f",[_carNewModel.workhourdiscount floatValue] * 100]:@"0.00";
            
        }
            break;
        case 102://备件小计
        {
            total = _carNewModel.partsprice ?  [NSString stringWithFormat:@"%@",_carNewModel.partsprice] : @"";
            discount = _carNewModel.workhourdiscount > 0 ? [NSString stringWithFormat:@"%.2f",[_carNewModel.partdiscount floatValue] * 100]:@"0.00";
        }
            break;
        case 103://总计
        {
            if (_totalPriceLb.text.length > 0 && ![_totalPriceLb.text isEqualToString:@"-----"]) {
                total = [_totalPriceLb.text substringFromIndex:1];
            }
        }
            break;
        default:
            break;
    }
    
    
    WeakObject(self);
    [HDDiscountView showAllDiscountViewWithPrice:total discount:discount discountPrice:@"0.00" realPrice:total sure:^(NSString *discount, NSString *discountPrice, NSString *realPrice,NSNumber *rangeId) {
        PorscheNewSchemews *model = [PorscheNewSchemews new];
        model.schemesubtype = sender.tag == 101 ? @1 : @2;
        
        [selfWeak discountActionCondition:model rate:@([discount floatValue] /100) rangeid:@4];
        
    }];
    
    
}

- (void)discountActionCondition:(PorscheNewSchemews *)schemews rate:(NSNumber *)rate rangeid:(NSNumber *)rangeid {
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    [PorscheRequestManager editDiscountWithSchemews:schemews rate:rate rangeid:rangeid complete:^(NSInteger status, PResponseModel * _Nonnull responser) {
        [hud hideAnimated:YES];
        if (status != 100) {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:HD_FULLView];
        }else {
            //打折成功 工单刷新数据
//            [[NSNotificationCenter defaultCenter] postNotificationName:BILLING_CAR_MESSAGE_NOTIFINATION object:nil];
        }
    }];
}

@end
