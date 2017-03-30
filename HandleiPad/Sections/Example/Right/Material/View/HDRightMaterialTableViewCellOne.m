//
//  HDRightMaterialTableViewCellOne.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDRightMaterialTableViewCellOne.h"

@interface HDRightMaterialTableViewCellOne  ()<UITextFieldDelegate>

@property (nonatomic, strong) NSArray *addedBtArray;
@property (weak, nonatomic) IBOutlet UIButton *spareNumberButton;

@end

@implementation HDRightMaterialTableViewCellOne

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cannotEditSpare
{
    if (_tmpModel)
    {
        [AlertViewHelpers setupCellTFView:_materialNumberTF save:YES];
    }
    
}


- (void)cubTextTFAction:(ProscheMaterialLocationModel *)model tf:(UITextField *)tf {
    if (model.pbstockid) {
        NSDictionary *dic = @{@"type":model.pbstockid,@"stockid":model.pbsid,@"amount":@([tf.text integerValue])};
        if (self.editMaterialCubBlock) {
            self.editMaterialCubBlock(dic);
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _materialPriceTF)
    {
        BOOL ret = [HDUtil textFieldFilter:textField shouldChangeCharactersInRange:range replacementString:string];
        if (!ret) {
//            textField.text =  [NSString stringWithFormat:@"￥%@",textField.text];
            return NO;
        }
    }
    
    if (textField == _materialCountTF)
    {
        BOOL ret = [HDUtil textFieldFilter:textField shouldChangeCharactersInRange:range replacementString:string];
        return ret;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_tmpModel) {
        if ([textField isEqual:_materialPriceTF]) {
            _materialPriceTF.attributedPlaceholder = [[NSString formatMoneyStringWithFloat:[_tmpModel.schemewsunitprice floatValue]] setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
            
            
        }else if ([textField isEqual:_materialCountTF]) {
            _materialCountTF.attributedPlaceholder = _tmpModel.schemewscount ? [[NSString stringWithFormat:@"%.2f",[_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY] : [@"0.00" setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
            
        }else if ([textField isEqual:_materailNameTF]) {
            _materailNameTF.attributedPlaceholder = [_tmpModel.schemewsname setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_tmpModel) {
        if ([textField isEqual:_materialPriceTF]) {
            _materialPriceTF.attributedPlaceholder = [[NSString formatMoneyStringWithFloat:[_tmpModel.schemewsunitprice floatValue]] setTFplaceHolderWithMainGray];
            
            
        }else if ([textField isEqual:_materialCountTF]) {
            _materialCountTF.attributedPlaceholder = _tmpModel.schemewscount ? [[NSString stringWithFormat:@"%.2f",[_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGray] : [@"0.00" setTFplaceHolderWithMainGray];
            
        }else if ([textField isEqual:_materailNameTF]) {
            _materailNameTF.attributedPlaceholder = [_tmpModel.schemewsname setTFplaceHolderWithMainGray];
        }
    }
    if ([textField isEqual:_materailNameTF]) {
        if ([_tmpModel.schemewsname isEqualToString:textField.text]) {
            return;
        }
        if (_tmpModel.schemewsname && (!textField.text || [textField.text isEqualToString:@""])) {
            return;
        }
        
    }
    
    if ([textField isEqual:_materialFigNumTF]) {
        if ([_tmpModel.schemewsphotocode isEqualToString:textField.text]) {
            return;
        }
        if (_tmpModel.schemewsphotocode && (!textField.text || [textField.text isEqualToString:@""])) {
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
    /*
    //价格是否试用全店
    if ([textField isEqual:_materialPriceTF]) {
        if (self.hDRightMaterialTableViewCellOneStyleBlock) {
            self.hDRightMaterialTableViewCellOneStyleBlock(HDRightMaterialTableViewCellOneStylePriceTF,nil,textField.text);
        }
        return;
    }
     */
    if (textField.tag >199) {//库存数量相关
        ProscheMaterialLocationModel *model = _tmpModel.partsstocklist[textField.tag - 200];
        [self cubTextTFAction:model tf:textField];
        return;
    }
    //---------------------------------------------------------------------------
    
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
    if (_materailNameTF.text.length > 0) {
        tmp.schemewsname = _materailNameTF.text;
    }else {
        if (_tmpModel) {
            tmp.schemewsname = _tmpModel.schemewsname;
        }
    }
    if (_materialFigNumTF.text.length > 0) {
        tmp.schemewsphotocode = _materialFigNumTF.text;
    }else {
        if (_tmpModel) {
            tmp.schemewsphotocode = _tmpModel.schemewsphotocode;
        }
    }
    if (_materialPriceTF.text.length > 0) {
        tmp.schemewsunitprice = @([_materialPriceTF.text floatValue]);
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
    
//    if (_tmpModel) {
        tmp.wospwosid = _tmpModel.wospwosid;
        tmp.schemewsid = _tmpModel.schemewsid;
//    }else {
//        tmp.schemewsid = @0;
//    }
    
    if (self.addedReturnBlock) {
        self.addedReturnBlock(tmp);
    }


}


- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    
    [textField resignFirstResponder];
        return YES;
}




- (IBAction)confirmAction:(id)sender {
    if ([_saveStatus integerValue] == 1) {
        return;
    }
    if (self.confirmActionBlock) {
        self.confirmActionBlock(sender);
    }
}

- (IBAction)showEditViewAction:(UIButton *)sender {
    if (self.editMaterialAllBlock) {
        self.editMaterialAllBlock(_tmpModel);
    }
}

- (IBAction)changeGuaranteeBtAction:(UIButton *)sender {
    
    if (self.guaranteeActionBlock) {
        self.guaranteeActionBlock();
    }
}

- (IBAction)downBtAction:(UIButton *)sender {
    if ([_saveStatus integerValue] == 1) {
        return;
    }
    if (self.hDRightMaterialTableViewCellOneStyleBlock) {
        self.hDRightMaterialTableViewCellOneStyleBlock(HDRightMaterialTableViewCellOneStyleDown,sender,nil);
    }
}
- (void)isConformWithStatus:(BOOL)ret
{
    if (ret)
    {
        self.chooseImg.image = [UIImage imageNamed:@"work_list_29.png"];
    }
    else
    {
        self.chooseImg.image = nil;
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
    
    _tmpModel = tmpModel;
    [self setDataArrayForLocation];
    [self cleanCell];
    [self setupText];
    [self setupPbTF];
    [self setBackImage];
    // 给库存赋值
//    [self setlocationAndCount];
    //显示添加的库存View
    [self hiddenLocationView];
    [self isConformWithStatus:[tmpModel.iscancel integerValue] == 0 ? NO: YES];
    [self setupAllBorderWithsaveStatus:_saveStatus];
    [self assiginmentCubTextfield];
    if ([_saveStatus integerValue] == 1) {
        [self setupAllBorderWithsaveStatus:_saveStatus];
    }

    //设置placeHolder显示颜色
    _materialFigNumTF.attributedPlaceholder = [tmpModel.schemewsphotocode setTFplaceHolderWithMainGray];
    _materialNumberTF.attributedPlaceholder = [tmpModel.schemewscode setTFplaceHolderWithMainGray];

    _materailNameTF.attributedPlaceholder = [tmpModel.schemewsname setTFplaceHolderWithMainGray];
    
    NSString *countStr = tmpModel.schemewsunitprice ? [NSString formatMoneyStringWithFloat:[tmpModel.schemewsunitprice floatValue]] : @"";
    
    _materialPriceTF.attributedPlaceholder = [countStr setTFplaceHolderWithMainGray];
    
    _materialCountTF.attributedPlaceholder = [tmpModel.schemewscount? [NSString stringWithFormat:@"%.2f", [tmpModel.schemewscount floatValue]] : @"" setTFplaceHolderWithMainGray];

    //保修图片 根据数据模型定
    
//    if (tmpModel.schemewstotalprice) {
//        _materialTotalPriceLb.text = [NSString formatMoneyStringWithFloat:[tmpModel.schemewstotalprice floatValue]];
//    }else {
//        _materialTotalPriceLb.text = [NSString formatMoneyStringWithFloat:0.00];
//    }
//    
    _materialTotalPriceLb.text = [NSString formatMoneyStringWithFloat:[[self showPrice] floatValue]];

    
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
//                    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                    _guaranteeImg.tintColor = MAIN_BLUE;
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
    [self cannotEditSpare];
}

- (void)assiginmentCubTextfield {
    _addMCubBtOne.hidden = NO;
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

//添加按钮的事件
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

    switch (_tmpModel.partsstocklist.count) {
        case 5:
        case 4:
        {
            ProscheMaterialLocationModel *model = [_tmpModel.partsstocklist objectAtIndex:3];
            _downContentTFFour.attributedPlaceholder = [model.pbstockname setTFplaceHolderWithMainGray];
            if ([model.pbstockid integerValue] == 3 || [model.pbstockid integerValue] == 4) {
                _materialCubCountTFFour.attributedPlaceholder = [@"--" setTFplaceHolderWithMainGray];
                _materialCubCountTFFour.userInteractionEnabled = NO;
            }else {
                _materialCubCountTFFour.attributedPlaceholder = [model.pbsamount setTFplaceHolderWithMainGray];
                _materialCubCountTFFour.userInteractionEnabled = YES;
            }
//            _materialCubCountTFFour.attributedPlaceholder = [model.pbsamount setTFplaceHolderWithMainGray];
        }
            
        case 3:
        {
            ProscheMaterialLocationModel *model = [_tmpModel.partsstocklist objectAtIndex:2];
//            _downContentTFThree.placeholder = model.pbsname;
            _downContentTFThree.attributedPlaceholder = [model.pbstockname setTFplaceHolderWithMainGray];
            if ([model.pbstockid integerValue] == 3 || [model.pbstockid integerValue] == 4) {
                _materialCubCountTFThree.attributedPlaceholder = [@"--" setTFplaceHolderWithMainGray];
                _materialCubCountTFThree.userInteractionEnabled = NO;
            }else {
                _materialCubCountTFThree.attributedPlaceholder = [model.pbsamount setTFplaceHolderWithMainGray];
                _materialCubCountTFThree.userInteractionEnabled = YES;
            }
//            _materialCubCountTFThree.attributedPlaceholder = [model.pbsamount setTFplaceHolderWithMainGray];
        }
            
        case 2:
        {
            ProscheMaterialLocationModel *model = [_tmpModel.partsstocklist objectAtIndex:1];
//            _downContentTFTwo.placeholder = model.pbsname;
            _downContentTFTwo.attributedPlaceholder = [model.pbstockname setTFplaceHolderWithMainGray];
            if ([model.pbstockid integerValue] == 3 || [model.pbstockid integerValue] == 4) {
                _materialCubCountTFTwo.attributedPlaceholder = [@"--" setTFplaceHolderWithMainGray];
                _materialCubCountTFTwo.userInteractionEnabled = NO;
            }else {
                _materialCubCountTFTwo.attributedPlaceholder = [model.pbsamount setTFplaceHolderWithMainGray];
                _materialCubCountTFTwo.userInteractionEnabled = YES;
            }
//            _materialCubCountTFTwo.attributedPlaceholder = [model.pbsamount setTFplaceHolderWithMainGray];
        }
            
        case 1:
        {
            ProscheMaterialLocationModel *model = [_tmpModel.partsstocklist objectAtIndex:0];
//            _downContentTFOne.placeholder = model.pbsname;
            _downContentTFOne.attributedPlaceholder = [model.pbstockname setTFplaceHolderWithMainGray];
            if ([model.pbstockid integerValue] == 3 || [model.pbstockid integerValue] == 4) {
                _materialCubCountTFOne.attributedPlaceholder = [@"--" setTFplaceHolderWithMainGray];
                _materialCubCountTFOne.userInteractionEnabled = NO;
            }else {
                _materialCubCountTFOne.attributedPlaceholder = [model.pbsamount setTFplaceHolderWithMainGray];
                _materialCubCountTFOne.userInteractionEnabled = YES;
            }
//            _materialCubCountTFOne.attributedPlaceholder = [model.pbsamount setTFplaceHolderWithMainGray];
        }
            break;
        default:
            break;
    }

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

#pragma mark  工单保存/编辑状态下，边框的显示/隐藏
//保存/编辑状态下 小计赋值

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
    _spareNumberButton.enabled = ![saveStatus integerValue];
}

//功能按钮的隐藏 hd_project_delete_new_cell.png//work_list_29
- (void)setupButtonWithsaveStatus:(NSNumber *)saveStatus {
    BOOL save = [saveStatus integerValue];
    _chooseSuperView.backgroundColor = save ? [UIColor whiteColor] : Color(170, 170, 170);
    _materialChooseBt.hidden = save;
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
//    _materailNameTF.userInteractionEnabled = ![isSave integerValue];
//    _materialNumberTF
    [self setupView:_materailNameTF save:[isSave integerValue] == 0 ? NO : YES];
    [self setupView:_materialNumberTF save:[isSave integerValue] == 0 ? NO : YES];

}
//编号-编码
- (void)setupNumberSuperViewWithSaveStatus:(NSNumber *)issave {
    _materialFigNumTF.userInteractionEnabled = ![issave integerValue];
    [self setupView:_materialFigNumTF save:[issave integerValue]];
    
    
}
//单价
- (void)setupPriceWithSaveStatus:(NSNumber *)issave {
    _materialPriceTF.userInteractionEnabled = ![issave integerValue];
    [self setupView:_materialPriceTF save:[issave integerValue]];
}
//设置边框颜色 及圆角
- (void)setupView:(UIView *)view save:(BOOL)issave {
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.layer.borderColor = Color(200, 200, 200).CGColor;
    view.layer.borderWidth = issave ? 0 : 0.5;
    if ([view isKindOfClass:[UITextField class]]) {
        UITextField *tf = (UITextField *)view;
        tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4,CGRectGetHeight(tf.frame))];
        tf.leftViewMode = UITextFieldViewModeAlways;
    }
}
//数量
- (void)setupCountWithSaveStatus:(NSNumber *)issave {
    _materialCountTF.userInteractionEnabled = ![issave integerValue];
    
    [self setupView:_materialCountTF save:[issave integerValue]];
    
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
    
    [self setupView:_downContentTFOne save:[issave integerValue]];
    [self setupView:_downContentTFTwo save:[issave integerValue]];
    [self setupView:_downContentTFThree save:[issave integerValue]];
    [self setupView:_downContentTFFour save:[issave integerValue]];
    
    [self setupView:_materialCubCountTFOne save:[issave integerValue]];
    [self setupView:_materialCubCountTFTwo save:[issave integerValue]];
    [self setupView:_materialCubCountTFThree save:[issave integerValue]];
    [self setupView:_materialCubCountTFFour save:[issave integerValue]];
}


- (void)cleanCell {
    _materailNameTF.text = @"";
    _materialCountTF.text = @"";
    _materialPriceTF.text = @"";
    _materialFigNumTF.text = @"";
    _materialTotalPriceLb.text = @"";
}

- (void)setupText {
    _materialCubCountTFOne.text = nil;
    _materialCubCountTFTwo.text = nil;
    _materialCubCountTFThree.text = nil;
    _materialCubCountTFFour.text = nil;
}

- (void)setupPbTF {
    _downContentTFOne.text = nil;
    _downContentTFTwo.text = nil;
    _downContentTFThree.text = nil;
    _downContentTFFour.text = nil;
}

@end
