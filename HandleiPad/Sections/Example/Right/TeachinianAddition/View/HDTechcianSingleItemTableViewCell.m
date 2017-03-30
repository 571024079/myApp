//
//  HDTechcianSingleItemTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDTechcianSingleItemTableViewCell.h"
#import "HDLeftSingleton.h"
@interface HDTechcianSingleItemTableViewCell ()<UITextFieldDelegate>

@end

@implementation HDTechcianSingleItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _itemNameTF.delegate = self;
    _itemCountTF.delegate = self;
    _itemtotalPriceTF.delegate = self;
    _itemTimeTF.delegate = self;
    _itemPrice.delegate = self;
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cannotEditWorkhourNumber
{
    if (_tmpModel && [_tmpModel.schemewstype integerValue] != 2)
    {
        [AlertViewHelpers setupCellTFView:_itemTimeTF save:YES];
        _numberBt.hidden = YES;
        _itemTimeTF.leftViewMode = UITextFieldViewModeNever;
    }
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
    if ([saveStatus integerValue]) {
        _itemNameTF.hidden = YES;
        _itemNameLabel.hidden = NO;
        _itemNameLabel.text = _tmpModel.schemewsname;
    }else {
        _itemNameTF.hidden = NO;
        _itemNameLabel.hidden = YES;
        _itemNameLabel.text = @"";
        [AlertViewHelpers setupCellTFView:_itemNameTF save:[saveStatus integerValue]];
    }
//    [AlertViewHelpers setupCellTFView:_itemNameTF save:[saveStatus integerValue]];
    [AlertViewHelpers setupCellTFView:_itemTimeTF save:[saveStatus integerValue]];
    // 如果是工时库工时，或者方案附带工时，价格不可修改
    if ([_tmpModel.schemewstype integerValue] == 1 || [_tmpModel.schemewstype integerValue] == 3)
    {
        [AlertViewHelpers setupCellTFView:_itemPrice save:YES];
    }
    else
    {
        [AlertViewHelpers setupCellTFView:_itemPrice save:[saveStatus integerValue]];
    }
    [AlertViewHelpers setupCellTFView:_itemCountTF save:[saveStatus integerValue]];
    _itemTimeTF.leftViewMode = UITextFieldViewModeNever;

    [self setupButtonWithsaveStatus:saveStatus];
}

//功能按钮的隐藏 hd_project_delete_new_cell.png//work_list_29
- (void)setupButtonWithsaveStatus:(NSNumber *)saveStatus {
    _guaranteeBt.userInteractionEnabled = ![saveStatus integerValue];
    _chooseBt.userInteractionEnabled = ![saveStatus integerValue];
    _chooseImageViewSuperView.backgroundColor = [saveStatus integerValue] == 1 ? Color(255, 255, 255) : Color(170, 170, 170);
    _chooseImageView.hidden = [saveStatus integerValue];
    _numberBt.hidden = [saveStatus integerValue];
    if (_tmpModel) {
        if ([_tmpModel.schemewstype integerValue] == 1 || ![HDLeftSingleton isUserAdded:_tmpModel.projectaddid]) {//不是技师添加的
            _chooseImageView.hidden = YES;
        }
    }else {
        _chooseImageView.hidden = YES;

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_itemNameTF]) {
        if (_tmpModel.schemewsname.length > 0) {
            _itemNameTF.attributedPlaceholder = [_tmpModel.schemewsname setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
            
        }
    }
    
    if ([textField isEqual:_itemPrice]) {
        if (_tmpModel.schemewsunitprice) {
            NSString *priceStr = _tmpModel.schemewsunitprice? [NSString formatMoneyStringWithFloat:[_tmpModel.schemewsunitprice floatValue]] : @"";
            _itemPrice.attributedPlaceholder = [priceStr setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
        }
        else
        {
            
        }
    }
    
    if ([textField isEqual:_itemCountTF]) {
        if (_tmpModel.schemewscount) {
            NSString *countStr = _tmpModel.schemewscount ? [NSString stringWithFormat:@"%.2fTU",[_tmpModel.schemewscount floatValue]] : @"";
            
            _itemCountTF.attributedPlaceholder = [countStr setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
        }
    }
    

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:_itemNameTF]) {
        if (_tmpModel.schemewsname.length > 0) {
            _itemNameTF.attributedPlaceholder = [_tmpModel.schemewsname setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
            
        }
    }
    
    if ([textField isEqual:_itemPrice]) {
        if (_tmpModel.schemewsunitprice) {
            NSString *priceStr = _tmpModel.schemewsunitprice? [NSString formatMoneyStringWithFloat:[_tmpModel.schemewsunitprice floatValue]] : @"";
            _itemPrice.attributedPlaceholder = [priceStr setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
        }
    }
    
    if ([textField isEqual:_itemCountTF]) {
        if (_tmpModel.schemewscount) {
            NSString *countStr = _tmpModel.schemewscount ? [NSString stringWithFormat:@"%.2fTU",[_tmpModel.schemewscount floatValue]] : @"";
            
            _itemCountTF.attributedPlaceholder = [countStr setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
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


- (IBAction)chooseBtAction:(UIButton *)sender {
    if ([_tmpModel.schemewstype integerValue] == 1 || ![HDLeftSingleton isUserAdded:_tmpModel.projectaddid]) {//不是技师添加的
        if (self.chooseBlock) {
            self.chooseBlock(_tmpModel,sender);
        }
    }else if (self.hDTechcianSingleItemTableViewCellBlock) {
        self.hDTechcianSingleItemTableViewCellBlock(HDTechcianSingleItemTableViewCellStyleChoose,sender);
    }
}


- (IBAction)repairBtAction:(UIButton *)sender {
    if (self.hDTechcianSingleItemTableViewCellBlock) {
        self.hDTechcianSingleItemTableViewCellBlock(HDTechcianSingleItemTableViewCellStyleRepair,sender);
    }
}

- (IBAction)itemTimenumberBtAction:(UIButton *)sender {
    if (self.hDTechcianSingleItemTableViewCellBlock) {
        self.hDTechcianSingleItemTableViewCellBlock(HDTechcianSingleItemTableViewCellStyleItemTimeTF,nil);
    }
}

- (void)setupChooseImage {
    if ([_tmpModel.iscancel integerValue] == 0) {
        _selectedImg.image = nil;
    }else {
        _selectedImg.image = [UIImage imageNamed:@"work_list_29.png"];
    }
}

- (void)defaultHiddenAndView {
    _repairBt.hidden = YES;
    
    _repairBtbgImg.hidden = YES;
    
    _cameraBt.hidden = YES;
    
    _photoBt.hidden = YES;
    
    _chooseBt.hidden = NO;
    
    _chooseImageView.hidden = NO;
    
    _chooseImageViewSuperView.hidden = NO;
    
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
        _chooseImageView.hidden = YES;
        //新增工时行
    }else {
//        if ([_tmpModel.schemewstype integerValue] == 3) {//工时库 工时
//            _headerImageView.image = [UIImage imageNamed:@"work_list_24.png"];
//        }
        _itemTimeSureLb.hidden = NO;
        _chooseBt.hidden = NO;
        _guaranteeBt.hidden = NO;
        _guaranteeImg.hidden = NO;
        if ([_tmpModel.schemewstype integerValue] == 1 || ![HDLeftSingleton isUserAdded:_tmpModel.projectaddid]) {//不是技师添加的
            _chooseImageView.hidden = YES;
        }
    }
}
- (BOOL)isSHowDiscountPrice {
    if (![_tmpModel.superschemesettlementway isEqual:@3]) {
        return YES;
    }else {
        if ([_tmpModel.schemesettlementway isEqual:@3]) {
            return NO;
        }else {
            return YES;
        }
    }
}

- (void)setTmpModel:(PorscheNewSchemews *)tmpModel {
    _tmpModel = tmpModel;
    [self clearCell];
    [self defaultHiddenAndView];

    
    [self setDefaultplaceHolder];
    [self setupAllBorderWithsaveStatus:_saveStatus];
    [self setupChooseImage];
    
    if (tmpModel.schemewscode) {
        _itemTimeTF.attributedPlaceholder = [tmpModel.schemewscode setTFplaceHolderWithMainGray];
    }
    if (tmpModel.schemewsname.length > 0) {
        _itemNameTF.attributedPlaceholder = [tmpModel.schemewsname setTFplaceHolderWithMainGray];

    }
    if (tmpModel.schemewsunitprice)
    {
        NSString *priceStr = tmpModel.schemewsunitprice? [NSString formatMoneyStringWithFloat:[tmpModel.schemewsunitprice floatValue]] : @"";
        _itemPrice.attributedPlaceholder = [priceStr setTFplaceHolderWithMainGray];
    }

    
    if (tmpModel.schemewscount) {
        NSString *countStr = tmpModel.schemewscount ? [NSString stringWithFormat:@"%.2fTU",[tmpModel.schemewscount floatValue]] : @"";
        
        _itemCountTF.attributedPlaceholder = [countStr setTFplaceHolderWithMainGray];
    }
    
    NSNumber *endPrice = [self isSHowDiscountPrice] ?_tmpModel.schemewstotalprice : _tmpModel.schemewsunitprice_yuan;

    if (tmpModel.schemewsunitprice_yuan) {
        if (tmpModel.schemewsunitprice_yuan) {
            [self setTotalPriceLbShowWithSavestatus:[_saveStatus integerValue] totalPrice:endPrice];
        }else {
            [self setTotalPriceLbShowWithSavestatus:[_saveStatus integerValue] totalPrice:@(0.00)];
        }
        
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
    
    [self cannotEditWorkhourNumber];
}

#pragma mark  ------保修相关------
- (IBAction)guaranteeBtAction:(UIButton *)sender {
    if (self.guaranteeViewBlock) {
        self.guaranteeViewBlock(sender);
    }
}

- (IBAction)cameraBtAction:(UIButton *)sender {
    if (self.hDTechcianSingleItemTableViewCellBlock) {
        self.hDTechcianSingleItemTableViewCellBlock(HDTechcianSingleItemTableViewCellStyleCamera,sender);
    }
}

//照片库
- (IBAction)photoBtAction:(UIButton *)sender {
    if (self.hDTechcianSingleItemTableViewCellBlock) {
        self.hDTechcianSingleItemTableViewCellBlock(HDTechcianSingleItemTableViewCellStylePhoto,sender);
    }
}


/*
 
 //工时编号
 @property (weak, nonatomic) IBOutlet UITextField *itemTimeTF;
 //工时名称
 @property (weak, nonatomic) IBOutlet UITextField *itemNameTF;
 //工时单价
 @property (weak, nonatomic) IBOutlet UITextField *itemPrice;
 //工时数
 @property (weak, nonatomic) IBOutlet UITextField *itemCountTF;
 //工时小计
 @property (weak, nonatomic) IBOutlet UITextField *itemtotalPriceTF;
 */
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
    
    _itemtotalPriceTF.placeholder = @"小计";
}

@end
