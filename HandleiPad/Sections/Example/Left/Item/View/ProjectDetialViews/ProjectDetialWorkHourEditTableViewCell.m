//
//  ProjectDetialWorkHourEditTableViewCell.m
//  HandleiPad
//
//  Created by Robin on 2016/11/17.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ProjectDetialWorkHourEditTableViewCell.h"
#import "HDAccessoryView.h"
#import "HDLinkageTextEditor.h"

@interface ProjectDetialWorkHourEditTableViewCell () <UITextFieldDelegate,HDLinkageTextEditorDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *imageCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;

@property (nonatomic, assign) BOOL canEditImageNumber;
@property (nonatomic, assign) BOOL canEditCodeNumber;
@property (nonatomic, assign) BOOL canEditName;
@property (nonatomic, assign) BOOL canEditPrice;


@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *numberButton;

@property (weak, nonatomic) IBOutlet HDLinkageTextEditor *codeView;
@property (weak, nonatomic) IBOutlet HDLinkageTextEditor *numberView;

@end

@implementation ProjectDetialWorkHourEditTableViewCell {
    
    BOOL _newObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    PorscheNumericKeyboard *inputView = [[PorscheNumericKeyboard alloc] init];
    self.priceTF.delegate = self;
    self.priceTF.inputView = inputView;
    [self.priceTF reloadInputViews];
    [HDAccessoryView accessoryViewWithTextField:_priceTF target:self];

    
    [self.codeTF setValue:MAIN_RED forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.nameTF setValue:MAIN_RED forKeyPath:@"_placeholderLabel.textColor"];
    [self.nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.priceTF setValue:MAIN_RED forKeyPath:@"_placeholderLabel.textColor"];
    [self.priceTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.codeView.delegate = self;
    self.numberView.delegate = self;
    
    CGRect codeFrame = self.codeTF.frame;
    CGRect numberFrame = self.imageCodeTF.frame;
    
    codeFrame.size.width = 160;
    numberFrame.size.width = 160;
    
    self.codeView.frame = codeFrame;
    self.numberView.frame = numberFrame;
    
    self.numberView.layer.cornerRadius = 4;
    self.numberView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.numberView.layer.borderWidth = 0.5f;
    
    self.codeView.layer.cornerRadius = 4;
    self.codeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.codeView.layer.borderWidth = 0.5f;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifer = @"ProjectDetialWorkHourEditTableViewCell";
    ProjectDetialWorkHourEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectDetialWorkHourEditTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (IBAction)picNumberButton:(id)sender {
    
    [self.codeView endEditing:YES];
    
    
    // 获取图号
    [self.numberView becomeEditWithTexts:[self.speraModel spareImageCodes]];
    
}

- (IBAction)codeButton:(id)sender {
    [self.numberView endEditing:YES];
    
        [self.codeView becomeEditWithTexts:[self.speraModel spareCodes]];
}

- (void)setupTextField {
    
//    self.canEditCodeNumber = NO;
//    self.canEditImageNumber = YES;
//    self.canEditName = NO;
//    self.canEditPrice = YES;
    
    [self reSetupEditPermission];
    
    self.codeTF.borderStyle = self.editCell && self.canEditCodeNumber ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    
    self.codeView.hidden =  self.editCell && self.canEditCodeNumber ? NO : YES;
    
    self.imageCodeTF.borderStyle = self.editCell && self.canEditImageNumber ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    
    self.numberView.hidden = self.editCell && self.canEditImageNumber  ? NO : YES;
    
    
    self.nameTF.borderStyle = self.editCell && self.canEditName ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    self.priceTF.borderStyle = self.editCell && self.canEditPrice ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    
    
   if (self.canEditCodeNumber) [self setupTextFieldHintBorader:self.codeTF];
    
    if (self.canEditCodeNumber)
    {
        self.codeView.layer.borderColor =  [self.codeTF.text isEqualToString:@""] ? MAIN_RED.CGColor : [UIColor grayColor].CGColor;
    }
   if (self.canEditName) [self setupTextFieldHintBorader:self.nameTF];
   if (self.canEditPrice) [self setupTextFieldHintBorader:self.priceTF];
}

- (void)setCanEditCodeNumber:(BOOL)canEditCodeNumber {
    _canEditCodeNumber = canEditCodeNumber;
    
    self.codeTF.enabled = canEditCodeNumber;
}
- (void)setCanEditImageNumber:(BOOL)canEditImageNumber {
    _canEditImageNumber = canEditImageNumber;
    
    self.imageCodeTF.enabled = canEditImageNumber;
}
- (void)setCanEditName:(BOOL)canEditName {
    _canEditName = canEditName;
    
    self.nameTF.enabled = canEditName;
}
- (void)setCanEditPrice:(BOOL)canEditPrice {
    _canEditPrice = canEditPrice;
    
    self.priceTF.enabled = canEditPrice;
}

- (void)setupTextFieldHintBorader:(UITextField *)textField {

    textField.layer.borderColor = [textField.text isEqualToString:@""] ? MAIN_RED.CGColor : [UIColor grayColor].CGColor;
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

////  ------- 工单主流程(进入备件库)
//#define HDOrder_GoSpacePartLibrary                                              10803      //进入备件库
//#define HDOrder_GoSpacePartLibrary_Add                                          10803001   //新增备件
//#define HDOrder_GoSpacePartLibrary_EditName                                     10803002   //编辑备件—名称
//#define HDOrder_GoSpacePartLibrary_EditFigureNumber                             10803003   //编辑备件—图号
//#define HDOrder_GoSpacePartLibrary_EditNumber                                   10803004   //编辑备件—编号
//#define HDOrder_GoSpacePartLibrary_EditPrice                                    10803005   //编辑备件—单价
//#define HDOrder_GoSpacePartLibrary_EditCount                                    10803006   //编辑备件—数量
//#define HDOrder_GoSpacePartLibrary_EditLevelClass                               10803007   //编辑备件—级别分类
//#define HDOrder_GoSpacePartLibrary_EditBusinessClass                            10803008   //编辑备件—业务分类
//#define HDOrder_GoSpacePartLibrary_EditGroupClass                               10803009   //编辑备件—组别分类
//#define HDOrder_GoSpacePartLibrary_EditApplicationCarType                       10803010   //编辑备件—适用车型
//#define HDOrder_GoSpacePartLibrary_EditMyShopSaveToOrder                        10803011   //编辑本店备件-保存并加入工单
- (void)reSetupEditPermission {
    
    if (_newObject) {
        self.canEditName = YES;
        self.canEditCodeNumber = YES;
        self.canEditImageNumber = YES;
        self.canEditPrice = YES;
    } else {
        
        self.canEditName = [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_Edit isNeedShowMessage:NO];
        self.canEditCodeNumber = [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_Edit isNeedShowMessage:NO];
        self.canEditImageNumber = [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_Edit isNeedShowMessage:NO];
        
        if ([self.speraModel.parts_status integerValue] > 1)
        {
            self.canEditPrice = NO;
        }
        else
        {
            self.canEditPrice = [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_Edit isNeedShowMessage:NO];
        }
    }
}



- (void)setEditCell:(BOOL)editCell {
    
    _editCell = editCell;
    
    [self setupTextField];
}

- (void)setNewCell:(BOOL)newCell
{
    _newCell = newCell;
//    NSString *imageName = [PorscheImageManager getMaterialHoursIconImage:MaterialTaskTimeDetailsTypeMaterial Normal:!newCell];
//    
//    self.picImageView.image = [UIImage imageNamed:imageName];
}

- (void)setSperaModel:(PorscheSchemeSpareModel *)speraModel {
    _speraModel = speraModel;
    
    NSString *imageName = [PorscheImageManager getMaterialHoursIconImage:MaterialTaskTimeDetailsTypeMaterial Normal:[_speraModel.parts_status integerValue] > 1];
    
    self.picImageView.image = [UIImage imageNamed:imageName];
    
    self.codeTF.text = speraModel.speraCode;
    self.imageCodeTF.text = speraModel.speraImageCode;
    self.nameTF.text = speraModel.parts_name;
    self.priceTF.text = [NSString stringWithFormat:@"单价:%@",[NSString formatMoneyStringWithFloat:[speraModel.price_after_tax floatValue]]];
    
    _newObject = !speraModel.parts_id.integerValue;
    
    [self.numberView configViewWithTextParts:4 borderStyle:UITextBorderStyleNone textLengthLimit:3 frame:CGRectZero];
    [self.codeView configViewWithTextParts:6 borderStyle:UITextBorderStyleNone textLengthLimit:3 frame:CGRectZero];
    
    [self.numberView setTextValues:[self.speraModel spareImageCodes]];
    [self.codeView setTextValues:[self.speraModel spareCodes]];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return self.editCell;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {

    if (textField == self.priceTF) {
        self.speraModel.price_after_tax = @(self.priceTF.text.floatValue);
        self.priceTF.text = [NSString formatMoneyStringWithFloat:[self.speraModel.price_after_tax floatValue]];
    }
    
    if (textField == self.nameTF) {
        _speraModel.parts_name = self.nameTF.text;
    }
    
    if (textField == self.codeTF) {
        
        [self.speraModel setupPartNumber:self.codeTF.text];
    }
    if (textField == self.imageCodeTF) {
        
        [self.speraModel setupImageNumber:self.imageCodeTF.text];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    

    if (textField == self.priceTF) {
        
        self.priceTF.text = self.speraModel.price_after_tax.stringValue;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.self.priceTF) {

        return [textField isPriceStringChangeRange:range replacementString:string];
    }
    
    if (textField == self.nameTF) {
        
        return [textField isFloatStringToMaxLength:20 changeRange:range replacementString:string];
    }
    
    return YES;
}


- (void)linkageTextEditor:(HDLinkageTextEditor *)editor didEndEditTextField:(UITextField *)textField atIndex:(NSInteger)index
{
    
    if (editor == self.numberView)
    {
        [self.speraModel setImage_no:textField.text atIndex:index];
        self.imageCodeTF.text = [self.speraModel speraImageCode];
    }
    else if (editor == self.codeView)
    {

        [self.speraModel setParts_no:textField.text atIndex:index];
        self.codeTF.text = [self.speraModel speraCode];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
