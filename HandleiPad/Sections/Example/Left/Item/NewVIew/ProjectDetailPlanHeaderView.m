//
//  ProjectDetailPlanHeaderView.m
//  HandleiPad
//
//  Created by Robin on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ProjectDetailPlanHeaderView.h"

@interface ProjectDetailPlanHeaderView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *schemeNameTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstant;
@property (nonatomic, strong) PorscheSchemeModel *schemeModel;
@property (weak, nonatomic) IBOutlet UILabel *workHourPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *speraPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *schemePriceLabel;

@property (nonatomic, assign) BOOL canEditName;

@end

@implementation ProjectDetailPlanHeaderView {
    
    CGFloat _schemeTotalPrice;
    CGFloat _workhourTotalPrice;
    CGFloat _speraTotalPrice;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)headerWithTableView:(UITableView *)tableView withSchemeModel:(PorscheSchemeModel *)schemeModel{
    
    static NSString *sectionHeaderId = @"ProjectDetailPlanHeaderView";
    ProjectDetailPlanHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderId];
    if (!headerView) {
        headerView = [[[NSBundle mainBundle] loadNibNamed:sectionHeaderId owner:nil options:nil] objectAtIndex:0];
    }
    headerView.schemeNameTF.layer.borderColor =  [headerView.schemeNameTF.text isEqualToString:@""] ? MAIN_RED.CGColor : [UIColor grayColor].CGColor;
    headerView.schemeNameTF.layer.borderWidth = .5f;
    headerView.schemeNameTF.layer.cornerRadius = 4.f;
    [headerView.schemeNameTF setValue:MAIN_RED forKeyPath:@"_placeholderLabel.textColor"];
    
    headerView.schemeModel = schemeModel;
    
    return headerView;
}

- (void)setEditType:(BOOL)editType {
    
    _editType = editType;
    
    self.leadingConstant.constant = editType ? 136 : 0;
    
    self.canEditName =  [HDPermissionManager isHasThisPermission:HDOrder_GoSchemeLibrary_EditContent isNeedShowMessage:NO];
    
    self.schemeNameTF.layer.borderWidth = self.canEditName ? .5f : 0;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.schemeNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSchemePrice) name:SCHEME_RIGHT_RELOADPRICE_NOTIFICATION object:nil];
}

- (void)setCanEditName:(BOOL)canEditName {
    _canEditName = canEditName;
    
    self.schemeNameTF.enabled = canEditName;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SCHEME_RIGHT_RELOADPRICE_NOTIFICATION object:nil];
    
}

- (void)setSchemeModel:(PorscheSchemeModel *)schemeModel {
    _schemeModel = schemeModel;
    
    //设置方案名
    self.schemeNameTF.text = schemeModel.schemename;
    [self textFieldDidChange:self.schemeNameTF];
    
    //
    [self setupPriceInfo];
}

- (void)setupPriceInfo {
    
    CGFloat workhourTotal = 0;
    for (PorscheSchemeWorkHourModel *workhour in self.schemeModel.workhourlist) {
        workhourTotal += workhour.workhourpriceall.floatValue;
    }
    CGFloat speraTotal = 0;
    for (PorscheSchemeSpareModel *spera in self.schemeModel.sparelist) {
        
        speraTotal += spera.sparepriceall.floatValue;
    }
    _workhourTotalPrice = workhourTotal;
    _speraTotalPrice = speraTotal;
    _schemeTotalPrice = workhourTotal + speraTotal;
    self.workHourPriceLabel.text = [NSString formatMoneyStringWithFloat:_workhourTotalPrice];
    self.speraPriceLabel.text = [NSString formatMoneyStringWithFloat:_speraTotalPrice];
    self.schemePriceLabel.text = [NSString formatMoneyStringWithFloat:_schemeTotalPrice];
    
    self.schemeModel.schemeprice = @(_schemeTotalPrice); //记录方案总价
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)updateSchemePrice {
    [self setupPriceInfo];
    
    self.schemeModel.schemeprice = @(_schemeTotalPrice);
    self.schemeModel.workhourpriceall = @(_workhourTotalPrice);
    self.schemeModel.sparepriceall = @(_speraTotalPrice);
}

- (void)textFieldDidChange:(UITextField *)field {
    
    if ([field.text isEqualToString:@""]) {
        
        field.layer.borderColor = [UIColor redColor].CGColor;
    } else {
        
        field.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    self.schemeModel.schemename = field.text;
}


@end
