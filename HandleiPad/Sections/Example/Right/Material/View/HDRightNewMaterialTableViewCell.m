//
//  HDRightNewMaterialTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDRightNewMaterialTableViewCell.h"
#import "HDLeftSingleton.h"

@interface HDRightNewMaterialTableViewCell ()<UITextFieldDelegate,UITextViewDelegate>
//键盘辅助视图
@property (nonatomic, strong) UIView *clearView;
@property (nonatomic, strong) NSArray *addedBtArray;


@end

@implementation HDRightNewMaterialTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    _numberTF.delegate = self;
    _materialTF.delegate = self;
    _materialCountTF.delegate = self;
    _materialPriceTF.delegate = self;
    
    [self setuptextViewCornerRadius];
    //    _numberTF.inputAccessoryView = self.clearView;
    
    // Initialization code
}

- (void)cannotEditSpare
{
    if (_tmpModel)
    {
        [AlertViewHelpers setupCellTFView:_addedNumberListTF save:YES];
        [AlertViewHelpers setupCellTFView:_addedNumberTF save:[_saveStatus integerValue]];
        _numberSuperView.layer.borderColor =  [UIColor clearColor].CGColor;
        _numberSuperView.layer.borderWidth =  0 ;
    }
}

#pragma mark  textView_delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if (_tmpModel) {
//            [self returnAction];
            PorscheNewSchemews *tmp = _tmpModel;
            tmp.schemewsname = textView.text;
            tmp.wospwosid = _tmpModel.wospwosid;
            tmp.schemewsid = _tmpModel.schemewsid;
            if (self.addedReturnBlock) {
                self.addedReturnBlock(tmp);
            }
        }
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"备件名称"]) {
        textView.text = nil;
        textView.textColor = Color(119, 119, 119);
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (!textView.text || [textView.text isEqualToString:@""]) {
        textView.text = @"备件名称";
        textView.textColor = Color(200, 200, 200);
    }
}

- (void)setuptextViewCornerRadius {
    _materialNameTView.layer.masksToBounds = YES;
    _materialNameTView.layer.cornerRadius = 5;
    _materialNameTView.layer.borderWidth = 0.5;
    _materialNameTView.layer.borderColor = Color(200, 200, 200).CGColor;
}

- (void)returnAction {
   
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (self.hDRightNewMaterialTableViewCellBlock) {
        
        self.hDRightNewMaterialTableViewCellBlock(HDRightNewMaterialTableViewCellStyleNormalTF,nil);
    }
    if (_tmpModel) {
        if ([textField isEqual:_materialPriceTF]) {
            _materialPriceTF.attributedPlaceholder = [[NSString formatMoneyStringWithFloat:[_tmpModel.schemewsunitprice floatValue]] setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
        }else if ([textField isEqual:_materialCountTF]) {
            _materialCountTF.attributedPlaceholder = _tmpModel.schemewscount ? [[NSString stringWithFormat:@"%.2f",[_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY] : [@"0.00" setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
        }
    }
}
#pragma mark  修改库存数量，编辑备件
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (_tmpModel) {
        if ([textField isEqual:_materialPriceTF]) {
            _materialPriceTF.attributedPlaceholder = [[NSString formatMoneyStringWithFloat:[_tmpModel.schemewsunitprice floatValue]] setTFplaceHolderWithMainGray];
            
            
        }else if ([textField isEqual:_materialCountTF]) {
            _materialCountTF.attributedPlaceholder = _tmpModel.schemewscount ? [[NSString stringWithFormat:@"%.2f",[_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGray] : [@"0.00" setTFplaceHolderWithMainGray];
            
        }
    }
    
    if ([textField isEqual:_materialCubCountTFOne]) {
        ProscheMaterialLocationModel *cubOne = _tmpModel.partsstocklist.firstObject;

        if ([cubOne.pbsamount isEqualToString:textField.text]) {
            return;
        }
        if (cubOne.pbsamount && (!textField.text || [textField.text isEqualToString:@""])) {
            return;
        }
        ProscheMaterialLocationModel *model = [ProscheMaterialLocationModel new];
        model.pbsid = cubOne.pbsid;
        model.pbspbid = cubOne.pbspbid;
        model.pbstockid = cubOne.pbstockid;
        model.pbsamount = textField.text;
        if (self.editCubCount) {
            self.editCubCount(model);
        }
        return;
    }
    
    if ([textField isEqual:_materialCubCountTFTwo]) {
        ProscheMaterialLocationModel *cubOne = _tmpModel.partsstocklist[1];
        
        if ([cubOne.pbsamount isEqualToString:textField.text]) {
            return;
        }
        if (cubOne.pbsamount && (!textField.text || [textField.text isEqualToString:@""])) {
            return;
        }
        ProscheMaterialLocationModel *model = [ProscheMaterialLocationModel new];
        model.pbsid = cubOne.pbsid;
        model.pbspbid = cubOne.pbspbid;
        model.pbstockid = cubOne.pbstockid;
        model.pbsamount = textField.text;
        if (self.editCubCount) {
            self.editCubCount(model);
        }
        return;
    }
    if ([textField isEqual:_materialCubCountTFThree]) {
        ProscheMaterialLocationModel *cubOne = _tmpModel.partsstocklist[2];
        
        if ([cubOne.pbsamount isEqualToString:textField.text]) {
            return;
        }
        if (cubOne.pbsamount && (!textField.text || [textField.text isEqualToString:@""])) {
            return;
        }
        ProscheMaterialLocationModel *model = [ProscheMaterialLocationModel new];
        model.pbsid = cubOne.pbsid;
        model.pbspbid = cubOne.pbspbid;
        model.pbstockid = cubOne.pbstockid;
        model.pbsamount = textField.text;
        if (self.editCubCount) {
            self.editCubCount(model);
        }
        return;
    }
    if ([textField isEqual:_materialCubCountTFFour]) {
        ProscheMaterialLocationModel *cubOne = _tmpModel.partsstocklist[3];
        
        if ([cubOne.pbsamount isEqualToString:textField.text]) {
            return;
        }
        if (cubOne.pbsamount && (!textField.text || [textField.text isEqualToString:@""])) {
            return;
        }
        ProscheMaterialLocationModel *model = [ProscheMaterialLocationModel new];
        model.pbsid = cubOne.pbsid;
        model.pbspbid = cubOne.pbspbid;
        model.pbstockid = cubOne.pbstockid;
        model.pbsamount = textField.text;
        if (self.editCubCount) {
            self.editCubCount(model);
        }
        return;
    }
    
    
    if ([textField isEqual:_materialTF]) {
        if ([_tmpModel.schemewsname isEqualToString:textField.text]) {
            return;
        }
        if (_tmpModel.schemewsname && (!textField.text || [textField.text isEqualToString:@""])) {
            return;
        }
        
    }
    
    if ([textField isEqual:_materialPriceTF]) {
        if (textField.text.length > 1 && [@([[textField.text substringFromIndex:1] floatValue]) isEqual:_tmpModel.schemewsunitprice]) {
            return;
        }
        if (_tmpModel.schemewsunitprice && (!textField.text || [textField.text isEqualToString:@""])) {
            return;
        }
    }
    
    if ([textField isEqual:_materialCountTF]) {
        if (textField.text.length > 2 && [@([[textField.text substringToIndex:textField.text.length - 2] floatValue]) isEqual:_tmpModel.schemewscount]) {
            return;
        }
        if (_tmpModel.schemewscount && (!textField.text || [textField.text isEqualToString:@""])) {
            return;
        }
    }
    
    //添加的新工时行数据
    PorscheNewSchemews *tmp ;
    //添加的新工时行数据
    if(_tmpModel)
    {
        tmp = _tmpModel;
    }
    else
    {
        tmp = [PorscheNewSchemews new];
    }
    
    if (_materialTF.text.length > 0) {
        tmp.schemewsname = _materialTF.text;
    }else {
        if (_tmpModel) {
            tmp.schemewsname = _tmpModel.schemewsname;
        }
    }
    if (_materialPriceTF.text.length > 1) {
        tmp.schemewsunitprice = @([[_materialPriceTF.text substringFromIndex:1] floatValue]);
    }else {
        if (_tmpModel) {
            tmp.schemewsunitprice = _tmpModel.schemewsunitprice;
        }
    }
    
    if (_materialCountTF.text.length > 0) {
        tmp.schemewscount = @([_materialCountTF.text floatValue]);
    }else {
        if (_tmpModel) {
            tmp.schemewscount = _tmpModel.schemewscount;
        }
    }
    
    if (_tmpModel) {
        tmp.wospwosid = _tmpModel.wospwosid;
        tmp.schemewsid = _tmpModel.schemewsid;
    }else {
        tmp.schemewsid = @0;
    }
    
    if (self.addedReturnBlock) {
        self.addedReturnBlock(tmp);
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:self.materialPriceTF]) {
        if (![string isEqualToString:@""]) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
            
            NSRange realRange = NSMakeRange(range.location - 1, range.length);
            BOOL ret = [HDUtil textFieldFilter:textField shouldChangeCharactersInRange:realRange replacementString:string];
            if (!ret) {
                textField.text =  [NSString stringWithFormat:@"￥%@",textField.text];
                return NO;
            }
            
            textField.text = [textField.text stringByAppendingString:string];
            textField.text =  [NSString stringWithFormat:@"￥%@",textField.text];
            return NO;
        }else {
            if (textField.text.length > 1) {
                string = [textField.text substringToIndex:textField.text.length - 1];
                if (string.length == 1) {
                    textField.text = @"";
                }else {
                    textField.text = string;
                }
                return NO;
            }
        }
        
    }
    else if (textField == _materialCountTF)
    {
        BOOL ret = [HDUtil textFieldFilter:textField shouldChangeCharactersInRange:range replacementString:string];
        return ret;
    }
    
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)numberBtAction:(UIButton *)sender {
    if (self.hDRightNewMaterialTableViewCellBlock) {
        
        self.hDRightNewMaterialTableViewCellBlock(HDRightNewMaterialTableViewCellStyleTF,nil);
    }
}

- (IBAction)chooseBtAction:(UIButton *)sender {
    if (self.hDRightNewMaterialTableViewCellBlock) {
        self.hDRightNewMaterialTableViewCellBlock(HDRightNewMaterialTableViewCellStyleChoose,sender);
    }
}

- (IBAction)addBtAction:(UIButton *)sender {
    if (self.hDRightNewMaterialTableViewCellBlock) {
        self.hDRightNewMaterialTableViewCellBlock(HDRightNewMaterialTableViewCellStyleAdd,sender);
    }
}

- (IBAction)cubAction:(UIButton *)sender {
    if ([_saveStatus integerValue] == 1) {
        return;
    }
    if (self.hDRightNewMaterialTableViewCellBlock) {
        self.hDRightNewMaterialTableViewCellBlock(HDRightNewMaterialTableViewCellStyleAddCub,sender);
    }
}

- (void)setupDeaultView {
    _headerImageView.image = [UIImage imageNamed:@"hd_custom_item_time_material.png"];

    _addbtSuperView.hidden = YES;
    _addBt.hidden = YES;
    _addBtbg.hidden = YES;
    _deleteImgSuperview.hidden = YES;

    if (_tmpModel) {
        _chooseBt.hidden = NO;
        _deleteImgSuperview.hidden = NO;
        _deleteImage.hidden = NO;
        _deleteImgSuperview.hidden = NO;

        if (![HDLeftSingleton isUserAdded:_tmpModel.projectaddid]) {
            _deleteImage.hidden = YES;
        }
        if ([_tmpModel.schemewstype integerValue] != 2) {
            _headerImageView.image = [UIImage imageNamed:@"work_list_25.png"];
        }
    }else {
        _addbtSuperView.hidden = NO;
        _addBt.hidden = NO;
        _addBtbg.hidden = NO;
    }
}

- (NSNumber *)showPrice {
    if (![_tmpModel.superschemesettlementway isEqual:@3]) {
        return _tmpModel.schemewstotalprice;
    }else {
        if ([_tmpModel.schemesettlementway isEqual:@3]) {
            return _tmpModel.schemewsunitprice_yuan;
        }else {
            return _tmpModel.schemewstotalprice;
        }
    }
}


- (void)setTmpModel:(PorscheNewSchemews *)tmpModel {
    _tmpModel =tmpModel;
    [self setupDeaultView];
    if (tmpModel) {
        [self setDataArrayForLocation];
    }
    [self setupText];//清空库存数量
    [self cleanCell];//清空价格、名字、编号等数据
    [self setupPbTF];//清空库存数据
    [self setDefaultTFPlaceHolder];
    [self setupAllBorderWithsaveStatus:_saveStatus];
    [self setBackImage];
    // 给库存赋值
    [self setlocationAndCount];
    //显示添加的库存View
    [self hiddenLocationView];
    _numberSuperView.hidden = YES;
    _materialNameTView.hidden = YES;
    
    if (tmpModel) {
        _materialNameTView.hidden = NO;
        _numberSuperView.hidden = NO;
        
        //图号有值，设置按钮无字
        if ( tmpModel.schemewsphotocode && tmpModel.schemewsphotocode.length > 0) {
            [_numberBt setTitle:@"" forState:UIControlStateNormal];
        }
        //图号
        if (tmpModel.schemewsphotocode.length > 0) {
            _addedNumberTF.attributedPlaceholder = [tmpModel.schemewsphotocode setTFplaceHolderWithMainGray];
        }else {
            _addedNumberTF.attributedPlaceholder = [@"  图号" setTFplaceHolderWithMainGrayWithColor:Color(200, 200, 200)];
        }
        //编号
        if (tmpModel.schemewscode.length > 0) {
            _addedNumberListTF.attributedPlaceholder = [tmpModel.schemewscode setTFplaceHolderWithMainGray];
        }else {
            _addedNumberListTF.attributedPlaceholder = [@"  编号" setTFplaceHolderWithMainGrayWithColor:Color(200, 200, 200)];
        }
        
        if (tmpModel.schemewsname.length > 0) {

            
            [AlertViewHelpers setupTview:_materialNameTView color:Color(119, 119, 119) string:tmpModel.schemewsname maxLength:5];

        }else {
            
            [AlertViewHelpers setupTview:_materialNameTView color:Color(200, 200, 200) string:@"备件名称" maxLength:5];

        }
        
        if (tmpModel.schemewsunitprice) {
            _materialPriceTF.attributedPlaceholder = [[NSString formatMoneyStringWithFloat:[tmpModel.schemewsunitprice floatValue]] setTFplaceHolderWithMainGray];
        }
        
        if (tmpModel.schemewscount) {
            _materialCountTF.attributedPlaceholder = tmpModel.schemewscount? [[NSString stringWithFormat:@"%.2f",[tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGray] : [@"0.00" setTFplaceHolderWithMainGray];
        }
        
        _materialTotalPriceTF.attributedPlaceholder = [[NSString formatMoneyStringWithFloat:[[self showPrice] floatValue]] setTFplaceHolderWithMainGray];

        //所属方案是否自费  1.内结  2.保修  3.自费
        if (![_tmpModel.superschemesettlementway isEqualToNumber:@3]) {
            _guaranteeImg.image = [UIImage imageNamed:@""];
            
        }else {
            //保修
            switch ([tmpModel.schemesettlementway integerValue]) {
                    //内结
                case 1:
                {
                    _guaranteeImg.image = [UIImage imageNamed:@"billing_pay_inside.png"];
                }
                    break;
                    //b保修
                case 2:
                {
                    if ([tmpModel.schemeswswarrantyconflg isEqualToNumber:@2]) {
                        UIImage *image = [UIImage imageNamed:@"fullLeftListForRight_insureBule"];
//                        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                        _guaranteeImg.tintColor = MAIN_BLUE;
                        _guaranteeImg.image = image;
                        
                    }else {
                        
                        _guaranteeImg.image = [UIImage imageNamed:@"billing_guarantee.png"];
                    }
                    
                }
                    break;
                case 3:
                {
                    _guaranteeImg.image = [UIImage imageNamed:@""];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
//        _downContentTF.text = tmpModel.localLocation.location;
//        _materialCubCountTF.text = tmpModel.localLocation.count;
        
    }
    [self cannotEditSpare];
    
}
- (void)cleanCell {
    _materialTF.text = @"";
    _materialCountTF.text = @"";
    _materialPriceTF.text = @"";
    _numberTF.text = @"";
    _materialTotalPriceTF.text = @"";
}

- (void)setupText {
    _materialCubCountTFOne.text = nil;
    _materialCubCountTFTwo.text = nil;
    _materialCubCountTFThree.text = nil;
    _materialCubCountTFFour.text = nil;
}

- (void)setDefaultTFPlaceHolder {
    
    
    _numberTF.placeholder = @"图号/编号";
    
    _materialTF.placeholder = @"备件名称";
    
    _materialPriceTF.placeholder = @"备件单价";
    
    _materialCountTF.placeholder = @"数量";
    
    _materialTotalPriceTF.placeholder = @"小计";
}

- (void)setupPbTF {
    _downContentTFOne.text = nil;
    _downContentTFTwo.text = nil;
    _downContentTFThree.text = nil;
    _downContentTFFour.text = nil;
}

#pragma mark  工单保存/编辑状态下，边框的显示/隐藏
//保存/编辑状态下 小计赋值
- (void)setTotalPriceLbShowWithSavestatus:(BOOL)issave totalPrice:(NSString *)price{
    if (issave) {
        _materialTotalPriceTF.text = [NSString formatMoneyStringWithFloat:[price floatValue]] ;
    }else {
        _materialTotalPriceTF.attributedText = [[NSString formatMoneyStringWithFloat:[price floatValue]] changeToBottomLine];
    }
}

//UI
- (void)setupAllBorderWithsaveStatus:(NSNumber *)saveStatus {
    [self setuptextViewCornerRadiusWithSaveStatus:saveStatus];
    [self setupNumberSuperViewWithSaveStatus:saveStatus];
    
    if ([_tmpModel.schemewstype integerValue] == 1 || [_tmpModel.schemewstype integerValue] == 3)
    {
        [self setupPriceWithSaveStatus:@1];
    }
    else
    {
        [self setupPriceWithSaveStatus:saveStatus];
    }
    [self setupCountWithSaveStatus:saveStatus];
    [self setupButtonWithsaveStatus:saveStatus];
    
    [self setupcubTfWithsaveStatus:saveStatus];
}

//功能按钮的隐藏 hd_project_delete_new_cell.png//work_list_29
- (void)setupButtonWithsaveStatus:(NSNumber *)saveStatus {
    BOOL save = [saveStatus integerValue];
    _chooseBt.hidden = save;
    _deleteImage.hidden = save;
    _numberBt.hidden =save;
    _addMCubBtOne.hidden = save;
    _addMCubBtTwo.hidden = save;
    _addMCubBtFour.hidden = save;
    _addMCubBtThree.hidden = save;
    _baseBt.hidden = save;
    _Onebt.hidden = save;
    _twoBt.hidden = save;
    _threeBt.hidden = save;
}

//名称
- (void)setuptextViewCornerRadiusWithSaveStatus:(NSNumber *)isSave {
    _materialTF.userInteractionEnabled = ![isSave integerValue];
    [AlertViewHelpers setupCellTFView:_materialNameTView save:[isSave integerValue]];

}
//编号-编码
- (void)setupNumberSuperViewWithSaveStatus:(NSNumber *)issave {
    _addedNumberListTF.userInteractionEnabled = ![issave integerValue];
    _numberTF.userInteractionEnabled = ![issave integerValue];
    _addedNumberTF.userInteractionEnabled = ![issave integerValue];
    [AlertViewHelpers setupCellTFView:_numberSuperView save:[issave integerValue]];

    
}
//单价
- (void)setupPriceWithSaveStatus:(NSNumber *)issave {
    [AlertViewHelpers setupCellTFView:_materialPriceTF save:[issave integerValue]];
}
//数量
- (void)setupCountWithSaveStatus:(NSNumber *)issave {
    [AlertViewHelpers setupCellTFView:_materialCountTF save:[issave integerValue]];


}
//库存相关
- (void)setupcubTfWithsaveStatus:(NSNumber *)issave {
    BOOL enabled = ![issave integerValue];
    _downContentTFOne.userInteractionEnabled = enabled;
    _downContentTFThree.userInteractionEnabled = enabled;
    _downContentTFTwo.userInteractionEnabled = enabled;
    _downContentTFFour.userInteractionEnabled = enabled;
    _materialCubCountTFOne.userInteractionEnabled = enabled;
    _materialCubCountTFTwo.userInteractionEnabled = enabled;
    _materialCubCountTFThree.userInteractionEnabled = enabled;
    _materialCubCountTFFour.userInteractionEnabled = enabled;

    [AlertViewHelpers setupCellTFView:_downContentTFOne save:[issave integerValue]];
    [AlertViewHelpers setupCellTFView:_downContentTFTwo save:[issave integerValue]];
    [AlertViewHelpers setupCellTFView:_downContentTFThree save:[issave integerValue]];
    [AlertViewHelpers setupCellTFView:_downContentTFFour save:[issave integerValue]];
    
    [AlertViewHelpers setupCellTFView:_materialCubCountTFOne save:[issave integerValue]];
    [AlertViewHelpers setupCellTFView:_materialCubCountTFTwo save:[issave integerValue]];
    [AlertViewHelpers setupCellTFView:_materialCubCountTFThree save:[issave integerValue]];
    [AlertViewHelpers setupCellTFView:_materialCubCountTFFour save:[issave integerValue]];
}


- (IBAction)addedBtAction:(UIButton *)sender {
    
    if ([_saveStatus integerValue] == 1) {
        return;
    }
    
    if (_tmpModel.partsstocklist.count == 4 && sender.tag == 103) {
        return;
    }
    
    if (_tmpModel.partsstocklist.count == 0) {
        return;
    }
    
    if (!self.addedBtArray) {
        self.addedBtArray = @[_addMCubBtOne,_addMCubBtTwo,_addMCubBtThree,_addMCubBtFour];
    }
    
    if (sender.tag - 100 == _tmpModel.partsstocklist.count - 1) {
        if (_tmpModel.partsstocklist.count < 4
            ) {
            if (self.addedCubBlock) {
                self.addedCubBlock(NO,_tmpModel,nil);
            }
        }
    }else {
        ProscheMaterialLocationModel *model = _tmpModel.partsstocklist[sender.tag - 100];
        if (self.addedCubBlock) {
            self.addedCubBlock(YES,_tmpModel,model.pbsid);
        }
    }
}

//重置 修改图片的属性 全部为@0.即设置Wie删除图片，最后一个设置@1，即为添加的图片
- (void)setDataArrayForLocation {
    for (ProscheMaterialLocationModel *localLocation in _tmpModel.partsstocklist) {
        localLocation.isAdd = @0;
    }
    ProscheMaterialLocationModel *localLocation = _tmpModel.partsstocklist.lastObject;
    localLocation.isAdd = @1;
}




//根据属性，设置按钮图片
- (void)setBackImage {
    for (int i = 0; i < _tmpModel.partsstocklist.count; i++) {
        UIButton *button = [self viewWithTag:100 + i];
        ProscheMaterialLocationModel *locationModel = _tmpModel.partsstocklist[i];
        if ([locationModel.isAdd integerValue] == 1) {
            
            [button setImage:[UIImage imageNamed:@"work_list_26.png"] forState:UIControlStateNormal];
        }else {
            [button setImage:[UIImage imageNamed:@"hd_project_delete_new_cell.png"] forState:UIControlStateNormal];
        }
    }
}

//数据源赋值
- (void)setlocationAndCount {
    if ([_saveStatus integerValue])
    {
        _addMCubBtOne.hidden = YES;
    }
    else
    {
        _addMCubBtOne.hidden = NO;
    }
    
    
    switch (_tmpModel.partsstocklist.count) {
        case 5:
        case 4:
        {
            ProscheMaterialLocationModel *model = _tmpModel.partsstocklist[3];
            [self showBeijianTypeViewWithModel:model countTextField:_materialCubCountTFFour namaTextField:_downContentTFFour];
        }
            
        case 3:
        {
            ProscheMaterialLocationModel *model = _tmpModel.partsstocklist[2];
            [self showBeijianTypeViewWithModel:model countTextField:_materialCubCountTFThree namaTextField:_downContentTFThree];
        }
        case 2:
        {
            ProscheMaterialLocationModel *model = _tmpModel.partsstocklist[1];
            [self showBeijianTypeViewWithModel:model countTextField:_materialCubCountTFTwo namaTextField:_downContentTFTwo];
        }
        case 1:
        {
            if (_tmpModel.partsstocklist.count > 1 && [_tmpModel.partsstocktype integerValue] ==1) {
                _addMCubBtOne.hidden = YES;
            }
            ProscheMaterialLocationModel *model = _tmpModel.partsstocklist[0];
            [self showBeijianTypeViewWithModel:model countTextField:_materialCubCountTFOne namaTextField:_downContentTFOne];
        }
            break;
        default:
            break;
    }
}
- (void)showBeijianTypeViewWithModel:(ProscheMaterialLocationModel *)model countTextField:(UITextField *)countTextField namaTextField:(UITextField *)nameTextField {
    if ([model.pbstockid integerValue] == 3 || [model.pbstockid integerValue] == 4 || [model.pbstockid integerValue] == 5) {
        countTextField.text = @"--";
        countTextField.userInteractionEnabled = NO;
    }else {
        countTextField.text = model.pbsamount;
        countTextField.userInteractionEnabled = YES;
    }
    nameTextField.text = model.pbstockname;
    nameTextField.textColor = Color(119, 119, 119);
}

//根据数组个数，，显示隐藏几个view
- (void)hiddenLocationView {
    _superTwoView.hidden = YES;
    _superThreeView.hidden = YES;
    _superFourView.hidden = YES;
    
    switch (_tmpModel.partsstocklist.count) {
        case 5:
        case 4:
            _superFourView.hidden = NO;
        case 3:
            _superThreeView.hidden = NO;
            
        case 2:
            _superTwoView.hidden = NO;
            
        case 1:
            
            break;
            
        default:
            break;
    }
}







@end
