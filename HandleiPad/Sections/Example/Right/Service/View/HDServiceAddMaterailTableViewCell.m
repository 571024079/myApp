//
//  HDServiceAddMaterailTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceAddMaterailTableViewCell.h"
#import "HDLeftSingleton.h"
@interface HDServiceAddMaterailTableViewCell ()<UITextFieldDelegate,UITextViewDelegate>
//键盘辅助视图
@property (nonatomic, strong) UIView *clearView;


@end

@implementation HDServiceAddMaterailTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    _numberTF.delegate = self;
    _materialTF.delegate = self;
    _materialCountTF.delegate = self;
    _materialPriceTF.delegate = self;
    _materialTotalPriceTF.delegate = self;
    _disCountTF.delegate = self;
    [self setuptextViewCornerRadius];
    // Initialization code
}

#pragma mark  textView_delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if (_tmpModel) {
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
    }else {
        if (_tmpModel) {
            PorscheNewSchemews *tmp = [PorscheNewSchemews new];
            tmp.schemewsname = textView.text;
            tmp.wospwosid = _tmpModel.wospwosid;
            tmp.schemewsid = _tmpModel.schemewsid;
            if (self.addedReturnBlock) {
                self.addedReturnBlock(tmp);
            }
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_tmpModel) {
        if ([textField isEqual:_materialPriceTF]) {
            _materialPriceTF.attributedPlaceholder = [[NSString formatMoneyStringWithFloat:[_tmpModel.schemewsunitprice floatValue]] setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
            
            
        }else if ([textField isEqual:_materialCountTF]) {
            _materialCountTF.attributedPlaceholder = _tmpModel.schemewscount ? [[NSString stringWithFormat:@"%.2f",[_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY] : [@"0.00" setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
            
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_tmpModel) {
        if ([textField isEqual:_materialPriceTF]) {
            _materialPriceTF.attributedPlaceholder = [[NSString formatMoneyStringWithFloat:[_tmpModel.schemewsunitprice floatValue]] setTFplaceHolderWithMainGray];
            
            
        }else if ([textField isEqual:_materialCountTF]) {
            _materialCountTF.attributedPlaceholder = _tmpModel.schemewscount ? [[NSString stringWithFormat:@"%.2f",[_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGray] : [@"0.00" setTFplaceHolderWithMainGray];
            
        }
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
        if (_tmpModel.schemewscount && (!textField.text.length || [textField.text isEqualToString:@""])) {
            return;
        }
    }
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
    
    if (_materialTF.text.length > 0) {//备件名称
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

- (void)setuptextViewCornerRadius {
    _materialNameTView.layer.masksToBounds = YES;
    _materialNameTView.layer.cornerRadius = 5;
    _materialNameTView.layer.borderWidth = 0.5;
    _materialNameTView.layer.borderColor = Color(200, 200, 200).CGColor;
}

- (void)returnAction {
   
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
//sender.tag = 0
- (IBAction)disCountBtAction:(UIButton *)sender {
    if (self.guaranteeBlock) {
        self.guaranteeBlock(sender);
    }
}
//sender.tag = 1
- (IBAction)guaranteeBtAction:(UIButton *)sender {
    
    if (self.guaranteeBlock) {
        self.guaranteeBlock(sender);
    }
}

- (IBAction)numberBtAction:(UIButton *)sender {
    
    
    if (self.hDServiceAddMaterailTableViewCellBlock) {
        
        self.hDServiceAddMaterailTableViewCellBlock(HDServiceAddMaterailTableViewCellStyleTF,nil);
    }
}

- (IBAction)chooseBtAction:(UIButton *)sender {
    
    if ([_tmpModel.schemewstype integerValue] == 1 || ![HDLeftSingleton isUserAdded:_tmpModel.projectaddid]) {
        if (self.selectedBlock) {
            self.selectedBlock(sender,_tmpModel);
        }
    }else {
        if (self.hDServiceAddMaterailTableViewCellBlock) {
            self.hDServiceAddMaterailTableViewCellBlock(HDServiceAddMaterailTableViewCellStyleChoose,sender);
        }
    }
    
}

- (IBAction)addBtAction:(UIButton *)sender {
    if (self.hDServiceAddMaterailTableViewCellBlock) {
        self.hDServiceAddMaterailTableViewCellBlock(HDServiceAddMaterailTableViewCellStyleAdd,sender);
    }
}
- (void)isConfirmStatus:(BOOL)ret
{
    if (ret)
    {
        self.selectedImg.image = [UIImage imageNamed:@"work_list_29.png"];
        _itemNeedResureLb.hidden = NO;
    }
    else
    {
        self.selectedImg.image = nil;
        _itemNeedResureLb.hidden = YES;
    }
}

- (void)setupViewInitWithModel:(PorscheNewSchemews *)tmpModel {
    _headerImageView.image = [UIImage imageNamed:@"work_list_25.png"];
    _numberSuperView.hidden = YES;
    _materialNameTView.hidden = YES;
    _chooseBt.hidden = YES;
    _chooseImageView.hidden = YES;
    _chooseImgViewSuperView.hidden = YES;
    _guaranteeImg.hidden = YES;
    _guaranteeBt.hidden = YES;
    _numberSuperView.hidden = YES;
    _materialNameTView.hidden = YES;
    _itemNeedResureLb.hidden = YES;
    
    _addBt.hidden = YES;
    _addBtbg.hidden = YES;
    
    _selectView.hidden = YES;
    
    
    if (tmpModel) {//新增配件行
        _chooseBt.hidden = NO;
        _chooseImageView.hidden = NO;
        _chooseImgViewSuperView.hidden = NO;
        _numberBt.hidden = NO;
        _guaranteeImg.hidden = NO;
        _guaranteeBt.hidden = NO;
        _numberSuperView.hidden = NO;
        _materialNameTView.hidden = NO;
        _itemNeedResureLb.hidden = NO;
        
        // 方案库附带
        if ([tmpModel.schemewstype integerValue] == 1 || ![HDLeftSingleton isUserAdded:tmpModel.projectaddid])
        {
            _chooseImageView.hidden = YES;
            _chooseImgViewSuperView.hidden = YES;
            _selectView.hidden = NO;
            [self isConfirmStatus:[tmpModel.iscancel integerValue] == 0 ? NO : YES];
        }
   /*
        if ([tmpModel.projectaddid integerValue]&& ![HDLeftSingleton isUserAdded:tmpModel.projectaddid]) {//不是自己加的不能删除
            _chooseImageView.hidden = YES;
            _chooseImgViewSuperView.hidden = YES;
            _selectView.hidden = NO;
            [self isConfirmStatus:[tmpModel.iscancel integerValue] == 0 ? NO : YES];
        }
*/
    }else {//配件添加行
        _addBt.hidden = NO;
        _addBtbg.hidden = NO;
        
        _headerImageView.image = [UIImage imageNamed:@"hd_custom_item_time_material.png"];
    }
}

- (void)setTmpModel:(PorscheNewSchemews *)tmpModel {
    _itemNeedResureLb.hidden = YES;
    [self cleanCell];
    [self setDefaultTFPlaceHolder];
    [self setupViewInitWithModel:tmpModel];

    _tmpModel =tmpModel;
    
    [self setupAllBorderWithsaveStatus:_saveStatus];

    if (tmpModel) {
        if ([tmpModel.schemewstype integerValue] == 2) {//自定义配件
            _headerImageView.image = [UIImage imageNamed:@"hd_custom_item_time_material.png"];
            
        }
        
//        if ([tmpModel.partsstocktype integerValue] == 1) {
//            _itemNeedResureLb.text = @"常备件";
//        }else {
//            if ([tmpModel.schemewsisconfirm integerValue] == 1) {
////                _itemNeedResureLb.text = @"库存已确认";
//                if (tmpModel.partsstocklist.count) {
//                    ProscheMaterialLocationModel *locaM = tmpModel.partsstocklist.firstObject;
//                    if ([locaM.pbstockid integerValue] == 3 || [locaM.pbstockid integerValue] == 4) {
//                        _itemNeedResureLb.text = locaM.pbstockname;
//                    }else {
//                        _itemNeedResureLb.text = [NSString stringWithFormat:@"%@ %@", locaM.pbstockname, locaM.pbsamount];
//                    }
//                }
//            }else {
////                if (tmpModel.partStockList.count) {
////                    ProscheMaterialLocationModel *locaM = tmpModel.partStockList.firstObject;
////                    _itemNeedResureLb.text = locaM.pbsname;
////                }else {
//                    _itemNeedResureLb.text = @"库存待确认";
////                }
//            }
//        }
        
        
        if ([tmpModel.partsstocktype integerValue] == 1) {
            _itemNeedResureLb.text = @"常备件";
            _itemNeedResureLb.textColor = MAIN_BLUE;
        }else {
            _itemNeedResureLb.textColor = MAIN_PLACEHOLDER_GRAY;
            if ([tmpModel.schemewsisconfirm integerValue] == 1) {
                //17-02-04 czz 要求将库存全部显示,向下排列  当数据大于三个的时候去前三个
                if (tmpModel.partsstocklist.count) {
                    NSMutableArray *nameStrArr = [NSMutableArray array];
                    for (ProscheMaterialLocationModel *locaModel in tmpModel.partsstocklist) {
                        NSString *tempStr = @"";
                        if ([locaModel.pbstockid integerValue] == 3 || [locaModel.pbstockid integerValue] == 4) {
                            tempStr = [NSString stringWithFormat:@"%@ -", locaModel.pbstockname];
                        }else {
                            tempStr = [NSString stringWithFormat:@"%@ %@", locaModel.pbstockname, locaModel.pbsamount];
                        }
                        [nameStrArr addObject:tempStr];
                    }
                    if (nameStrArr.count > 3) {
                        nameStrArr = [[nameStrArr subarrayWithRange:NSMakeRange(0, 3)] mutableCopy];
                    }
                    NSString *nameText = [nameStrArr componentsJoinedByString:@"\n"];
                    if (nameStrArr.count > 2) {
                        _itemNeedResureLb.font = [UIFont systemFontOfSize:9];
                    }else {
                        _itemNeedResureLb.font = [UIFont systemFontOfSize:12];
                    }
                    _itemNeedResureLb.text = nameText;
                }
            }else {
                _itemNeedResureLb.text = @"库存待确认";
                _itemNeedResureLb.textColor = MAIN_BLUE;
            }
        }
        
        
        _materialNameTView.hidden = NO;
        _numberSuperView.hidden = NO;
        
        //清空txt 不在text显示
        //图号
        if (tmpModel.schemewsphotocode) {
            _addedNumberTF.attributedPlaceholder = [[NSString stringWithFormat:@"%@",tmpModel.schemewsphotocode] setTFplaceHolderWithMainGray];
        }else {
            _addedNumberTF.attributedPlaceholder = [@"  图号" setTFplaceHolderWithMainGrayWithColor:Color(200, 200, 200)];
        }
        //编号
        if (tmpModel.schemewscode) {
            _addedNumberListTF.attributedPlaceholder = [[NSString stringWithFormat:@"%@",tmpModel.schemewscode] setTFplaceHolderWithMainGray];
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
        
        //折扣 格式 - 20%
        if ([tmpModel.schemewstdiscount integerValue] == 1) {
            _disCountTF.text = nil;
        }else {
            _disCountTF.text = tmpModel.schemewstdiscount ? [NSString stringWithFormat:@"-%.2f%%", [tmpModel.schemewstdiscount floatValue] *100] : nil;
        }
        
        //备件总计部位空
        if (tmpModel.schemewstotalprice) {
            //实收不为空
//            if (tmpModel.schemewsdiscounttotalprice) {
                //保存，编辑状态下的小计显示
                [self setTotalPriceLbShowWithSavestatus:[_saveStatus integerValue] totalPrice:tmpModel.schemewstotalprice];
                
//            }else {
//                [self setTotalPriceLbShowWithSavestatus:[_saveStatus integerValue] totalPrice:@(0.00)];
//            }
        }else {
            _materialTotalPriceTF.text = nil;
            
        }
        
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
    }
    
    
    //服务沟通界面   红色的工时和备件可以进行编号图号的编辑,界面样式改变
    //扳手图标 自定义工时 默认红色
    if (!([tmpModel.schemewstype integerValue] == 2 || _tmpModel == nil)) {
        [self setupNumberSuperViewWithSaveStatus:@1];
        _numberBt.hidden = YES;
    }
    
}

- (void)setDefaultTFPlaceHolder {
    
    _numberTF.placeholder = @" 图号/编号";
    
    _materialTF.placeholder = @" 备件名称";
    
    _materialPriceTF.placeholder = @"备件单价";
    
    _materialCountTF.placeholder = @"数量";
    
    _disCountTF.placeholder = @"折扣率";

    _materialTotalPriceTF.placeholder = @"折后金额";
}

- (void)cleanCell {
    _materialTF.text = @"";
    _materialCountTF.text = @"";
    _materialPriceTF.text = @"";
    _numberTF.text = @"";
    _materialTotalPriceTF.text = @"";
    _disCountTF.text = @"";
}

#pragma mark  工单保存/编辑状态下，边框的显示/隐藏
//保存/编辑状态下 小计赋值
- (void)setTotalPriceLbShowWithSavestatus:(BOOL)issave totalPrice:(NSNumber *)price{
    if (issave) {
        _materialTotalPriceTF.text = [NSString formatMoneyStringWithFloat:[price floatValue]] ;
    }else {
        _materialTotalPriceTF.attributedText = [[NSString formatMoneyStringWithFloat:[price floatValue]] changeToBottomLine];
    }
}

//UI
- (void)setupAllBorderWithsaveStatus:(NSNumber *)saveStatus {
    //名称
    [self setuptextViewCornerRadiusWithSaveStatus:saveStatus];
    //图号，编号
    [self setupNumberSuperViewWithSaveStatus:saveStatus];
    //单价
    if ([_tmpModel.schemewstype integerValue] == 1 || [_tmpModel.schemewstype integerValue] == 3)
    {
        [self setupPriceWithSaveStatus:@1];
    }
    else
    {
        [self setupPriceWithSaveStatus:saveStatus];
    }
    
    //数量
    [self setupCountWithSaveStatus:saveStatus];
    //按钮显示隐藏
    [self setupButtonWithsaveStatus:saveStatus];
    //折扣
    [self setDiscountWithSaveStatus:saveStatus];
    // 勾选框状态
    if (_tmpModel.iscancel != 0 && [saveStatus integerValue] == 1)
    {
        _selectView.hidden = NO;
        [self isConfirmStatus:[_tmpModel.iscancel integerValue] == 0 ? NO : YES];
    }
}

//功能按钮的隐藏 hd_project_delete_new_cell.png//work_list_29
- (void)setupButtonWithsaveStatus:(NSNumber *)saveStatus {
    _guaranteeBt.hidden = [saveStatus integerValue];
    _chooseBt.userInteractionEnabled = ![saveStatus integerValue];
    _chooseImageView.hidden = [saveStatus integerValue];
    _numberBt.hidden = [saveStatus integerValue];
    _discountBt.hidden = [saveStatus integerValue];
    _selectView.backgroundColor = [saveStatus integerValue] == 1 ? Color(255, 255, 255) : Color(170, 170, 170);
    
    if (!_tmpModel) {
        _chooseBt.hidden = YES;
    }
}

//名称
- (void)setuptextViewCornerRadiusWithSaveStatus:(NSNumber *)isSave {
    [AlertViewHelpers setupCellTFView:_materialNameTView save:[isSave integerValue]];
    [AlertViewHelpers setupCellTFView:_materialTF save:[isSave integerValue]];

}
//编号-编码
- (void)setupNumberSuperViewWithSaveStatus:(NSNumber *)issave {
    
    _addedNumberListTF.userInteractionEnabled = ![issave integerValue];
    _addedNumberTF.userInteractionEnabled = ![issave integerValue];
    [AlertViewHelpers setupCellTFView:_numberSuperView save:[issave integerValue]];
    [AlertViewHelpers setupCellTFView:_numberTF save:[issave integerValue]];
    _numberTF.leftViewMode = UITextFieldViewModeNever;

}
//单价
- (void)setupPriceWithSaveStatus:(NSNumber *)issave {
    [AlertViewHelpers setupCellTFView:_materialPriceTF save:[issave integerValue]];

    
}
//数量
- (void)setupCountWithSaveStatus:(NSNumber *)issave {
    [AlertViewHelpers setupCellTFView:_materialCountTF save:[issave integerValue]];

}
//折扣
- (void)setDiscountWithSaveStatus:(NSNumber *)issave {
    [AlertViewHelpers setupCellTFView:_disCountTF save:[issave integerValue]];
}


//设置边框颜色 及圆角



// 保修审批显示
- (void)guranteeShenPiStatus
{
    [self setTotalPriceLbShowWithSavestatus:NO totalPrice:_tmpModel.schemewstotalprice];
    self.guaranteeBt.hidden = NO;
}
@end
