//
//  HDWorkListRightTableViewCellOne.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/5.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDWorkListRightTableViewCellOne.h"

@interface HDWorkListRightTableViewCellOne ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *spareFigureNumberButton;

@end

@implementation HDWorkListRightTableViewCellOne




- (void)awakeFromNib {
    [super awakeFromNib];
    _peijianCountTF.delegate = self;
    
    // Initialization code
}

- (void)cannotEditSpare
{

}
- (IBAction)spareFigureAction:(id)sender {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _peijianCountTF)
    {
        BOOL ret = [HDUtil textFieldFilter:textField shouldChangeCharactersInRange:range replacementString:string];
        return ret;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.attributedPlaceholder = [[NSString stringWithFormat:@"%.2f", [_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGrayWithColor:MAIN_ATTRIBUTED_GRAY];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.attributedPlaceholder = [[NSString stringWithFormat:@"%.2f", [_tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGray];

    
    
    if ([textField isEqual:_peijianCountTF]) {
        if (_peijianCountTF.text.length > 0 && [@([_peijianCountTF.text  floatValue]) isEqual:_tmpModel.schemewscount]) {
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
    if (_peijianCountTF.text.length > 0) {
        tmp.schemewscount = @([_peijianCountTF.text  floatValue]);
    }else {
        tmp.schemewscount = _tmpModel.schemewscount;
        return;
    }
    
    if (self.returnBlock) {
        self.returnBlock(tmp);
    }
}

- (void)setTmpModel:(PorscheNewSchemews *)tmpModel {
    _tmpModel = tmpModel;
    _peijianCountTF.text = nil;
    _peijianStatus.hidden = YES;
    //根据是否保存，是否显示边框
    [self setTFborderWithSaveStatus:_saveStatus];
    [self setTotalPriceLbShowWithSavestatus:[_saveStatus integerValue]];
    
    _peijianNumberLb.text = [NSString stringWithFormat:@"%@",tmpModel.schemewsphotocode];
    _peijianListNumber.text = [NSString stringWithFormat:@"%@",tmpModel.schemewscode];
    //文字显示
    NSString *endString = tmpModel.schemewsname;
    
    if (tmpModel.schemewsname.length == 7) {
        NSString *string = [tmpModel.schemewsname substringToIndex:5];
        NSString *lastString = [tmpModel.schemewsname substringFromIndex:5];
        endString = [string stringByAppendingString:[NSString stringWithFormat:@" %@",lastString]];
    }
    _peijianName.text = endString;
    
    _peijiandanjiaLb.text = [NSString formatMoneyStringWithFloat:[tmpModel.schemewsunitprice floatValue]];
    _peijianCountTF.attributedPlaceholder = [[NSString stringWithFormat:@"%.2f", [tmpModel.schemewscount floatValue]] setTFplaceHolderWithMainGray];
    
//    if ([tmpModel.partsstocktype integerValue] == 1) {
//        _peijianStatus.text = @"常备件";
//    }else {
//        _peijianStatus.text = @"库存待确认";
//    }
    
//    if ([tmpModel.partsstocktype integerValue] == 1) {
//        _peijianStatus.text = @"常备件";
//    }else {
//        if ([tmpModel.schemewsisconfirm integerValue] == 1) {
//            //                _itemNeedResureLb.text = @"库存已确认";
//            if (tmpModel.partsstocklist.count) {
//                ProscheMaterialLocationModel *locaM = tmpModel.partsstocklist.firstObject;
//                if ([locaM.pbstockid integerValue] == 3 || [locaM.pbstockid integerValue] == 4) {
//                    _peijianStatus.text = locaM.pbstockname;
//                }else {
//                    _peijianStatus.text = [NSString stringWithFormat:@"%@ %@", locaM.pbstockname, locaM.pbsamount];
//                }
//            }
//        }else {
//            //                if (tmpModel.partStockList.count) {
//            //                    ProscheMaterialLocationModel *locaM = tmpModel.partStockList.firstObject;
//            //                    _itemNeedResureLb.text = locaM.pbsname;
//            //                }else {
//            _peijianStatus.text = @"库存待确认";
//            //                }
//        }
//    }
    
    if ([tmpModel.partsstocktype integerValue] == 1) {
        _peijianStatus.text = @"常备件";
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
                    _peijianStatus.font = [UIFont systemFontOfSize:9];
                }else {
                    _peijianStatus.font = [UIFont systemFontOfSize:12];
                }
                _peijianStatus.text = nameText;
            }
        }else {
            _peijianStatus.text = @"库存待确认";
        }
    }
    
    
    if (![tmpModel.iscancel isEqualToNumber:@0]) {
        //选中状态
        _chooseImageView.image = [UIImage imageNamed:@"work_list_29.png"];
        _peijianStatus.hidden = NO;

    }else {
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
//    [self cannotEditSpare];
}



//0.非保存 1.保存
- (void)setTFborderWithSaveStatus:(NSNumber *)saveStatus {
    //非保存，编辑状态，TF有框可输入，总计下划线可弹窗，勾选有框可取消选择
    [self setTFBorderWithSaveStatus:[saveStatus integerValue]];
}
//保存状态下赋值
- (void)setTotalPriceLbShowWithSavestatus:(BOOL)issave {
    
    NSNumber *endPrice = [self isSHowDiscountPrice] ?_tmpModel.schemewstotalprice : _tmpModel.schemewsunitprice_yuan;
    
    if (issave) {
        _totalPriceLb.text = [NSString formatMoneyStringWithFloat:[endPrice floatValue]] ;
    }else {
        _totalPriceLb.attributedText = [[NSString formatMoneyStringWithFloat:[endPrice floatValue]] changeToBottomLine];
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




//保存状态下 TF视图样式,保修按钮交互，选择框交互和显示
- (void)setTFBorderWithSaveStatus:(BOOL)isSave {
    _peijianCountTF.layer.masksToBounds = YES;
    _peijianCountTF.layer.cornerRadius = 3;
    _changeGuaranteeBt.hidden = isSave;
    _peijianCountTF.userInteractionEnabled = !isSave;
    _chooseBt.hidden = isSave;

    if (isSave) {
        _peijianCountTF.layer.borderWidth = 0;
        _peijianCountTF.layer.borderColor = [UIColor whiteColor].CGColor;
        _chooseSuperView.backgroundColor = [UIColor whiteColor];
    }else {
        _peijianCountTF.layer.borderWidth = 0.5;
        _peijianCountTF.layer.borderColor = Color(200, 200, 200).CGColor;
        _chooseSuperView.backgroundColor = Color(170, 170, 170);

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)chooseBtAction:(UIButton *)sender {
    if (self.hDWorkListRightTableViewCellOneBlock) {
        self.hDWorkListRightTableViewCellOneBlock(HDWorkListRightTableViewCellOneStyleChoose,sender);
    }
}
- (IBAction)changeGuaranteeBtAction:(UIButton *)sender {
    if (self.guaranteeBtBlock) {
        self.guaranteeBtBlock(sender);
    }
}
@end
