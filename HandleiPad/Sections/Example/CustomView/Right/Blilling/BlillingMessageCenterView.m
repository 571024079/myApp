 //
//  BlillingMessageCenterView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "BlillingMessageCenterView.h"
//图片cell
#import "BillingRightCollectionViewCell.h"

#import "HDLeftSingleton.h"
#import "UIImageView+WebCache.h"
#import "HDAccessoryView.h"
#import "HDPoperDeleteView.h"
#import "HDInputCarCadastralView.h"
#import "HDInputVINView.h"
#import "HDWorkListTableViews.h"
#import "IQKeyboardManager.h"


#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface BlillingMessageCenterView ()<UITextFieldDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
HDInputCarCadastralViewDelegate,
HDInputVinViewDelegate>

//默认空白页面的数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

// 页面所有可编辑View
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *allEditViews;

// 页面所有浏览View
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *allScanViews;

@property (nonatomic, strong) PorscheNewCarMessage *carinfo;
// 保险公司
@property (nonatomic, strong) NSMutableArray *insuranceArray;
// 保修状态
@property (nonatomic, strong) NSArray *guaranteeStatus;
////车牌弹出框
@property (nonatomic, strong) UIPopoverController *carCardastralPoperController;
//VIN键盘辅助
@property (nonatomic, strong) HDInputVINView *VINaccessoryView;
@property (weak, nonatomic) IBOutlet UIButton *insuranceCompanyBtn;
@property (weak, nonatomic) IBOutlet UIButton *insuranceDateBtn;

//车牌输入下拉列表
@property (nonatomic, strong) HDWorkListTableViews *carNumberListView;


@end

@implementation BlillingMessageCenterView {
    
    BillingRightCollectionViewCell *_lastCell;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.picCollectionView registerNib:[UINib nibWithNibName:@"BillingRightCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BillingRightCollectionViewCell"];
    self.VINnumberTF.inputAccessoryView = self.VINaccessoryView;
    self.VINnumberTF.delegate = self;

}

#pragma mark -- 设置开单信息数据 --
- (void)setViewContentData:(PorscheNewCarMessage *)carInfo
{
    _carinfo = carInfo;
    // DMS
    self.dmsLb.text = carInfo.wodmsno;
    self.DMSnumberTF.text = carInfo.wodmsno;
    
    // 报价单号
    self.additionNumberLb.text = carInfo.woserialno;
    
    // 进厂日期
    NSString *inputDate = [carInfo.woenyardtime convertFromFormat:@"yyyyMMddHHmmss" toAnotherFormat:@"yyyy-MM-dd HH:mm"];
    self.inputDateLb.text = inputDate;
    
    // 预计交车时间
    NSString *preOutputdate = [carInfo.wofinishtime convertFromFormat:@"yyyyMMddHHmmss" toAnotherFormat:@"yyyy-MM-dd HH:mm"];
    self.preOutputDateLb.text = preOutputdate;
    self.preOutputDateTF.text = preOutputdate;
    
    // 保修状态
    // 获取保修状态worepair
//    NSString *guaranteeStatus = @"";

    PorscheConstantModel *guaranteeModel = nil;
    
    NSArray *repairs = [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataWarranty];
    
    if (carInfo.crepair)
    {
        for (PorscheConstantModel *constant in repairs)
        {
            if ([constant.cvsubid isEqualToNumber:carInfo.crepair])
            {
                guaranteeModel = constant;
            }
        }
    }

    
    self.guaranteeTF.text = guaranteeModel.cvvaluedesc;
    self.guaranteeStatusLb.text =  guaranteeModel.cvvaluedesc;
    
    // 保修到期日
    NSString *guaranteeExpiry = [carInfo.crepairtime convertFromFormat:@"yyyyMMddHHmmss" toAnotherFormat:@"yyyy-MM-dd"];
    self.guaranreeEndLb.text = guaranteeExpiry;
    self.guaranteeEndTF.text = guaranteeExpiry;
    
    // 首登日期
    NSString *woregisterdate =  [carInfo.cregisterdate convertFromFormat:@"yyyyMMddHHmmss" toAnotherFormat:@"yyyy-MM-dd"];
    self.firstLoginLb.text = woregisterdate;
    self.firstLoginTF.text = woregisterdate;

    
    // 车牌号
    NSString *carplate = carInfo.ccarplate;
    NSString *carplace = carInfo.plateplace;
    if (!carplace.length)
    {
        carplace = @"";
    }
    
    if (!carplate.length)
    {
        carplate = @"";
    }
    
    self.carNumberLb.text = [NSString stringWithFormat:@"%@%@",carplace, carplate];
    self.carNumberTF.text = carplate;
    self.carLocationLb.text = carplace;
    // VIN
    NSString *vin = carInfo.cvincode;
    vin = [vin stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.vinLb.text = vin;
    self.VINnumberTF.text = vin;
    
    // 公里数
    NSString *mile = carInfo.wocurmiles ? [[NSString formatMoneyStringWithMilesFloat:carInfo.wocurmiles.floatValue] stringByAppendingString:@"公里"] : @"";
    
    self.cardistanceLb.text = mile;
    self.carDistancedTF.text = mile;
    
    // 车系
    NSString *cars = carInfo.wocarcatena ? carInfo.wocarcatena : @"" ;
    self.carCategoryLb.text = cars;
    self.carCategoryTF.text = cars;

    // 车型
    NSString *cartype = carInfo.wocarmodel ? carInfo.wocarmodel : @"" ;
    NSString *cartypeString = [NSString stringWithFormat:@"%@ %@",cars,cartype];
    if (!cars.length && !cartype.length)
    {
        cartypeString = @"";
    }
    self.carStyleTF.text = cartypeString;
    self.carStyleLb.text = cartypeString;
    
    // 年款
    NSString *caryear = carInfo.woyearstyle;
    self.carYearLb.text = caryear;
    self.carMadeYearTF.text = caryear;
    
    // 排量
    NSString *caroutput = carInfo.wooutputvolume;
    self.carDisplacementLb.text = caroutput;
    self.carDisplacementTF.text = caroutput;
    
    // 保险公司
    NSString *woinsurecomname = carInfo.cinsurecomname;
    self.secureTF.text = woinsurecomname;
    
    // 保险到期日
    NSString *woinsureenddate = [carInfo.cinsureenddate convertFromFormat:@"yyyyMMddHHmmss" toAnotherFormat:@"yyyy-MM-dd"];
    self.secureDateTF.text = woinsureenddate;
    
    
    // 是否有贵重物品
    UIImage *chooseImg = nil;

    self.preciousBt.selected = NO;
    if ([carInfo.isvaluables integerValue] == 2)
    {
        chooseImg = [UIImage imageNamed:@"work_list_29.png"];
        self.preciousBt.selected = YES;
    }
    
    self.chooseImgView.image = chooseImg;
    
    // 图片视频
    self.picArray = [NSMutableArray arrayWithArray:carInfo.attachments];
    
    carInfo.picArray = self.picArray;
    carInfo.videoModel = self.videoModel;
    [_picCollectionView reloadData];
}


#pragma mark -- 图片视频等数据 --
- (void)setPicArray:(NSMutableArray *)picArray
{
    _picArray = [ZLCamera convertToZLCameraFrom:picArray];
    ZLCamera *camera = [ZLCamera queryCoversFromCameras:_picArray];
    // 设置封面
    [self.cycleCarimgv sd_setImageWithURL:camera.editImageUrl];
    // 设置
    ZLCamera *video = [ZLCamera queryVideoFirstKeframeFromCameras:_picArray];
    [ZLCamera setImageView:self.videoImageView ofVideoModelFirstKeyframe:video];
    self.videoModel = video;
    
    [_picArray removeObject:video];
    
    
    if (_picArray.count > 0 && _picArray.count < 4) {
        _picMoreImgV.hidden = YES;
        _picPreViewMoreBt.hidden = YES;
    }else {
        _picMoreImgV.hidden = NO;
        _picPreViewMoreBt.hidden = NO;
    }
    
    
    [_picCollectionView reloadData];
}

#pragma mark -- 设置页面编辑状态 ---
- (void)setViewEdit:(BOOL)isEdit
{

    for (UIView *view in self.allEditViews)
    {
        view.hidden = !isEdit;
    }
    
    for (UIView *view in self.allScanViews)
    {
        view.hidden = isEdit;
    }

    self.preciousBt.enabled = isEdit;
    
    // 公里数 dd
    NSNumber *status = @0;
    if (!isEdit)
    {
        status = @1;
    }
    
    [self setupBorderWithDSaveStatus:status];
    
    // 保险公司
    self.insuranceDateBtn.enabled = isEdit;
    self.insuranceCompanyBtn.enabled = isEdit;
    self.driverLicenseUpBt.enabled = isEdit;
    self.VINCameraBt.enabled = isEdit;
    self.cycleCarbt.enabled = isEdit;
    
    //  无保修状态保修到期日选择
    
    if ([self.carinfo.crepair integerValue] == 1)
    {
        self.guaranteeDateSuperView.hidden = YES;
        self.guaranreeEndLb.hidden = NO;
    }
    
    if (isEdit && self.carinfo.ccarplate.length) {
        [_preCheckButton setBackgroundImage:[UIImage imageNamed:@"sure_bg_blue.png"] forState:UIControlStateNormal];
        _preCheckButton.enabled = YES;
    }else {
        [_preCheckButton setBackgroundImage:[UIImage imageNamed:@"gray_backGroundImage.png"] forState:UIControlStateNormal];
        _preCheckButton.enabled = NO;
    }
    
    
}



#pragma mark  ------/****更多按钮****/
- (IBAction)preViewMoreBtAction:(UIButton *)sender {
    
    
    if (_picArray.count) {
        //            BillingRightCollectionViewCell *cell = self.picCollectionView.visibleCells.firstObject;
        //            NSIndexPath *index = [self.picCollectionView indexPathForCell:cell];
        
        //            if (index.row == 1) {
        //                cell = [self.picCollectionView.visibleCells objectAtIndex:1];
        //                index = [self.picCollectionView indexPathForCell:cell];
        //            }
        if (self.morePicBlock) {
            
            CGRect rect = [_picPreViewMoreBt convertRect:_picPreViewMoreBt.bounds toView:KEY_WINDOW];
            
            self.morePicBlock(0,rect);
        }
    }else {
        if (self.blillingMessageCenterViewBlock) {
            self.blillingMessageCenterViewBlock(BlillingMessageCenterViewStylePreView,sender,-1,nil);
        }
        
    }
    
    
}
+ (instancetype)initWithCustomFrame:(CGRect)frame {
    
        
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BlillingMessageCenterView" owner:nil options:nil];
    
    BlillingMessageCenterView *billingView = [array objectAtIndex:0];

    billingView.frame = frame;
    
    billingView.DMSnumberTF.delegate = billingView;

    billingView.preOutputDateTF.delegate = billingView;
    
    billingView.carNumberTF.delegate = billingView;
    
    billingView.VINnumberTF.delegate = billingView;
    
    billingView.carStyleTF.delegate = billingView;
    billingView.carCategoryTF.delegate = billingView;
    billingView.carMadeYearTF.delegate = billingView;
    billingView.carDisplacementTF.delegate = billingView;

    billingView.carDistancedTF.delegate = billingView;
    
    billingView.carDistancedTF.inputView = [[PorscheNumericKeyboard alloc] init];
    
    [HDAccessoryView accessoryViewWithTextField:billingView.carDistancedTF target:self];

    billingView.clearView.backgroundColor = [[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.3];
    
    [billingView initDMSTF];
    
    //设置textFieldPlaceholder
    [billingView initNormalTFWithPlaceholderColor:Color(119, 119, 119) font:[UIFont systemFontOfSize:12]];
    
    //collection
    //注册
    [billingView.picCollectionView registerNib:[UINib nibWithNibName:@"BillingRightCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BillingRightCollectionViewCell"];
    
    billingView.roundView.layer.cornerRadius = 5;
    billingView.roundView.layer.masksToBounds = YES;
    billingView.roundView.layer.borderColor = Color(200, 200, 200).CGColor;
    billingView.roundView.layer.borderWidth = 1;
    
    [billingView setupBorderWithDSaveStatus:@0];
    
    return billingView;
}


- (void)setRoundWithView:(UIView *)view withRadius:(NSInteger)radius {
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
}

- (void)setShadowWithView:(UIView *)view {
    //阴影
    view.layer.shadowColor = [UIColor redColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowRadius = 3;
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    
}

#pragma mark  ------ 公里数的键盘添加完成方法
- (void)handleKeybordButtonAction {
    [HD_FULLView endEditing:YES];
}

#pragma mark  ------delegate--datasource----

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _picArray && _picArray.count > 0 ? _picArray.count : self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(105, 75);
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BillingRightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BillingRightCollectionViewCell" forIndexPath:indexPath];
    cell.conImgView.image = [UIImage imageNamed:@""];
    if (_picArray && _picArray.count > 0) {
        ZLCamera *model = self.picArray[indexPath.row];
        [cell.conImgView sd_setImageWithURL:model.editImageUrl];
    }
    
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BillingRightCollectionViewCell *cell = (BillingRightCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
            if (_picArray.count > indexPath.row && [_picArray[indexPath.row] isKindOfClass:[ZLCamera class]]) {
                if (self.blillingMessageCenterViewBlock) {
                    self.blillingMessageCenterViewBlock(BlillingMessageCenterViewStylePreView,nil,indexPath.row,cell);
                }
            }
}


- (void)setPlayAndMoreHidden:(BOOL)status {

}


//默认数据源
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@1,@1,@1, nil];
    }
    return _dataArray;
}

#pragma mark  ------clean------




// 初始化DMS的TF
- (void)initDMSTF {

    [AlertViewHelpers setupCellTFView:_DMSnumberTF save:NO];
    [_carNumberTF setValue:Color(153, 0, 0) forKeyPath:@"_placeholderLabel.textColor"];
    [_carNumberTF setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [_VINnumberTF setValue:Color(153, 0, 0) forKeyPath:@"_placeholderLabel.textColor"];
    [_VINnumberTF setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
}

- (void)initNormalTFWithPlaceholderColor:(UIColor *)color font:(UIFont *)font {
    NSArray *array = @[_secureTF,_secureDateTF,_firstLoginTF,_preOutputDateTF,_carCategoryTF,_guaranteeTF,_guaranteeEndTF,_carStyleTF,_carMadeYearTF,_carDisplacementTF,_carDistancedTF];
    for (UITextField *tmp in array) {
        [tmp setValue:color forKeyPath:@"_placeholderLabel.textColor"];
        [_DMSnumberTF setValue:font forKeyPath:@"_placeholderLabel.font"];
    }
}

#pragma mark -- textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    BlillingMessageCenterViewStyle style = 0;
    if (textField == _DMSnumberTF)
    {
        self.carinfo.wodmsno = _DMSnumberTF.text;
    }
    
    if (textField == _carNumberTF)
    {
        [self removeCarNumberListView];
        self.carinfo.ccarplate = _carNumberTF.text;
        style = BlillingMessageCenterViewStyleCarNumber;
    }
    
    if (textField == _carDistancedTF)
    {
        self.carinfo.wocurmiles = [NSNumber numberWithInteger:_carDistancedTF.text.integerValue];
        _carDistancedTF.text = [[NSString formatMoneyStringWithMilesFloat:_carDistancedTF.text.floatValue] stringByAppendingString:@"公里"];
    }
    
    [self saveViewContentBillingStyle:style];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:_carDistancedTF]) {
        if (![string isEqualToString:@""]) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"公里" withString:@""];
            textField.text = [textField.text removeFirstZero];
            
            string = [NSString stringWithFormat:@"%@公里",string];
            
            if (textField.text.length > 6) {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"公里数过大" height:60 center:self.center superView:self];
                textField.text = [textField.text stringByAppendingString:@"公里"];
            }else {
                textField.text = [textField.text stringByAppendingString:string];

            }
            return NO;
        }else {
            if (textField.text.length > 2) {
                NSString *tmpString = [textField.text stringByReplacingOccurrencesOfString:@"公里" withString:@""];
                textField.text = [textField.text removeFirstZero];

                string = [tmpString substringToIndex:tmpString.length - 1];
                if (string.length == 0) {
                    textField.text = @"";
                }else {
                    //数字键盘的问题，需要多加一个供删除用
                    textField.text = [NSString stringWithFormat:@"%@公里里",string];
                }
                return NO;
            }
        }
        
    }
    else if (textField == _VINnumberTF)
    {
        
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum]invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        BOOL canChange = [string isEqualToString:filtered];
        if (canChange==NO)
        {
            return NO;
        }

    }
    else if (textField == _carNumberTF) {
        
        NSString *tempStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
//            if (textField.text.length >= range.length && [string isEqualToString:@""]) {
//                tempStr = [tempStr substringWithRange:NSMakeRange(0, textField.text.length - range.length)];
//            }else {
//                tempStr = [textField.text stringByAppendingString:string];
//            }
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
        NSString *firstStr = @"";
        NSString *secndStr = @"";
        if (self.carLocationLb.text.length) {
            firstStr = self.carLocationLb.text;
        }
        if (tempStr.length) {
            secndStr = tempStr;
        }
        NSString *resultStr = [NSString stringWithFormat:@"%@%@", firstStr, tempStr];
        [param hs_setSafeValue:resultStr forKey:@"plateall"];
        WeakObject(self)
        if (resultStr.length) {
            [PorscheRequestManager carNumberInputListWithParam:param completion:^(NSArray<PorscheConstantModel *> * _Nonnull carNumberList, PResponseModel * _Nonnull responser) {
                
                if (carNumberList.count) {
                    if (!([self.cententView.subviews containsObject:selfWeak.carNumberListView])) {
                        CGFloat height = carNumberList.count * 40 < 200 ? carNumberList.count * 40 : 200;
                        CGSize size = CGSizeMake(CGRectGetWidth(_carNumberTF.frame), height);
                        selfWeak.carNumberListView = [HDWorkListTableViews showTableViewlistViewAroundView:_carNumberTF superView:self.cententView direction:UIPopoverArrowDirectionUp dataSource:[carNumberList mutableCopy] size:size seletedNeedDelete:NO complete:^(NSNumber *idx, BOOL needAccessoryDisclosureIndicator, HDWorkListTableViewsStyle style) {
                            PorscheConstantModel *model = selfWeak.carNumberListView.dataSource[[idx integerValue]];
                            selfWeak.carNumberTF.text = model.extrainfo;
                            selfWeak.carLocationLb.text = model.cvsubidstr;
                            selfWeak.carinfo.plateplace = selfWeak.carLocationLb.text;
                            [selfWeak.carNumberTF resignFirstResponder];
                            
                            [selfWeak removeCarNumberListView];
                        }];
                        
                        [self.cententView addSubview:selfWeak.carNumberListView];
                        
                    }else {
                        selfWeak.carNumberListView.dataSource = [NSArray arrayWithArray:carNumberList];
                    }
                }else {
                    [selfWeak removeCarNumberListView];
                }
            }];
        }else {
            [selfWeak removeCarNumberListView];
        }
    }
    
    
    return YES;
}

#pragma mark  ------视频播放按钮
- (IBAction)videoPalyBtAction:(UIButton *)sender {
    [self registerFirstForTF];

    if (self.blillingMessageCenterViewBlock) {
        self.blillingMessageCenterViewBlock(BlillingMessageCenterViewStyleVideo,sender,-1,nil);
    }
}


- (IBAction)dateChooseBtAction:(UIButton *)sender {
    [self registerFirstForTF];
    [self predictPayAboutDate];
}
/****行驶证正面****/
- (IBAction)liscenceUpBtAction:(UIButton *)sender {
    [self registerFirstForTF];

    if (self.blillingMessageCenterViewBlock) {
        self.blillingMessageCenterViewBlock(BlillingMessageCenterViewStyleCameraUp,sender,-1,nil);
    }
}
/****行驶证背面****/
- (IBAction)liscenceDownAction:(UIButton *)sender {
}
/****换车牌照按钮****/
- (IBAction)cycleBtAction:(UIButton *)sender {
    [self registerFirstForTF];

    if (self.blillingMessageCenterViewBlock) {
        self.blillingMessageCenterViewBlock(BlillingMessageCenterViewStyleCycle,sender,-1,nil);
    }
}
/****照片查看按钮****/
- (IBAction)picPreViewBtAction:(UIButton *)sender {
}
#pragma mark  ------/****更多按钮****/

/****车牌省会按钮****/
- (IBAction)carLocationBtAction:(UIButton *)sender {
    [self registerFirstForTF];
    [self carNumberLocation];

}
/****车系按钮****/
- (IBAction)carCategoryBtAction:(UIButton *)sender {
    [self registerFirstForTF];

    [self carsSelectFromView:sender];
}
/****车型按钮****/
- (IBAction)carStyleBtAction:(UIButton *)sender {
    [self registerFirstForTF];

    [self cartypeSelectFromView:sender];
}
- (IBAction)VINBtAction:(UIButton *)sender {

    [self.VINnumberTF becomeFirstResponder];
    [self.VINaccessoryView showInputView:self originalVINNo:self.VINnumberTF.text textField:self.VINnumberTF];
}


//年款
- (IBAction)carYearBtAction:(UIButton *)sender {
    [self registerFirstForTF];

    [self caryearSelectFromView:sender];
}
//排量
- (IBAction)carDismentBtAction:(UIButton *)sender {
    [self registerFirstForTF];

    [self cardisplacementSelectFromView:sender];
}

- (IBAction)guaranteeBtAction:(UIButton *)sender {
    [self registerFirstForTF];

    [self guaranteeStatusSelectFrom:sender];
    
}

- (IBAction)guaranteeEndBtAction:(UIButton *)sender {

    [self registerFirstForTF];

    [self guaranteeEndDateAction];
    
}

- (IBAction)firstLoginBtAction:(UIButton *)sender {
    [self registerFirstForTF];

    [self firstLoginDateAction];
}
- (void)setupBorderWithDSaveStatus:(NSNumber *)issave {
    _secureImageView.hidden = [issave integerValue];
    _sceureDateImg.hidden = [issave integerValue];
    
    [AlertViewHelpers setupCellTFView:_secureTF save:[issave integerValue]];
    [AlertViewHelpers setupCellTFView:_secureDateTF save:[issave integerValue]];
    _secureTF.placeholder = [issave integerValue]? @"":@"请选择保险公司";
    _secureDateTF.placeholder = [issave integerValue]? @"":@"请选择保险到期日期";
}
//选择保险公司
- (IBAction)chooseSecureCompanyAction:(UIButton *)sender {
    if ([_saveStatus integerValue] == 1) {
        return;
    }
    [self chooseSecureCompanyActionButton:sender];
}
//选择保险到期时间
- (IBAction)secureDateBtAction:(UIButton *)sender {
    if ([_saveStatus integerValue] == 1) {
        return;
    }

    [self secureEndedDateAction];
}


- (IBAction)isHasPrecious:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        _chooseImgView.image = [UIImage imageNamed:@"work_list_29.png"];
        self.carinfo.isvaluables = @2;
    }
    else
    {
        _chooseImgView.image = nil;
        self.carinfo.isvaluables = @1;
    }
    [self saveViewContentBillingStyle:0];
    
}

#pragma mark  获取参数




- (IBAction)vinRecognizeAction:(id)sender {
    if (self.blillingMessageCenterViewBlock) {
        self.blillingMessageCenterViewBlock(BlillingMessageCenterViewStyleVinPhotoRecognize,sender,-1,nil);
    }
    
}


#pragma mark -- 预计交车时间 --
- (void)predictPayAboutDate {
    WeakObject(self);
    [HD_FULLView endEditing:YES];

    [HDPoperDeleteView showTimeAndSecondViewFrame:CGRectMake(0, 0, 500, 300) aroundView:selfWeak.preLocationBt style:HDWorkListDateChooseViewStyleTimeBegin direction:UIPopoverArrowDirectionUp sure:^(NSString *string) {
        selfWeak.preOutputDateTF.text =  [string convertFromFormat:@"yyyy-MM-dd HH:mm:ss" toAnotherFormat:@"yyyy-MM-dd HH:mm"];;
        selfWeak.carinfo.wofinishtime = [string convertFromFormat:@"yyyy-MM-dd HH:mm:ss" toAnotherFormat:@"yyyyMMddHHmmss"];
        [selfWeak saveViewContentBillingStyle:0];
    } cancel:^{
        
    }];
}

#pragma mark -- 保修到期日 --
- (void)guaranteeEndDateAction {
    WeakObject(self);
    [HDPoperDeleteView showDateAndWeekViewWithFrame:CGRectMake(0, 0, 300, 200) aroundView:self.guaranteeEndLocationBt direction:UIPopoverArrowDirectionUp headerTitle:@"保修到期日" isLimit:YES style:HDRightDateChooseViewStyleBegin complete:^(HDRightDateChooseViewStyle style, NSString *endStr) {
        //赋值
        selfWeak.guaranteeEndTF.text = endStr;
        selfWeak.carinfo.crepairtime = [endStr convertFromFormat:@"yyyy-MM-dd" toAnotherFormat:@"yyyyMMddHHmmss"];
        [selfWeak saveViewContentBillingStyle:0];
    }];
}


#pragma mark -- 保修状态选择 --
- (void)guaranteeStatusSelectFrom:(UIView *)view
{
    if (!self.guaranteeStatus.count)
    {
        self.guaranteeStatus = [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataWarranty];//@[@"无保修",@"新车保修",@"延长保修"];
    }
    
    WeakObject(self);
    
    [PorscheMultipleListhView showSingleListViewFrom:view dataSource:self.guaranteeStatus selected:nil showArrow:NO direction:ListViewDirectionDown complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
        //
        selfWeak.guaranteeTF.text = constantModel.cvvaluedesc;
        selfWeak.guaranteeStatusLb.text = constantModel.cvvaluedesc;
        selfWeak.carinfo.crepair = constantModel.cvsubid;
        
        // 是否无保修
        if ([constantModel.cvsubid isEqualToNumber:@1])
        {
            selfWeak.guaranteeDateSuperView.hidden = YES;
            selfWeak.guaranreeEndLb.hidden = NO;
        }
        else
        {
            selfWeak.guaranteeDateSuperView.hidden = NO;
            selfWeak.guaranreeEndLb.hidden = YES;
        }
        
        [selfWeak saveViewContentBillingStyle:0];
    }];
}


#pragma mark -- 车系选择 -- 
- (void)carsSelectFromView:(UIView *)view
{
    WeakObject(self);

    // 获取VIN适配车型
    NSArray *cars = [self.carinfo getCarseries];
    if (cars.count)
    {

        [PorscheMultipleListhView showSingleListViewFrom:view dataSource:cars selected:nil showArrow:NO showClearButton:NO direction:ListViewDirectionDown withLimit:@1 complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
            [selfWeak selectCarsFinishedHandleWithCarsModel:constantModel];
        }];
    }
    else
    {
        __block MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self];
        [PorscheRequestManager getAllCarSeriersConstant:^(NSArray<PorscheConstantModel *> * _Nullable carSeries, PResponseModel * _Nullable responser) {
            [hud hideAnimated:YES];
            [PorscheMultipleListhView showSingleListViewFrom:view dataSource:carSeries selected:nil showArrow:NO showClearButton:NO direction:ListViewDirectionDown withLimit:@1 complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
                [selfWeak selectCarsFinishedHandleWithCarsModel:constantModel];
            }];
        }];
    }
}

- (void)selectCarsFinishedHandleWithCarsModel:(PorscheConstantModel *)constantModel
{
    self.carCategoryLb.text = constantModel.cvvaluedesc;
    self.carCategoryTF.text = constantModel.cvvaluedesc;
    self.carinfo.carsid = constantModel.cvsubid;
    self.carinfo.savecartypeid = constantModel.cvsubid;
    
    // 清除之前数据
    self.carStyleTF.text = @"";
    self.carStyleLb.text = @"";
    self.carYearLb.text = @"";
    self.carMadeYearTF.text = @"";
    self.carDisplacementTF.text = @"";
    self.carDisplacementLb.text = @"";
    self.carinfo.cartypeid = nil;
    self.carinfo.caryearid = nil;
    self.carinfo.cardisplacementid = nil;
    
    
    [self saveViewContentBillingStyle:BlillingMessageCenterViewStyleCarCategory];
    // 获取车型
    [self cartypeSelectFromView:self.carStyleBt];
}


#pragma mark -- 车型选择 --
- (void)cartypeSelectFromView:(UIView *)view
{
    WeakObject(self);
    
    NSArray *cartypes = [self.carinfo getCartypeWithCarspctid:self.carinfo.carsid];
    if (cartypes.count)
    {
        [PorscheMultipleListhView showSingleListViewFrom:view dataSource:cartypes selected:nil showArrow:NO showClearButton:NO direction:ListViewDirectionDown withLimit:@1 complete:^(PorscheConstantModel *constantModel, NSInteger idx) {
            [selfWeak selectCartypeFinishedHandleWithCarsModel:constantModel];
        }];
    }
    else
    {
//        __block MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self];
        [PorscheRequestManager getAllCarTypeConstantWithCarsPctid:self.carinfo.carsid completion:^(NSArray<PorscheConstantModel *>  * _Nullable cartypes , PResponseModel * _Nullable response) {
//            [hud hideAnimated:YES];
            [PorscheMultipleListhView showSingleListViewFrom:view dataSource:cartypes selected:nil showArrow:NO showClearButton:NO direction:ListViewDirectionDown withLimit:@1 complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
                
                [selfWeak selectCartypeFinishedHandleWithCarsModel:constantModel];
            }];
        }];
    
    }
}

- (void)selectCartypeFinishedHandleWithCarsModel:(PorscheConstantModel *)constantModel
{
    self.carStyleTF.text = constantModel.cvvaluedesc;
    self.carStyleLb.text = constantModel.cvvaluedesc;
    self.carinfo.cartypeid = constantModel.cvsubid;
    
    
    self.carinfo.savecartypeid = constantModel.cvsubid;
    
    // 清除之前数据
    self.carYearLb.text = @"";
    self.carMadeYearTF.text = @"";
    self.carDisplacementTF.text = @"";
    self.carDisplacementLb.text = @"";
    self.carinfo.caryearid = nil;
    self.carinfo.cardisplacementid = nil;
    
    [self saveViewContentBillingStyle:0];
    
    [self caryearSelectFromView:self.carYearBt];

}


#pragma mark -- 年款选择 --
- (void)caryearSelectFromView:(UIView *)view
{
    WeakObject(self);
    
    NSArray *caryears = [self.carinfo getCaryearWithCarspctid:self.carinfo.carsid cartypepctid:self.carinfo.cartypeid];
    if (caryears.count)
    {
        [PorscheMultipleListhView showSingleListViewFrom:view dataSource:caryears selected:nil showArrow:NO showClearButton:NO direction:ListViewDirectionDown withLimit:@1 complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
            
            [selfWeak selectCaryearFinishedHandleWithCarsModel:constantModel];
        }];
    }
    else
    {
//        __block MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self];
        [PorscheRequestManager getAllCarYearConstantWithCartypePctid:self.carinfo.cartypeid completion:^(NSArray<PorscheConstantModel *>  * _Nullable caryears , PResponseModel * _Nullable response) {
//            [hud hideAnimated:YES];
            [PorscheMultipleListhView showSingleListViewFrom:view dataSource:caryears selected:nil showArrow:NO showClearButton:NO direction:ListViewDirectionDown withLimit:@1 complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
                
                [selfWeak selectCaryearFinishedHandleWithCarsModel:constantModel];
            }];
        }];
    }
}

- (void)selectCaryearFinishedHandleWithCarsModel:(PorscheConstantModel *)constantModel
{
    self.carYearLb.text = constantModel.cvvaluedesc;
    self.carMadeYearTF.text = constantModel.cvvaluedesc;
    self.carinfo.caryearid = constantModel.cvsubid;
    
    self.carinfo.savecartypeid = constantModel.cvsubid;
    
    // 清除之前数据
    self.carDisplacementTF.text = @"";
    self.carDisplacementLb.text = @"";
    self.carinfo.cardisplacementid = nil;
    
    [self saveViewContentBillingStyle:0];
    
    [self cardisplacementSelectFromView:self.carDisplacementBt];
}


#pragma mark -- 排量选择 --
- (void)cardisplacementSelectFromView:(UIView *)view
{
    WeakObject(self);

    //
    NSArray *cardisplacements = [self.carinfo getCaroutputWithCarspctid:self.carinfo.carsid cartypepctid:self.carinfo.cartypeid caryearpctid:self.carinfo.caryearid];
    if (cardisplacements.count)
    {
        [PorscheMultipleListhView showSingleListViewFrom:view dataSource:cardisplacements selected:nil showArrow:NO showClearButton:NO direction:ListViewDirectionDown withLimit:@1 complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
            [selfWeak selectCaroutputFinishedHandleWithCarsModel:constantModel];
        }];
    }
    else
    {
//        __block MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self];
        
        [PorscheRequestManager getAllCarOutputConstantWithCaryearPctid:self.carinfo.caryearid completion:^(NSArray<PorscheConstantModel *>  * _Nullable cartypes , PResponseModel * _Nullable response) {
//            [hud hideAnimated:YES];
            [PorscheMultipleListhView showSingleListViewFrom:view dataSource:cartypes selected:nil showArrow:NO showClearButton:NO direction:ListViewDirectionDown withLimit:@1 complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
                [selfWeak selectCaroutputFinishedHandleWithCarsModel:constantModel];
            }];
        }];
    }
}

- (void)selectCaroutputFinishedHandleWithCarsModel:(PorscheConstantModel *)constantModel
{
    self.carDisplacementLb.text = constantModel.cvvaluedesc;
    self.carDisplacementTF.text = constantModel.cvvaluedesc;
    self.carinfo.cardisplacementid = constantModel.cvsubid;
    
    self.carinfo.savecartypeid = constantModel.cvsubid;
    
    [self saveViewContentBillingStyle:0];
}


#pragma mark --- 首登日期 ---
- (void)firstLoginDateAction {
    WeakObject(self);
    [HDPoperDeleteView showDateAndWeekViewWithFrame:CGRectMake(0, 0, 300, 200) aroundView:self.firstLoginBt direction:UIPopoverArrowDirectionAny headerTitle:@"首登日期" isLimit:NO style:HDRightDateChooseViewStyleBegin complete:^(HDRightDateChooseViewStyle style, NSString *endStr) {
        //赋值
        selfWeak.firstLoginTF.text = endStr;
        selfWeak.carinfo.cregisterdate = [endStr convertFromFormat:@"yyyy-MM-dd" toAnotherFormat:@"yyyyMMddHHmmss"];
        [selfWeak saveViewContentBillingStyle:0];
    }];
}

#pragma mark --- 保险公司选择 ---
- (void)chooseSecureCompanyActionButton:(UIButton *)button {
    
    if (!self.insuranceArray.count) {
        self.insuranceArray = [NSMutableArray arrayWithArray:[[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataInsuranceCompany]];
    }
    [self showInsuranceCompanyFromView:button];
    
}

#pragma mark --- 保险到期日期 ---
- (void)secureEndedDateAction {
    WeakObject(self);
    [HDPoperDeleteView showDateAndWeekViewWithFrame:CGRectMake(0, 0, 300, 200) aroundView:self.secureDateTF direction:UIPopoverArrowDirectionDown headerTitle:@"保险到期日期" isLimit:YES style:HDRightDateChooseViewStyleBegin complete:^(HDRightDateChooseViewStyle style, NSString *endStr) {
        //赋值
        selfWeak.secureDateTF.text = endStr;
        selfWeak.carinfo.cinsureenddate = [endStr convertFromFormat:@"yyyy-MM-dd" toAnotherFormat:@"yyyyMMddHHmmss"];
        
        [selfWeak saveViewContentBillingStyle:0];
    }];
    
}


- (void)showInsuranceCompanyFromView:(UIView *)view {
    WeakObject(self);
    
    [PorscheMultipleListhView showSingleListViewFrom:view dataSource:self.insuranceArray selected:nil showArrow:NO direction:ListViewDirectionUp complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
        
        selfWeak.secureTF.text = constantModel.cvvaluedesc;
        selfWeak.carinfo.cinsurecomname = constantModel.cvvaluedesc;
        selfWeak.carinfo.cinsurecomid = constantModel.cvsubid;
        
        [selfWeak saveViewContentBillingStyle:0];
    }];
}


#pragma mark --- 省会选择 ---

- (void)carNumberLocation {
    WeakObject(self);
    if (!selfWeak.carCardastralPoperController) {
        
        selfWeak.carCardastralPoperController = [AlertViewHelpers getPoperVCWithCustomView:[[HDInputCarCadastralView alloc]initViewWithDelegate:self] popoverContentSize:CGSizeMake(400, 330)];
        selfWeak.carCardastralPoperController.backgroundColor = [UIColor lightGrayColor];
    }
    
    [selfWeak.carCardastralPoperController presentPopoverFromRect:selfWeak.carLocationbt.bounds inView:selfWeak.carLocationbt permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

#pragma mark -- 保存数据 --
- (void)saveViewContentBillingStyle:(BlillingMessageCenterViewStyle)style
{
    if ([self.delegate respondsToSelector:@selector(billingViewSaveCarInfo:blillingMessageCenterViewStyle:)])
    {
        [self.delegate billingViewSaveCarInfo:self.carinfo blillingMessageCenterViewStyle:style];
    }
}


#pragma mark  省会选择弹窗代理方法
//点击文字事件
- (void)inputCarCadastralView:(HDInputCarCadastralView *)view didSelectString:(NSString *)string {
    
    self.carLocationLb.text = string;
    
    [self.carCardastralPoperController dismissPopoverAnimated:YES];
    
    if ([string isEqualToString:@"未上牌"]) {
        self.carNumberTF.text = nil;
        self.carNumberTF.placeholder = @"*请输入车辆标记";
    }else {
        self.carNumberTF.placeholder = @"*请输入车牌号";
    }
    
    self.carinfo.plateplace = string;
    
    [self.carNumberTF becomeFirstResponder];
    
    [self saveViewContentBillingStyle:0];
    
}
// 取消按钮事件
- (void)inputCarCadastralView:(HDInputCarCadastralView *)view cancelButtonAction:(UIButton *)button {
    
    [self.carCardastralPoperController dismissPopoverAnimated:YES];
}


//VIN辅助弹框
- (HDInputVINView *)VINaccessoryView {
    if (!_VINaccessoryView) {
        //frame 根据文字框大小
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HDInputVINView" owner:self options:nil];
        
        _VINaccessoryView = [nib objectAtIndex:0];
        _VINaccessoryView.frame = CGRectMake(0, 0, HD_WIDTH, (HD_WIDTH + 120) / 18 + 10);
        
        _VINaccessoryView.btSuperView.layer.masksToBounds = YES;
        _VINaccessoryView.btSuperView.layer.cornerRadius = 5;
    }
    return _VINaccessoryView;
}

- (void)inputVINView:(HDInputVINView *)inputView inputVIN:(NSString *)vinNo
{
    self.carinfo.cvincode = vinNo;
    [self saveViewContentBillingStyle:BlillingMessageCenterViewStyleVIN];
}
#pragma mark --- 取消页面响应 ---

- (void)registerFirstForTF
{
    [self endEditing:YES];
    
    [self removeCarNumberListView];
}

- (void)removeCarNumberListView {
    for (UIView *view in self.cententView.subviews) {
        if ([view isKindOfClass:[HDWorkListTableViews class]]) {
            [view removeFromSuperview];
        }
    }
}
- (IBAction)precheckAction:(id)sender {
    
    if (self.blillingMessageCenterViewBlock) {
        self.blillingMessageCenterViewBlock(BlillingMessageCenterViewStylePrecheckOrder,sender,-1,nil);
    }
}

@end
