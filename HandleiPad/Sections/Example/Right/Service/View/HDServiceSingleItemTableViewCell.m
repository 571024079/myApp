//
//  HDServiceSingleItemTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/27.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceSingleItemTableViewCell.h"
#import "HDLeftSingleton.h"
@interface HDServiceSingleItemTableViewCell ()<UITextFieldDelegate>

@end

@implementation HDServiceSingleItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _itemNameTF.delegate = self;
    _itemCountTF.delegate = self;
    _itemtotalPriceTF.delegate = self;
    _itemTimeTF.delegate = self;
    _itemPrice.delegate = self;
    _discountTF.delegate = self;
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)guaranteeBtAction:(UIButton *)sender {
    if (self.guaranteeViewBlock) {
        self.guaranteeViewBlock(sender);
    }
}
- (IBAction)discountBtAction:(UIButton *)sender {
    if (self.guaranteeViewBlock) {
        self.guaranteeViewBlock(sender);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_tmpModel) {
        if ([textField isEqual:_itemPrice]) {
            _itemPrice.attributedPlaceholder = [[NSString formatMoneyStringWithFloat:[_tmpModel.schemewsunitprice floatValue]] setTFplaceHolderWithMainGray];
            
            
        }else if ([textField isEqual:_itemCountTF]) {
            _itemCountTF.attributedPlaceholder = _tmpModel.schemewscount ? [[NSString stringWithFormat:@"%.2f",[_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGray] : [@"0.00" setTFplaceHolderWithMainGray];
            
        }else if ([textField isEqual:_itemNameTF]) {
            _itemNameTF.attributedPlaceholder = [_tmpModel.schemewsname setTFplaceHolderWithMainGray];
            
        }
    }
    if ([textField isEqual:_itemNameTF]) {
        if ([_tmpModel.schemewsname isEqualToString:textField.text]) {
            return;
        }
        if (_tmpModel.schemewsname && (!textField.text || [textField.text isEqualToString:@""])) {
            return;
        }
        
    }
    
    if ([textField isEqual:_itemPrice]) {
        if (textField.text.length > 1 && [@([[textField.text substringFromIndex:1] floatValue]) isEqual:_tmpModel.schemewsunitprice]) {
            return;
        }
        if (_tmpModel.schemewsunitprice && (!textField.text || [textField.text isEqualToString:@""])) {
            return;
        }
    }
    
    if ([textField isEqual:_itemCountTF]) {
        if (_itemCountTF.text.length > 2 && [@([[_itemCountTF.text substringToIndex:_itemCountTF.text.length - 2] floatValue]) isEqual:_tmpModel.schemewscount]) {
            return;
        }
        if (_tmpModel.schemewscount && (!textField.text || [textField.text isEqualToString:@""])) {
            return;
        }
    }
    
    //添加的新工时行数据
    PorscheNewSchemews *tmp ;
    if(_tmpModel)
    {
        tmp = _tmpModel;
    }
    else
    {
        tmp = [PorscheNewSchemews new];
    }
    if (_itemNameTF.text.length > 0) {
        tmp.schemewsname = _itemNameTF.text;
    }else {
        if (_tmpModel) {
            tmp.schemewsname = _tmpModel.schemewsname;
        }
    }
    if (_itemPrice.text.length > 1) {
        tmp.schemewsunitprice = @([[_itemPrice.text substringFromIndex:1] floatValue]);
    }else {
        if (_tmpModel) {
            tmp.schemewsunitprice = _tmpModel.schemewsunitprice;
        }
    }
    
    if (_itemCountTF.text.length > 2) {
        tmp.schemewscount = @([[_itemCountTF.text substringToIndex:_itemCountTF.text.length - 2] floatValue]);
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
    
    if (self.addedreturnBlock) {
        self.addedreturnBlock(tmp);
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.itemCountTF]) {
        if (![string isEqualToString:@""]) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"TU" withString:@""];
            
            NSRange realRange = NSMakeRange(range.location - 2, range.length);
            BOOL ret = [HDUtil textFieldFilter:textField shouldChangeCharactersInRange:realRange replacementString:string];
            if (!ret) {
                string = @"TU";//NSString stringWithFormat:@"TU",string];
                textField.text = [textField.text stringByAppendingString:string];
                return NO;
            }
            
            string = [NSString stringWithFormat:@"%@TU",string];
            textField.text = [textField.text stringByAppendingString:string];
            return NO;
        }else {
            if (textField.text.length > 2) {
                NSString *tmpString = [textField.text stringByReplacingOccurrencesOfString:@"TU" withString:@""];
                string = [tmpString substringToIndex:tmpString.length - 1];
                if (string.length == 0) {
                    textField.text = @"";
                }else {
                    textField.text = [NSString stringWithFormat:@"%@TU",string];
                }
                return NO;
            }
        }
        
    }
    
    if ([textField isEqual:self.itemPrice]) {
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
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (_tmpModel) {
        if ([textField isEqual:_itemPrice]) {
            _itemPrice.attributedPlaceholder = [[NSString formatMoneyStringWithFloat:[_tmpModel.schemewsunitprice floatValue]] setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
            
            
        }else if ([textField isEqual:_itemCountTF]) {
            _itemCountTF.attributedPlaceholder = _tmpModel.schemewscount ? [[NSString stringWithFormat:@"%.2f",[_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY] : [@"0.00" setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
            
        }else if ([textField isEqual:_itemNameTF]) {
            _itemNameTF.attributedPlaceholder = [_tmpModel.schemewsname setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];

        }
    }
    if ([textField isEqual:_itemTimeTF]) {
        if (self.hDServiceSingleItemTableViewCellBlock) {
            self.hDServiceSingleItemTableViewCellBlock(HDServiceSingleItemTableViewCellStyleItemTimeTF,nil);
        }
    }else {
        if (self.hDServiceSingleItemTableViewCellBlock) {
            
            self.hDServiceSingleItemTableViewCellBlock(HDServiceSingleItemTableViewCellStyleTF,nil);
        }
    }
    
}


- (IBAction)chooseBtAction:(UIButton *)sender {
    if (self.hDServiceSingleItemTableViewCellBlock) {
        self.hDServiceSingleItemTableViewCellBlock(HDServiceSingleItemTableViewCellStyleChoose,sender);
    }
}


- (IBAction)repairBtAction:(UIButton *)sender {
    if (self.hDServiceSingleItemTableViewCellBlock) {
        self.hDServiceSingleItemTableViewCellBlock(HDServiceSingleItemTableViewCellStyleRepair,sender);
    }
}

- (IBAction)itemTimenumberBtAction:(UIButton *)sender {
    if ([_saveStatus integerValue] == 1) {
        return;
    }
    
    if (self.hDServiceSingleItemTableViewCellBlock) {
        self.hDServiceSingleItemTableViewCellBlock(HDServiceSingleItemTableViewCellStyleItemTimeTF,nil);
    }
}
//分割未
- (NSString *)setCodeListSHow {
    NSString *useString;
    NSString *realCode = [[NSString stringWithFormat:@"%@",_tmpModel.schemewscode ] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (realCode.length >= 8) {
        useString = [realCode substringToIndex:8];
        NSString *endString = @"";
        for (int i = 0; i < 4; i++) {
            NSString *subStr = [useString substringWithRange:NSMakeRange(i*2, 2)];
            endString = [endString stringByAppendingString:[NSString stringWithFormat:@"%@ ",subStr]];
        }
        return endString;
        
    }else {
        return realCode;
    }
}

//- (void)setupUIWithModel {
//    /*
//    if ([_tmpModel.isCanAddItemTime integerValue] == 0) {//不能添加工时行
//        _headerImageView.image = [UIImage imageNamed:@"work_list_24.png"];
//        _itemTimeSureLb.hidden = NO;
//        _chooseBt.hidden = NO;
//
////        if ([_tmpModel.schemewsaddstatus isEqualToNumber:@3]) {
////           _chooseImageView.hidden = NO;
////            _maskView.hidden = YES;
////            
////        }else {
////            _chooseImageView.hidden = YES;
////            _maskView.hidden = NO;
////        }
//        
//    }else {
//        _chooseImageView.hidden = YES;
//        _repairBt.hidden = NO;
//        _repairBtbgImg.hidden = NO;
//        //可添加工时行。不能选择
//        _chooseBt.hidden = YES;
//        _maskView.hidden = YES;
//    }
//    
//    if ([_tmpModel.schemewsisconfirm isEqualToNumber:@1]) {
//        //选中状态
//        _chooseImageView.image = [UIImage imageNamed:@"hd_project_delete_new_cell.png"];
//    }else {
//        //未选中状态
//        _chooseImageView.image = [UIImage imageNamed:@""];
//        
//    }
//    
//*/
//}

- (void)isConfirmStatus:(BOOL)ret
{
    if (ret)
    {
        self.selectImageView.image = [UIImage imageNamed:@"work_list_29.png"];
    }
    else
    {
        self.selectImageView.image = nil;
    }
}

- (void)defaultHiddenAndView {
    _repairBt.hidden = YES;
    
    _repairBtbgImg.hidden = YES;
    
//    _cameraBt.hidden = YES;
    
//    _photoBt.hidden = YES;
    [self isConfirmStatus:[_tmpModel.iscancel integerValue] == 0 ? NO : YES];
    
    _selectImageViewSuperView.hidden = YES;
    
    _chooseBt.hidden = NO;
    _chooseImageView.hidden = NO;
    _chooseImageViewSuperView.hidden = NO;
    
    // 不是自己添加 隐藏删除
    if ([_tmpModel.schemewstype integerValue] == 1 || ![HDLeftSingleton isUserAdded:_tmpModel.projectaddid]) {
        _chooseImageView.hidden = YES;
        _chooseImageViewSuperView.hidden = YES;
        _selectImageViewSuperView.hidden = NO;
    }
    
    _itemTimeSureLb.hidden = YES;
    //扳手图标 自定义工时 默认红色
    if ([_tmpModel.schemewstype integerValue] == 2 || _tmpModel == nil)
    {
        _headerImageView.image = [UIImage imageNamed:@"hd_custom_item_time_pic.png"];
    }
    else
    {
        _headerImageView.image = [UIImage imageNamed:@"work_list_24.png"];
    }
    
    if(!_tmpModel) {//是可以添加工时行
        _repairBt.hidden = NO;
        _repairBtbgImg.hidden = NO;
        _chooseImageViewSuperView.hidden = YES;
        _guaranteeBt.hidden = YES;
        _guaranteeImg.hidden = YES;
        //可添加工时行。不能选择
        _chooseBt.hidden = YES;
        
        //新增工时行
    }else {
        _itemTimeSureLb.hidden = NO;
        _chooseBt.hidden = NO;
        _guaranteeBt.hidden = NO;
        _guaranteeImg.hidden = NO;
    }
    
}

- (void)setTmpModel:(PorscheNewSchemews *)tmpModel {
    _tmpModel = tmpModel;
    
    [self defaultHiddenAndView];
    
    [self clearCell];
    
    [self setDefaultplaceHolder];
    [self setupAllBorderWithsaveStatus:_saveStatus];
    if (tmpModel.schemewscode) {
        _itemTimeTF.attributedPlaceholder = [[self setCodeListSHow] setTFplaceHolderWithMainGray];
    }
    if (tmpModel.schemewsname.length > 0) {
        _itemNameTF.attributedPlaceholder = [tmpModel.schemewsname setTFplaceHolderWithMainGray];
        
    }
    if (tmpModel.schemewsunitprice) {
        NSString *priceStr = tmpModel.schemewsunitprice? [NSString formatMoneyStringWithFloat:[tmpModel.schemewsunitprice floatValue]] : @"";
        _itemPrice.attributedPlaceholder = [priceStr setTFplaceHolderWithMainGray];
    }
    
    if (tmpModel.schemewscount) {
        NSString *countStr = tmpModel.schemewscount? [NSString stringWithFormat:@"%.2fTU",[tmpModel.schemewscount floatValue]] : @"";
        
        _itemCountTF.attributedPlaceholder = [countStr setTFplaceHolderWithMainGray];
    }
    
    //折扣 格式 - 20%
    if ([tmpModel.schemewstdiscount integerValue] == 1) {
        _discountTF.text = nil;
    }else {
        _discountTF.text = tmpModel.schemewstdiscount ? [NSString stringWithFormat:@"-%.2f%%", [tmpModel.schemewstdiscount floatValue] *100] : nil;
    }
    
    if (tmpModel.schemewstotalprice) {
//        if (tmpModel.schemewsdiscounttotalprice) {
            [self setTotalPriceLbShowWithSavestatus:[_saveStatus integerValue] totalPrice:tmpModel.schemewstotalprice];
//        }else {
//            [self setTotalPriceLbShowWithSavestatus:[_saveStatus integerValue] totalPrice:@(0.00)];

//        }
        
    }else {
        _itemtotalPriceTF.text = @"";
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
    
    //服务沟通界面   红色的工时和备件可以进行编号图号的编辑,界面样式改变
    //扳手图标 自定义工时 默认红色
    _itemTimeBtn.hidden = NO;
    if (!([_tmpModel.schemewstype integerValue] == 2 || _tmpModel == nil)) {
        [self setupNumberSuperViewWithSaveStatus:@1];
        self.itemTimeBtn.hidden = YES;
    }
    
}

- (void)clearCell {
    _itemNameTF.text = nil;
    _itemTimeTF.text = nil;
    _itemCountTF.text = nil;
    _itemPrice.text = nil;
    _itemtotalPriceTF.text = nil;
}

- (void)setDefaultplaceHolder {
    _itemTimeTF.placeholder = @" 工时编号";
    
    _itemNameTF.placeholder = @" 工时名称";
    
    _itemPrice.placeholder = @"工时单价 ";
    
    _itemCountTF.placeholder = @"数量";
    
    _itemtotalPriceTF.placeholder = @"折后金额";
    
    _discountTF.placeholder = @"折扣率";
}


#pragma mark  工单保存/编辑状态下，边框的显示/隐藏
//保存/编辑状态下 小计赋值
- (void)setTotalPriceLbShowWithSavestatus:(BOOL)issave totalPrice:(NSNumber *)price{
    if (issave) {
        _itemtotalPriceTF.text = [NSString formatMoneyStringWithFloat:[price floatValue]] ;
    }else {
        _itemtotalPriceTF.attributedText = [[NSString formatMoneyStringWithFloat:[price floatValue]] changeToBottomLine];
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
}

//功能按钮的隐藏 hd_project_delete_new_cell.png//work_list_29
- (void)setupButtonWithsaveStatus:(NSNumber *)saveStatus {
    _chooseBt.hidden = YES;
    _guaranteeBt.hidden = YES;
    _chooseImageView.hidden = YES;
    _selectImageViewSuperView.hidden = YES;
    if (_tmpModel) {
        _chooseImageView.hidden = [saveStatus integerValue];
        _chooseBt.hidden = [saveStatus integerValue];
        _guaranteeBt.hidden = [saveStatus integerValue];
        _chooseImageView.hidden = [saveStatus integerValue];
        _selectImageViewSuperView.hidden = ![saveStatus integerValue];
        _selectImageViewSuperView.backgroundColor = [saveStatus integerValue] ? Color(255, 255, 255) : Color(119, 119, 119);
        if ([_tmpModel.schemewstype integerValue] == 1 || ![HDLeftSingleton isUserAdded:_tmpModel.projectaddid]) {
            _chooseImageView.hidden = YES;
            _chooseImageViewSuperView.hidden = YES;
            _selectImageViewSuperView.hidden = NO;
        }else {
            _chooseImageViewSuperView.hidden = NO;
        }
    }
    
    
    _discountBt.hidden = [saveStatus integerValue];
     
}

//名称
- (void)setuptextViewCornerRadiusWithSaveStatus:(NSNumber *)isSave {
    if ([isSave integerValue]) {
        _itemNameTF.hidden = YES;
        _itemNameLabel.hidden = NO;
        _itemNameLabel.text = _tmpModel.schemewsname;
    }else {
        _itemNameTF.hidden = NO;
        _itemNameLabel.hidden = YES;
        _itemNameLabel.text = @"";
        [AlertViewHelpers setupCellTFView:_itemNameTF save:[isSave integerValue]];
    }
    
}
//编号-编码
- (void)setupNumberSuperViewWithSaveStatus:(NSNumber *)issave {
    
    _itemTimeTF.userInteractionEnabled = ![issave integerValue];
    [AlertViewHelpers setupCellTFView:_itemTimeTF save:[issave integerValue]];
    _itemTimeTF.leftViewMode = UITextFieldViewModeNever;
    
}
//单价
- (void)setupPriceWithSaveStatus:(NSNumber *)issave {
    [AlertViewHelpers setupCellTFView:_itemPrice save:[issave integerValue]];
    
    
}
//数量
- (void)setupCountWithSaveStatus:(NSNumber *)issave {
    [AlertViewHelpers setupCellTFView:_itemCountTF save:[issave integerValue]];
    
}
//折扣
- (void)setDiscountWithSaveStatus:(NSNumber *)issave {
    [AlertViewHelpers setupCellTFView:_discountTF save:[issave integerValue]];
}

// 保修审批显示
- (void)guranteeShenPiStatus
{
    [self setTotalPriceLbShowWithSavestatus:NO totalPrice:_tmpModel.schemewstotalprice];
    self.guaranteeBt.hidden = NO;
}

@end
