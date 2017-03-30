//
//  HDServiceMaterialTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceMaterialTableViewCell.h"

@interface HDServiceMaterialTableViewCell ()<UITextFieldDelegate>

@end

@implementation HDServiceMaterialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _itemCountTF.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    PorscheNewSchemews *schemews;
    if (textField.text && ![textField.text isEqualToString:@""] && [textField.text floatValue] != [_tmpModel.schemewscount floatValue]) {
        schemews = _tmpModel;
        schemews.wospwosid = _tmpModel.wospwosid;
        schemews.schemewsid = _tmpModel.schemewsid;
        schemews.schemewscount = @([textField.text floatValue]);
    }
    if (self.editCountBlock) {
        self.editCountBlock(schemews);
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_itemCountTF]) {
        _itemCountTF.attributedPlaceholder = _tmpModel.schemewscount ? [[NSString stringWithFormat:@"%.2f",[_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY] : [@"0.00" setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:_itemCountTF]) {
        _itemCountTF.attributedPlaceholder = _tmpModel.schemewscount ? [[NSString stringWithFormat:@"%.2f",[_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGray] : [@"0.00" setTFplaceHolderWithMainGray];
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _itemCountTF)
    {
        BOOL ret = [HDUtil textFieldFilter:textField shouldChangeCharactersInRange:range replacementString:string];
        return ret;
    }
    return YES;
}

- (void)setTmpModel:(PorscheNewSchemews *)tmpModel {
    _tmpModel = tmpModel;
    _materialCubLb.hidden = YES;
    [self setupAllBorderWithsaveStatus:_saveStatus];
    [self isConfirmStatus:[tmpModel.iscancel integerValue] == 0 ? NO : YES];
    _itemTimeNumberLb.text = tmpModel.schemewscode.length > 0 ?[NSString stringWithFormat:@"%@", tmpModel.schemewscode] : @"";
    _itemTimeNameLb.text = tmpModel.schemewsname;
    _itemTimePriceLb.text = tmpModel.schemewsunitprice ? [NSString formatMoneyStringWithFloat:[tmpModel.schemewsunitprice floatValue]] : @"";
    
    if (tmpModel.schemewscount) {
        _itemCountTF.attributedPlaceholder = tmpModel.schemewscount ? [[NSString stringWithFormat:@"%.2f",[tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGray] : [@"0.00" setTFplaceHolderWithMainGray];
    }
    
    //折扣 格式 - 20%
    if ([tmpModel.schemewstdiscount integerValue] == 1) {
        _discountTF.text = nil;
    }else {
        _discountTF.text = tmpModel.schemewstdiscount ? [NSString stringWithFormat:@"-%.2f%%", [tmpModel.schemewstdiscount floatValue] *100] : nil;
    }
    
    if (tmpModel.schemewstotalprice) {
        //保存/编辑
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

    
    if ([tmpModel.partsstocktype integerValue] == 1) {
        _materialCubLb.text = @"常备件";
        _materialCubLb.textColor = MAIN_BLUE;
    }else {
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
                    _materialCubLb.font = [UIFont systemFontOfSize:9];
                }else {
                    _materialCubLb.font = [UIFont systemFontOfSize:12];
                }
                _materialCubLb.text = nameText;
            }
        }else {
            _materialCubLb.text = @"库存待确认";
            _materialCubLb.textColor = MAIN_BLUE;
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
    [self setupPriceWithSaveStatus:saveStatus];
    [self setupButtonWithsaveStatus:saveStatus];
}

//功能按钮的隐藏 hd_project_delete_new_cell.png//work_list_29
- (void)setupButtonWithsaveStatus:(NSNumber *)saveStatus {
    _changeGuaranteeBt.hidden = [saveStatus integerValue];
    _discountBt.hidden = [saveStatus integerValue];
    _chooseBt.hidden = [saveStatus integerValue];
    _chooseSuperView.backgroundColor = [saveStatus integerValue] == 1 ? Color(255, 255, 255) : Color(170, 170, 170);
}

//数量
- (void)setuptextViewCornerRadiusWithSaveStatus:(NSNumber *)isSave {
    [AlertViewHelpers setupCellTFView:_itemCountTF save:[isSave integerValue]];
}
//折扣
- (void)setupPriceWithSaveStatus:(NSNumber *)issave {
    [AlertViewHelpers setupCellTFView:_discountTF save:[issave integerValue]];
    
}


- (void)isConfirmStatus:(BOOL)ret
{
    if (ret)
    {
        self.markImageView.image = [UIImage imageNamed:@"work_list_29.png"];
        _materialCubLb.hidden = NO;
    }
    else
    {
        self.markImageView.image = nil;
        _materialCubLb.hidden = YES;
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

- (IBAction)confirmButtonAction:(id)sender {
    if (self.confirmActionBlock) {
        self.confirmActionBlock(sender);
    }
}

// 保修审批显示
- (void)guranteeShenPiStatus
{
    [self setTotalPriceLbShowWithSavestatus:NO totalPrice:_tmpModel.schemewstotalprice];
    self.changeGuaranteeBt.hidden = NO;
}
@end
