//
//  HDWorkListRightTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/1.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDWorkListRightTableViewCell.h"

@interface HDWorkListRightTableViewCell ()<UITextFieldDelegate>

@end

@implementation HDWorkListRightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.itemCountTF.delegate = self;
    _itemCountLb.hidden = YES;
    
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setTmpModel:(PorscheNewSchemews *)tmpModel {
    _tmpModel = tmpModel;
    _itemCountTF.text = nil;
    
    [self setTFborderWithSaveStatus:_saveStatus];
    [self setTotalPriceLbShowWithSavestatus:[_saveStatus integerValue]];
    
    _headerNumLb.text = [NSString stringWithFormat:@"%@",tmpModel.schemewscode];
    //文字显示
    NSString *endString = tmpModel.schemewsname;
    
    if (tmpModel.schemewsname.length == 7) {
        NSString *string = [tmpModel.schemewsname substringToIndex:5];
        NSString *lastString = [tmpModel.schemewsname substringFromIndex:5];
        endString = [string stringByAppendingString:[NSString stringWithFormat:@"\n%@",lastString]];
    }
    
    _seviceLb.text = endString;
    
    _itemPrice.text = [NSString formatMoneyStringWithFloat:[tmpModel.schemewsunitprice floatValue]];
    _itemCountTF.attributedPlaceholder = [[NSString stringWithFormat:@"%.2fTU",[tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGray];
    
    if (![tmpModel.iscancel isEqualToNumber:@0]) {
        //选中状态
        _chooseImageView.image = [UIImage imageNamed:@"work_list_29.png"];
    }else  {
        //未选中状态
        _chooseImageView.image = [UIImage imageNamed:@""];
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


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.attributedPlaceholder = [[NSString stringWithFormat:@"%.2fTU", [_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.attributedPlaceholder = [[NSString stringWithFormat:@"%.2fTU", [_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGray];

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
    
    if (self.addedReturnBlock) {
        self.addedReturnBlock(tmp);
    }
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;
}
//0.非保存 1.保存
- (void)setTFborderWithSaveStatus:(NSNumber *)saveStatus {
    //非保存，编辑状态，TF有框可输入，总计下划线可弹窗，勾选有框可取消选择
    [self setTFBorderWithSaveStatus:[saveStatus integerValue]];
    _chooseBgView.backgroundColor = [saveStatus integerValue] ? Color(255, 255, 255) : Color(170, 170, 170);
    _chooseBt.userInteractionEnabled = ![saveStatus integerValue];
}
//保存状态下赋值
- (void)setTotalPriceLbShowWithSavestatus:(BOOL)issave {
    NSNumber *endPrice = [self isSHowDiscountPrice] ?_tmpModel.schemewstotalprice : _tmpModel.schemewsunitprice_yuan;

    
    if (issave) {
        _itemTotalPrice.text = [NSString formatMoneyStringWithFloat:[endPrice floatValue]] ;
    }else {
        _itemTotalPrice.attributedText = [[NSString formatMoneyStringWithFloat:[endPrice floatValue]] changeToBottomLine];
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

//保存状态下，选择按钮
//- (void)setupChooseViewWithSaveStatus:(BOOL)isSave {
//    
//}


//保修 事件
- (IBAction)changeGuaranteeBtAction:(UIButton *)sender {
    if (self.guaranteeActionBlock) {
        self.guaranteeActionBlock(sender);
    }
    
}

- (IBAction)cameraBtAction:(UIButton *)sender {
    if (self.block) {
        self.block(CameraAndPicStyleCamera,sender);
    }
}

- (IBAction)picBtAction:(UIButton *)sender {
    if (self.block) {
        self.block(CameraAndPicStylePic,sender);
    }
}

- (IBAction)chooseBtAction:(UIButton *)sender {
    if (self.block) {
        self.block(chooseBtStyle,sender);
    }
}
@end
