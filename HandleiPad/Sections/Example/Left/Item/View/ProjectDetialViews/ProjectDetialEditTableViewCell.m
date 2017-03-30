//
//  ProjectDetialEditTableViewCell.m
//  HandleiPad
//
//  Created by Robin on 2016/10/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ProjectDetialEditTableViewCell.h"
#import "PorscheNumericKeyboard.h"
#import "HDAccessoryView.h"
#import "HDLinkageTextEditor.h"

#define Width 157

@interface ProjectDetialEditTableViewCell ()<UITextFieldDelegate,UITextViewDelegate,HDLinkageTextEditorDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UITextField *picNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *codeNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UITextField *countTF;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picNumberTFLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeNumberTFLayoutHeight;
//工时库添加项标题数组
@property (nonatomic, strong) NSArray *editWorkHoursTitleArray;

@property (nonatomic, assign) BOOL canEditName;
@property (nonatomic, assign) BOOL canEditPicNumber;
@property (nonatomic, assign) BOOL canEditCodeNumber;
@property (nonatomic, assign) BOOL canEditPrice;
@property (nonatomic, assign) BOOL canEditCount;
@property (weak, nonatomic) IBOutlet HDLinkageTextEditor *codeView;
@property (weak, nonatomic) IBOutlet HDLinkageTextEditor *picNumberView;

@property (weak, nonatomic) IBOutlet UIButton *numberButton;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;


@end

@implementation ProjectDetialEditTableViewCell {
    
//    UIColor *_textFieldGrayColor;
    BOOL _newObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setLeftViewModel:_codeNumberTF];
    [self setLeftViewModel:_nameTF];
    [self setLeftViewModel:_picNumberTF];
    [self setupKeyBoard];
    
    self.picNumberView.delegate = self;
    self.codeView.delegate = self;
    
    self.picNumberView.layer.cornerRadius = 4;
    self.picNumberView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.picNumberView.layer.borderWidth = 0.5f;
    
    self.codeView.layer.cornerRadius = 4;
    self.codeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.codeView.layer.borderWidth = 0.5f;
    
    
    self.codeButton.frame = self.codeNumberTF.frame;
    self.numberButton.frame = self.picNumberTF.frame;
    
    self.codeView.frame = self.codeNumberTF.frame;
    self.picNumberView.frame = self.picNumberTF.frame;
    
}


- (IBAction)picNumberButton:(id)sender {

    [self.codeView endEditing:YES];

    
    // 获取图号
    if (self.type == MaterialTaskTimeDetailsTypeMaterial)
    {
        
        [self.picNumberView becomeEditWithTexts:[self.speraModel spareImageCodes]];

    }
    
}

- (IBAction)codeButton:(id)sender {
    [self.picNumberView endEditing:YES];

    
    if (self.type == MaterialTaskTimeDetailsTypeMaterial)
    {
        [self.codeView becomeEditWithTexts:[self.speraModel spareCodes]];
    }
    else if (self.type == MaterialTaskTimeDetailsTypeWorkHours)
    {
        [self.codeView  becomeEditWithTexts:[self.hoursModel workHourCodes]];
    }

}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"ProjectDetialEditTableViewCell";
    ProjectDetialEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectDetialEditTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;

}

- (void)setupKeyBoard {
    
    PorscheNumericKeyboard *inputView = [[PorscheNumericKeyboard alloc] init];
    self.countTF.delegate = self;
    self.countTF.inputView = inputView;
    [self.countTF reloadInputViews];
    [HDAccessoryView accessoryViewWithTextField:_countTF target:self];
    
    PorscheNumericKeyboard *inputView2 = [[PorscheNumericKeyboard alloc] init];
    self.priceTF.delegate = self;
    self.priceTF.inputView = inputView2;
    [self.priceTF reloadInputViews];
    [HDAccessoryView accessoryViewWithTextField:_priceTF target:self];

    
    self.picNumberTF.delegate = self;
    self.codeNumberTF.delegate = self;
    self.nameTF.delegate = self;
    
    [self.codeNumberTF setValue:MAIN_RED forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeNumberTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self.nameTF setValue:MAIN_RED forKeyPath:@"_placeholderLabel.textColor"];
    [self.nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self.priceTF setValue:MAIN_RED forKeyPath:@"_placeholderLabel.textColor"];
    [self.priceTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self.countTF setValue:MAIN_RED forKeyPath:@"_placeholderLabel.textColor"];
    [self.countTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)setupTextField {
    
//    self.canEditCodeNumber = NO;
//    self.canEditPicNumber = YES;
//    self.canEditName = YES;
//    self.canEditPrice = YES;
//    self.canEditCount = YES;
    [self reSetupEditPermission];
    
    self.picNumberTF.borderStyle = self.editCell && self.canEditPicNumber ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    
    self.picNumberView.hidden = self.editCell && self.canEditPicNumber ? NO : YES;
    self.numberButton.hidden = self.editCell && self.canEditPicNumber ? NO : YES;
    
    self.codeNumberTF.borderStyle = self.editCell && self.canEditCodeNumber ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    
    self.codeView.hidden = self.editCell && self.canEditCodeNumber ? NO : YES;
    self.codeButton.hidden = self.editCell && self.canEditCodeNumber ? NO : YES;

    self.nameTF.borderStyle = self.editCell && self.canEditName ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    self.priceTF.borderStyle = self.editCell && self.canEditPrice ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    self.countTF.borderStyle = self.editCell && self.canEditCount ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;


    if (self.canEditCodeNumber)  [self setupTextFieldHintBorader:self.codeNumberTF];

    if (self.canEditCodeNumber)
    {
        self.codeView.layer.borderColor =  [self.codeNumberTF.text isEqualToString:@""] ? MAIN_RED.CGColor : [UIColor grayColor].CGColor;
//        self.codeView.layer.borderWidth = self.editCell ? .5f : 0;
//        self.codeView.layer.cornerRadius = 4.f;
    }
    
    if (self.canEditName) [self setupTextFieldHintBorader:self.nameTF];
    if (self.canEditPrice) [self setupTextFieldHintBorader:self.priceTF];
    if (self.canEditCount) [self setupTextFieldHintBorader:self.countTF];

}

- (void)setCanEditPicNumber:(BOOL)canEditPicNumber {
    _canEditPicNumber = canEditPicNumber;
    
    self.picNumberTF.enabled = canEditPicNumber;
}
- (void)setCanEditCodeNumber:(BOOL)canEditCodeNumber {
    _canEditCodeNumber = canEditCodeNumber;
    
    self.codeNumberTF.enabled = canEditCodeNumber;
}
- (void)setCanEditName:(BOOL)canEditName {
    _canEditName = canEditName;
    
    self.nameTF.enabled = canEditName;
}
- (void)setCanEditPrice:(BOOL)canEditPrice {
    _canEditPrice = canEditPrice;
    
    self.priceTF.enabled = canEditPrice;
}
- (void)setCanEditCount:(BOOL)canEditCount {
    _canEditCount = canEditCount;
    
    self.countTF.enabled = canEditCount;
}

- (void)setupTextFieldHintBorader:(UITextField *)textField {
    
    textField.layer.borderColor =  [textField.text isEqualToString:@""] ? MAIN_RED.CGColor : [UIColor grayColor].CGColor;
    textField.layer.borderWidth = self.editCell ? .5f : 0;
    textField.layer.cornerRadius = 4.f;
}

- (void)textFieldDidChange:(UITextField *)field {
    
    if ([field.text isEqualToString:@""]) {
        
        field.layer.borderColor = MAIN_RED.CGColor;
    } else {
        
        field.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
}

- (void)setDetailType:(MaterialTaskTimeDetailsType)detailType
{
    _detailType = detailType;
    
    if (_detailType == MaterialTaskTimeDetailsTypeScheme)
    {
        
        if ((self.type == MaterialTaskTimeDetailsTypeMaterial && [_speraModel.parts_status integerValue] > 1)
            || (self.type == MaterialTaskTimeDetailsTypeWorkHours && [_hoursModel.workhourstatus integerValue] > 1))
        {
            // 方案库详情
            _codeNumberTF.enabled = NO;
            _codeNumberTF.borderStyle = UITextBorderStyleNone;
            
            _nameTF.enabled = NO;
            _nameTF.borderStyle = UITextBorderStyleNone;
        }

    }
}

- (NSArray *)editWorkHoursTitleArray {
    
    if (!_editWorkHoursTitleArray) {

        _editWorkHoursTitleArray = @[@"work_list_24.png",@"工时编号",@"工时名称",@"工时单价",@"工时数",@"工时总计：— — — —"];
    }
    return _editWorkHoursTitleArray;
}

- (void)setEditCell:(BOOL)editCell {
    
    _editCell = editCell;
    
    [self setupTextField];
    
    if (_detailType == MaterialTaskTimeDetailsTypeScheme)
    {
        // 方案库详情
        
        if ((self.type == MaterialTaskTimeDetailsTypeMaterial && [_speraModel.parts_status integerValue] > 1)
            || (self.type == MaterialTaskTimeDetailsTypeWorkHours && [_hoursModel.workhourstatus integerValue] > 1))
        {
            _codeNumberTF.enabled = NO;
            _codeNumberTF.borderStyle = UITextBorderStyleNone;
            _codeNumberTF.layer.borderWidth = 0;
            _nameTF.enabled = NO;
            _nameTF.borderStyle = UITextBorderStyleNone;
            _nameTF.layer.borderWidth = 0;
            
            _codeNumberTF.leftViewMode = UITextFieldViewModeAlways;
            _nameTF.leftViewMode = UITextFieldViewModeAlways;
            _picNumberTF.leftViewMode = UITextFieldViewModeAlways;

            self.codeView.hidden = YES;
            self.codeButton.hidden = YES;
            
            if (editCell)
            {
                _picNumberTF.leftViewMode = UITextFieldViewModeNever;
            }

        }
        else
        {
            if (_editCell)
            {
                _codeNumberTF.leftViewMode = UITextFieldViewModeNever;
                _nameTF.leftViewMode = UITextFieldViewModeNever;
                _picNumberTF.leftViewMode = UITextFieldViewModeNever;
            }
            else
            {
                
                _codeNumberTF.leftViewMode = UITextFieldViewModeAlways;
                _nameTF.leftViewMode = UITextFieldViewModeAlways;
                _picNumberTF.leftViewMode = UITextFieldViewModeAlways;
            }
        }

    }
}


- (void)setLeftViewModel:(UITextField *)textField
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6.5, 10)];
    leftView.backgroundColor = [UIColor whiteColor];
    textField.leftView = leftView;
}

- (void)setNewCell:(BOOL)newCell
{
    _newCell = newCell;
//    NSString *imageName = [PorscheImageManager getMaterialHoursIconImage:self.type Normal:!newCell];
//    self.picImageView.image = [UIImage imageNamed:imageName];
}

////  ------- 工单主流程(进入方案库)
//#define HDOrder_GoSchemeLibrary                                                 10802      //进入方案库
//#define HDOrder_GoSchemeLibrary_EditSchemeName                                  10802001   //编辑方案一名称
//#define HDOrder_GoSchemeLibrary_EditSpacePartName                               10802002   //编辑方案备件—名称
//#define HDOrder_GoSchemeLibrary_EditSpacePartFigureNumber                       10802003   //编辑方案备件—图号
//#define HDOrder_GoSchemeLibrary_EditSpacePartNumber                             10802004   //编辑方案备件—编号
//#define HDOrder_GoSchemeLibrary_EditSpacePartPrice                              10802005   //编辑方案备件—单价
//#define HDOrder_GoSchemeLibrary_EditSpacePartCount                              10802006   //编辑方案备件—数量
//#define HDOrder_GoSchemeLibrary_EditSchemeTimeName                              10802007   //编辑方案工时—名称
//#define HDOrder_GoSchemeLibrary_EditSchemeTimeNumber                            10802008   //编辑方案工时—编号
//#define HDOrder_GoSchemeLibrary_EditSchemeTimePrice                             10802009   //编辑方案工时—单价
//#define HDOrder_GoSchemeLibrary_EditSchemeTimeCount                             10802010   //编辑方案工时—数量
//#define HDOrder_GoSchemeLibrary_ApplicationCarType                              10802011   //编辑方案—适用车型
//#define HDOrder_GoSchemeLibrary_KMAndTimeRange                                  10802012   //编辑方案—公里数范围、时间范围
//#define HDOrder_GoSchemeLibrary_LevelAndBusinessClass                           10802013   //编辑方案—级别、业务分类
//#define HDOrder_GoSchemeLibrary_Favorite                                        10802014   //编辑方案—收藏夹
//#define HDOrder_GoSchemeLibrary_SaveToOrder                                     10802015   //方案库方案加入工单
//#define HDOrder_GoSchemeLibrary_ReplaceOldSchemeAfterChangeMyShop               10802016   //修改本店方案后替换原方案
//#define HDOrder_GoSchemeLibrary_AddCustomScheme                                 10802017   //新增自定义方案

////  ------- 工单主流程(进入工时库)
//#define HDOrder_GoTimeLibrary                                                   10804      //进入工时库
//#define HDOrder_GoTimeLibrary_Add                                               10804001   //新增工时
//#define HDOrder_GoTimeLibrary_EditName                                          10804002   //编辑工时—名称
//#define HDOrder_GoTimeLibrary_EditNumber                                        10804003   //编辑工时—编号
//#define HDOrder_GoTimeLibrary_EditPrice                                         10804004   //编辑工时—单价
//#define HDOrder_GoTimeLibrary_EditCount                                         10804005   //编辑工时—数量
//#define HDOrder_GoTimeLibrary_EditBusinessClass                                 10804006   //编辑工时—业务分类
//#define HDOrder_GoTimeLibrary_EditGroupClass                                    10804007   //编辑工时—组别分类
//#define HDOrder_GoTimeLibrary_EditKMRange                                       10804008   //编辑工时—公里数范围
//#define HDOrder_GoTimeLibrary_EditTimeRange                                     10804009   //编辑工时—时间范围
//#define HDOrder_GoTimeLibrary_EditApplicationCarType                            10804010   //编辑工时—适用车型
//#define HDOrder_GoTimeLibrary_EditMyShopSaveToOrder                             10804011   //编辑本店工时-保存并加入工单
- (void)reSetupEditPermission {
    
    switch (self.detailType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
            if (self.type == MaterialTaskTimeDetailsTypeMaterial) {
                
                BOOL isHasPermission = _isFromNotice ? [HDPermissionManager isHasThisPermission:HDTaskNotice_MyShopNotice_Edit isNeedShowMessage:NO] : [HDPermissionManager isHasThisPermission:HDOrder_GoSchemeLibrary_EditContent isNeedShowMessage:NO];
                
                self.canEditName = isHasPermission;
                self.canEditCodeNumber = isHasPermission;
                self.canEditPicNumber = isHasPermission;
                self.canEditPrice = isHasPermission;
                self.canEditCount = isHasPermission;
                
            } else if (self.type == MaterialTaskTimeDetailsTypeWorkHours) {
                
                BOOL isHasPermission = _isFromNotice ? [HDPermissionManager isHasThisPermission:HDTaskNotice_MyShopNotice_Edit isNeedShowMessage:NO] : [HDPermissionManager isHasThisPermission:HDOrder_GoSchemeLibrary_EditContent isNeedShowMessage:NO];

                self.canEditName = isHasPermission;
                self.canEditPicNumber = NO;
                self.canEditCodeNumber = isHasPermission;
                self.canEditPrice = isHasPermission;
                self.canEditCount = isHasPermission;
            }
        }
            break;

        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            if (_newObject) {
             
                self.canEditName = YES;
                self.canEditCodeNumber = YES;
                self.canEditPrice = YES;
                self.canEditCount = YES;
                self.canEditPicNumber = NO;
            } else {
                self.canEditPicNumber = NO;
                self.canEditName = [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_Edit isNeedShowMessage:NO];
                self.canEditCodeNumber = [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_Edit isNeedShowMessage:NO];
                self.canEditPrice = [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_Edit isNeedShowMessage:NO];
                self.canEditCount = [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_Edit isNeedShowMessage:NO];
            }
        }
            break;
        default:
            break;
    }
    
    if ((self.type == MaterialTaskTimeDetailsTypeMaterial && [self.speraModel.parts_status integerValue] > 1)
        || (self.type == MaterialTaskTimeDetailsTypeWorkHours && [self.hoursModel.workhourstatus integerValue] > 1))
    {
        self.canEditPrice = NO;
    }
}

- (void)setType:(MaterialTaskTimeDetailsType)type {
    _type = type;
    
    switch (type) {
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            self.picImageView.image = [UIImage imageNamed:@"hd_custom_item_time_material"];
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {

            self.picImageView.image = [UIImage imageNamed:@"work_list_24.png"];
            self.codeNumberTF.placeholder = self.editWorkHoursTitleArray[1];
            self.nameTF.placeholder = self.editWorkHoursTitleArray[2];
            self.priceTF.placeholder = self.editWorkHoursTitleArray[3];
            self.countTF.placeholder = self.editWorkHoursTitleArray[4];
            self.totalLabel.text = self.editWorkHoursTitleArray[5];
            
        }
            break;
        default:
            break;
    }
}

- (void)setSperaModel:(PorscheSchemeSpareModel *)speraModel {
    _speraModel = speraModel;
    
    NSString *imageName = [PorscheImageManager getMaterialHoursIconImage:MaterialTaskTimeDetailsTypeMaterial Normal:[speraModel.parts_status integerValue] > 1];
    
    self.picImageView.image = [UIImage imageNamed:imageName];
    NSString *unitStr = @"个";
    NSString *str = @"小计";
    self.codeNumberTFLayoutHeight.constant = 17;
    
    
    CGRect codeFrame = self.codeNumberTF.frame;
    codeFrame.origin.y = 23.5f;
    codeFrame.size.height = 17;
    codeFrame.size.width = Width;
    self.codeButton.frame = codeFrame;
    self.codeView.frame = codeFrame;
    
    CGRect numberFrame = self.picNumberTF.frame;
    numberFrame.size.height = 17;
    numberFrame.size.width = Width;
    self.numberButton.frame = numberFrame;
    self.picNumberView.frame = numberFrame;
    
    self.picNumberView.hidden = NO;
    self.numberButton.hidden = NO;
    
    self.picNumberTF.hidden = NO;
    self.codeNumberTF.hidden = NO;
    self.codeNumberTF.text = speraModel.speraCode;
    self.picNumberTF.text = speraModel.speraImageCode;
    self.nameTF.text = speraModel.parts_name;
    self.priceTF.text = [NSString formatMoneyStringWithFloat:[speraModel.price_after_tax floatValue]];
    self.countTF.text = [NSString stringWithFormat:@"%.2f%@",[speraModel.parts_num floatValue],unitStr];
    self.totalLabel.text = [NSString stringWithFormat:@"%@%@",str,[NSString formatMoneyStringWithFloat:[speraModel.sparepriceall floatValue]]];
    

    
    [self.picNumberView configViewWithTextParts:4 borderStyle:UITextBorderStyleNone textLengthLimit:3 frame:CGRectZero];
    [self.codeView configViewWithTextParts:6 borderStyle:UITextBorderStyleNone textLengthLimit:3 frame:CGRectZero];
    
    [self.picNumberView setTextValues:[self.speraModel spareImageCodes]];
    [self.codeView setTextValues:[self.speraModel spareCodes]];
}

- (void)setHoursModel:(PorscheSchemeWorkHourModel *)hoursModel {
    
    _hoursModel = hoursModel;
    
    NSString *imageName = [PorscheImageManager getMaterialHoursIconImage:MaterialTaskTimeDetailsTypeWorkHours Normal:[hoursModel.workhourstatus integerValue] > 1];
    
    self.picImageView.image = [UIImage imageNamed:imageName];
    
    NSString *unitStr = @"TU";
    NSString *str = @"小计";
    self.codeNumberTFLayoutHeight.constant = 35;
    
    
    CGRect codeFrame = self.codeButton.frame;
    codeFrame.size.height = 36;
    codeFrame.size.width = Width;
    codeFrame.origin.y = 4;
    
    self.codeButton.frame = codeFrame;
    self.codeView.frame = codeFrame;
    
    self.codeView.hidden = NO;
    self.codeNumberTF.hidden = NO;
    
    self.picNumberView.hidden = YES;
    self.numberButton.hidden = YES;
    
    self.picNumberTF.hidden = YES;
    self.codeNumberTF.hidden = NO;
    self.codeNumberTF.text = hoursModel.workHourCode;
    self.nameTF.text = hoursModel.workhourname;
    self.priceTF.text = [NSString formatMoneyStringWithFloat:[hoursModel.workhourprice floatValue]];
    self.countTF.text = [NSString stringWithFormat:@"%.2f%@",[hoursModel.workhourcount floatValue],unitStr];
    self.totalLabel.text = [NSString stringWithFormat:@"%@%@",str,[NSString formatMoneyStringWithFloat:[hoursModel.workhourpriceall floatValue]]];
    
    _newObject = !hoursModel.workhourid.integerValue;

    
    [self.codeView configViewWithTextParts:4 borderStyle:UITextBorderStyleNone textLengthLimit:2 frame:CGRectZero];
    
    [self.codeView setTextValues:[self.hoursModel workHourCodes]];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return self.editCell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
 
    [self endEditing:YES];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSString *str;
    NSString *unitStr;
    switch (_type) {
        case MaterialTaskTimeDetailsTypeMaterial:
            str = @"小计:";
            unitStr = @"个";
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
            str = @"小计:";
            unitStr = @"TU";
            break;
        default:
            str = @"总计:";
            unitStr = @"个";
            break;
    }

    
    
    if (textField == self.countTF) {
        
        if (self.type == MaterialTaskTimeDetailsTypeMaterial) {
            self.speraModel.parts_num = @(self.countTF.text.floatValue);
            self.countTF.text = [NSString stringWithFormat:@"%@%@",self.speraModel.parts_num,unitStr];
        } else if (self.type == MaterialTaskTimeDetailsTypeWorkHours) {
            self.hoursModel.workhourcount = @(self.countTF.text.floatValue);
            self.countTF.text = [NSString stringWithFormat:@"%@%@",self.hoursModel.workhourcount,unitStr];
        }
    }
    
    if (textField == self.priceTF) {
        if (self.type == MaterialTaskTimeDetailsTypeMaterial) {
            self.speraModel.price_after_tax = @(self.priceTF.text.floatValue);
            self.priceTF.text = [NSString formatMoneyStringWithFloat:self.priceTF.text.floatValue];
        } else if (self.type == MaterialTaskTimeDetailsTypeWorkHours) {
            self.hoursModel.workhourprice = @(self.priceTF.text.floatValue);
            self.priceTF.text = [NSString formatMoneyStringWithFloat:self.priceTF.text.floatValue];
        }
    }
    
    if (textField == self.countTF || textField == self.priceTF) {

        if (self.type == MaterialTaskTimeDetailsTypeMaterial) {
            CGFloat totalPrice = self.speraModel.parts_num.floatValue * self.speraModel.price_after_tax.floatValue;
            self.speraModel.sparepriceall = @(totalPrice);
            self.totalLabel.text = [NSString stringWithFormat:@"%@%@",str,[NSString formatMoneyStringWithFloat:totalPrice]];
        } else if (self.type == MaterialTaskTimeDetailsTypeWorkHours) {

            CGFloat totalPrice = self.hoursModel.workhourcount.floatValue * self.hoursModel.workhourprice.floatValue;
            self.hoursModel.workhourpriceall = @(totalPrice);
            self.totalLabel.text = [NSString stringWithFormat:@"%@%@",str,[NSString formatMoneyStringWithFloat:totalPrice]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_RIGHT_RELOADPRICE_NOTIFICATION object:nil];
    }
    if (textField == self.nameTF) {
        if (self.type == MaterialTaskTimeDetailsTypeMaterial) {
            
            self.speraModel.parts_name = self.nameTF.text;
        } else if (self.type == MaterialTaskTimeDetailsTypeWorkHours) {
            
            self.hoursModel.workhourname = self.nameTF.text;
        }
    }
    
    if (textField == self.picNumberTF) {
        [self.speraModel setupImageNumber:self.picNumberTF.text] ;
    }
    
    if (textField == self.codeNumberTF) {
        if (self.type == MaterialTaskTimeDetailsTypeMaterial) {
            
            [self.speraModel setupPartNumber:self.codeNumberTF.text];

        } else if (self.type == MaterialTaskTimeDetailsTypeWorkHours) {
            
            [self.hoursModel setupWorkHourNumber:self.codeNumberTF.text];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == self.countTF) {
        
        if (self.type == MaterialTaskTimeDetailsTypeMaterial) {
            
            self.countTF.text = self.speraModel.parts_num.stringValue;
        } else if (self.type == MaterialTaskTimeDetailsTypeWorkHours) {
            
            self.countTF.text = self.hoursModel.workhourcount.stringValue;
        }
    }
    if (textField == self.priceTF) {
        if (self.type == MaterialTaskTimeDetailsTypeMaterial) {
            
            self.priceTF.text = self.speraModel.price_after_tax.stringValue;
        } else if (self.type == MaterialTaskTimeDetailsTypeWorkHours) {
            
            self.priceTF.text = self.hoursModel.workhourprice.stringValue;
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.priceTF) {
        
        return [textField isPriceStringChangeRange:range replacementString:string];
    }
    
    if (textField == self.countTF) {
        return [textField isPriceStringChangeRange:range replacementString:string];
    }
    
    if (textField == self.nameTF) {

        return [textField isFloatStringToMaxLength:20 changeRange:range replacementString:string];
    }
    
    return YES;
}


- (void)linkageTextEditor:(HDLinkageTextEditor *)editor didEndEditTextField:(UITextField *)textField atIndex:(NSInteger)index
{

    if (editor == self.picNumberView)
    {
        [self.speraModel setImage_no:textField.text atIndex:index];
        self.picNumberTF.text = [self.speraModel speraImageCode];
    }
    else if (editor == self.codeView)
    {
        if (self.type == MaterialTaskTimeDetailsTypeMaterial)
        {
            [self.speraModel setParts_no:textField.text atIndex:index];
            self.codeNumberTF.text = [self.speraModel speraCode];
        }
        else if (self.type == MaterialTaskTimeDetailsTypeWorkHours)
        {
            [self.hoursModel setWorkhourcode:textField.text atIndex:index];
            self.codeNumberTF.text = [self.hoursModel workHourCode];
        }
    }
}

- (void)linkageTextEditor:(HDLinkageTextEditor *)editor didDoneEditTextField:(NSArray *)texts
{
    // 编辑结束
////    editor.hidden = YES;
//    if (editor == self.picNumberView)
//    {
//        // 图号
//        [self.speraModel setupImageNumberWithArray:texts];
//        self.picNumberTF.text = [self.speraModel speraImageCode];
//        
//    }
//    else if (editor == self.codeView)
//    {
//        // 编号
//        if (self.type == MaterialTaskTimeDetailsTypeMaterial) {
//            
//            [self.speraModel setupPartNumberWithArray:texts];
//            self.codeNumberTF.text = [self.speraModel speraCode];
//            
//        } else if (self.type == MaterialTaskTimeDetailsTypeWorkHours) {
//            
//            [self.hoursModel setupWorkHourNumberWithArray:texts];
//            self.codeNumberTF.text = [self.hoursModel workHourCode];
//        }
//    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
