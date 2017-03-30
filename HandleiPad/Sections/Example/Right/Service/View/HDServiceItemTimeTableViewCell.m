//
//  HDServiceItemTimeTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceItemTimeTableViewCell.h"

@interface HDServiceItemTimeTableViewCell ()<UITextFieldDelegate>



@end

@implementation HDServiceItemTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.attributedPlaceholder = [[NSString stringWithFormat:@"%.2fTU", [_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.itemCountTF]) {
        NSLog(@"string %@",string);
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
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:_itemCountTF]) {
        if (_itemCountTF.text.length > 2 && [@([[_itemCountTF.text substringToIndex:_itemCountTF.text.length - 2] floatValue]) isEqual:_tmpModel.schemewscount]) {
            return;
        }
        if (_tmpModel.schemewscount && (!textField.text || [textField.text isEqualToString:@""])) {
            return;
        }
    }
    PorscheNewSchemews *tmp ;
    if(_tmpModel)
    {
        tmp = _tmpModel;
    }
    else
    {
        tmp = [PorscheNewSchemews new];
    }
    tmp.wospwosid = _tmpModel.wospwosid;
    tmp.schemewsid = _tmpModel.schemewsid;
    if (_itemCountTF.text.length > 2) {
        tmp.schemewscount = @([[_itemCountTF.text substringToIndex:_itemCountTF.text.length - 2] floatValue]);
    }else {
        tmp.schemewscount = _tmpModel.schemewscount;
        return;
    }
    
    if (self.editWorkhourBlock) {
        self.editWorkhourBlock(tmp);
    }
}


//保存状态下 TF视图样式
- (void)setTFBorderWithSaveStatus:(BOOL)isSave {
    _itemCountTF.layer.masksToBounds = YES;
    _itemCountTF.layer.cornerRadius = 3;
    if (isSave) {
        _itemCountTF.layer.borderWidth = 0;
        _itemCountTF.layer.borderColor = [UIColor whiteColor].CGColor;
        _itemCountTF.userInteractionEnabled = NO;
        _changeGuaranteeBt.userInteractionEnabled = NO;
    }else {
        _itemCountTF.layer.borderWidth = 0.5;
        _itemCountTF.layer.borderColor = Color(200, 200, 200).CGColor;
        _itemCountTF.userInteractionEnabled = YES;
        _changeGuaranteeBt.userInteractionEnabled = YES;
        
        
    }
}

- (void)setTmpModel:(PorscheNewSchemews *)tmpModel {
    _tmpModel = tmpModel;
    _itemCountTF.text = nil;
    [self isConfirmStatus:[tmpModel.iscancel integerValue] == 0 ? NO : YES];
    [self setupAllBorderWithsaveStatus:_saveStatus];
    _itemTimeNumberLb.text = [NSString stringWithFormat:@"%@",tmpModel.schemewscode];
    _itemTimeNameLb.text = tmpModel.schemewsname;
    _itemTimePriceLb.text = tmpModel.schemewsunitprice ? [NSString formatMoneyStringWithFloat:[tmpModel.schemewsunitprice floatValue]] : @"";
    
    _itemCountTF.attributedPlaceholder = [[NSString stringWithFormat:@"%.2fTU",[tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGray];
    //折扣 格式 - 20%
    if ([tmpModel.schemewstdiscount integerValue] == 1) {
        _discountTF.text = nil;
    }else {
        _discountTF.text = tmpModel.schemewstdiscount ? [NSString stringWithFormat:@"-%.2f%%", [tmpModel.schemewstdiscount floatValue] *100] : nil;
    }

    //保修图片 根据数据模型定
    
    
    if (tmpModel.schemewstotalprice) {
        [self setTotalPriceLbShowWithSavestatus:[_saveStatus integerValue] totalPrice:tmpModel.schemewstotalprice];
    }else {
        [self setTotalPriceLbShowWithSavestatus:[_saveStatus integerValue] totalPrice:@(0.00)];
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

    
    
}

#pragma mark  工单保存/编辑状态下，边框的显示/隐藏
//保存/编辑状态下 小计赋值
- (void)setTotalPriceLbShowWithSavestatus:(BOOL)issave totalPrice:(NSNumber *)price{
    if (issave) {
        _itemTimeTotalPriceLb.text = [NSString formatMoneyStringWithFloat:[price floatValue]] ;
    }else {
        _itemTimeTotalPriceLb.attributedText = [[NSString formatMoneyStringWithFloat:[price floatValue]] changeToBottomLine];
    }
}

//UI
- (void)setupAllBorderWithsaveStatus:(NSNumber *)saveStatus {
    [self setuptextViewCornerRadiusWithSaveStatus:saveStatus];
    [self setupButtonWithsaveStatus:saveStatus];
    [self setTFBorderWithSaveStatus:[saveStatus integerValue]];
}

//功能按钮的隐藏 hd_project_delete_new_cell.png//work_list_29
- (void)setupButtonWithsaveStatus:(NSNumber *)saveStatus {
    _changeGuaranteeBt.hidden = [saveStatus integerValue];
    _discountBt.hidden = [saveStatus integerValue];
    _chooseBt.hidden = [saveStatus integerValue];
    _markView.backgroundColor = [saveStatus integerValue] == 1 ? Color(255, 255, 255) : Color(170, 170, 170);
}

//折扣率
- (void)setuptextViewCornerRadiusWithSaveStatus:(NSNumber *)isSave {
    [AlertViewHelpers setupCellTFView:_discountTF save:[isSave integerValue]];
    
}

- (IBAction)confirmButtonAction:(id)sender;
{
    if (self.confirmActionBlock) {
        self.confirmActionBlock(sender);
    }
}

- (void)isConfirmStatus:(BOOL)ret
{
    if (ret)
    {
        self.markImageView.image = [UIImage imageNamed:@"work_list_29.png"];
    }
    else
    {
        self.markImageView.image = nil;
    }
}

- (IBAction)changeGuaranteeBtAction:(UIButton *)sender {
    if (self.guaranteeActionBlock) {
        self.guaranteeActionBlock(sender);
    }
}

- (IBAction)discountBtAction:(UIButton *)sender {
    if (self.guaranteeActionBlock) {
        self.guaranteeActionBlock(sender);
    }
}

// 保修审批显示
- (void)guranteeShenPiStatus
{
    [self setTotalPriceLbShowWithSavestatus:NO totalPrice:_tmpModel.schemewstotalprice];
    self.changeGuaranteeBt.hidden = NO;
    self.changeGuaranteeBt.userInteractionEnabled = YES;
}
@end
